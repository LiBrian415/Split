//
//  CalculatedController.swift
//  splitv02
//
//  Created by Brian Li on 8/10/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class CalculatedController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        table.layer.borderColor = UIColor.black.cgColor
        table.layer.borderWidth = 1
        table.layer.cornerRadius = 20
        table.clipsToBounds = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        navigationItem.title = "Total"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableCell.self, forCellReuseIdentifier: cellId)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.individual.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! Header
        header.text.text = "Share: "
        let v = UIView()
        v.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0)
        header.backgroundView = v
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableCell
        cell.nameLabel.text = Data.individual[indexPath.row].name
        cell.costLabel.text = "\(String(format: "$%.02f", Data.individual[indexPath.row].totalAmount()))"
        return cell
    }
    
    //MARK: - Setup
    
    func setupView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
