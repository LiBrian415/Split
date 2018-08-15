//
//  HeaderCell.swift
//  splitv02
//
//  Created by Brian Li on 8/4/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class Header: UITableViewHeaderFooterView {
    
    let text: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bill: "
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    func setupViews(){
        addSubview(text)
        
        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            text.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
