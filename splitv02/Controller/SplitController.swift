//
//  ViewController.swift
//  splitv02
//
//  Created by Brian Li on 8/4/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import UIKit

class SplitController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let collectionId = "collectionId"
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private var selectedIndividual = 0
    private var selectedItem = -1
    private var currPortion = 0

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.layer.borderColor = UIColor.black.cgColor
        collection.layer.borderWidth = 1
        collection.layer.cornerRadius = 20
        collection.clipsToBounds = true
        return collection
    }()
    
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
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Calculate", for: .normal)
        button.backgroundColor = UIColor(red:0.00, green:0.50, blue:1.00, alpha:1.0)
        button.tintColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        let iconHeight: CGFloat = 38
        let padding: CGFloat = 6
        
        let images = [#imageLiteral(resourceName: "Add"),#imageLiteral(resourceName: "Portion"),#imageLiteral(resourceName: "Remove"),#imageLiteral(resourceName: "Cancel")]
        
        let arrangedSubviews =
            images.map({ (image) -> UIView in
            let v = UIImageView(image: image)
            v.layer.cornerRadius = iconHeight/2
            //required for hit testing
            v.isUserInteractionEnabled = true
            return v
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        //configuration options
        let numIcons = CGFloat(arrangedSubviews.count)
        let width: CGFloat = numIcons*iconHeight + (numIcons+1)*padding;
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight+2*padding)
        containerView.layer.cornerRadius = containerView.frame.height/2
        
        //shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackView.frame = containerView.frame
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        navigationItem.title = "Split"
        
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: collectionId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.register(TableCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SplitHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupView()
        setupLongPressGesture()
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionId, for: indexPath) as! CollectionCell
        if(selectedIndividual == indexPath.row){
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        cell.name.text = Data.individual[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Data.individual.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndividual = indexPath.row
        collectionView.scrollToItem(at:indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = (collectionView.frame.size.width - 50) / 2
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
    //MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableCell
        cell.nameLabel.text = Data.items[indexPath.row].name
        cell.costLabel.text = "\(String(format: "$%.02f", Data.items[indexPath.row].cost))"
        cell.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! SplitHeader
        let v = UIView()
        v.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0)
        header.backgroundView = v
        header.table = self
        return header
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Data.items.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            tableView.reloadData()
        }
    }
    
    //MARK: - Long Press Gesture
    
    fileprivate func setupLongPressGesture(){
        tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            handleGestureEnded(gesture: gesture)
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconsContainerView)
        
        let pressedLocation = gesture.location(in: self.tableView)
        if let indexPath = tableView.indexPathForRow(at: pressedLocation) {
            selectedItem = indexPath.row
        }
        
        //transformation of the box
        let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        iconsContainerView.alpha = 0
        self.iconsContainerView.transform =  CGAffineTransform(translationX: centeredX, y: pressedLocation.y + self.collectionView.frame.height + self.iconsContainerView.frame.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y + self.collectionView.frame.height)
        })
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconsContainerView)
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height/2)
        
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    
    fileprivate func handleGestureEnded(gesture: UILongPressGestureRecognizer) {
        //cleanup animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let stackView = self.iconsContainerView.subviews.first
            var selectedButton = -1
            var temp = 1
            stackView?.subviews.forEach({ (imageView) in
                if imageView.transform == CGAffineTransform(translationX: 0, y: -50) {
                    selectedButton = temp
                }
                imageView.transform = .identity
                temp+=1;
            })
            
            if(selectedButton == 1){
                self.add()
            } else if(selectedButton == 2){
                self.portion()
            } else if(selectedButton == 3){
                self.remove()
            } else {
                //do nothing (cancel/escape button)
            }
            
            self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 30)
            self.iconsContainerView.alpha = 0
        }, completion: { (_) in
            self.iconsContainerView.removeFromSuperview()
        })
    }
    
    func add(){
        if(!Data.items[selectedItem].isSelected && !Data.items[selectedItem].isPortioned){
            Data.items[selectedItem].isSelected = true
            Data.individual[selectedIndividual].costs.append(Data.items[selectedItem])
        } else {
            alreadySelected()
        }
    }
    
    func portion(){ //add alert for setting portion
        if(Data.items[selectedItem].isSelected){
            alreadySelected()
        } else {
            portionAlert()
        }
    }
    
    func remove(){
        var index = -1;
        var count = 0;
        for item in Data.individual[selectedIndividual].costs {
            if(item == Data.items[selectedItem]) {
                index = count;
                break
            }
            count+=1
        }
        if index >= 0 { //isSelected is true
            Data.individual[selectedIndividual].costs.remove(at: index)
            Data.items[selectedItem].isSelected = false
        } else if(Data.individual[selectedIndividual].portions[selectedItem] != 0) { //individual does have a portion
            Data.items[selectedItem].totalPortions -= Data.individual[selectedIndividual].portions[selectedItem] //subtract user's portion
            Data.individual[selectedIndividual].portions.remove(at: selectedItem)
            if(Data.items[selectedItem].totalPortions == 0){
                Data.items[selectedItem].isPortioned = false
            }
        }
    }
    
    func alreadySelected(){
        let alert = UIAlertController(title: "Item was already selected", message: "You or another individual has already selected this time.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Return", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func portionAlert(){
        let alert = UIAlertController(title: "Portion", message: "Input your portion", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            if let cost = Int(alert.textFields![0].text!){
                self.currPortion = cost
            }
            
            if(!Data.items[self.selectedItem].isPortioned){
                Data.items[self.selectedItem].totalPortions = self.currPortion
                Data.individual[self.selectedIndividual].portions[self.selectedItem] = self.currPortion
                Data.items[self.selectedItem].isPortioned = true
            } else if(Data.items[self.selectedItem].isPortioned){
                if(Data.individual[self.selectedIndividual].portions[self.selectedItem] == 0){
                    Data.items[self.selectedItem].totalPortions += self.currPortion
                } else {
                    Data.items[self.selectedItem].totalPortions += self.currPortion - Data.individual[self.selectedIndividual].portions[self.selectedItem]
                }
                Data.individual[self.selectedIndividual].portions[self.selectedItem] = self.currPortion
            }
            self.currPortion = 0
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Set Your Portion"
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
    
    //Mark: - Setup
    
    func setupView(){
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -16),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 200),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/6),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),
        ])
    }
    
    @objc func calculate() {
        let calculatedController = CalculatedController()
        navigationController?.pushViewController(calculatedController, animated: true)
    }
    
    @objc func insert() {
        let alert = UIAlertController(title: "New Item", message: "Input the item's quantity, name, and price", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add", style: .default) { [unowned self] action in
            
            var cost = 0.0
            
            let name = alert.textFields![0].text!
            if let price = Double(alert.textFields![1].text!) {
                cost = price
            }
            
            Data.items.append(Item(name: name, cost: cost))
            
            for individual in Data.individual {
                individual.portions = Array(repeating: 0, count: Data.items.count)
            }
            
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Item Name"
            textField.backgroundColor = UIColor.clear
            textField.keyboardType = .default
            textField.borderStyle = .roundedRect
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Item Price"
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
}


