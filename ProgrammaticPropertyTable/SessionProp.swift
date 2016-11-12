//
//  SessionPropVC.swift
//  ProgrammaticPropertyTable
//
//  Created by Per Ekskog on 2015-08-12.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

/*
Todo:

- textFieldDidEditing borde ha mer generiskt utseende, kanske det är den i SessionProp
som borde spara undan värdet och inte sakapa ett SessionResult förrän man trycker på save()?

- Text i tabellen ska ha lite luft mot kanterna

*/

import UIKit

class SessionPropVC: 
        UIViewController, 
        UITableViewDelegate, 
        UITableViewDataSource,
        UITextFieldDelegate {

    // Input data
    var sessionTemplate: Session?
    var segue: String?
    
    // Output data
    var sessionResult: Session?

    // Local data
    // (none)

    // Table and table cells
    var table: UITableView!
    
    // Hold TaskEntry attributes while editing
    let textSessionName = UITextField()
    
    // View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None

        if let s = segue {
            switch s {
                case "AddSession": 
                    self.title = "Add session"
                case "EditSession": 
                    self.title = "Edit session"
                default:
                    self.title = "???"
            }
        }
        
        self.table = UITableView(frame: self.view.frame, style: .Grouped)

        let buttonCancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = buttonCancel
        let buttonSave = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "save:")
        self.navigationItem.rightBarButtonItem = buttonSave

        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
        
        textSessionName.placeholder = "Name of session"
        textSessionName.delegate = self
        
        if let s = sessionTemplate {
            textSessionName.text = s.name
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = table.indexPathForSelectedRow() {
            table.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }

    override func viewWillLayoutSubviews() {

        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        table.frame = CGRectMake(0, 0, width, height)

        textSessionName.frame = CGRectMake(10, 0, width-20, 30)
        
    }

    override func viewDidLayoutSubviews() {

        table.separatorInset = UIEdgeInsetsZero
        table.layoutMargins = UIEdgeInsetsZero
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // GUI actions

    func cancel(sender: UIButton) {
        performSegueWithIdentifier("CancelSessionProp", sender: self)
    }
    
    func save(sender: UIButton) {
        if let s = textSessionName.text {
            performSegueWithIdentifier("SaveSessionProp", sender: self)
        }
    }

    //UITextFieldDelegate

    func textFieldDidEditing(textfield: UITextField) {
        switch textfield {
        case textSessionName:
            self.sessionResult = Session(name: textfield.text, taskEntries: [])
        default:
            let x = 1
        }
    }
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    // UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell = UITableViewCell()
                cell.contentView.addSubview(textSessionName)
            default:
                cell = UITableViewCell()
                cell.textLabel?.text = "Configuration error"
            }
        default:    
            cell = UITableViewCell()
            cell.textLabel?.text = "Configuration error"
        }

        return cell
    }

    // Segue handling
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CancelSessionProp" {
            // Do nothing
        }
        if segue.identifier == "SaveSessionProp" {
            // Fill in sessionResult
            sessionResult = Session(
                name: textSessionName.text!,
                taskEntries: [])
        }
    }
    

    
}

