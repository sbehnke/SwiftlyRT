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
    
    @IBAction func renderRefactionTest(_ sender: Any) {
        let startTime = CACurrentMediaTime()
        
        var camera = Camera(w: 800, h: 400, fieldOfView: .pi / 3)
        camera.transform = Matrix4x4.viewTransform(from: .Point(x: -2.6, y: 1.5, z: -3.9), to: .Point(x: -0.6, y: 1, z: -0.8), up: .Vector(x: 0, y: 1, z: 0))
        let light = PointLight(position: .Point(x: -4.9, y: 4.9, z: -1), intensity: Color.white)
        
//        Camera camera{800, 400, math_constants::pi_by_three<>,
//            view_transform(make_point(-2.6, 1.5, -3.9), make_point(-0.6, 1, -0.8), predefined_tuples::y1)};
//        PointLight light{make_point(-4.9, 4.9, -1), predefined_colours::white};
        
        var wallMaterial = Material()
        let stripeColors = [Color(r: 0.45, g: 0.45, b: 0.45), Color(r: 0.55, g: 0.55, b: 0.55)]
        let wallPattern = StripePattern(a: stripeColors[0], b: stripeColors[1])
        wallMaterial.pattern = wallPattern
        wallMaterial.pattern!.transform = Matrix4x4.rotateY(.pi / 2) * Matrix4x4.scale(x: 0.25, y: 0.25, z: 0.25)
        wallMaterial.ambient = 0
        wallMaterial.diffuse = 0.4
        wallMaterial.specular = 0
        wallMaterial.reflective = 0.3
        
        // WALL MATERIAL
//        auto wall_material = std::make_shared<Material>();
//        std::vector<Colour> stripe_colours{make_colour(0.45, 0.45, 0.45), make_colour(0.55, 0.55, 0.55)};
//        auto wall_pattern = std::make_shared<StripePattern>(stripe_colours);
//        wall_pattern->setTransformation(rotation_y(math_constants::pi_by_two<>) * scale(0.25, 0.25, 0.25));
//        wall_material->setPattern(wall_pattern);
//        wall_material->setAmbient(0);
//        wall_material->setDiffuse(0.4);
//        wall_material->setSpecular(0);
//        wall_material->setReflectivity(0.3);
        
        let floor = Plane()
        floor.material.pattern = CheckerPattern(a: Color(r: 0.35, g: 0.35, b: 0.35), b: Color(r: 0.65, g: 0.65, b: 0.65))
        floor.material.specular = 0
        floor.material.reflective = 0.4
        floor.transform = .rotateY(.pi / 10)
        
        // CHECKERED FLOOR
//        auto floor = Plane::createPlane();
//        auto floor_material = std::make_shared<Material>();
//        auto floor_material_pattern = std::make_shared<CheckerPattern>(make_colour(0.35, 0.35, 0.35), make_colour(0.65, 0.65, 0.65));
//        floor_material->setPattern(floor_material_pattern);
//        floor_material->setSpecular(0);
//        floor_material->setReflectivity(0.4);
//        floor->setMaterial(floor_material);
//        floor->setTransformation(rotation_y(math_constants::pi<> / 10));
        
        let ceiling = Plane()
        ceiling.material.pattern = SolidColorPattern(Color(r: 0.8, g: 0.8, b: 0.8))
        ceiling.material.ambient = 0.3
        ceiling.material.specular = 0
        ceiling.transform = .translate(x: 0, y: 5, z: 0)
        
        // CEILING
//        auto ceiling = Plane::createPlane();
//        auto ceiling_material = std::make_shared<Material>();
//        ceiling_material->setPattern(std::make_shared<SolidPattern>(make_colour(0.8, 0.8, 0.8)));
//        ceiling_material->setAmbient(0.3);
//        ceiling_material->setSpecular(0);
//        ceiling->setMaterial(ceiling_material);
//        ceiling->setTransformation(translation(0, 5, 0));
        
        let westWall = Plane()
        westWall.material = wallMaterial
        westWall.transform = Matrix4x4.translate(x: -5, y: 0, z: 0) * Matrix4x4.rotateZ(.pi / 2.0) * Matrix4x4.rotateY(.pi / 2.0)
        // WEST WALL
//        auto west_wall = Plane::createPlane();
//        west_wall->setMaterial(wall_material);
//        west_wall->setTransformation(translation(-5, 0, 0) * rotation_z(math_constants::pi_by_two<>) *
//        rotation_y(math_constants::pi_by_two<>));
        
        let eastWall = Plane()
        eastWall.material = wallMaterial
        eastWall.transform = Matrix4x4.translate(x: 5, y: 0, z: 0) * Matrix4x4.rotateZ(.pi / 2.0) * Matrix4x4.rotateY(.pi / 2.0)
        
        // EAST WALL
//        auto east_wall = Plane::createPlane();
//        east_wall->setMaterial(wall_material);
//        east_wall->setTransformation(translation(5, 0, 0) * rotation_z(math_constants::pi_by_two<>) *
//        rotation_y(math_constants::pi_by_two<>));
        
        let northWall = Plane()
        northWall.material = wallMaterial
        northWall.transform = Matrix4x4.translate(x: 0, y: 0, z: 5) * Matrix4x4.rotateX(.pi / 2.0)
        
        // NORTH WALL
//        auto north_wall = Plane::createPlane();
//        north_wall->setMaterial(wall_material);
//        north_wall->setTransformation(translation(0, 0, 5) * rotation_x(math_constants::pi_by_two<>));
        
        let southWall = Plane()
        southWall.material = wallMaterial
        southWall.transform = Matrix4x4.translate(x: 0, y: 0, z: 5) * Matrix4x4.rotateX(.pi / 2.0)
        // SOUTH WALL
//        auto south_wall = Plane::createPlane();
//        south_wall->setMaterial(wall_material);
//        south_wall->setTransformation(translation(0, 0, 5) * rotation_x(math_constants::pi_by_two<>));
        
        let bsphere1 = Sphere()
        bsphere1.material.pattern = SolidColorPattern(Color(r: 0.8, g: 0.5, b: 0.3))
        bsphere1.material.shininess = 50
        bsphere1.transform = Matrix4x4.translate(x: 4.6, y: 0.4, z: 1) * Matrix4x4.scale(x: 0.4, y: 0.4, z: 0.4)
        // BACKGROUND BALLS
//        auto bsphere1 = Sphere::createSphere();
//        auto bsphere1_material = std::make_shared<Material>();
//        bsphere1_material->setPattern(std::make_shared<SolidPattern>(make_colour(0.8, 0.5, 0.3)));
//        bsphere1_material->setShininess(50);
//        bsphere1->setMaterial(bsphere1_material);
//        bsphere1->setTransformation(translation(4.6, 0.4, 1) * scale(0.4, 0.4, 0.4));
        
        let bsphere2 = Sphere()
        bsphere2.material.pattern = SolidColorPattern(Color(r: 0.9, g: 0.4, b: 0.5))
        bsphere2.material.shininess = 50
        bsphere2.transform = Matrix4x4.translate(x: 4.7, y: 0.3, z: 0.4) * Matrix4x4.scale(x: 0.3, y: 0.3, z: 0.3)
//        auto bsphere2 = Sphere::createSphere();
//        auto bsphere2_material = std::make_shared<Material>();
//        bsphere2_material->setPattern(std::make_shared<SolidPattern>(make_colour(0.9, 0.4, 0.5)));
//        bsphere2_material->setShininess(50);
//        bsphere2->setMaterial(bsphere2_material);
//        bsphere2->setTransformation(translation(4.7, 0.3, 0.4) * scale(0.3, 0.3, 0.3));
        
        let bsphere3 = Sphere()
        bsphere3.material.pattern = SolidColorPattern(Color(r: 0.4, g: 0.9, b: 0.6))
        bsphere3.material.shininess = 50
        bsphere3.transform = Matrix4x4.translate(x: -1, y: 0.5, z: 4.5) * Matrix4x4.scale(x: 0.5, y: 0.5, z: 0.5)
//        auto bsphere3 = Sphere::createSphere();
//        auto bsphere3_material = std::make_shared<Material>();
//        bsphere3_material->setPattern(std::make_shared<SolidPattern>(make_colour(0.4, 0.9, 0.6)));
//        bsphere3_material->setShininess(50);
//        bsphere3->setMaterial(bsphere3_material);
//        bsphere3->setTransformation(translation(-1, 0.5, 4.5) * scale(0.5, 0.5, 0.5));
        
        let bsphere4 = Sphere()
        bsphere4.material.pattern = SolidColorPattern(Color(r: 0.3, g: 0.3, b: 0.3))
        bsphere4.material.shininess = 50
        bsphere4.transform = Matrix4x4.translate(x: -1.7, y: 0.3, z: 4.7) * Matrix4x4.scale(x: 0.3, y: 0.3, z: 0.3)
//        auto bsphere4 = Sphere::createSphere();
//        auto bsphere4_material = std::make_shared<Material>();
//        bsphere4_material->setPattern(std::make_shared<SolidPattern>(make_colour(0.4, 0.6, 0.9)));
//        bsphere4_material->setShininess(50);
//        bsphere4->setMaterial(bsphere4_material);
//        bsphere4->setTransformation(translation(-1.7, 0.3, 4.7) * scale(0.3, 0.3, 0.3));
        
        let redsphere = Sphere()
        redsphere.material.pattern = SolidColorPattern(Color(r: 1, g: 0.3, b: 0.2))
        redsphere.material.shininess = 5
        redsphere.material.specular = 0.4
        redsphere.transform = Matrix4x4.translate(x: -0.6, y: 1, z: 0.6)
        // FOREGROUND BALLS
//        auto red_sphere = Sphere::createSphere();
//        auto red_sphere_material = std::make_shared<Material>();
//        red_sphere_material->setPattern(std::make_shared<SolidPattern>(make_colour(1, 0.3, 0.2)));
//        red_sphere_material->setSpecular(0.4);
//        red_sphere_material->setShininess(5);
//        red_sphere->setMaterial(red_sphere_material);
//        red_sphere->setTransformation(translation(-0.6, 1, 0.6));
        
        let bluesphere = Sphere()
        bluesphere.material.pattern = SolidColorPattern(Color(r: 1, g: 0.3, b: 0.2))
        bluesphere.material.ambient = 0
        bluesphere.material.diffuse = 0.4
        bluesphere.material.reflective = 0.9
        bluesphere.material.transparency = 0.9
        bluesphere.material.refractiveIndex = 1.52
        bluesphere.material.shininess = 300
        bluesphere.material.specular = 0.4
        bluesphere.transform = Matrix4x4.translate(x: 0.6, y: 0.7, z: -0.6) * Matrix4x4.scale(x: 0.7, y: 0.7, z: 0.7)
//        auto blue_sphere = Sphere::createSphere();
//        auto blue_sphere_material = std::make_shared<Material>();
//        blue_sphere_material->setPattern(std::make_shared<SolidPattern>(make_colour(0, 0, 0.2)));
//        blue_sphere_material->setAmbient(0);
//        blue_sphere_material->setDiffuse(0.4);
//        blue_sphere_material->setSpecular(0.9);
//        blue_sphere_material->setShininess(300);
//        blue_sphere_material->setReflectivity(0.9);
//        blue_sphere_material->setTransparency(0.9);
//        blue_sphere_material->setRefractiveIndex(1.5);
//        blue_sphere->setMaterial(blue_sphere_material);
//        blue_sphere->setTransformation(translation(0.6, 0.7, -0.6) * scale(0.7, 0.7, 0.7));
        
        let greensphere = Sphere()
        greensphere.material.pattern = SolidColorPattern(Color(r: 0, g: 0.2, b: 0.2))
        greensphere.material.ambient = 0
        greensphere.material.diffuse = 0.4
        greensphere.material.reflective = 0.9
        greensphere.material.transparency = 0.9
        greensphere.material.refractiveIndex = 1.52
        greensphere.material.shininess = 300
        greensphere.material.specular = 0.9
        greensphere.transform = Matrix4x4.translate(x: -0.7, y: 0.5, z: -0.8) * Matrix4x4.scale(x: 0.5, y: 0.5, z: 0.5)
        //        auto green_sphere = Sphere::createSphere();
        //        auto green_sphere_material = std::make_shared<Material>();
        //        green_sphere_material->setPattern(std::make_shared<SolidPattern>(make_colour(0, 0.2, 0)));
        //        green_sphere_material->setAmbient(0);
        //        green_sphere_material->setDiffuse(0.4);
        //        green_sphere_material->setSpecular(0.9);
        //        green_sphere_material->setShininess(300);
        //        green_sphere_material->setReflectivity(0.9);
        //        green_sphere_material->setTransparency(0.9);
        //        green_sphere_material->setRefractiveIndex(1.5);
        //        green_sphere->setMaterial(green_sphere_material);
        //        green_sphere->setTransformation(translation(-0.7, 0.5, -0.8) * scale(0.5, 0.5, 0.5));
        
        let world = World()
        world.light = light
        world.objects = [floor, ceiling, southWall, westWall, eastWall, northWall, bsphere1, bsphere2, bsphere3, bsphere4, redsphere, bluesphere, greensphere]
        
        DispatchQueue.global(qos: .background).async {
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
        let floor = Plane()
        
        let material = Material(color: Color(r: 1, g: 0.9, b: 0.9), ambient: 0.05, diffuse: 0.6, specular: 0, shininess: 200)
        floor.transform = .translate(x: 0, y: 0, z: -1)
        floor.material = material
        floor.material.pattern = CheckerPattern(a: Color.white, b: Color.black)
        floor.material.reflective = 0.5

        let leftWall = Plane()
        leftWall.transform = .translate(x: 0, y: 0, z: 10) *
            .rotateX(.pi / 2)
        leftWall.material = Material(color: Color(r: 0, g: 0, b: 1), ambient: 0.05, diffuse: 0.6, specular: 0.5, shininess: 200)
        
        let rightWall = Plane()
        rightWall.transform = .translate(x: 0, y: 0, z: 5) *
            .rotateY(.pi / 4) *
            .rotateX(.pi / 2) *
            .scale(x: 10, y: 0.01, z: 10)
        rightWall.material.color = Color(r: 0.2, g: 0, b: 0.8)
        rightWall.material.pattern = GradientPattern(a: rightWall.material.color, b: Color.white)
        
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
        
        var camera = Camera(w: 300, h: 150, fieldOfView: .pi / 3)
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

