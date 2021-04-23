//
//  ConfiguratorView.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 11.04.21.
//

import UIKit
import Feuerlib

protocol ConfiguratorViewUiDelegate {
    func didRequestClose()
}

protocol ConfiguratorViewValueDelegate {
    func onSpecularChanged(sphereId:Int, value:Int)
    func onRadiusChanged(sphereId:Int, value:Float)
    func onReflectivityChanged(sphereId:Int, value:Float)
    func onPositionXChanged(sphereId:Int, value:Float)
    func onPositionYChanged(sphereId:Int, value:Float)
    func onPositionZChanged(sphereId:Int, value:Float)
    func onColorRChanged(sphereId:Int, value:Int)
    func onColorGChanged(sphereId:Int, value:Int)
    func onColorBChanged(sphereId:Int, value:Int)
    func onLightTypeChanged(lightId:Int, value:Int)
    func onIntensityChanged(lightId:Int, value:Float)
    func onPositionXChanged(lightId:Int, value:Float)
    func onPositionYChanged(lightId:Int, value:Float)
    func onPositionZChanged(lightId:Int, value:Float)
    func onDirectionXChanged(lightId:Int, value:Float)
    func onDirectionYChanged(lightId:Int, value:Float)
    func onDirectionZChanged(lightId:Int, value:Float)
    func onBackgroundColorRChanged(value:Int)
    func onBackgroundColorGChanged(value:Int)
    func onBackgroundColorBChanged(value:Int)
    func onReflectionsChanged(value:Int)
    func onQualityLowChanged(value:Int)
    func onQualityMediumChanged(value:Int)
    func onQualityHighChanged(value:Int)
    func onShowLightsChanged(value:Bool)
}

class ConfiguratorView: UIView {
    var uiDelegate:ConfiguratorViewUiDelegate?
    var valueDelegate:ConfiguratorViewValueDelegate?
    
    private lazy var lblName:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textColor = .label
        return lbl
    }()
    
    private lazy var btnClose:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Close", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tvSettings:UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView(frame: .null) //Hide extra dividers
        tv.backgroundColor = .systemBackground
        return tv
    }()
    
    private lazy var vTopBar:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private var elements:[UITableViewCell] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(vTopBar)
        self.addSubview(tvSettings)
        self.vTopBar.addSubview(lblName)
        self.vTopBar.addSubview(btnClose)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        let topHeight = vTopBar.heightAnchor.constraint(equalToConstant: 44)
        topHeight.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            
            vTopBar.topAnchor.constraint(equalTo: self.topAnchor),
            vTopBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vTopBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topHeight,
            
            lblName.leadingAnchor.constraint(equalTo: vTopBar.leadingAnchor, constant: 20),
            btnClose.centerYAnchor.constraint(equalTo: vTopBar.centerYAnchor),
            lblName.centerYAnchor.constraint(equalTo: vTopBar.centerYAnchor),
            self.trailingAnchor.constraint(equalTo: btnClose.trailingAnchor, constant: 20),
            
            tvSettings.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tvSettings.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tvSettings.topAnchor.constraint(equalTo: vTopBar.bottomAnchor),
            tvSettings.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func setup(with sphere:Sphere) {
        self.lblName.text = sphere.name
        self.elements = [
            ConfiguratorFloatCell(title: "X", min: -30, max: 30, value: sphere.center.x) { [weak self] value in self?.valueDelegate?.onPositionXChanged(sphereId: sphere.id, value: value) },
            ConfiguratorFloatCell(title: "Y", min: -30, max: 30, value: sphere.center.y) { [weak self] value in self?.valueDelegate?.onPositionYChanged(sphereId: sphere.id, value: value) },
            ConfiguratorFloatCell(title: "Z", min: -30, max: 30, value: sphere.center.z) { [weak self] value in self?.valueDelegate?.onPositionZChanged(sphereId: sphere.id, value: value) },
            ConfiguratorFloatCell(title: "Radius", min: 0, max: 50, value: sphere.radius) { [weak self] value in self?.valueDelegate?.onRadiusChanged(sphereId: sphere.id, value: value) },
            ConfiguratorIntCell(title: "Specular", min: -1, max: 500, value: sphere.specular) { [weak self] value in self?.valueDelegate?.onSpecularChanged(sphereId: sphere.id, value: value) },
            ConfiguratorFloatCell(title: "Reflectivity", min: 0, max: 1, value: sphere.reflectivity) { [weak self] value in self?.valueDelegate?.onReflectivityChanged(sphereId: sphere.id, value: value) },
            ConfiguratorIntCell(title: "R", min: 0, max: 255, value: sphere.color.red) { [weak self] value in self?.valueDelegate?.onColorRChanged(sphereId: sphere.id, value: value) },
            ConfiguratorIntCell(title: "G", min: 0, max: 255, value: sphere.color.green) { [weak self] value in self?.valueDelegate?.onColorGChanged(sphereId: sphere.id, value: value) },
            ConfiguratorIntCell(title: "B", min: 0, max: 255, value: sphere.color.blue) { [weak self] value in self?.valueDelegate?.onColorBChanged(sphereId: sphere.id, value: value) },
        ]
        self.tvSettings.reloadData()
    }
    
    public func setup(with light:Light) {
        var light = light
        self.elements = [
            ConfiguratorSegmentedCell(title: "Type", options: ["Ambient", "Point", "Directional"], value: light.type.rawValue) { [weak self] value in
                self?.valueDelegate?.onLightTypeChanged(lightId: light.id, value: value)
                
                //TODO: This is not the way
                if let newType = LightType(rawValue: value) {
                    light.type = newType
                    self?.setup(with: light)
                }
            },
            ConfiguratorFloatCell(title: "Intensity", min: 0, max: 1, value: light.intensity) { [weak self] value in
                self?.valueDelegate?.onIntensityChanged(lightId: light.id, value: value)
            }
        ]
        self.lblName.text = light.name
        switch light.type {
        case .ambient: break
        case .point:
            self.elements += [
                ConfiguratorFloatCell(title: "X", min: -30, max: 30, value: light.position.x) { [weak self] value in self?.valueDelegate?.onPositionXChanged(lightId: light.id, value: value) },
                ConfiguratorFloatCell(title: "Y", min: -30, max: 30, value: light.position.y) { [weak self] value in self?.valueDelegate?.onPositionYChanged(lightId: light.id, value: value) },
                ConfiguratorFloatCell(title: "Z", min: -30, max: 30, value: light.position.z) { [weak self] value in self?.valueDelegate?.onPositionZChanged(lightId: light.id, value: value) }
            ]
        case .directional:
            self.elements += [
                ConfiguratorFloatCell(title: "Direction X", min: -1, max: 1, value: light.direction.x) { [weak self] value in self?.valueDelegate?.onDirectionXChanged(lightId: light.id, value: value) },
                ConfiguratorFloatCell(title: "Direction Y", min: -1, max: 1, value: light.direction.y) { [weak self] value in self?.valueDelegate?.onDirectionYChanged(lightId: light.id, value: value) },
                ConfiguratorFloatCell(title: "Direction Z", min: -1, max: 1, value: light.direction.z) { [weak self] value in self?.valueDelegate?.onDirectionZChanged(lightId: light.id, value: value) }
            ]
        }
        self.tvSettings.reloadData()
    }
    
    public func setup(with scene:Scene, setting:SceneSettings) {
        switch setting {
        case .backgroundcolor:
            self.lblName.text = "Background Color"
            self.elements = [
                ConfiguratorIntCell(title: "R", min: 0, max: 255, value: scene.background.red) { [weak self] value in self?.valueDelegate?.onBackgroundColorRChanged(value: value) },
                ConfiguratorIntCell(title: "G", min: 0, max: 255, value: scene.background.green) { [weak self] value in self?.valueDelegate?.onBackgroundColorGChanged(value: value) },
                ConfiguratorIntCell(title: "B", min: 0, max: 255, value: scene.background.blue) { [weak self] value in self?.valueDelegate?.onBackgroundColorBChanged(value: value) },
            ]
        case .reflections:
            self.lblName.text = "Number of reflections"
            self.elements = [
                ConfiguratorIntCell(title: "Reflections", min: 0, max: 5, value: scene.reflections) { [weak self] value in self?.valueDelegate?.onReflectionsChanged(value: value) }
            ]
        case .quality:
            self.lblName.text = "Quality"
            self.elements = [
                ConfiguratorIntCell(title: "Low", min: 1, max: 100, value: Int(scene.quality.low*100), unit: "%") { [weak self] value in self?.valueDelegate?.onQualityLowChanged(value: value) },
                ConfiguratorIntCell(title: "Medium", min: 1, max: 100, value: Int(scene.quality.medium*100), unit: "%") { [weak self] value in self?.valueDelegate?.onQualityMediumChanged(value: value) },
                ConfiguratorIntCell(title: "High", min: 1, max: 500, value: Int(scene.quality.high*100), unit: "%") { [weak self] value in self?.valueDelegate?.onQualityHighChanged(value: value) }
            ]
        case .showLights:
            self.lblName.text = "Show lights in scene"
            self.elements = [
                ConfiguratorBoolCell(title: "Show Lights", value: scene.showLights) { [weak self] value in self?.valueDelegate?.onShowLightsChanged(value: value) }
            ]
        }
        self.tvSettings.reloadData()
    }
    
    @objc func didTapClose() {
        uiDelegate?.didRequestClose()
    }
}

extension ConfiguratorView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = elements[safe: indexPath.row] else {
            fatalError()
        }
        return cell
    }
}
