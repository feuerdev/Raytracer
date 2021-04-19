//
//  ConfiguratorIntCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 11.04.21.
//

import UIKit

class ConfiguratorIntCell: UITableViewCell {
    
    private var oldValue: Int = -1
    
    private var valueChangedHandler: ((_ value:Int)->Void)? = nil
    
    private lazy var lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = textLabel?.font
        return lbl
    }()
    
    private lazy var slValue:UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(didSlide(slider:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var lblValue:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override private init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(title:String, min:Int, max:Int, value:Int, valueChangedHandler: @escaping (_ value:Int)->Void) {
        self.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        self.slValue.minimumValue = Float(min)
        self.slValue.maximumValue = Float(max)
        self.slValue.value = Float(value)
        self.lblValue.text = String(value)
        self.lblTitle.text = title
        self.valueChangedHandler = valueChangedHandler
        
        contentView.addSubview(slValue)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblValue)
        
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 57)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            heightConstraint,
            lblTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            slValue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblValue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            slValue.leadingAnchor.constraint(equalTo: lblTitle.trailingAnchor, constant: 15),
            lblValue.leadingAnchor.constraint(equalTo: slValue.trailingAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: lblValue.trailingAnchor, constant: 20),
            lblValue.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func didSlide(slider:UISlider) {
        let rounded = roundf(slider.value)
        slider.value = rounded
        
        if oldValue != Int(rounded) {
            self.lblValue.text = String(Int(rounded))
            valueChangedHandler?(Int(rounded))
        }
        
        oldValue = Int(rounded)
    }
}
