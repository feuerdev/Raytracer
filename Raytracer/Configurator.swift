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
            conConfigurationTopHidden
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
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.activate(landscapeConstraints)
    }
    
    private func setupPortraitConstraints() {
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
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.conConfigurationTopHidden.isActive = false
            self.conConfigurationTopExtended.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideConfigurationSettingsView() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.conConfigurationTopExtended.isActive = false
            self.conConfigurationTopHidden.isActive = true
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.cvSettings.isHidden = true
        })
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
    func didTapSphere(_ sphere: Sphere) {
        cvSettings.setup(with: sphere)
        showConfigurationSettingsView()
    }
}
