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
        tv.delegate = dataSource
        tv.dataSource = dataSource
        return tv
    }()
    
    private var dataSource = SceneDataSource()
    
    var scene:Scene!
    
    var pitch:Float = 0
    var roll:Float = 0
    var yaw:Float = 0
    
    var width = 0
    var height = 0
    
    let fastQueue = DispatchQueue(label: "fast", qos: .userInteractive)
    let slowQueue = DispatchQueue(label: "better", qos: .userInitiated)
    let slowestQueue = DispatchQueue(label: "best", qos: .userInitiated)
    var slowTracers = [Raytracer]()
    var slowestTracers = [Raytracer]()
    
    private func redraw() {
        fastQueue.async {
            self.slowTracers.forEach { $0.cancel() }
            self.slowestTracers.forEach { $0.cancel() }
            let fastTracer = Raytracer()
            fastTracer.draw(scene: self.scene, width: 50, height: 50) { img in
                DispatchQueue.main.async {
                    self.ivImage.layer.contents = img
                }
                self.slowQueue.async {
                    let slowTracer = Raytracer()
                    self.slowTracers = [slowTracer]
                    slowTracer.draw(scene: self.scene, width: 100, height: 100) { img in
                        DispatchQueue.main.async {
                            self.ivImage.layer.contents = img
                        }
                        self.slowestQueue.async {
                            let slowestTracer = Raytracer()
                            self.slowestTracers = [slowestTracer]
                            slowestTracer.draw(scene: self.scene, width: 500, height: 500) { img in
                                DispatchQueue.main.async {
                                    self.ivImage.layer.contents = img
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func didRotate(_ sender: UIRotationGestureRecognizer) {
        yaw += Float(sender.velocity/20)
        let mtx = rotate(pitch: pitch, roll: roll, yaw: yaw)
        scene.cameraRotation = mtx
        redraw()
    }
    
    @objc private func didPinch(_ sender: UIPinchGestureRecognizer) {
        let vector = .init(0, 0, Float(sender.velocity)) * scene.cameraRotation
        scene.cameraPosition = scene.cameraPosition + vector
        redraw()
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        let x = sender.velocity(in: ivImage).x
        let y = sender.velocity(in: ivImage).y
        
        if sender.numberOfTouches == 1 {
            pitch -= Float(x/5000)
            roll -= Float(y/5000)
            let mtx = rotate(pitch: pitch, roll: roll, yaw: yaw)
            scene.cameraRotation = mtx
        } else {
            let vector = .init(Float(x/1000), Float(y/1000), 0) * scene.cameraRotation
            scene.cameraPosition = scene.cameraPosition + vector
        }
        redraw()
    }
    
    func rotate(pitch:Float, roll:Float, yaw:Float)->[[Float]] {
        let cosa = cos(yaw)
        let sina = sin(yaw)

        let cosb = cos(pitch)
        let sinb = sin(pitch)

        let cosc = cos(roll)
        let sinc = sin(roll)

        let Axx = cosa*cosb
        let Axy = cosa*sinb*sinc - sina*cosc
        let Axz = cosa*sinb*cosc + sina*sinc

        let Ayx = sina*cosb
        let Ayy = sina*sinb*sinc + cosa*cosc
        let Ayz = sina*sinb*cosc - cosa*sinc

        let Azx = -sinb
        let Azy = cosb*sinc
        let Azz = cosb*cosc
        
        let mtx = [
            [Axx, Axy, Axz],
            [Ayx, Ayy, Ayz],
            [Azx, Azy, Azz]
        ]
        return mtx
    }
    
    override func viewDidLoad() {
        self.scene = Scene.testScene
        
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
        self.width = Int(ivImage.frame.width*UIScreen.main.scale)
        self.height = Int(ivImage.frame.height*UIScreen.main.scale)
        redraw()
    }
    
}

