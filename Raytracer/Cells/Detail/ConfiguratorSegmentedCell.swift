//
//  ConfiguratorFloatCell.swift
//  Raytracer
//
//  Created by Jannik Feuerhahn on 17.04.21.
//

import UIKit

class ConfiguratorSegmentedCell: UITableViewCell {
    
    private var valueChangedHandler: ((_ value:Int)->Void)? = nil
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = textLabel?.font
        return lbl
    }()
    
    private lazy var sgValue:UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(didSelect(segmentedControl:)), for: .valueChanged)
        return segment
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override private init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(title:String, options: [String], value:Int, valueChangedHandler: @escaping (_ value:Int)->Void) {
        self.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        options.forEach { (title) in
            self.sgValue.insertSegment(withTitle: title, at: self.sgValue.numberOfSegments, animated: false)
        }
        self.sgValue.selectedSegmentIndex = value
        self.lblTitle.text = title
        self.valueChangedHandler = valueChangedHandler
        
        contentView.addSubview(sgValue)
        contentView.addSubview(lblTitle)
        
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 57)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            heightConstraint,
            lblTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sgValue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sgValue.leadingAnchor.constraint(greaterThanOrEqualTo: lblTitle.trailingAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: sgValue.trailingAnchor, constant: 20)
        ])
    }
    
    @objc func didSelect(segmentedControl:UISegmentedControl) {
        valueChangedHandler?(segmentedControl.selectedSegmentIndex)
    }
}
