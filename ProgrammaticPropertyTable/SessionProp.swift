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
        
        self.edgesForExtendedLayout = UIRectEdge()

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
        
        self.table = UITableView(frame: self.view.frame, style: .grouped)

        let buttonCancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SessionPropVC.cancel(_:)))
        self.navigationItem.leftBarButtonItem = buttonCancel
        let buttonSave = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SessionPropVC.save(_:)))
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = table.indexPathForSelectedRow {
            table.deselectRow(at: indexPath, animated: true)
        }
        
    }

    override func viewWillLayoutSubviews() {

        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        table.frame = CGRect(x: 0, y: 0, width: width, height: height)

        textSessionName.frame = CGRect(x: 10, y: 0, width: width-20, height: 30)
        
    }

    override func viewDidLayoutSubviews() {

        table.separatorInset = UIEdgeInsets.zero
        table.layoutMargins = UIEdgeInsets.zero
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // GUI actions

    func cancel(_ sender: UIButton) {
        performSegue(withIdentifier: "CancelSessionProp", sender: self)
    }
    
    func save(_ sender: UIButton) {
        if textSessionName.text != nil {
            performSegue(withIdentifier: "SaveSessionProp", sender: self)
        }
    }

    //UITextFieldDelegate

    @nonobjc func textFieldDidEditing(_ textfield: UITextField) {
        switch textfield {
        case textSessionName:
            self.sessionResult = Session(name: textfield.text!, taskEntries: [])
        default:
            _ = 1
        }
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    // UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

