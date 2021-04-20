//
//  ConfigureBackgroundCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 09.04.21.
//

import UIKit
import Feuerlib

class ConfigureShowLightsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: Constants.identifierShowLights)
    }
    
    required init?(coder: NSCoder) {
        fatalError() //Not needed
    }
    
    func setup(with show:Bool) {
        self.imageView?.layer.borderColor = UIColor(named: "border")?.cgColor
        self.imageView?.layer.borderWidth = 1
        self.textLabel?.text = "Show Lights"
        self.detailTextLabel?.text = show ? "Yes" : "No"
        self.imageView?.image = UIImage(named: "icon_ceiling_lamp")?.withRenderingMode(.alwaysTemplate)
        self.imageView?.tintColor = UIColor(named: "border")
    }
    
}
