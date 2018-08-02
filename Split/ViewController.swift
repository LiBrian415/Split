//
//  ViewController.swift
//  Split
//
//  Created by Brian Li on 7/9/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "individualCell"
    let headerId = "headerId"
    
    var individuals: [Individual] = []
    
    //MARK: - Total Input
    
    let totalView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total: $"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "\(String(format: "%.02f", Total.total))"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var stackTotal: UIStackView = {
        let stack =  UIStackView(arrangedSubviews: [totalLabel, totalTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip: %"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tipTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "\(String(Total.tipPercentage))"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var stackTip: UIStackView = {
        let stack =  UIStackView(arrangedSubviews: [tipLabel, tipTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.backgroundColor = UIColor(red:0.00, green:0.50, blue:1.00, alpha:1.0)
        button.tintColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    //MARK: - Individual Table
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTotalView()
        
        navigationItem.title = "Bill"
        view.backgroundColor = UIColor.white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(IndividualCell.self, forCellReuseIdentifier: cellId)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return individuals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! IndividualCell
        
        cell.nameLabel.text = individuals[indexPath.row].name
        
        cell.costLabel.text = "$\(String(format: "%.02f", individuals[indexPath.row].totalAmount()))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            individuals.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! Header
        header.table = self
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let individualViewController = IndividualViewController()
        individualViewController.individual = individuals[indexPath.row]
        individualViewController.mainViewController = self
        
        navigationController?.pushViewController(individualViewController, animated: true)
    }
    
    @objc func insert() {
        individuals.append(Individual(name: "Person \(individuals.count)", costs: []))
        
        let insertionIndexPath = IndexPath(row: individuals.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath], with: .automatic)
        
        tableView.reloadData()
    }
    
    @objc func updateTotal() {
        if let newTotal = Double(totalTextField.text!) {
            Total.total = (newTotal*100).rounded()/100
        }
        if let newTip = Int(tipTextField.text!) {
            Total.tipPercentage = newTip
        }
        
        tableView.reloadData()
        dismissKeyboard()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    //MARK: - View setup
    
    private func setupTotalView(){
        view.addSubview(totalView)
        view.addSubview(tableView)
        totalView.addSubview(stackTotal)
        totalView.addSubview(stackTip)
        totalView.addSubview(updateButton)
        
        updateButton.addTarget(self, action: #selector(self.updateTotal), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            totalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            totalView.heightAnchor.constraint(equalToConstant: 150),
            totalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: totalView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackTotal.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 15),
            stackTotal.centerXAnchor.constraint(equalTo: totalView.centerXAnchor),
            totalTextField.widthAnchor.constraint(equalToConstant: 125),
            stackTip.topAnchor.constraint(equalTo: stackTotal.bottomAnchor, constant: 15),
            stackTip.centerXAnchor.constraint(equalTo: totalView.centerXAnchor),
            tipTextField.widthAnchor.constraint(equalToConstant: 125),
            tipLabel.trailingAnchor.constraint(equalTo: totalLabel.trailingAnchor),
            updateButton.topAnchor.constraint(equalTo: stackTip.bottomAnchor, constant: 15),
            updateButton.centerXAnchor.constraint(equalTo: totalView.centerXAnchor),
            updateButton.widthAnchor.constraint(equalTo: stackTotal.widthAnchor, constant: -10)
        ])
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


//MARK: - Header

class Header: UITableViewHeaderFooterView {
    
    var table: ViewController?
    
    let addButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Individuals"
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

//MARK: - Cell
class IndividualCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Person"
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
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


