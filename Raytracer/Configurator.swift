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
        tv.register(ConfigureSphereCell.self, forCellReuseIdentifier: identifierSpheres)
        tv.register(ConfigureLightCell.self, forCellReuseIdentifier: identifierLights)
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
    
    private var dataSource = ConfiguratorDatasource()
    
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


//extension ViewController: UIViewControllerTransitioningDelegate {
//    
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return MyPresentationController(presentedViewController: presented, presentingViewController: presenting, height: self.view.frame.height/2)
//        
//    }
//    
//}




//extension Configurator: UITableViewDelegate {
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .systemOrange
//        vc.modalPresentationStyle = .pageSheet
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            vc.dismiss(animated: true, completion: nil)
//        }
//        present(vc, animated: true, completion: nil)
//    }
//}

