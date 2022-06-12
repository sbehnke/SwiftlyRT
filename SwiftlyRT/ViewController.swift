//
//  ViewController.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Cocoa

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
            print(error)
            return false
        }
    }
}

class ViewController: NSViewController {
    var imageReady: Bool = false
    var filename: String = ""
    var world: World? = nil

    @IBOutlet weak var progressLabel: NSTextFieldCell!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var widthField: NSTextField!
    @IBOutlet weak var heightField: NSTextField!
    @IBOutlet weak var fieldOfViewField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressLabel.stringValue = ""

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1

        return formatter.string(from: duration)!
    }

    func hexagonCorner(_ n: Int) -> Shape {
        //        function hexagon_corner()
        //        corner ← sphere()
        //        set_transform(corner, translation(0, 0, -1) *
        //            scaling(0.25, 0.25, 0.25))
        //        return corner
        //        end function
        //
        let corner = Sphere()
        corner.name = "Corner: \(n)"
        corner.transform =
            .translated(x: 0, y: 0, z: -1) * Matrix4x4.scaled(x: 0.25, y: 0.25, z: 0.25)
        return corner
    }

    func hexagonEdge(_ n: Int) -> Shape {
        //    function hexagon_edge()
        //    edge ← cylinder()
        //    edge.minimum ← 0
        //    edge.maximum ← 1
        //    set_transform(edge, translation(0, 0, -1) *
        //    rotation_y(-π/6) *
        //    rotation_z(-π/2) *
        //    scaling(0.25, 1, 0.25))
        //    return edge
        //    end function

        let edge = Cylinder()
        edge.name = "Edge: \(n)"
        edge.minimum = 0
        edge.maximum = 1
        edge.transform =
            .translated(x: 0, y: 0, z: -1) * Matrix4x4.rotatedY(-.pi / 6)
            * Matrix4x4.rotatedZ(-.pi / 2) * Matrix4x4.scaled(x: 0.25, y: 1, z: 0.25)
        return edge
    }

    func hexagonSide(_ n: Int) -> Group {
        //    function hexagon_side()
        //    side ← group()
        //
        //    add_child(side, hexagon_corner())
        //    add_child(side, hexagon_edge())
        //
        //    return side
        //    end function

        let side = Group()
        side.name = "InnerSideGroup: \(n)"
        side.addChild(hexagonCorner(n))
        side.addChild(hexagonEdge(n))

        print(side.name)
        switch n {
        case 0:
            side.material.color = Color(r: 1, g: 1, b: 0)
            break
        case 1:
            side.material.color = Color(r: 1, g: 0, b: 0)
            break
        case 2:
            side.material.color = Color(r: 1, g: 0, b: 1)
            break
        case 3:
            side.material.color = Color(r: 0, g: 0, b: 1)
            break
        case 4:
            side.material.color = Color(r: 0, g: 1, b: 1)
            break
        case 5:
            side.material.color = Color(r: 0, g: 1, b: 0)
            break

        default:
            side.material.color = Color(r: 1, g: 1, b: 1)
            break
        }

        return side
    }

    func hexagon() -> Group {
        //    function hexagon()
        //    hex ← group()
        //
        //    for n ← 0 to 5
        //    side ← hexagon_side()
        //    set_transform(side, rotation_y(n*π/3))
        //    add_child(hex, side)
        //    end for
        //
        //    return hex
        //    end function

        let hex = Group()
        for n in 0...5 {
            let side = hexagonSide(n)
            side.name = "HexGroupSide: \(n)"
            side.transform = .rotatedY(Double(n) * .pi / 3)
            hex.addChild(side)
        }

        return hex
    }

    func updateUI() {
        if let w = world {
            if let camera = w.camera {
                widthField.stringValue = String(camera.width)
                heightField.stringValue = String(camera.height)
                fieldOfViewField.stringValue = String(camera.fieldOfView)
            }
        }
    }

    @IBAction func testButton(_ sender: Any) {
        let w = World.defaultWorld()
        w.objects.removeAll()
        w.objects.append(hexagon())
        world = w

        var camera = Camera(w: 200, h: 200, fieldOfView: 0.5)
        camera.transform = .viewTransformed(
            from: .Point(x: 1, y: 2, z: -5), to: .pointZero, up: .Vector(x: 0, y: 1, z: 0))
        w.camera = camera
        updateUI()

        renderScene(self)
    }

    @IBAction func renderScene(_ sender: Any) {
/*
        // Single Threaded

        progressLabel.stringValue = "Rendering!"
        if let w = world {
            let startTime = CACurrentMediaTime()
            imageView.image = nil
            imageReady = false

            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal

            let width = formatter.number(from: widthField.stringValue)?.intValue ?? 0
            let height = formatter.number(from: heightField.stringValue)?.intValue ?? 0
            let fov = formatter.number(from: fieldOfViewField.stringValue)?.doubleValue ?? 0.0

            w.camera?.width = width
            w.camera?.height = height
            w.camera?.fieldOfView = fov

            DispatchQueue.global(qos: .background).async {
                let canvas = w.camera!.render(
                    world: w,
                    progress: { (x: Int, y: Int) -> Void in
                        DispatchQueue.main.async {
                            self.progressLabel.stringValue = "(\(x),\(y))"
                        }
                    })

                let data = canvas.getPPM()
                let img = NSImage(data: data)
                DispatchQueue.main.async {
                    self.imageReady = true
                    self.imageView.image = img

                    let timeElapsed = CACurrentMediaTime() - startTime
                    self.progressLabel.stringValue =
                    "Finished in: " + self.format(duration: timeElapsed)
                }
            }
        }
*/

        // Multithreaded
        progressLabel.stringValue = "Rendering!"
        if let w = world {
            w.computeBounds()

            let startTime = CACurrentMediaTime()
            imageView.image = nil
            imageReady = false

            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal

            let width = formatter.number(from: widthField.stringValue)?.intValue ?? 0
            let height = formatter.number(from: heightField.stringValue)?.intValue ?? 0
            let fov = formatter.number(from: fieldOfViewField.stringValue)?.doubleValue ?? 0.0

            w.camera?.width = width
            w.camera?.height = height
            w.camera?.fieldOfView = fov

            let output = RenderResults()
            Task {
                await output.setDimensions(width: width, height: height)
            }

            let dest = Canvas(width: width, height: height)
            let data = dest.getPPM()
            let img = NSImage(data: data)
            self.imageView.image = img

            let queue = TaskQueue()
            let total = Int(ceil(Double(width * height) / Double((RenderResults.sizeX * RenderResults.sizeY))))
            let showProgress = true

            queue.dispatch {
                await withTaskGroup(of: Void.self) { group in
                    for y in stride(from: 0, to: height, by: RenderResults.sizeY) {
                        for x in stride(from: 0, to: width, by: RenderResults.sizeX) {
                            group.addTask(priority: TaskPriority.medium) {
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

            Task {
                var count = 0
                var lastCount = 0
                repeat {
                    count = await output.chunkCount
                    let percent = (Double)(count) / Double(total) * 100.0
                    DispatchQueue.main.async {
                        self.progressLabel.stringValue = "\(String(format: "Value: %.1f", percent))%"
                    }

                    if (showProgress && count > lastCount) {
                        lastCount = count
                        let img = await output.getImage()
                        DispatchQueue.main.async {
                            if let img = img {
                                self.imageView.image = img
                            }
                        }
                    }
                    try await Task.sleep(nanoseconds: 100_000_000)
                } while (count < total)

                let img = await output.getImage()
                DispatchQueue.main.async {
                    self.imageView.image = img

                    self.imageReady = true
                    let timeElapsed = CACurrentMediaTime() - startTime
                    let labelValue = "Finished in: " + self.format(duration: timeElapsed)
                    self.progressLabel.stringValue = labelValue
                }
            }
        }
    }

    @IBAction func loadYamlFile(_ sender: Any) {
        progressLabel.stringValue = ""

        let dialog = NSOpenPanel()

        dialog.title = "Choose a .yml file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["yml"]

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let result = dialog.url  // Pathname of the file
            if result != nil {
                filename = NSString(string: result!.lastPathComponent).deletingPathExtension
                var loader = WorldLoader()
                world = loader.loadWorld(fromYamlFile: result)
                updateUI()
                progressLabel.stringValue = "Loaded file!"
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }

    @IBAction func saveImage(_ sender: Any) {
        if let image = imageView.image {
            let savePanel = NSSavePanel()
            savePanel.allowedFileTypes = ["png"]
            savePanel.nameFieldStringValue = filename
            savePanel.begin(completionHandler: { (result: NSApplication.ModalResponse) -> Void in
                if result == .OK {
                    if let exportedUrl = savePanel.url {
                        let _ = image.pngWrite(to: exportedUrl)
                        self.progressLabel.stringValue = "Image Saved!"
                    }
                }
            })
        }
    }
}
