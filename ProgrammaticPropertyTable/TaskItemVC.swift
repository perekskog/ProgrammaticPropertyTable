//
//  TaskItemVC.swift
//  TestStaticDynamicTable
//
//  Created by Per Ekskog on 2015-07-06.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

import UIKit

class TaskItemVC: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    var nameOfTask: String?
    var descriptionOfTask: String?
    
    let textfieldName = UITextField()
    let textfieldDescription = UITextField()

    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let height = self.view.frame.height
        let width = self.view.frame.width
        
        table.frame = CGRectMake(5, 20, width-10, height-25)
        table.dataSource = self
        table.rowHeight = 30
        self.view.addSubview(table)
        
        textfieldName.delegate = self
        textfieldDescription.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDateSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let width = tableView.frame.width
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            textfieldName.frame = CGRectMake(0, 0, width, 30)
            textfieldName.placeholder = "Name of task"
            cell.contentView.addSubview(textfieldName)
        case 1:
            textfieldDescription.frame = CGRectMake(0, 0, width, 30)
            textfieldDescription.placeholder = "Description of task"
            cell.contentView.addSubview(textfieldDescription)
        default:
            cell.textLabel?.text = "Unknown cell"
        }
        
        return cell
    }
    
    // UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
        case textfieldName:
            self.nameOfTask = textField.text
        case textfieldDescription:
            self.descriptionOfTask = textField.text
        default:
            let x = 1
        }
    }
    
}
