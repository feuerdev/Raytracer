//
//  Configurator.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 12.03.21.
//

import UIKit
import Feuerlib

class Configurator:UIViewController {
    
    private lazy var ivImage:UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var tvConfiguration:UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let raytracer = Raytracer()
    var spheres = [
        Sphere(center:Vector3(0, -1, 3), radius: 1, color: .white, specular: 1000, reflectivity: 0.2), //Red,
        Sphere(center:Vector3(0, 3, 3), radius: 2, color: .red, specular: 10000, reflectivity: 0.4), //Red,
        
        Sphere(center: Vector3(2, 0, 4), radius: 1, color: .blue, specular: 500, reflectivity: 0.3), //Blue
        Sphere(center: Vector3(-2, 0, 4), radius: 1, color: .green, specular: 10, reflectivity: 0.4), //Green
        Sphere(center: Vector3(0, -5001, 0), radius: 5000, color: .yellow, specular: 1000, reflectivity: 0) //Yellow
    ]
    var lights = [
        Light(type: .ambient, intensity: 0.4),
        Light(type: .point, intensity: 0.2, position: .init(2, 3, 3)),
        Light(type: .point, intensity: 0.6, position: .init(2, 3, -1)),
        Light(type: .directional, intensity: 0.2, direction: .init(1, 4, 4))
    ]
    var scene:Scene!
    
    var pitch:Float = 0
    var roll:Float = 0
    var yaw:Float = 0
    
    @objc private func didRotate(_ sender: UIRotationGestureRecognizer) {
//        print(sender.rotation)
//        print(sender.velocity)
        yaw += Float(sender.velocity/20)
        let mtx = rotate(pitch: pitch, roll: roll, yaw: yaw)
        
        scene.cameraRotation = mtx
        let img = raytracer.draw(scene: scene, width: 50 ?? Int(ivImage.frame.width), height: 50 ?? Int(ivImage.frame.height))
        ivImage.image = UIImage(cgImage: img!)
    }
    @objc private func didPinch(_ sender: UIPinchGestureRecognizer) {
        print(sender.velocity)
        let vector = .init(0, 0, Float(sender.velocity)) * scene.cameraRotation
        scene.cameraPosition = scene.cameraPosition + vector
        
//        scene.cameraPosition = .init(scene.cameraPosition.x, scene.cameraPosition.y, scene.cameraPosition.z+Float(sender.velocity))
        
        
        
        let img = raytracer.draw(scene: scene, width: 50 ?? Int(ivImage.frame.width), height: 50 ?? Int(ivImage.frame.height))
        ivImage.image = UIImage(cgImage: img!)
    }

    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
//        print("panned")
//        print(sender.velocity(in: ivImage))
//        print(sender.numberOfTouches)
        
        let x = sender.velocity(in: ivImage).x
        let y = sender.velocity(in: ivImage).y
        
        if sender.numberOfTouches == 1 {
            pitch -= Float(x/5000)
            roll -= Float(y/5000)
//            print(Float(x/1000000))
            let mtx = rotate(pitch: pitch, roll: roll, yaw: yaw)
    //        let new = Vector3.add(mtx, scene.cameraRotation)
            scene.cameraRotation = mtx
        } else {
            let vector = .init(Float(x/1000), Float(y/1000), 0) * scene.cameraRotation
            scene.cameraPosition = scene.cameraPosition + vector
        }
        
        
        
        
        let img = raytracer.draw(scene: scene, width: 50 ?? Int(ivImage.frame.width), height: 50 ?? Int(ivImage.frame.height))
        ivImage.image = UIImage(cgImage: img!)
    }
    
    func rotate(pitch:Float, roll:Float, yaw:Float)->[[Float]] {
        let cosa = cos(yaw);
        let sina = sin(yaw);

        let cosb = cos(pitch);
        let sinb = sin(pitch);

        let cosc = cos(roll);
        let sinc = sin(roll);

        let Axx = cosa*cosb;
        let Axy = cosa*sinb*sinc - sina*cosc;
        let Axz = cosa*sinb*cosc + sina*sinc;

        let Ayx = sina*cosb;
        let Ayy = sina*sinb*sinc + cosa*cosc;
        let Ayz = sina*sinb*cosc - cosa*sinc;

        let Azx = -sinb;
        let Azy = cosb*sinc;
        let Azz = cosb*cosc;
//        let mtx = [
//            [Axx, Ayx, Azx],
//            [Axy, Ayy, Azy],
//            [Axz, Ayz, Azz]
//        ]
        
        let mtx = [
            [Axx, Axy, Axz],
            [Ayx, Ayy, Ayz],
            [Azx, Azy, Azz]
        ]
        return mtx
    }
    
    override func viewDidLoad() {
        
        scene = Scene(spheres: spheres, lights: lights, cameraPosition: .init(0, 0, -10))
        
        view.addSubview(ivImage)
        view.addSubview(tvConfiguration)
        tvConfiguration.translatesAutoresizingMaskIntoConstraints = false
        ivImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ivImage.topAnchor.constraint(equalTo: view.topAnchor),
            ivImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            ivImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ivImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            tvConfiguration.topAnchor.constraint(equalTo: ivImage.bottomAnchor),
            tvConfiguration.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tvConfiguration.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tvConfiguration.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        let a = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        let b = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        let c = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))

        ivImage.isUserInteractionEnabled = true
        ivImage.addGestureRecognizer(a)
        ivImage.addGestureRecognizer(b)
        ivImage.addGestureRecognizer(c)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let img = raytracer.draw(scene: scene, width: Int(ivImage.frame.width), height: Int(ivImage.frame.height))
        ivImage.image = UIImage(cgImage: img!)
    }
    
}

