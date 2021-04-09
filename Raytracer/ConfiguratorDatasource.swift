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

private enum SceneSettings:Int, CaseIterable {
    case backgroundcolor, reflections, quality
}

class ConfiguratorDatasource: NSObject {
    var scene: Scene = Scene.testScene
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
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierSpheres, for: indexPath) as! ConfigureSphereCell
            guard let sphere = scene.spheres[safe: indexPath.row] else {
                return cell
            }
            cell.setup(with: sphere)
            return cell
        case .lights:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierLights, for: indexPath) as! ConfigureLightCell
            guard let light = scene.lights[safe: indexPath.row] else {
                return cell
            }
            cell.setup(with: light)
            return cell
        case .settings:
            return UITableViewCell()
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
            print("a")
        case .lights:
            print("b")
        case .settings:
            print("c")
        default:
            print("d")
        }
    }
}




