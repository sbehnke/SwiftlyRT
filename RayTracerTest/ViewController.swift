//
//  ViewController.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

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

    @IBOutlet weak var progressLabel: NSTextFieldCell!
    
    @IBAction func buttonRenderScene(_ sender: Any) {
        renderScene()
    }
    
    func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: duration)!
    }
    
    @IBAction func renderFullScene(_ sender: Any) {
        let startTime = CACurrentMediaTime()

        //let floor = Sphere()
        let floor = Plane()
        
        let material = Material(color: Color(r: 1, g: 0.9, b: 0.9), ambient: 0.05, diffuse: 0.6, specular: 0, shininess: 200)
        floor.transform = .translate(x: 0, y: 0, z: -1)
        floor.material = material
        floor.material.pattern = CheckerPattern(a: Color.white, b: Color.black)

        let leftWall = Plane()
        leftWall.transform = .translate(x: 0, y: 0, z: 10) *
            .rotateX(.pi / 2)
        leftWall.material = Material(color: Color(r: 0, g: 0, b: 1), ambient: 0.05, diffuse: 0.6, specular: 0.5, shininess: 200)
        
        let rightWall = Plane()
        rightWall.transform = .translate(x: 0, y: 0, z: 5) *
            .rotateY(.pi / 4) *
            .rotateX(.pi / 2) *
            .scale(x: 10, y: 0.01, z: 10)
        rightWall.material = material
        
        let right = Sphere()
        right.transform = .translate(x: 1.5, y: 0.5, z: -0.5) * .scale(x: 0.5, y: 0.5, z: 0.5)
        right.material.color = Color(r: 0.5, g: 1, b: 0.1)
        right.material.diffuse = 0.7
        right.material.specular = 0.3
        right.material.pattern = GradientPattern(a: right.material.color, b: Color.white)
        
        let middle = Sphere()
        middle.transform = .translate(x: -0.5, y: 1, z: 0.5)
        middle.material.color = Color(r: 0.1, g: 1, b: 0.5)
        middle.material.diffuse = 0.7
        middle.material.specular = 0.3
        middle.material.pattern = StripePattern(a: Color.white, b: middle.material.color)
        middle.material.pattern?.transform = .scale(x: 0.25, y: 0.25, z: 0.25)
        
        let left = Sphere()
        left.transform = .translate(x: -1.5, y: 0.33, z: -0.75) * .scale(x: 0.33, y: 0.33, z: 0.33)
        left.material.color = Color(r: 1, g: 0.8, b: 0.1)
        left.material.diffuse = 0.7
        left.material.specular = 0.3
        
        let world = World()
        world.light = PointLight(position: .Point(x: -10, y: 10, z: -10), intensity: .white)
        world.objects.append(contentsOf: [floor, leftWall, rightWall, right, middle, left])
        
        var camera = Camera(w: 100, h: 50, fieldOfView: .pi / 3)
        camera.transform = .viewTransform(from: .Point(x: 0, y: 1.5, z: -5),
                                          to: .Point(x: 0, y: 1, z: 0),
                                          up: .Vector(x: 0, y: 1, z: 0))
        
        DispatchQueue.global(qos: .background).async {
            let canvas = camera.render(world: world, progress: { (x: Int, y: Int) -> Void in
                DispatchQueue.main.async {
                    self.progressLabel.stringValue = "(\(x),\(y))"
                }
            })
            
            let data = canvas.getPPM()
            
            let filename = self.getDocumentsDirectory().appendingPathComponent("rayTracingScene.ppm")
            do {
                try data.write(to: filename)
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.getDocumentsDirectory().absoluteString)
            } catch {
                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            }
            
            DispatchQueue.main.async {
                let timeElapsed = CACurrentMediaTime() - startTime
                self.progressLabel.stringValue = "Finished in: " + self.format(duration: timeElapsed)
            }
        }
    }
    
    @IBAction func renderShrinkY(_ sender: Any) {
        renderScene(transform: Matrix4x4.scale(x: 1.0, y: 0.5, z: 1))
    }
    
    @IBAction func renderShrinkX(_ sender: Any) {
        renderScene(transform: Matrix4x4.scale(x: 0.5, y: 1.0, z: 1))
    }
    
    @IBAction func renderShrinkXAndRotate(_ sender: Any) {
        renderScene(transform: Matrix4x4.scale(x: 0.5, y: 1.0, z: 1).rotateZ(Double.pi / 4))
    }
    
    @IBAction func renderShrinkXAndShear(_ sender: Any) {
        renderScene(transform: Matrix4x4.scale(x: 0.5, y: 1.0, z: 1).shear(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0))
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func renderScene(transform: Matrix4x4 = Matrix4x4.identity) {
        //        # start the ray at z = -5
        //        ray_origin ← point(0, 0, -5)
        let rayOrigin = Tuple.Point(x: 0, y: 0, z: -5)
        //        # put the wall at z = 10
        //        wall_z ← 10
        let wallZ = 10.0
        //        wall_size ← 7.0
        let wallSize = 7.0
        //        canvas_pixels ← 100
        let canvasSize = 100
        //        pixel_size ← wall_size / canvas_pixels
        let pixelSize = wallSize / Double(canvasSize)
        //        half ← wall_size / 2
        let half = wallSize / 2.0
        //        canvas ← canvas(canvas_pixels, canvas_pixels)
        let canvas = Canvas(width: canvasSize, height: canvasSize)
        //        color  ← color(1, 0, 0) # red
        // let color = Color(r: 1, g: 0, b: 0)
        //        shape  ← sphere()
        let shape = Sphere()
        
        shape.material.color = Color(r: 1, g: 0.2, b: 1)
        
        let lightPosition = Tuple.Point(x: -10, y: 10, z: -10)
        let lightColor = Color.white
        let light = PointLight(position: lightPosition, intensity: lightColor)
        
        shape.transform = transform
        
        //        # for each row of pixels in the canvas
        //        for y ← 0 to canvas_pixels - 1
        for y in 0..<canvasSize {
            //        # compute the world y coordinate (top = +half, bottom = -half)
            //        world_y ← half - pixel_size * y
            let worldY = half - pixelSize * Double(y)
            //        # for each pixel in the row
            //        for x ← 0 to canvas_pixels - 1
            for x in 0..<canvasSize {
                //        # compute the world x coordinate (left = -half, right = half)
                //        world_x ← -half + pixel_size * x
                let worldX = -half + pixelSize * Double(x)
                //        # describe the point on the wall that the ray will target
                //        position ← point(world_x, world_y, wall_z)
                let position = Tuple.Point(x: worldX, y: worldY, z: wallZ)
                //        r ← ray(ray_origin, normalize(position - ray_origin))
                let ray = Ray(origin: rayOrigin, direction: (position - rayOrigin).normalize())
                //        xs ← intersect(shape, r)
                let xs = shape.intersects(ray: ray)
                //        if hit(xs) is defined
                
                let hit = Intersection.hit(xs)
                if (hit != nil) {
                    //        write_pixel(canvas, x, y, color)
                    let point = ray.position(time: hit!.t)
                    let normal = hit!.object?.normalAt(p: point)
                    let eyeVector = -ray.direction
                    let coloredLight = light.lighting(object: hit?.object, material: hit!.object!.material, position: position, eyeVector: eyeVector, normalVector: normal!)
                    canvas.setPixel(x: x, y: y, color: coloredLight)
                }
            }
        }
        
        let data = canvas.getPPM()
        let filename = getDocumentsDirectory().appendingPathComponent("rayTracingSphere.ppm")
        do {
            try data.write(to: filename)
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: getDocumentsDirectory().absoluteString)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
}

