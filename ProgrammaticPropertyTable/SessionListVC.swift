//
//  SessionListListVC.swift
//  ProgrammaticPropertyTable
//
//  Created by Per Ekskog on 2015-08-12.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

/*
Todo:

- Edit ger detta (add funkar fint)
ProgrammaticPropertyTable[4781:433847] Warning: Attempt to present <UINavigationController: 0x7ff0a15796b0> 
on <ProgrammaticPropertyTable.SessionListVC: 0x7ff0a151cc10> 
whose view is not in the window hierarchy!
*/


import UIKit

protocol SessionListDelegate {
    func save(taskEntries: [TaskEntry])
}

class SessionLongPressRecognizer:
        UILongPressGestureRecognizer {

    var sessionIndex: Int

    init(sessionIndex: Int, target: SessionListVC) {
        self.sessionIndex = sessionIndex
        super.init(target: target, action: "handleEditSession:")
    }
}

class SessionListVC: 
        UIViewController, 
        UITableViewDataSource, 
        UITableViewDelegate,
        SessionListDelegate {
    
    // Input/output data
    var sessions: [Session] = Session.find()
    
    // Internal
    
    let cellReuseId = "SessionList"
    var isEditingMode = false
    var selectedSessionIndex: Int = -1
    
    let table = UITableView()

    var addButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None
        self.title = "Session list"

        table.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseId)
        table.dataSource = self
        table.delegate = self
        table.setEditing(isEditingMode, animated: true)
        self.view.addSubview(table)      

        // Navigation bar
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addItem:")
        editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editItems:")

        self.navigationItem.rightBarButtonItems = [addButton, editButton]
    }

    override func viewWillAppear(animated: Bool) {
        if let indexPath = table.indexPathForSelectedRow() {
            table.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    override func viewWillLayoutSubviews() {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        var lastview: UIView

        table.frame = CGRectMake(5, 0, width-10, height)
        lastview = table
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // GUI actions
    
    func editItems(sender: UIButton) {
        isEditingMode = !isEditingMode
        if isEditingMode {
            editButton.title = "Done"
            editButton.style = .Done
        } else {
            editButton.title = "Edit"
            editButton.style = .Plain
        }
        table.setEditing(isEditingMode, animated: true)
    }
    
    func addItem(sender: UIButton) {
        performSegueWithIdentifier("AddSession", sender: self)
        selectedSessionIndex = -1
    }

//    func handleEditSession(sender: UILongPressGestureRecognizer) {
//        performSegueWithIdentifier("EditSession", sender: self)
//    }
    
    func handleEditSession(sender: SessionLongPressRecognizer) {
        selectedSessionIndex = sender.sessionIndex
        performSegueWithIdentifier("EditSession", sender: self)
    }
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSessionIndex = indexPath.row
        performSegueWithIdentifier("NavigateToTaskEntry", sender: self)
    }
        // UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if let c = tableView.dequeueReusableCellWithIdentifier(cellReuseId, forIndexPath: indexPath) as? UITableViewCell {
            cell = c
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellReuseId)
        }
        
        let s = sessions[indexPath.row]
        cell.textLabel?.text = "\(s.name)"
        cell.showsReorderControl = true
//        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleEditSession:"))
        cell.addGestureRecognizer(SessionLongPressRecognizer(sessionIndex: indexPath.row, target: self))
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let item = sessions[sourceIndexPath.row]
        sessions.removeAtIndex(sourceIndexPath.row)
        sessions.insert(item, atIndex: destinationIndexPath.row)
        dumpItems()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            sessions.removeAtIndex(indexPath.row)
        }
        dumpItems()
    }
    
    // Segue handling
    
    override
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NavigateToTaskEntry" {
            if let vc = segue.destinationViewController as? TaskEntryListVC {
                vc.taskEntries = sessions[selectedSessionIndex].taskEntries
                vc.sessionListDelegate = self
            }
        }
        if segue.identifier == "AddSession" {
            if let nvc = segue.destinationViewController as? UINavigationController,
                vc = nvc.topViewController as? SessionPropVC {
                vc.segue = "AddSession"
            }
        }
        if segue.identifier == "EditSession" {
            if let nvc = segue.destinationViewController as? UINavigationController,
                vc = nvc.topViewController as? SessionPropVC {
                vc.sessionTemplate = sessions[selectedSessionIndex]
                vc.segue = "EditSession"
            }
        }
    }

    @IBAction func exitSessionProp(unwindSegue: UIStoryboardSegue ) {
        if unwindSegue.identifier == "CancelSessionProp" {
            // Do nothing
        }
        if unwindSegue.identifier == "SaveSessionProp" {
            if let vc = unwindSegue.sourceViewController as? SessionPropVC,
                s = vc.sessionResult {
                if selectedSessionIndex == -1 {
                    // New TaskEntry added
                    sessions.append(s)
                } else {
                    // Existing TskEntry modified
                    sessions[selectedSessionIndex] = s
                }
                table.reloadData()
            }
        }
    }

    // SessionListDeegate
    func save(taskEntries: [TaskEntry]) {
        sessions[selectedSessionIndex].taskEntries = taskEntries
    }
    
    // Utilities
    
    func dumpItems() {
        println("---")
        for item in sessions {
            println(item)
        }
    }
    
}
