//
//  CollectionCell.swift
//  splitv02
//
//  Created by Brian Li on 8/4/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {

    let color: UIColor = UIColor.white
    
    let name: UILabel = {
        let num = UILabel()
        num.text = "AA"
        num.translatesAutoresizingMaskIntoConstraints = false
        return num
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected{
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.contentView.layer.borderColor = UIColor.black.cgColor
                self.name.textColor = UIColor.black
            } else {
                self.transform = CGAffineTransform.identity
                self.contentView.layer.borderColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0).cgColor
                self.name.textColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    func setupViews() {
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
        addSubview(name)
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
}
