//
//  ConfigureSphereCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 08.04.21.
//

import UIKit
import Feuerlib

class ConfigureLightCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: identifierSpheres)
    }
    
    required init?(coder: NSCoder) {
        fatalError() //Not needed
    }
    
    func setup(with light:Light) {
        self.imageView?.layer.borderColor = UIColor.black.cgColor
        self.imageView?.layer.borderWidth = 1
        self.textLabel?.text = light.name
        
        
        var img:UIImage?
        var subtitle:String?
        switch light.type {
        case .ambient:
            img = UIImage(named: "icon-brightness")
            subtitle = "Ambient"
        case .directional:
            img = UIImage(named: "icon-arrow-bottom-left")
            subtitle = "Directional"
        case .point:
            img = UIImage(named: "icon-ceiling-lamp")
            subtitle = "Point"
        }
        self.imageView?.image = img
        self.detailTextLabel?.text = subtitle
    }
}

