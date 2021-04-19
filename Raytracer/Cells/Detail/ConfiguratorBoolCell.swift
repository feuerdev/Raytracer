//
//  ConfiguratorFloatCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 17.04.21.
//

import UIKit

class ConfiguratorBoolCell: UITableViewCell {
    
    private var valueChangedHandler: ((_ value:Bool)->Void)? = nil
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = textLabel?.font
        return lbl
    }()
    
    private lazy var swValue:UISwitch = {
        let swValue = UISwitch()
        swValue.translatesAutoresizingMaskIntoConstraints = false
        swValue.addTarget(self, action: #selector(didSelect(element:)), for: .valueChanged)
        return swValue
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override private init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(title:String, value:Bool, valueChangedHandler: @escaping (_ value:Bool)->Void) {
        self.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        self.swValue.isOn = value
        self.lblTitle.text = title
        self.valueChangedHandler = valueChangedHandler
        
        contentView.addSubview(swValue)
        contentView.addSubview(lblTitle)
        
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 57)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            heightConstraint,
            lblTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            swValue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            swValue.leadingAnchor.constraint(greaterThanOrEqualTo: lblTitle.trailingAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: swValue.trailingAnchor, constant: 20)
        ])
    }
    
    @objc func didSelect(element:UISwitch) {
        valueChangedHandler?(element.isOn)
    }
}
