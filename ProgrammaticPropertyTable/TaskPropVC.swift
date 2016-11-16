//
//  TaskPropVC.swift
//  ProgrammaticPropertyTable
//
//  Created by Per Ekskog on 2015-07-06.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

/*
Todo:

*/

import UIKit

class TaskPropVC: 
        UIViewController, 
        UITableViewDataSource, 
        UITextFieldDelegate {
    
    var nameOfTask: String?
    var descriptionOfTask: String?
    
    let textfieldName = UITextField()
    let textfieldDescription = UITextField()

    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let height = self.view.frame.height
        let width = self.view.frame.width
        
        table.frame = CGRect(x: 5, y: 0, width: width-10, height: height-25)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let width = tableView.frame.width
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            textfieldName.frame = CGRect(x: 0, y: 0, width: width, height: 30)
            textfieldName.placeholder = "Name of task"
            cell.contentView.addSubview(textfieldName)
        case 1:
            textfieldDescription.frame = CGRect(x: 0, y: 0, width: width, height: 30)
            textfieldDescription.placeholder = "Description of task"
            cell.contentView.addSubview(textfieldDescription)
        default:
            cell.textLabel?.text = "Unknown cell"
        }
        
        return cell
    }
    
    // UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case textfieldName:
            self.nameOfTask = textField.text
        case textfieldDescription:
            self.descriptionOfTask = textField.text
        default:
            _ = 1
        }
    }
    
}
