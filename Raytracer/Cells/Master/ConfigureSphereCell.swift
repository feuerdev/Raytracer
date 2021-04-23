//
//  ConfigureSphereCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 08.04.21.
//

import UIKit
import Feuerlib

class ConfigureSphereCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: Constants.identifierSpheres)
    }
    
    required init?(coder: NSCoder) {
        fatalError() //Not needed
    }
    
    func setup(with sphere:Sphere) {
        self.accessoryType = .disclosureIndicator
        //Labels
        self.textLabel?.text = sphere.name
        self.detailTextLabel?.text = "(\(String(format: "%.1f", sphere.center.x))), (\(String(format: "%.1f", sphere.center.y))), (\(String(format: "%.1f", sphere.center.z)))"
        
        //Color
        self.imageView?.image = sphere.color.toUIColor().image(size: Constants.configurationRowImageSize)
        
        self.imageView?.layer.borderColor = UIColor(named: "border")?.cgColor
        self.imageView?.layer.borderWidth = 1
    }
}

