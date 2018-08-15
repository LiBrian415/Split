//
//  TableCell.swift
//  splitv02
//
//  Created by Brian Li on 8/4/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    func setupViews(){
        addSubview(nameLabel)
        addSubview(costLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: costLabel.leadingAnchor, constant: -8),
            costLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            costLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
