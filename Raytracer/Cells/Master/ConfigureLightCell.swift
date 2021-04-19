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
        super.init(style: .subtitle, reuseIdentifier: Constants.identifierSpheres)
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
            img = UIImage(named: "icon_brightness")
            subtitle = "Ambient"
        case .directional:
            img = UIImage(named: "icon_arrow_bottom_left")
            subtitle = "Directional"
        case .point:
            img = UIImage(named: "icon_ceiling_lamp")
            subtitle = "Point"
        }
        self.imageView?.image = img
        self.detailTextLabel?.text = subtitle
    }
}

