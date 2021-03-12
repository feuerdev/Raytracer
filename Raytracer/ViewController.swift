//
//  ViewController.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 03.03.21.
//

import UIKit
import Feuerlib

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var spheres = [Sphere]()
        for _ in 1...30 {
            let sphere = Sphere(
                center: Vector3(Float.random(in: -30...30), Float.random(in: -30...30), Float.random(in: 0...100)),
                radius: Float.random(in: 0.3...12),
                color: RGBColor(Int.random(in: 0...255), Int.random(in: 0...255), Int.random(in: 0...255)),
                specular: Int.random(in: -1...1000),
                reflectivity: Float.random(in: 0...0.5))
            spheres.append(sphere)
        }

        let debugSpheres = [
            Sphere(center:Vector3(0, -1, 3), radius: 1, color: .white, specular: 1000, reflectivity: 0.2), //Red
            Sphere(center: Vector3(2, 0, 4), radius: 1, color: .blue, specular: 500, reflectivity: 0.3), //Blue
            Sphere(center: Vector3(-2, 0, 4), radius: 1, color: .green, specular: 10, reflectivity: 0.4), //Green
            Sphere(center: Vector3(0, -5005, 0), radius: 5000, color: .init(20, 20, 20), specular: 1000, reflectivity: 0) //Yellow
        ]

        let lights = [
//            Light(type: .ambient, intensity: 0.4),
            Light(type: .point, intensity: 1, position: .init(400, 200, -10)),
//            Light(type: .directional, intensity: 0.2, direction: .init(1, 4, 4))
        ]

        let scene = Scene(spheres: debugSpheres,
                          lights: lights)

        print(UIScreen.main.nativeBounds.width)
        let quality:CGFloat = 0.1
        let raytracer = Raytracer(
            width: Int(UIScreen.main.nativeBounds.width*quality),
            height: Int(UIScreen.main.nativeBounds.height*quality),
            scene: scene,
            background: .black,
            rDepth: 2)

        Timer.scheduledTimer(withTimeInterval: 1/24, repeats: false) { (timer) in
            raytracer.scene.cameraPosition = Vector3(
                raytracer.scene.cameraPosition.x,
                raytracer.scene.cameraPosition.y,
                raytracer.scene.cameraPosition.z+1)
            self.view.layer.contents = raytracer.draw()
        }
        
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MyPresentationController(presentedViewController: presented, presentingViewController: presenting, height: self.view.frame.height/2)
        
    }
    
}

