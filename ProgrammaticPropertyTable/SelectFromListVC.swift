//
//  SelectItemVC.swift
//  TestStaticDynamicTable
//
//  Created by Per Ekskog on 2015-07-06.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

import UIKit

class SelectFromListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Input data
    var items: [String]?
    
    // Output data
    var itemSelected: Int?
    
    
    // Internal
    
    let cellReuseId = "SelectItem"
    
    let table = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        table.frame = CGRectMake(5, 25, width-10, height-25)
        table.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseId)
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        itemSelected = indexPath.row
        performSegueWithIdentifier("ExitSelectItem", sender: self)
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
    
}
