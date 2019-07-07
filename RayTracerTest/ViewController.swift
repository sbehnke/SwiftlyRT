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
    
    func hexagonCorner() -> Shape {
        let corner = Sphere()
        corner.transform = .translated(x: 0, y: 0, z: -1) * Matrix4x4.scaled(x: 0.25, y: 0.25, z: 0.25)
        return corner
    }
    
    @IBOutlet weak var TextField: NSTextField!
    
    func hexagonEdge() -> Shape {
        let edge = Cylinder()
        edge.minimum = 0
        edge.maximum = 1
        edge.transform = Matrix4x4.translated(x: 0, y: 0, z: -1) *
                         Matrix4x4.rotatedY(-.pi / 6) *
                         Matrix4x4.rotatedZ(-.pi / 2) *
                         Matrix4x4.scaled(x: 0.25, y: 1, z: 0.25)
        return edge
    }
    
    func hexagonSide() -> Group {
        let side = Group()
        side.addChild(hexagonCorner())
//        side.addChild(hexagonEdge())
        
        return side
    }
    
    func getColor(index: Int) -> Color {
        if index == 0 {
            return Color(r: 1, g: 1, b: 1)
        }
        
        if index == 1 {
            return Color(r: 1, g: 0, b: 0)
        }
        
        if index == 2 {
            return Color(r: 0.5, g: 0, b: 0)
        }
        
        if index == 3 {
            return Color(r: 0, g: 1, b: 0)
        }
        
        if index == 4 {
            return Color(r: 0, g: 0.5, b: 0)
        }
        
        if index == 5 {
            return Color(r: 0, g: 0, b: 1)
        }
        
        if index == 0 {
            return Color(r: 0, g: 0, b: 0.5)
        }
        
        return Color(r: 0.25, g: 0.25, b: 0.25)
    }
    
    func hexagon() -> Group {
        let hex = Group()
        
        
        for index in 0...6 {
            let side = hexagonSide()
            side.material.color = getColor(index: index)
            side.transform = Matrix4x4.rotatedY(Double(index) * Double(index) / 3.0)
            hex.addChild(side)
        }
        
        return hex
    }
    
    
    func hexagon(_ whichSide: Int) -> Group {
        let hex = Group()
        let side = hexagonSide()
        let rotation = Double(whichSide * whichSide) / 3.0
        side.transform = Matrix4x4.rotatedY(rotation)
        hex.addChild(side)
        return hex
    }
    
    func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: duration)!
    }
    
    @IBAction func multiThreadedTest(_ sender: Any) {
//        let camera = Camera(w: 400, h: 200, fieldOfView: .pi / 3)
//        let _ = camera.multiThreadedRender(world: World.defaultWorld(), numberOfJobs: 4)
    }
    
    @IBAction func renderRefactionTest(_ sender: Any) {
        let startTime = CACurrentMediaTime()
        
//        # ======================================================
//        # the camera
//        # ======================================================
//
//        - add: camera
//        width: 400
//        height: 200
//        field-of-view: 1.152
//        from: [-2.6, 1.5, -3.9]
//        to: [-0.6, 1, -0.8]
//        up: [0, 1, 0]
        
        var camera = Camera(w: 400, h: 200, fieldOfView: 1.152)
        camera.transform = Matrix4x4.viewTransformed(from: .Point(x: -2.6, y: 1.5, z: -3.9),
                                                   to: .Point(x: -0.6, y: 1, z: -0.8),
                                                   up: .Vector(x: 0, y: 1, z: 0))

//        # ======================================================
//        # light sources
//        # ======================================================
//
//        - add: light
//        at: [-4.9, 4.9, -1]
//        intensity: [1, 1, 1]

        let light = PointLight(position: .Point(x: -4.9, y: 4.9, z: -1),
                               intensity: Color.white)
        
//        # ======================================================
//        # define constants to avoid duplication
//        # ======================================================
//
//        - define: wall-material
//        value:
//        pattern:
//        type: stripes
//        colors:
//        - [0.45, 0.45, 0.45]
//        - [0.55, 0.55, 0.55]
//        transform:
//        - [ scale, 0.25, 0.25, 0.25 ]
//        - [ rotate-y, 1.5708 ]
//        ambient: 0
//        diffuse: 0.4
//        specular: 0
//        reflective: 0.3
        
        var wallMaterial = Material()
        let stripeColors = [Color(r: 0.45, g: 0.45, b: 0.45),
                            Color(r: 0.55, g: 0.55, b: 0.55)]
        wallMaterial.pattern = StripePattern(a: stripeColors[0], b: stripeColors[1])
        wallMaterial.pattern!.transform = Matrix4x4.rotatedY(1.5708) *
                                          Matrix4x4.scaled(x: 0.25, y: 0.25, z: 0.25)
        wallMaterial.ambient = 0
        wallMaterial.diffuse = 0.4
        wallMaterial.specular = 0
        wallMaterial.reflective = 0.3
        
//        # ======================================================
//        # describe the elements of the scene
//        # ======================================================
//
//        # the checkered floor
//        - add: plane
//        transform:
//        - [ rotate-y, 0.31415 ]
//        material:
//        pattern:
//        type: checkers
//        colors:
//        - [0.35, 0.35, 0.35]
//        - [0.65, 0.65, 0.65]
//        specular: 0
//        reflective: 0.4
        
        let floor = Plane()
        floor.transform = .rotatedY(0.31415)
        floor.material.pattern = CheckerPattern(a: Color(r: 0.35, g: 0.35, b: 0.35),
                                                b: Color(r: 0.65, g: 0.65, b: 0.65))
        floor.material.specular = 0
        floor.material.reflective = 0.4
        
//        # the ceiling
//        - add: plane
//        transform:
//        - [ translate, 0, 5, 0 ]
//        material:
//        color: [0.8, 0.8, 0.8]
//        ambient: 0.3
//        specular: 0
        
        let ceiling = Plane()
        ceiling.transform = .translated(x: 0, y: 5, z: 0)
        ceiling.material.color = Color(r: 0.8, g: 0.8, b: 0.8)
        ceiling.material.ambient = 0.3
        ceiling.material.specular = 0
        
//        # west wall
//        - add: plane
//        transform:
//        - [ rotate-y, 1.5708 ] # orient texture
//        - [ rotate-z, 1.5708 ] # rotate to vertical
//        - [ translate, -5, 0, 0 ]
//        material: wall-material
        
        let westWall = Plane()
        westWall.transform = Matrix4x4.translated(x: -5, y: 0, z: 0) *
                             Matrix4x4.rotatedZ(1.5708) *
                             Matrix4x4.rotatedY(1.5708)
        westWall.material = wallMaterial

//        # east wall
//        - add: plane
//        transform:
//        - [ rotate-y, 1.5708 ] # orient texture
//        - [ rotate-z, 1.5708 ] # rotate to vertical
//        - [ translate, 5, 0, 0 ]
//        material: wall-material
        
        let eastWall = Plane()
        eastWall.transform = Matrix4x4.translated(x: 5, y: 0, z: 0) *
                             Matrix4x4.rotatedZ(1.5708) *
                             Matrix4x4.rotatedY(1.5708)
        eastWall.material = wallMaterial

//        # north wall
//        - add: plane
//        transform:
//        - [ rotate-x, 1.5708 ] # rotate to vertical
//        - [ translate, 0, 0, 5 ]
//        material: wall-material
        
        let northWall = Plane()
        northWall.transform = Matrix4x4.translated(x: 0, y: 0, z: 5) *
                              Matrix4x4.rotatedX(1.5708)
        northWall.material = wallMaterial

//        # south wall
//        - add: plane
//        transform:
//        - [ rotate-x, 1.5708 ] # rotate to vertical
//        - [ translate, 0, 0, -5 ]
//        material: wall-material
        
        let southWall = Plane()
        southWall.transform = Matrix4x4.translated(x: 0, y: 0, z: -5) *
                              Matrix4x4.rotatedX(1.5708)
        southWall.material = wallMaterial

//        # ----------------------
//        # background balls
//        # ----------------------
//
//        - add: sphere
//        transform:
//        - [ scale, 0.4, 0.4, 0.4 ]
//        - [ translate, 4.6, 0.4, 1 ]
//        material:
//        color: [0.8, 0.5, 0.3]
//        shininess: 50

        let bsphere1 = Sphere()
        bsphere1.transform = Matrix4x4.translated(x: 4.6, y: 0.4, z: 1) *
                             Matrix4x4.scaled(x: 0.4, y: 0.4, z: 0.4)
        bsphere1.material.color = Color(r: 0.8, g: 0.5, b: 0.3)
        bsphere1.material.shininess = 50
        
//        - add: sphere
//        transform:
//        - [ scale, 0.3, 0.3, 0.3 ]
//        - [ translate, 4.7, 0.3, 0.4 ]
//        material:
//        color: [0.9, 0.4, 0.5]
//        shininess: 50
        
        let bsphere2 = Sphere()
        bsphere2.transform = Matrix4x4.translated(x: 4.7, y: 0.3, z: 0.4) *
                             Matrix4x4.scaled(x: 0.3, y: 0.3, z: 0.3)
        bsphere2.material.color = Color(r: 0.9, g: 0.4, b: 0.5)
        bsphere2.material.shininess = 50

//        - add: sphere
//        transform:
//        - [ scale, 0.5, 0.5, 0.5 ]
//        - [ translate, -1, 0.5, 4.5 ]
//        material:
//        color: [0.4, 0.9, 0.6]
//        shininess: 50
        
        let bsphere3 = Sphere()
        bsphere3.transform = Matrix4x4.translated(x: -1, y: 0.5, z: 4.5) *
                             Matrix4x4.scaled(x: 0.5, y: 0.5, z: 0.5)
        bsphere3.material.color = Color(r: 0.4, g: 0.9, b: 0.6)
        bsphere3.material.shininess = 50
        
//        - add: sphere
//        transform:
//        - [ scale, 0.3, 0.3, 0.3 ]
//        - [ translate, -1.7, 0.3, 4.7 ]
//        material:
//        color: [0.4, 0.6, 0.9]
//        shininess: 50
        
        let bsphere4 = Sphere()
        bsphere4.transform = Matrix4x4.translated(x: -1.7, y: 0.3, z: 4.7) *
                             Matrix4x4.scaled(x: 0.3, y: 0.3, z: 0.3)
        bsphere4.material.color = Color(r: 0.4, g: 0.6, b: 0.9)
        bsphere4.material.shininess = 50
    
//        # ----------------------
//        # foreground balls
//        # ----------------------
//
//        # red sphere
//        - add: sphere
//        transform:
//        - [ translate, -0.6, 1, 0.6 ]
//        material:
//        color: [1, 0.3, 0.2]
//        specular: 0.4
//        shininess: 5
        
        let redsphere = Sphere()
        redsphere.transform = Matrix4x4.translated(x: -0.6, y: 1, z: 0.6)
        redsphere.material.color = Color(r: 1, g: 0.3, b: 0.2)
        redsphere.material.specular = 0.4
        redsphere.material.shininess = 5

//        # blue glass sphere
//        - add: sphere
//        transform:
//        - [ scale, 0.7, 0.7, 0.7 ]
//        - [ translate, 0.6, 0.7, -0.6 ]
//        material:
//        color: [0, 0, 0.2]
//        ambient: 0
//        diffuse: 0.4
//        specular: 0.9
//        shininess: 300
//        reflective: 0.9
//        transparency: 0.9
//        refractive-index: 1.5
        
        let bluesphere = Sphere()
        bluesphere.transform = Matrix4x4.translated(x: 0.6, y: 0.7, z: -0.6) *
                               Matrix4x4.scaled(x: 0.7, y: 0.7, z: 0.7)
        bluesphere.material.color = Color(r: 0, g: 0, b: 0.2)
        bluesphere.material.ambient = 0
        bluesphere.material.diffuse = 0.4
        bluesphere.material.specular = 0.9
        bluesphere.material.shininess = 300
        bluesphere.material.reflective = 0.9
        bluesphere.material.transparency = 0.9
        bluesphere.material.refractiveIndex = 1.5
        
//        # green glass sphere
//        - add: sphere
//        transform:
//        - [ scale, 0.5, 0.5, 0.5 ]
//        - [ translate, -0.7, 0.5, -0.8 ]
//        material:
//        color: [0, 0.2, 0]
//        ambient: 0
//        diffuse: 0.4
//        specular: 0.9
//        shininess: 300
//        reflective: 0.9
//        transparency: 0.9
//        refractive-index: 1.5
        
        let greensphere = Sphere()
        greensphere.transform = Matrix4x4.translated(x: -0.7, y: 0.5, z: -0.8) *
                                Matrix4x4.scaled(x: 0.5, y: 0.5, z: 0.5)
        greensphere.material.color = Color(r: 0, g: 0.2, b: 0.0)
        greensphere.material.ambient = 0
        greensphere.material.diffuse = 0.4
        greensphere.material.specular = 0.9
        greensphere.material.shininess = 300
        greensphere.material.reflective = 0.9
        greensphere.material.transparency = 0.9
        greensphere.material.refractiveIndex = 1.5
        
        let world = World()
        world.light = light
        world.objects = [floor, ceiling, southWall, westWall, eastWall, northWall, bsphere1, bsphere2, bsphere3, bsphere4, redsphere, bluesphere, greensphere]
        
        DispatchQueue.global(qos: .background).async {
//            let numberOfJobs = ProcessInfo.processInfo.activeProcessorCount
//            let canvas = camera.render(world: world, progress: { (jobNumber: Int, y: Int, numberOfRows: Int) -> Void in
//                DispatchQueue.main.async {
//                    let percent = 100.0 * (Float(y) / Float(numberOfRows))
//                    // self.progressLabel.stringValue = "Job: \(jobNumber) - \(percent)%)"
//                    print("Job: \(jobNumber) - " + String(format: "%.2f", percent) + "%")
//                }
//            })
            
            let canvas = camera.render(world: world, progress: { (x: Int, y: Int) -> Void in
                DispatchQueue.main.async {
                    self.progressLabel.stringValue = "(\(x),\(y))"
                }
            })
            
            let data = canvas.getPPM()
            
            let filename = self.getDocumentsDirectory().appendingPathComponent("refraction.ppm")
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
    
    @IBAction func renderFullScene(_ sender: Any) {
        let startTime = CACurrentMediaTime()

        //let floor = Sphere()
//        let floor = Plane()
//
//        let material = Material(color: Color(r: 1, g: 0.9, b: 0.9), ambient: 0.05, diffuse: 0.6, specular: 0, shininess: 200)
//        floor.transform = .translated(x: 0, y: 0, z: -1)
//        floor.material = material
//        floor.material.pattern = CheckerPattern(a: Color.white, b: Color.black)
//        floor.material.reflective = 0.5
//
//        let leftWall = Plane()
//        leftWall.transform = .translated(x: 0, y: 0, z: 10) *
//            .rotatedX(.pi / 2)
//        leftWall.material = Material(color: Color(r: 0, g: 0, b: 1), ambient: 0.05, diffuse: 0.6, specular: 0.5, shininess: 200)
//
//        let rightWall = Plane()
//        rightWall.transform = .translated(x: 0, y: 0, z: 5) *
//            .rotatedY(.pi / 4) *
//            .rotatedX(.pi / 2) *
//            .scaled(x: 10, y: 0.01, z: 10)
//        rightWall.material.color = Color(r: 0.2, g: 0, b: 0.8)
//        rightWall.material.pattern = GradientPattern(a: rightWall.material.color, b: Color.white)
//
//        let right = Sphere()
//        right.transform = .translated(x: 1.5, y: 0.5, z: -0.5) * .scaled(x: 0.5, y: 0.5, z: 0.5)
//        right.material.color = Color(r: 0.5, g: 1, b: 0.1)
//        right.material.diffuse = 0.7
//        right.material.specular = 0.3
//        right.material.pattern = GradientPattern(a: right.material.color, b: Color.white)
//
//        let middle = Sphere()
//        middle.transform = .translated(x: -0.5, y: 1, z: 0.5)
//        middle.material.color = Color(r: 0.1, g: 1, b: 0.5)
//        middle.material.diffuse = 0.7
//        middle.material.specular = 0.3
//        middle.material.pattern = StripePattern(a: Color.white, b: middle.material.color)
//        middle.material.pattern?.transform = .scaled(x: 0.25, y: 0.25, z: 0.25)
//
//        let left = Sphere()
//        left.transform = .translated(x: -1.5, y: 0.33, z: -0.75) * .scaled(x: 0.33, y: 0.33, z: 0.33)
//        left.material.color = Color(r: 1, g: 0.8, b: 0.1)
//        left.material.diffuse = 0.7
//        left.material.specular = 0.3
        
//        var wallMaterial = Material()
//        let stripeColors = [Color(r: 0.45, g: 0.45, b: 0.45),
//                            Color(r: 0.55, g: 0.55, b: 0.55)]
//        wallMaterial.pattern = StripePattern(a: stripeColors[0], b: stripeColors[1])
//        wallMaterial.pattern!.transform = Matrix4x4.rotatedY(1.5708) *
//            Matrix4x4.scaled(x: 0.25, y: 0.25, z: 0.25)
//        wallMaterial.ambient = 0
//        wallMaterial.diffuse = 0.4
//        wallMaterial.specular = 0
//        wallMaterial.reflective = 0.3
//
//        let floor = Plane()
//        floor.transform = .rotatedY(0.31415)
//        floor.material.pattern = CheckerPattern(a: Color(r: 0.35, g: 0.35, b: 0.35),
//                                                b: Color(r: 0.65, g: 0.65, b: 0.65))
//        floor.material.specular = 0
//        floor.material.reflective = 0.4
//
//        let ceiling = Plane()
//        ceiling.transform = .translated(x: 0, y: 5, z: 0)
//        ceiling.material.color = Color(r: 0.8, g: 0.8, b: 0.8)
//        ceiling.material.ambient = 0.3
//        ceiling.material.specular = 0
//
//        let westWall = Plane()
//        westWall.transform = Matrix4x4.translated(x: -5, y: 0, z: 0) *
//            Matrix4x4.rotatedZ(1.5708) *
//            Matrix4x4.rotatedY(1.5708)
//        westWall.material = wallMaterial
//
//        let eastWall = Plane()
//        eastWall.transform = Matrix4x4.translated(x: 5, y: 0, z: 0) *
//            Matrix4x4.rotatedZ(1.5708) *
//            Matrix4x4.rotatedY(1.5708)
//        eastWall.material = wallMaterial
//
//        let northWall = Plane()
//        northWall.transform = Matrix4x4.translated(x: 0, y: 0, z: 5) *
//            Matrix4x4.rotatedX(1.5708)
//        northWall.material = wallMaterial
//
//        let southWall = Plane()
//        southWall.transform = Matrix4x4.translated(x: 0, y: 0, z: -5) *
//            Matrix4x4.rotatedX(1.5708)
//        southWall.material = wallMaterial
        
//        var hex = hexagon()
//        if (!TextField.stringValue.isEmpty) {
//            hex = hexagon(Int(TextField.stringValue) ?? 0)
//        }
//        hex.transform = Matrix4x4.translated(x: 0.6, y: 0.7, z: -0.6) * Matrix4x4.rotatedZ(.pi / 3)
//
//        let s = Sphere()
//        s.transform = Matrix4x4.translated(x: 0.6, y: 0.7, z: -0.6)
        
        
        var camera = Camera(w: 400, h: 300, fieldOfView: 1.047)
        camera.transform = Matrix4x4.viewTransformed(from: .Point(x: 1, y: 2, z: -5), to: .Point(x: 0, y: 1, z: 0), up: .Vector(x: 0, y: 1, z: 0))
        
        let world = World()
        world.light = PointLight(position: .Point(x: -9, y: 9, z: -9), intensity: Color.white)
        
        let floor = Plane()
        floor.material.pattern = CheckerPattern(a: Color(r: 0.7, g: 0.7, b: 0.7), b: Color(r: 0.3, g: 0.3, b: 0.3))
        floor.material.pattern?.transform = Matrix4x4.scaled(x: 0.6, y: 0.6, z: 0.6)
        floor.material.ambient = 0.02
        floor.material.diffuse = 0.7
        floor.material.specular = 0
        floor.material.reflective = 0.05
        
        let room = Cube()
        room.material.color = Color(r: 0.7, g: 0.7, b: 0.7)
        room.material.diffuse = 0.8
        room.material.ambient = 0.1
        room.material.specular = 0
        room.transform = Matrix4x4.translated(x: 0, y: 0.99, z: 0) * Matrix4x4.scaled(x: 10, y: 10, z: 10)
        
        let sphere1 = Sphere()
        sphere1.transform = .translated(x: 0, y: 1, z: 0)
        sphere1.material.color = Color(r: 0.9, g: 0.9, b: 0.9)
        sphere1.material.ambient = 0.1
        sphere1.material.diffuse = 0.6
        sphere1.material.specular = 0.4
        sphere1.material.shininess = 5
        sphere1.material.reflective = 0.1
        
        let sphere2 = Sphere()
        sphere2.transform = Matrix4x4.translated(x: 1.5, y: 0.6, z: -0.3) * Matrix4x4.scaled(x: 0.6, y: 0.6, z: 0.6)
        sphere2.material.color = Color(r: 0.9, g: 1, b: 0.9)
        sphere2.material.ambient = 0.1
        sphere2.material.diffuse = 0.6
        sphere2.material.specular = 0.4
        sphere2.material.shininess = 5
        sphere2.material.reflective = 0.1
        
        let sphere3 = Sphere()
        sphere3.transform = Matrix4x4.translated(x: -1.1, y: 0.5, z: -0.9) * Matrix4x4.scaled(x: 0.5, y: 0.5, z: 0.5)
        sphere3.material.color = Color(r: 1, g: 0.9, b: 0.9)
        sphere3.material.ambient = 0.1
        sphere3.material.diffuse = 0.6
        sphere3.material.specular = 0.4
        sphere3.material.shininess = 5
        sphere3.material.reflective = 0.1
        
        let group = Group()
        group.addChildren([sphere1, sphere2, sphere3])
        
        group.transform = .translated(x: 0, y: 0.75, z: 0) * Matrix4x4.rotatedY(.pi / 6) * Matrix4x4.rotatedZ(.pi / 6)
        
        world.objects = [floor, room, group]
        
//        let light = PointLight(position: .Point(x: -4.9, y: 4.9, z: -1),
//                               intensity: Color.white)
//        world.light = light
//        world.objects.append(contentsOf: [hex])

        
//        var camera = Camera(w: 400, h: 200, fieldOfView: 1.152)
//        camera.transform = Matrix4x4.viewTransformed(from: .Point(x: -2.6, y: 1.5, z: -3.9),
//                                                     to: .Point(x: -0.6, y: 1, z: -0.8),
//                                                     up: .Vector(x: 0, y: 1, z: 0))
//
        DispatchQueue.global(qos: .background).async {
//            let numberOfJobs = ProcessInfo.processInfo.activeProcessorCount
//            let canvas = camera.multiThreadedRender(world: world, numberOfJobs: numberOfJobs, progress: { (jobNumber: Int, y: Int, numberOfRows: Int) -> Void in
//                DispatchQueue.main.async {
//                    let percent = 100.0 * (Float(y) / Float(numberOfRows))
//                    // self.progressLabel.stringValue = "Job: \(jobNumber) - \(percent)%)"
//                    print("Job: \(jobNumber) - " + String(format: "%.2f", percent) + "%")
//                }
//            })
            
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
        renderScene(transform: Matrix4x4.scaled(x: 1.0, y: 0.5, z: 1))
    }
    
    @IBAction func renderShrinkX(_ sender: Any) {
        renderScene(transform: Matrix4x4.scaled(x: 0.5, y: 1.0, z: 1))
    }
    
    @IBAction func renderShrinkXAndRotate(_ sender: Any) {
        renderScene(transform: Matrix4x4.scaled(x: 0.5, y: 1.0, z: 1).rotatedZ(Double.pi / 4))
    }
    
    @IBAction func renderShrinkXAndShear(_ sender: Any) {
        renderScene(transform: Matrix4x4.scaled(x: 0.5, y: 1.0, z: 1).sheared(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0))
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
                let ray = Ray(origin: rayOrigin, direction: (position - rayOrigin).normalized())
                //        xs ← intersect(shape, r)
                let xs = shape.intersects(ray: ray)
                //        if hit(xs) is defined
                
                if let hit = Intersection.hit(xs) {
                    //        write_pixel(canvas, x, y, color)
                    let point = ray.position(time: hit.t)
                    let normal = hit.object?.normalAt(p: point, hit: hit)
                    let eyeVector = -ray.direction
                    let coloredLight = hit.object!.material.lighting(object: hit.object, light: light, position: position, eyeVector: eyeVector, normalVector: normal!)
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

