//
//  ConfigureBackgroundCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 09.04.21.
//

import UIKit
import Feuerlib

class ConfigureQualityCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: Constants.identifierQuality)
    }
    
    required init?(coder: NSCoder) {
        fatalError() //Not needed
    }
    
    func setup(with quality:RenderQuality) {
        self.imageView?.layer.borderColor = UIColor.black.cgColor
        self.imageView?.layer.borderWidth = 1
        self.textLabel?.text = "Quality"
        self.detailTextLabel?.text = "Low:\(quality.low) Medium:\(quality.medium) High:\(quality.high)"
        self.imageView?.image = UIImage(named: "icon_reflection")
    }
    
}
