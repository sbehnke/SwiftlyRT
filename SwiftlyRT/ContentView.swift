//
//  ContentView.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 9/11/25.
//  Copyright © 2025 Luster Images. All rights reserved.
//

import SwiftUI
import OSLog
import UniformTypeIdentifiers

extension OSLog {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let contentViewLogger = OSLog(subsystem: subsystem, category: "ContentView")
}

struct ContentView: View {
    @StateObject private var rayTracerModel = RayTracerModel()
    
    var body: some View {
        HSplitView {
            // Left panel - Controls
            VStack(alignment: .leading, spacing: 20) {
                GroupBox("Scene Settings") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Width:")
                                .frame(width: 120, alignment: .leading)
                            TextField("Width", value: $rayTracerModel.width, format: .number)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        HStack {
                            Text("Height:")
                                .frame(width: 120, alignment: .leading)
                            TextField("Height", value: $rayTracerModel.height, format: .number)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        HStack {
                            Text("Field of View:")
                                .frame(width: 120, alignment: .leading)
                            TextField("FOV", value: $rayTracerModel.fieldOfView, format: .number)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                }
                .padding()
                
                GroupBox("Actions") {
                    VStack(spacing: 10) {
                        Button("Test Scene") {
                            rayTracerModel.createTestScene()
                        }
                        .disabled(rayTracerModel.isRendering)
                        
                        Button(rayTracerModel.isRendering ? "Cancel" : "Render Scene") {
                            if rayTracerModel.isRendering {
                                rayTracerModel.cancelRendering()
                            } else {
                                rayTracerModel.renderScene()
                            }
                        }
                        .disabled(rayTracerModel.world == nil && !rayTracerModel.isRendering)
                        
                        Divider()
                        
                        Button("Load YAML File...") {
                            rayTracerModel.loadYamlFile()
                        }
                        .disabled(rayTracerModel.isRendering)
                        
                        Button("Save Image...") {
                            rayTracerModel.saveImage()
                        }
                        .disabled(!rayTracerModel.imageReady || rayTracerModel.isRendering)
                    }
                }
                .padding()
                
                // Progress section
                GroupBox("Status") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(rayTracerModel.progressText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if rayTracerModel.isRendering {
                            ProgressView(value: rayTracerModel.renderProgress)
                                .progressViewStyle(LinearProgressViewStyle())
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .frame(minWidth: 280, maxWidth: 320)
            
            // Right panel - Image display
            VStack {
                if let image = rayTracerModel.renderedImage {
                    ScrollView([.horizontal, .vertical]) {
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No image rendered")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Load a YAML file or create a test scene to begin")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .loadYAMLFile)) { _ in
            rayTracerModel.loadYamlFile()
        }
        .onReceive(NotificationCenter.default.publisher(for: .saveImage)) { _ in
            rayTracerModel.saveImage()
        }
        .navigationTitle("SwiftlyRT")
    }
}

#Preview {
    ContentView()
        .frame(width: 800, height: 600)
}
