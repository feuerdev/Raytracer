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
    
    var fastTracer = Raytracer()
    var betterTracer = Raytracer()
    var bestTracer = Raytracer()
    
    let fastQueue = DispatchQueue(label: "fast", qos: .userInteractive)
    let slowQueue = DispatchQueue(label: "slow", qos: .userInitiated)
    let slowestQueue = DispatchQueue(label: "slowest", qos: .userInitiated)
    
    var x0 = 0
    var x1 = 0
    var a0 = 0
    var a1 = 0
    var b0 = 0
    var b1 = 0
    
    let betterQueue = OperationQueue()
    
    
    private func redraw() {
//        fastTracer.cancelled = true
        betterTracer.cancelled = true
        bestTracer.cancelled = true
        fastQueue.async {
//            self.fastTracer.cancelled = false
            self.x0 += 1
            self.slowQueue.async {
                self.a0 += 1
                self.betterTracer.cancelled = false
                if let betterImg = self.betterTracer.draw(scene: self.scene, width: 300, height: 300) {
                    DispatchQueue.main.async {
                        self.a1 += 1
                        self.ivImage.layer.contents = betterImg
                        print(self.x0, self.x1, " - ",self.a0, self.a1, " - ", self.b0, self.b1)
                    }
                    self.slowestQueue.async {
                        self.b0 += 1
                        self.bestTracer.cancelled = false
                        if let bestImg = self.bestTracer.draw(scene: self.scene, width: self.width, height: self.height) {
                            DispatchQueue.main.async {
                                self.b1 += 1
                                self.ivImage.layer.contents = bestImg
                                print(self.x0, self.x1, " - ",self.a0, self.a1, " - ", self.b0, self.b1)
                            }
                        }
                    }
                }
            }
            if let fastImg = self.fastTracer.draw(scene: self.scene, width: 50, height: 50) {
                DispatchQueue.main.async {
                    self.x1 += 1
                    self.ivImage.layer.contents = fastImg
                    print(self.x0, self.x1, " - ",self.a0, self.a1, " - ", self.b0, self.b1)
                }
            }
//                DispatchQueue.global().async {
//                    let opBetter:BlockOperation =  {
//                        let op = BlockOperation()
//                        op.addExecutionBlock {
//                            guard !op.isCancelled else {
//                                return
//                            }
//
//                            guard let img = self.betterTracer.draw(scene: self.scene, width: 300, height: 300) else {
//                                return
//                            }
//                            DispatchQueue.main.async {
//                                self.ivImage.layer.contents = img
//                            }
//                        }
//                        return op
//                    }()
//                    self.betterQueue.maxConcurrentOperationCount = 1
//                    self.betterQueue.cancelAllOperations()
//                    self.betterQueue.addOperation(opBetter)
//                    self.betterQueue.waitUntilAllOperationsAreFinished()
//                }
                
                
                
 
            
            
            
//            self.betterTracer.cancelled = false
            
//            self.bestTracer.cancelled = false
//            let bestImg = self.bestTracer.draw(scene: self.scene, width: self.width, height: self.height)
//            DispatchQueue.main.async {
//                self.ivImage.layer.contents = bestImg
//            }
        }
        
        
//
//        drawQueue.cancelAllOperations()
//        let fast = BlockOperation()
//        fast.addExecutionBlock {
//            let img = Raytracer().draw(scene: self.scene, width: 50, height: 50)
//
//
//
//        }
//        let better = BlockOperation()
//        better.addExecutionBlock {
//            if !better.isCancelled {
//                let img = self.raytracer.draw(scene: self.scene, width: 300, height: 300)
////                if !better.isCancelled {
////                    DispatchQueue.main.async {
////                        self.ivImage.layer.contents = img
////                    }
////                }
//            }
//        }
//        let best = BlockOperation()
//        best.addExecutionBlock {
//            print("best")
//            let img = self.raytracer.draw(scene: self.scene, width: self.width, height: self.height)
//            if !best.isCancelled {
//                DispatchQueue.main.async {
//                    print("block1")
//                    self.ivImage.layer.contents = img
//                }
//            }
//        }
//        best.addDependency(better)
//        better.addDependency(fast)
//        self.drawQueue.addOperations([fast, better], waitUntilFinished: true)
//
    }
    
    @objc private func didRotate(_ sender: UIRotationGestureRecognizer) {
        yaw += Float(sender.velocity/20)
        let mtx = rotate(pitch: pitch, roll: roll, yaw: yaw)
        
        print(self.scene.hashValue)
        scene.cameraRotation = mtx
        print(self.scene.hashValue)
        redraw()
    }
    @objc private func didPinch(_ sender: UIPinchGestureRecognizer) {
        print(sender.velocity)
        let vector = .init(0, 0, Float(sender.velocity)) * scene.cameraRotation
        scene.cameraPosition = scene.cameraPosition + vector
        
//        scene.cameraPosition = .init(scene.cameraPosition.x, scene.cameraPosition.y, scene.cameraPosition.z+Float(sender.velocity))
        
        
        
        redraw()
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

