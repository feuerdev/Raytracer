//
//  ConfigureBackgroundCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 09.04.21.
//

import UIKit
import Feuerlib

class ConfigureBackgroundCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: Constants.identifierBackgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError() //Not needed
    }
    
    func setup(with color:RGBColor) {
        self.imageView?.layer.borderColor = UIColor(named: "border")?.cgColor
        self.imageView?.layer.borderWidth = 1
        self.textLabel?.text = "Background Color"
        self.detailTextLabel?.text = "(R:\(color.red) G:\(color.green) B:\(color.blue))"        
        self.imageView?.image = color.toUIColor().image(size: Constants.configurationRowImageSize)
    }
    
}
