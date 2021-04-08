//
//  Configurator.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 12.03.21.
//

import UIKit
import Feuerlib

class Configurator:UIViewController {
    
    private lazy var rvRay:UIRaytracerView = {
        let rv = UIRaytracerView()
        rv.translatesAutoresizingMaskIntoConstraints = false
        return rv
    }()
    
    private lazy var tvConfiguration:UITableView = {
        let tv = UITableView()
        tv.delegate = dataSource
        tv.dataSource = dataSource
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var landscapeConstraints:[NSLayoutConstraint] = {
        return [
            rvRay.topAnchor.constraint(equalTo: view.topAnchor),
            rvRay.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rvRay.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rvRay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }()
    
    private lazy var portraitConstraints:[NSLayoutConstraint] = {
        return [
            rvRay.topAnchor.constraint(equalTo: view.topAnchor),
            rvRay.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rvRay.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rvRay.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            tvConfiguration.topAnchor.constraint(equalTo: rvRay.bottomAnchor),
            tvConfiguration.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tvConfiguration.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tvConfiguration.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }()
    
    var pitch:Float = 0
    var roll:Float = 0
    var yaw:Float = 0
    
    override func viewDidLoad() {
        view.addSubview(rvRay)
        view.addSubview(tvConfiguration)
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let orientation = self.view.window?.windowScene?.interfaceOrientation.isLandscape else {
            return
        }
        
        if orientation {
            setupLandscapeConstraints()
        } else {
            setupPortraitConstraints()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { [weak self] context in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                self?.setupLandscapeConstraints()
            } else {
                self?.setupPortraitConstraints()
            }
            // 3. If you want the change to be smoothly animated call this block here
            UIView.animate(withDuration: context.transitionDuration) {
                self?.view.layoutIfNeeded()
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setupLandscapeConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.activate(landscapeConstraints)
    }
    
    private func setupPortraitConstraints() {
        NSLayoutConstraint.deactivate(landscapeConstraints)
        NSLayoutConstraint.activate(portraitConstraints)
    }
}



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

