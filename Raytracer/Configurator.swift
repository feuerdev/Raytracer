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
        rv.sceneDelegate = dataSource
        rv.interactionDelegate = self
        rv.translatesAutoresizingMaskIntoConstraints = false
        return rv
    }()
    
    private lazy var tvConfiguration:UITableView = {
        let tv = UITableView()
        tv.delegate = dataSource
        tv.dataSource = dataSource
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(ConfigureSphereCell.self, forCellReuseIdentifier: Constants.identifierSpheres)
        tv.register(ConfigureLightCell.self, forCellReuseIdentifier: Constants.identifierLights)
        tv.register(ConfigureBackgroundCell.self, forCellReuseIdentifier: Constants.identifierBackgroundColor)
        tv.register(ConfigureReflectionsCell.self, forCellReuseIdentifier: Constants.identifierReflections)
        tv.register(ConfigureQualityCell.self, forCellReuseIdentifier: Constants.identifierQuality)
        tv.register(ConfigureShowLightsCell.self, forCellReuseIdentifier: Constants.identifierShowLights)
        return tv
    }()
    
    private lazy var cvSettings:ConfiguratorView = {
        let view = ConfiguratorView()
        view.uiDelegate = self
        view.valueDelegate = dataSource
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var btnAdd:UIButton = {
        let btn = UIButton(primaryAction: .init(handler: { _ in
            let ac = UIAlertController(title: "Add", message: "Select type of object to add to the scene", preferredStyle: .actionSheet)
            ac.addAction(.init(title: "Sphere", style: .default, handler: { _ in
                print("sphere")
                self.dataSource.scene.spheres.append(Sphere.createRandom())
                self.sceneUpdate()
            }))
            ac.addAction(.init(title: "Light", style: .default, handler: { _ in
                let light = Light(type: .ambient, intensity: 0.2)
                self.dataSource.scene.lights.append(light)
                self.sceneUpdate()
            }))
            ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }))
        btn.backgroundColor = .systemGray2
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "icon_add"), for: .normal)
        btn.layer.cornerRadius = 35
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn.layer.shadowOffset = CGSize(width: 10, height: 10)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 5
        btn.layer.masksToBounds = false
        return btn
    }()
    
    private lazy var conConfigurationTopExtended: NSLayoutConstraint = {
        let con = cvSettings.topAnchor.constraint(equalTo: rvRay.bottomAnchor)
        return con
    }()
    
    private lazy var conConfigurationTopHidden: NSLayoutConstraint = {
        let con = cvSettings.topAnchor.constraint(equalTo: cvSettings.bottomAnchor)
        return con
    }()
    
    private lazy var landscapeConstraints:[NSLayoutConstraint] = {
        return [
            rvRay.topAnchor.constraint(equalTo: view.topAnchor),
            rvRay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rvRay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rvRay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            conConfigurationTopHidden
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
            tvConfiguration.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cvSettings.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cvSettings.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cvSettings.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            conConfigurationTopHidden,
            view.trailingAnchor.constraint(equalTo: btnAdd.trailingAnchor, constant: 40),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: btnAdd.bottomAnchor, constant: 40),
            btnAdd.widthAnchor.constraint(equalToConstant: 70),
            btnAdd.heightAnchor.constraint(equalToConstant: 70)
        ]
    }()
    
    private lazy var dataSource:ConfiguratorDatasource = {
        let datasource = ConfiguratorDatasource()
        datasource.delegate = self
        return datasource
    }()
    
    override func viewDidLoad() {
        view.addSubview(rvRay)
        view.addSubview(tvConfiguration)
        view.addSubview(cvSettings)
        view.addSubview(btnAdd)
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
                self?.hideConfigurationSettingsView() //Hide settings on rotation
                self?.setupLandscapeConstraints()
            } else {
                self?.setupPortraitConstraints()
            }
            
            UIView.animate(withDuration: context.transitionDuration) {
                self?.view.layoutIfNeeded()
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setupLandscapeConstraints() {
        btnAdd.isHidden = true
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.activate(landscapeConstraints)
    }
    
    private func setupPortraitConstraints() {
        btnAdd.isHidden = false
        NSLayoutConstraint.deactivate(landscapeConstraints)
        NSLayoutConstraint.activate(portraitConstraints)
    }
    
    private func showConfigurationSettingsView() {
        //Only show settings in Portrait mode
        guard let orientation = self.view.window?.windowScene?.interfaceOrientation,
            orientation.isPortrait else {
            return
        }
        self.view.layoutIfNeeded()
        self.cvSettings.isHidden = false
        hideAddButton()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.conConfigurationTopHidden.isActive = false
            self.conConfigurationTopExtended.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideConfigurationSettingsView() {
        self.view.layoutIfNeeded()
        showAddButton()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.conConfigurationTopExtended.isActive = false
            self.conConfigurationTopHidden.isActive = true
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.cvSettings.isHidden = true
        })
    }
    
    private func showAddButton() {
        btnAdd.alpha = 0
        btnAdd.isHidden = false
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut) {
            self.btnAdd.alpha = 1
        }
    }
    
    private func hideAddButton() {
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            self.btnAdd.alpha = 0
        }) { (finished) in
            self.btnAdd.isHidden = finished
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if dataSource.getScene().background.luma > 100 {
            return .darkContent
        } else {
            return .lightContent
        }
    }
}

extension Configurator: ConfigurationDatasourceDelegate {
    func scrolledDown() {
        hideAddButton()
    }
    
    func scrolledUp() {
        if btnAdd.isHidden {
            showAddButton()
        }        
    }
    
    func uiUpdate() {
        setNeedsStatusBarAppearanceUpdate() //To update status bar color in light or dark scenes
    }
    
    func sceneUpdate() {
        rvRay.layoutSubviews()
        tvConfiguration.reloadData()
    }
    
    func didSelectSphereConfiguration(with sphere: Sphere) {
        cvSettings.setup(with: sphere)
        showConfigurationSettingsView()
    }
    
    func didSelectLightConfiguration(with light: Light) {
        cvSettings.setup(with: light)
        showConfigurationSettingsView()
    }
    
    func didSelectSettingConfiguration(with scene: Scene, setting: SceneSettings) {
        cvSettings.setup(with: scene, setting: setting)
        showConfigurationSettingsView()
    }
}

extension Configurator: ConfiguratorViewUiDelegate {
    func didRequestClose() {
        hideConfigurationSettingsView()
    }
}

extension Configurator: UIRaytracerViewInteractionDelegate {
    func didTapSphere(_ sphere: Sphere?) {
        if let sphere = sphere {
            cvSettings.setup(with: sphere)
            showConfigurationSettingsView()
        } else {
            hideConfigurationSettingsView()
        }
    }
}