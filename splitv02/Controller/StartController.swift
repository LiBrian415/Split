//
//  StartController.swift
//  splitv02
//
//  Created by Brian Li on 8/11/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class StartController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    let tip: UILabel = {
        let view = UILabel()
        view.text = "Tip Percentage"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let segment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["10", "15", "18", "20", "Custom"])
        control.backgroundColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        control.layer.borderWidth = 1
        control.layer.borderColor = UIColor.black.cgColor
        control.layer.cornerRadius = 20
        control.clipsToBounds = true
        control.selectedSegmentIndex = 1
        control.addTarget(self, action: #selector(tipSelection), for: .valueChanged)
        return control
    }()
    
    lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tip, segment])
        stackView.backgroundColor = UIColor.white
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.borderColor = UIColor.black.cgColor
        table.layer.borderWidth = 1
        table.layer.cornerRadius = 20
        table.clipsToBounds = true
        return table
    }()
    
    let uploadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Split", for: .normal)
        button.backgroundColor = UIColor(red:0.00, green:0.50, blue:1.00, alpha:1.0)
        button.tintColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        navigationItem.title = "Setup"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCell.self, forCellReuseIdentifier: cellId)
        tableView.register(StartHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupView()
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.individual.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableCell
        cell.nameLabel.text = Data.individual[indexPath.row].name
        cell.costLabel.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! StartHeader
        header.table = self
        let v = UIView()
        v.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0)
        header.backgroundView = v
        return header
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Data.individual.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            tableView.reloadData()
        }
    }
    
    //MARK: - Setup
    
    func setupView(){
        /*
        view.addSubview(tip)
        view.addSubview(segment)
        */
        view.addSubview(stack)
        view.addSubview(tableView)
        view.addSubview(uploadButton)
        
        uploadButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            /*
            tip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tip.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tip.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tip.heightAnchor.constraint(equalToConstant: 40),
            segment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:8),
            segment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            segment.topAnchor.constraint(equalTo: tip.bottomAnchor, constant: 8),
            segment.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -16),
            */
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -16),
            uploadButton.heightAnchor.constraint(equalToConstant: 40),
            uploadButton.widthAnchor.constraint(equalToConstant: 200),
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/5),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:-8),
            tableView.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -16)
        ])
    }
    
    @objc func tipSelection(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            Total.tipPercentage = 10
            break
        case 1:
            Total.tipPercentage = 15
            break
        case 2:
            Total.tipPercentage = 18
            break
        case 3:
            Total.tipPercentage = 20
            break
        default:
            customTip()
            break
        }
    }
    
    func customTip(){
        let alert = UIAlertController(title: "Tip Percentage", message: "Input your custom tip percentage.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            var tipPercentage = 0
            if let tip = Int(alert.textFields![0].text!){
                tipPercentage = tip
            }
            Total.tipPercentage = tipPercentage
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add Tip Percentage(%)"
            textField.backgroundColor = UIColor.clear
            textField.keyboardType = .numberPad
            textField.borderStyle = .roundedRect
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
        for textfield: UIView in alert.textFields! {
            let container: UIView = textfield.superview!
            let effectView: UIView = container.superview!.subviews[0]
            container.backgroundColor = UIColor.clear
            effectView.removeFromSuperview()
        }
    }
    
    @objc func uploadImage(){
        let splitController = SplitController()
        navigationController?.pushViewController(splitController, animated: true)
    }
    
    @objc func insert() {
        let alert = UIAlertController(title: "New Individual", message: "Input the individual's initials", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add", style: .default) { [unowned self] action in
            
            let initials = alert.textFields![0].text!
            let individual = Individual(name: initials, costs: [], portions: [])
            Data.individual.append(individual)
            
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add initials"
            textField.backgroundColor = UIColor.clear
            textField.keyboardType = .default
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
}

