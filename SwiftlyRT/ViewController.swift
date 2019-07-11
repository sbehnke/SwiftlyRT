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
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
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
    
    @IBOutlet weak var progressLabel: NSTextFieldCell!
    @IBOutlet weak var imageView: NSImageView!

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
    
    func renderYamlFile(_ url: URL?) {
        if url != nil {
            let startTime = CACurrentMediaTime()
            filename = NSString(string: url!.lastPathComponent).deletingPathExtension
            imageView.image = nil
            imageReady = false

            let world = World.fromYamlFile(url)
            DispatchQueue.global(qos: .background).async {
                let canvas = world.camera!.render(world: world, progress: { (x: Int, y: Int) -> Void in
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
                    self.progressLabel.stringValue = "Finished in: " + self.format(duration: timeElapsed)
                }
            }
        }
    }
    
    @IBAction func loadImage(_ sender: Any) {
        let dialog = NSOpenPanel();
    
        dialog.title                   = "Choose a .yml file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["yml"];
    
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            if (result != nil) {
                renderYamlFile(result)
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
                    }
                }
            })
        }
    }
}

