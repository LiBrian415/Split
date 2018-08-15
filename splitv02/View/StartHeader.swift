//
//  StartHeader.swift
//  splitv02
//
//  Created by Brian Li on 8/11/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class StartHeader: UITableViewHeaderFooterView {
    
    var table: StartController?
    
    let addButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let text: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Individuals: "
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
        addSubview(addButton)
        
        addButton.addTarget(table, action: #selector(insert), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            text.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    @objc func insert(){
        table?.insert()
    }
    
}
