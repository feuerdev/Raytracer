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
        self.detailTextLabel?.text = "Low:\(Int(quality.low*100))% Medium:\(Int(quality.medium*100))% High:\(Int(quality.high*100))%"
        self.imageView?.image = UIImage(named: "icon_percent")
    }
    
}
