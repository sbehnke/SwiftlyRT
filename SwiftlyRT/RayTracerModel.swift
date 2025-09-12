//
//  RayTracerModel.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/10/19.
//  Copyright © 2025 Luster Images. All rights reserved.
//

import SwiftUI
import AppKit
import OSLog
import UniformTypeIdentifiers

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation,
            let bitmapImage = NSBitmapImageRep(data: tiffRepresentation)
        else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            os_log("%{public}@", log: OSLog.contentViewLogger, type: .error, error.localizedDescription)
            return false
        }
    }
}

@MainActor
class RayTracerModel: ObservableObject {
    @Published var imageReady: Bool = false
    @Published var isRendering: Bool = false
    @Published var width: Int = 200
    @Published var height: Int = 200
    @Published var fieldOfView: Double = 0.5
    @Published var progressText: String = "Ready"
    @Published var renderProgress: Double = 0.0
    @Published var renderedImage: NSImage?
    
    private var isCanceled: Bool = false
    private var filename: String = ""
    var world: World?
    
    // MARK: - Scene Creation
    
    func createTestScene() {
        renderedImage = nil
        imageReady = false

        let w = World.defaultWorld()
        w.objects.removeAll()
        w.objects.append(hexagon())
        world = w
        
        var camera = Camera(w: width, h: height, fieldOfView: fieldOfView)
        camera.transform = .viewTransformed(
            from: .Point(x: 1, y: 2, z: -5),
            to: .pointZero,
            up: .Vector(x: 0, y: 1, z: 0)
        )
        w.camera = camera
        
        updateCameraSettings()
        progressText = "Test scene created"
    }
    
    // MARK: - Hexagon Creation Functions (from original ViewController)
    
    private func hexagonCorner(_ n: Int) -> Shape {
        let corner = Sphere()
        corner.name = "Corner: \(n)"
        corner.transform = .translated(x: 0, y: 0, z: -1) * Matrix4x4.scaled(x: 0.25, y: 0.25, z: 0.25)
        return corner
    }
    
    private func hexagonEdge(_ n: Int) -> Shape {
        let edge = Cylinder()
        edge.name = "Edge: \(n)"
        edge.minimum = 0
        edge.maximum = 1
        edge.transform = .translated(x: 0, y: 0, z: -1) * Matrix4x4.rotatedY(-.pi / 6)
            * Matrix4x4.rotatedZ(-.pi / 2) * Matrix4x4.scaled(x: 0.25, y: 1, z: 0.25)
        return edge
    }
    
    private func hexagonSide(_ n: Int) -> Group {
        let side = Group()
        side.name = "InnerSideGroup: \(n)"
        side.addChild(hexagonCorner(n))
        side.addChild(hexagonEdge(n))
        
        switch n {
        case 0:
            side.material.color = Color(r: 1, g: 1, b: 0)
        case 1:
            side.material.color = Color(r: 1, g: 0, b: 0)
        case 2:
            side.material.color = Color(r: 1, g: 0, b: 1)
        case 3:
            side.material.color = Color(r: 0, g: 0, b: 1)
        case 4:
            side.material.color = Color(r: 0, g: 1, b: 1)
        case 5:
            side.material.color = Color(r: 0, g: 1, b: 0)
        default:
            side.material.color = Color(r: 1, g: 1, b: 1)
        }
        return side
    }
    
    private func hexagon() -> Group {
        let hex = Group()
        for n in 0...5 {
            let side = hexagonSide(n)
            side.name = "HexGroupSide: \(n)"
            side.transform = .rotatedY(Double(n) * .pi / 3)
            hex.addChild(side)
        }
        return hex
    }
    
    // MARK: - Camera Settings
    
    private func updateCameraSettings() {
        if let w = world, let camera = w.camera {
            width = camera.width
            height = camera.height
            fieldOfView = camera.fieldOfView
        }
    }
    
    // MARK: - Rendering
    
    func renderScene() {
        guard let w = world else { return }
        
        isRendering = true
        isCanceled = false
        renderedImage = nil
        imageReady = false
        progressText = "Rendering..."
        renderProgress = 0.0
        
        // Update camera with current settings
        w.camera?.width = width
        w.camera?.height = height
        w.camera?.fieldOfView = fieldOfView
        
        w.computeBounds()
        let startTime = CACurrentMediaTime()
        
        let output = RenderResults()
        
        Task(priority: .utility) {
            await output.setDimensions(width: width, height: height)
            
            // Create initial canvas for preview
            let dest = Canvas(width: width, height: height)
            let img = dest.getNSImage()  // Direct NSImage generation - much faster
            
            await MainActor.run {
                self.renderedImage = img
            }
            
            // Start rendering task
            let renderTask = Task(priority: .utility) {
                await withTaskGroup(of: Void.self) { group in
                    for y in stride(from: 0, to: height, by: RenderResults.sizeY) {
                        for x in stride(from: 0, to: width, by: RenderResults.sizeX) {
                            group.addTask(priority: TaskPriority.utility) {
                                if Task.isCancelled {
                                    return
                                }
                                let canvas = w.camera!.render(
                                    c: w.camera!,
                                    world: w,
                                    startX: x,
                                    startY: y,
                                    width: RenderResults.sizeX,
                                    height: RenderResults.sizeY)
                                let chunk = CanvasChunk(canvas: canvas, x: x, y: y)
                                await output.addChunk(chunk: chunk)
                            }
                        }
                    }
                    await group.waitForAll()
                }
            }
            
            // Progress monitoring task
            Task(priority: .userInitiated) {
                var count = 0
                var lastCount = 0
                let total = await output.total
                
                repeat {
                    count = await output.chunkCount
                    let percent = Double(count) / Double(total) * 100.0
                    
                    await MainActor.run {
                        if self.isCanceled {
                            renderTask.cancel()
                            self.progressText = "Canceled"
                            self.isRendering = false
                            self.renderProgress = 0.0
                            return
                        }
                        self.progressText = String(format: "Rendering: %.1f%%", percent)
                        self.renderProgress = percent / 100.0
                    }
                    
                    if isCanceled {
                        return
                    }
                    
                    // Update image preview
                    if count > lastCount {
                        lastCount = count
                        let img = await output.getNSImage()  // Direct NSImage - no conversion needed
                        await MainActor.run {
                            if let img = img {
                                self.renderedImage = img
                            }
                        }
                    }
                    
                    try await Task.sleep(nanoseconds: 100_000_000)
                } while (count < total)
                
                // Final image update
                let img = await output.getFinalNSImage()  // Direct NSImage for final result
                await MainActor.run {
                    if let img = img {
                        self.renderedImage = img
                        self.imageReady = true
                        let timeElapsed = CACurrentMediaTime() - startTime
                        let labelValue = "Finished in: " + self.format(duration: timeElapsed)
                        self.progressText = labelValue
                        self.isRendering = false
                        self.renderProgress = 1.0
                    }
                }
            }
        }
    }
    
    func cancelRendering() {
        isCanceled = true
    }
    
    private func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        return formatter.string(from: duration)!
    }
    
    // MARK: - File Operations
    
    func loadYamlFile() {
        progressText = ""
        let dialog = NSOpenPanel()
        dialog.title = "Choose a .yml file"
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [.yaml]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let result = dialog.url
            if let result = result {
                filename = NSString(string: result.lastPathComponent).deletingPathExtension
                var loader = WorldLoader()
                world = loader.loadWorld(fromYamlFile: result)
                updateCameraSettings()
                progressText = "Loaded file!"
            }

            renderedImage = nil
            imageReady = false
        }
    }
    
    func saveImage() {
        guard let image = renderedImage else { return }
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.nameFieldStringValue = filename.isEmpty ? "rendered_image" : filename
        
        savePanel.begin { result in
            if result == .OK, let exportedUrl = savePanel.url {
                let _ = image.pngWrite(to: exportedUrl)
                Task { @MainActor in
                    self.progressText = "Image Saved!"
                }
            }
        }
    }
}
