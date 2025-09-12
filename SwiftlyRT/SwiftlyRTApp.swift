//
//  SwiftlyRTApp.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/10/19.
//  Copyright © 2025 Luster Images. All rights reserved.
//

import SwiftUI

@main
struct SwiftlyRTApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Load YAML File...") {
                    NotificationCenter.default.post(name: .loadYAMLFile, object: nil)
                }
                .keyboardShortcut("o")
            }
            
            CommandGroup(after: .saveItem) {
                Button("Save Image...") {
                    NotificationCenter.default.post(name: .saveImage, object: nil)
                }
                .keyboardShortcut("s")
            }
        }
    }
}

// Notification names for menu commands
extension Notification.Name {
    static let loadYAMLFile = Notification.Name("loadYAMLFile")
    static let saveImage = Notification.Name("saveImage")
}
