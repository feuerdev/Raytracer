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

class SceneDataSource: NSObject {
    var scene: Scene = Scene.testScene
}

extension SceneDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SceneSections(rawValue: section)
        switch section {
        case .spheres:
            return scene.spheres.count
        case .lights:
            return scene.spheres.count
        case .settings:
            return SceneSettings.allCases.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        
//        let section = SceneSections(rawValue: indexPath.section)
//        switch section {
//        case .spheres:
//            return scene.spheres.count
//        case .lights:
//            return scene.spheres.count
//        case .settings:
//            return SceneSettings.allCases.count
//        default:
//            return 0
//        }
    }
}

extension SceneDataSource: UITableViewDelegate {
    
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




