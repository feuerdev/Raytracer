//
//  SceneDatasource.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 16.03.21.
//

import UIKit
import Feuerlib

private enum SceneSections:Int {
    case spheres, lights, settings
}

enum SceneSettings:Int, CaseIterable {
    case backgroundcolor, reflections, quality, showLights
}

protocol ConfigurationDatasourceDelegate {
    func didSelectSphereConfiguration(with sphere:Sphere)
    func didSelectLightConfiguration(with light:Light)
    func didSelectSettingConfiguration(with scene: Scene, setting: SceneSettings)
    func sceneUpdate()
}

class ConfiguratorDatasource: NSObject {
    var scene: Scene = Scene.testScene
    var delegate: ConfigurationDatasourceDelegate?
}

extension ConfiguratorDatasource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SceneSections(rawValue: section)
        switch section {
        case .spheres:
            return scene.spheres.count
        case .lights:
            return scene.lights.count
        case .settings:
            return SceneSettings.allCases.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = SceneSections(rawValue: section)
        switch section {
        case .spheres:
            return "Spheres"
        case .lights:
            return "Lights"
        case .settings:
            return "Settings"
        case .none:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SceneSections(rawValue: indexPath.section)
        switch section {
        case .spheres:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifierSpheres, for: indexPath) as! ConfigureSphereCell
            guard let sphere = scene.spheres[safe: indexPath.row] else {
                return cell
            }
            cell.setup(with: sphere)
            return cell
        case .lights:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifierLights, for: indexPath) as! ConfigureLightCell
            guard let light = scene.lights[safe: indexPath.row] else {
                return cell
            }
            cell.setup(with: light)
            return cell
        case .settings:
            let setting = SceneSettings.init(rawValue: indexPath.row)
            switch setting {            
            case .backgroundcolor:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifierBackgroundColor, for: indexPath) as! ConfigureBackgroundCell
                cell.setup(with: scene.background)
                return cell
            case .quality:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifierQuality, for: indexPath) as! ConfigureQualityCell
                cell.setup(with: scene.quality)
                return cell
            case .reflections:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifierReflections, for: indexPath) as! ConfigureReflectionsCell
                cell.setup(with: scene.reflections)
                return cell
            case .showLights:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifierShowLights, for: indexPath) as! ConfigureShowLightsCell
                cell.setup(with: scene.showLights)
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}


extension ConfiguratorDatasource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = SceneSections(rawValue: indexPath.section)
        switch section {
        case .spheres:
            if let sphere = scene.spheres[safe: indexPath.row] {
                delegate?.didSelectSphereConfiguration(with: sphere)
            }
        case .lights:
            if let light = scene.lights[safe: indexPath.row] {
                delegate?.didSelectLightConfiguration(with: light)
            }
        case .settings:
            if let setting = SceneSettings(rawValue: indexPath.row) {
                delegate?.didSelectSettingConfiguration(with: scene, setting: setting)
            }
        default:
            break
        }
    }
}

extension ConfiguratorDatasource: UIRaytracerSceneDelegate {
    func getScene() -> Scene {
        return self.scene
    }
    
    func setScene(_ scene: Scene) {
        self.scene = scene
    }
}

extension ConfiguratorDatasource: ConfiguratorViewValueDelegate {
    func onReflectionsChanged(value: Int) {
        scene.reflections = value
        delegate?.sceneUpdate()
    }
    
    func onQualityLowChanged(value: Int) {
        scene.quality.low = Float(value)/100.0
        delegate?.sceneUpdate()
    }
    
    func onQualityMediumChanged(value: Int) {
        scene.quality.medium = Float(value)/100.0
        delegate?.sceneUpdate()
    }
    
    func onQualityHighChanged(value: Int) {
        scene.quality.high = Float(value)/100.0
        delegate?.sceneUpdate()
    }
    
    func onShowLightsChanged(value: Bool) {
        scene.showLights = value
        delegate?.sceneUpdate()
    }
    
    func onBackgroundColorRChanged(value: Int) {
        scene.background.red = value
        delegate?.sceneUpdate()
    }
    
    func onBackgroundColorGChanged(value: Int) {
        scene.background.green = value
        delegate?.sceneUpdate()
    }
    
    func onBackgroundColorBChanged(value: Int) {
        scene.background.blue = value
        delegate?.sceneUpdate()
    }
    
    func onDirectionXChanged(lightId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == lightId }) else {
            return
        }
        scene.lights[index].direction.x = value
        delegate?.sceneUpdate()
    }
    
    func onDirectionYChanged(lightId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == lightId }) else {
            return
        }
        scene.lights[index].direction.y = value
        delegate?.sceneUpdate()
    }
    
    func onDirectionZChanged(lightId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == lightId }) else {
            return
        }
        scene.lights[index].direction.z = value
        delegate?.sceneUpdate()
    }
    
    func onIntensityChanged(lightId: Int, value: Float) {
        guard let index = (scene.lights.firstIndex { $0.id == lightId }) else {
            return
        }
        scene.lights[index].intensity = value
        delegate?.sceneUpdate()
    }
    
    func onLightTypeChanged(lightId: Int, value: Int) {
        guard let index = (scene.lights.firstIndex { $0.id == lightId }),
              let type = LightType(rawValue: value) else {
            return
        }
        scene.lights[index].type = type
        delegate?.sceneUpdate()
    }
    
    func onColorRChanged(sphereId: Int, value: Int) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].color.red = value
        delegate?.sceneUpdate()
    }
    
    func onColorGChanged(sphereId: Int, value: Int) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].color.green = value
        delegate?.sceneUpdate()
    }
    
    func onColorBChanged(sphereId: Int, value: Int) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].color.blue = value
        delegate?.sceneUpdate()
    }
    
    func onPositionXChanged(lightId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == lightId }) else {
            return
        }
        scene.lights[index].position.x = value
        delegate?.sceneUpdate()
    }
    
    func onPositionYChanged(lightId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == lightId }) else {
            return
        }
        scene.lights[index].position.y = value
        delegate?.sceneUpdate()
    }
    
    func onPositionZChanged(lightId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == lightId }) else {
            return
        }
        scene.lights[index].position.z = value
        delegate?.sceneUpdate()
    }
    
    func onPositionXChanged(sphereId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].center.x = value
        delegate?.sceneUpdate()
    }
    
    func onPositionYChanged(sphereId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].center.y = value
        delegate?.sceneUpdate()
    }
    
    func onPositionZChanged(sphereId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].center.z = value
        delegate?.sceneUpdate()
    }
    
    func onReflectivityChanged(sphereId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].reflectivity = value
        delegate?.sceneUpdate()
    }
    
    func onRadiusChanged(sphereId: Int, value: Float) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].radius = value
        delegate?.sceneUpdate()
    }
    
    func onSpecularChanged(sphereId: Int, value: Int) {
        guard let index = (scene.spheres.firstIndex { $0.id == sphereId }) else {
            return
        }
        scene.spheres[index].specular = value
        delegate?.sceneUpdate()
    }
}




