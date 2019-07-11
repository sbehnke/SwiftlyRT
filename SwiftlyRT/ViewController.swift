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
    
    
    func updateUI() {
        if let w = world {
            widthField.stringValue = String(w.camera!.width)
            heightField.stringValue = String(w.camera!.height)
            fieldOfViewField.stringValue = String(w.camera!.fieldOfView)
        }
    }
    
    
    @IBAction func renderScene(_ sender: Any) {
        if let w = world {
            let startTime = CACurrentMediaTime()
            imageView.image = nil
            imageReady = false
            
            let width = NSString(string: widthField.stringValue).intValue
            let height = NSString(string: heightField.stringValue).intValue
            let fov = NSString(string: fieldOfViewField.stringValue).doubleValue
            
            w.camera?.width = Int(width)
            w.camera?.height = Int(height)
            w.camera?.fieldOfView = fov
            
            DispatchQueue.global(qos: .background).async {
                let canvas = w.camera!.render(world: w, progress: { (x: Int, y: Int) -> Void in
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
    
    @IBAction func loadYamlFile(_ sender: Any) {
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
                filename = NSString(string: result!.lastPathComponent).deletingPathExtension
                world = World.fromYamlFile(result)
                updateUI()
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

