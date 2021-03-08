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
            let sphere = Sphere(center: Vector3(Float.random(in: -30...30), Float.random(in: -30...30), Float.random(in: 0...100)), radius: Float.random(in: 0.3...12), color: UInt32(a:255, r:Int.random(in: 0...255), g:Int.random(in: 0...255), b:Int.random(in: 0...255)))
            spheres.append(sphere)
        }

        let debugSpheres = [
            Sphere(center:Vector3(0, -1, 3), radius: 1, color: 0xFFFF0000),
            Sphere(center: Vector3(2, 0, 4), radius: 1, color: 0xFF0000FF),
            Sphere(center: Vector3(-2, 0, 4), radius: 1, color: 0xFF00FF00),
            Sphere(center: Vector3(0, -5001, 0), radius: 5000, color: 0xFFFFFF00)
        ]

        let lights = [
            Light(type: .ambient, intensity: 0.2),
            Light(type: .point, intensity: 0.6, position: .init(2, 1, 0)),
            Light(type: .directional, intensity: 0.2, direction: .init(1, 4, 4))
        ]

        let scene = Scene(spheres: spheres,
                          lights: lights,
                          cameraPosition: Vector3(0, 0, 0),
                          viewportSize: 1,
                          projectionPlane: 1)

        let raytracer = Raytracer(
            width: 100,//Int(view.frame.width),
            height: 100,//Int(view.frame.height),
            scene: scene)

        Timer.scheduledTimer(withTimeInterval: 1/24, repeats: true) { (timer) in
            raytracer.scene.cameraPosition = Vector3(
                raytracer.scene.cameraPosition.x,
                raytracer.scene.cameraPosition.y,
                raytracer.scene.cameraPosition.z+1)
            self.view.layer.contents = raytracer.draw()
        }
    }
}

