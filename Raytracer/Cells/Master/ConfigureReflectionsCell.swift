//
//  ConfigureBackgroundCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 09.04.21.
//

import UIKit
import Feuerlib

class ConfigureReflectionsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: Constants.identifierReflections)
    }
    
    required init?(coder: NSCoder) {
        fatalError() //Not needed
    }
    
    func setup(with reflections:Int) {
        self.accessoryType = .disclosureIndicator
        self.imageView?.layer.borderColor = UIColor(named: "border")?.cgColor
        self.imageView?.layer.borderWidth = 1
        self.textLabel?.text = "Reflections"
        self.detailTextLabel?.text = String(reflections)
        self.imageView?.image = UIImage(named: "icon_reflection")?.withRenderingMode(.alwaysTemplate)
        self.imageView?.tintColor = UIColor(named: "border")
    }
    
}
