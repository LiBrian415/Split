//
//  IndividualController.swift
//  Split
//
//  Created by Brian Li on 7/10/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class IndividualViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let itemId = "itemId"
    let itemHeader = "itemHeader"
    
    var mainViewController: ViewController?
    var individual: Individual?
    
    let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name:"
        return label
    }()
    
    let nameTextBox: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Person"
        textField.keyboardType = .default
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var stackName: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, nameTextBox])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupViews()
        
        tableView.dataSource = self
        tableView.delegate = self
        nameTextBox.delegate = self
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: itemId)
        tableView.register(ItemHeader.self, forHeaderFooterViewReuseIdentifier: itemHeader)
        
        tableView.sectionHeaderHeight = 50
        tableView.rowHeight = 30
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reload()
    }
    
    //MARK: - Data Source
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: itemHeader) as! ItemHeader
        
        header.table = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return individual!.costs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemId, for: indexPath) as! ItemCell
        
        let item = individual!.costs[indexPath.row]
        
        cell.nameLabel.text = item.name
        
        cell.costLabel.text = String(format: "$%.02f", item.cost)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            individual!.costs.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            tableView.reloadData()
        }
    }
    
    @objc func insert(){
        let alert = UIAlertController(title: "New Item", message: "Add a new item", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            var costDouble = 0.0
            
            if let cost = Double(alert.textFields![0].text!){
                costDouble = cost
            }
            
            self.individual!.costs.append(Item(name: "Item \(self.individual!.costs.count)",cost: costDouble))
            
            let insertionIndexPath = IndexPath(row: self.individual!.costs.count - 1, section: 0)
            
            self.tableView.insertRows(at: [insertionIndexPath], with: .automatic)
            
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add Item Cost ($)"
            textField.backgroundColor = UIColor.clear
            textField.keyboardType = .decimalPad
            textField.borderStyle = .roundedRect
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        for textfield: UIView in alert.textFields! {
            let container: UIView = textfield.superview!
            let effectView: UIView = container.superview!.subviews[0]
            container.backgroundColor = UIColor.clear
            effectView.removeFromSuperview()
        }

    }
    
    @objc func reload() {
        if nameTextBox.text! == "" {
            individual!.name = "Person"
        } else {
            individual!.name = nameTextBox.text!
        }
        
        mainViewController?.reload()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        individual!.name = nameTextBox.text!
        
        self.view.endEditing(true)
        
        return true
    }
    
    //MARK: - Setup
    
    func setupViews(){
        view.addSubview(mainView)
        view.addSubview(stackName)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 100),
            stackName.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            stackName.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            nameTextBox.widthAnchor.constraint(equalToConstant: 200),
            tableView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
    }
    
}

class ItemHeader: UITableViewHeaderFooterView {
    
    var table: IndividualViewController?
    
    let addButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Items"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(addButton)
        
        addButton.addTarget(table, action: #selector(insert), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    @objc func insert(){
        table?.insert()
    }
}

class ItemCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Item"
        return label
    }()
    
    let costLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$0.00"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(costLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            costLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            costLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            costLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
