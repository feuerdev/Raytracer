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
        super.init(style: .subtitle, reuseIdentifier: identifierSpheres)
    }
    
    required init?(coder: NSCoder) {
        fatalError() //Not needed
    }
    
    func setup(with sphere:Sphere) {
        //Labels
        self.textLabel?.text = sphere.name
        self.detailTextLabel?.text = "(\(sphere.center.x), \(sphere.center.y), \(sphere.center.z))"
        
        //Color
        let height = 40
        let img = sphere.color.toUIColor().image(size: .init(width: height, height: height))
        self.imageView?.image = sphere.color.toUIColor().image(size: .init(width: height, height: height))
        
        self.imageView?.layer.borderColor = UIColor.black.cgColor
        self.imageView?.layer.borderWidth = 1
    }
}

