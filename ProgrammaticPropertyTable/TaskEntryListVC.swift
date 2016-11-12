//
//  TaskEntryListVC.swift
//  ProgrammaticPropertyTable
//
//  Created by Per Ekskog on 2015-07-06.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

/*
Todo:


*/


import UIKit

class TaskEntryListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Input/output data
    var taskEntries: [TaskEntry] = []
    var sessionListDelegate: SessionListDelegate?
    
    // Internal
    
    let cellReuseId = "EditTaskEntryList"
    var isEditingMode = false
    var selectedTaskEntryIndex: Int = -1
    
    let table = UITableView()

    var addButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None
        self.title = "TaskEntry list"

        table.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseId)
        table.dataSource = self
        table.delegate = self
        table.setEditing(isEditingMode, animated: true)
        self.view.addSubview(table)      

        // Navigation bar
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addItem:")
//        editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editItems:")
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
        performSegueWithIdentifier("AddTaskEntry", sender: self)
        selectedTaskEntryIndex = -1
    }
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTaskEntryIndex = indexPath.row
        performSegueWithIdentifier("EditTaskEntry", sender: self)
    }
    
    // UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if let c = tableView.dequeueReusableCellWithIdentifier(cellReuseId, forIndexPath: indexPath) as? UITableViewCell {
            cell = c
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellReuseId)
        }
        
        let t = taskEntries[indexPath.row]
        cell.textLabel?.text = "\(t.task.name): \(getStringNoDate(t.starttime))-\(getStringNoDate(t.stoptime)))"
        cell.showsReorderControl = true
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskEntries.count
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let item = taskEntries[sourceIndexPath.row]
        taskEntries.removeAtIndex(sourceIndexPath.row)
        taskEntries.insert(item, atIndex: destinationIndexPath.row)
        dumpItems()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            taskEntries.removeAtIndex(indexPath.row)
        }
        dumpItems()
    }
    
    // Segue handling
    
    override
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nvc = segue.destinationViewController as? UINavigationController {
            if segue.identifier == "AddTaskEntry" {
                if let vc = nvc.topViewController as? TaskEntryPropVC {
                    vc.segue = "AddTaskEntry"
                }
            }
            if segue.identifier == "EditTaskEntry" {
                if let vc = nvc.topViewController as? TaskEntryPropVC {
                    vc.taskEntryTemplate = taskEntries[selectedTaskEntryIndex]
                    vc.segue = "EditTaskEntry"
                }
            }
        }
    }

    @IBAction func exitTaskEntry(unwindSegue: UIStoryboardSegue ) {
        if unwindSegue.identifier == "CancelTaskEntry" {
            // Do nothing
        }
        if unwindSegue.identifier == "SaveTaskEntry" {
            if let vc = unwindSegue.sourceViewController as? TaskEntryPropVC,
                t = vc.taskEntryResult {
                if selectedTaskEntryIndex == -1 {
                    // New TaskEntry added
                    taskEntries.append(t)
                } else {
                    // Existing TskEntry modified
                    taskEntries[selectedTaskEntryIndex] = t
                }
                sessionListDelegate?.save(taskEntries)
                table.reloadData()
            }
        }
    }
    
    // Utilities
    
    func dumpItems() {
        println("---")
        for item in taskEntries {
            println(item)
        }
    }
    
}
