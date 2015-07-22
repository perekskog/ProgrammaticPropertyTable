//
//  EditListVC.swift
//  TestStaticDynamicTable
//
//  Created by Per Ekskog on 2015-07-06.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

import UIKit

class EditListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Input data
    var items: [String]?
    
    // Output data
    var editedItems: [String]?
    
    
    // Internal
    
    let cellReuseId = "EditItems"
    var isEditingMode = false
    
    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = ["Ett", "Två", "Tre", "Fyra"]
        
        // Do any additional setup after loading the view.
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        var lastview: UIView
        
        let addItem = UIButton.buttonWithType(.System) as! UIButton
        addItem.frame = CGRectMake(width-80, 30, 30, 20)
        addItem.setTitle("Add", forState: UIControlState.Normal)
        addItem.addTarget(self, action: "addItem:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addItem)
        lastview = addItem
        
        let editing = UIButton.buttonWithType(.System) as! UIButton
        editing.frame = CGRectMake(width-40, 30, 30, 20)
        editing.setTitle("Edit", forState: UIControlState.Normal)
        editing.addTarget(self, action: "editItems:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(editing)
        lastview = editing
        
        table.frame = CGRectMake(5,CGRectGetMaxY(lastview.frame), width-10, height-CGRectGetMaxY(lastview.frame))
        table.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseId)
        table.dataSource = self
        table.delegate = self
        table.setEditing(isEditingMode, animated: true)
        self.view.addSubview(table)
        lastview = table
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // GUI actions
    
    func editItems(sender: UIButton) {
        isEditingMode = !isEditingMode
        table.setEditing(isEditingMode, animated: true)
    }
    
    func addItem(sender: UIButton) {
        // Not implemented
    }
    
    // UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if let c = tableView.dequeueReusableCellWithIdentifier(cellReuseId, forIndexPath: indexPath) as? UITableViewCell {
            cell = c
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellReuseId)
        }
        
        cell.textLabel?.text = items?[indexPath.row]
        cell.showsReorderControl = true
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let i = items {
            return i.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        println("Move from \(sourceIndexPath.row) to \(destinationIndexPath.row)")
        if let item = items?[sourceIndexPath.row] {
            items?.removeAtIndex(sourceIndexPath.row)
            items?.insert(item, atIndex: destinationIndexPath.row)
        }
        dumpItems()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            items?.removeAtIndex(indexPath.row)
        }
        dumpItems()
        table.reloadData()
    }
    
    // Utilities
    
    func dumpItems() {
        println("---")
        if let ii=items {
            for item in ii {
                println(item)
            }
        }
    }
    
}
