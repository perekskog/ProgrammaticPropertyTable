//
//  TaskEntryPropVC.swift
//  ProgrammaticPropertyTable
//
//  Created by Per Ekskog on 2015-07-05.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

/*
Todo:

- textFieldDidEditing borde ha mer generiskt utseende, kanske det är den i SessionProp
som borde spara undan värdet och inte sakapa ett SessionResult förrän man trycker på sava()?

*/

import UIKit

class TaskEntryPropVC: 
        UIViewController, 
        UITableViewDelegate, 
        UITableViewDataSource,
        UITextFieldDelegate {

    // Input data
    var taskEntryTemplate: TaskEntry?
    var segue: String?
    let tasks = Task.find()
    
    // Output data
    var taskEntryResult: TaskEntry?

    // Local data
    var editStart = false
    var editStop = false
    
    // Table and table cells
    var table: UITableView!
    
    let cellStartTime = UITableViewCell(style: .Value1, reuseIdentifier: "TaskEntry-type1")
    let cellStopTime = UITableViewCell(style: .Value1, reuseIdentifier: "TaskEntry-type2")
    let cellTask = UITableViewCell(style: .Value1, reuseIdentifier: "TaskEntry-type3")

    // Hold TaskEntry attributes while editing
    let datePickerStart = UIDatePicker()
    let datePickerStop = UIDatePicker()
    var taskSelected: Task?
    let textTaskEntryDescription = UITextField()
    
    // View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None

        if let s = segue {
            switch s {
                case "AddTaskEntry": 
                    self.title = "Add task entry"
                case "EditTaskEntry": 
                    self.title = "Edit task entry"
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
        
        let now = NSDate()
        datePickerStart.date = now
        datePickerStop.date = now
        datePickerStart.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
        datePickerStop.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)

        textTaskEntryDescription.placeholder = "Description"
        textTaskEntryDescription.delegate = self

        if let t = taskEntryTemplate {
            datePickerStart.date = t.starttime
            datePickerStop.date = t.stoptime
            taskSelected = t.task
            textTaskEntryDescription.text = t.description
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

        textTaskEntryDescription.frame = CGRectMake(10, 0, width-20, 30)

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // GUI actions

    func cancel(sender: UIButton) {
        performSegueWithIdentifier("CancelTaskEntry", sender: self)
    }
    
    func save(sender: UIButton) {
        if let t = taskSelected {
            // Must have selected a task to save the task entry
            performSegueWithIdentifier("SaveTaskEntry", sender: self)            
        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        if sender == datePickerStart {
            if datePickerStart.date.compare(datePickerStop.date) == .OrderedDescending {
                datePickerStop.date = datePickerStart.date
                cellStopTime.detailTextLabel?.text = getString(datePickerStop.date)
            }
            cellStartTime.detailTextLabel?.text = getString(datePickerStart.date)
        }
        if sender == datePickerStop {
            if datePickerStop.date.compare(datePickerStart.date) == .OrderedAscending {
                datePickerStart.date = datePickerStop.date
                cellStartTime.detailTextLabel?.text = getString(datePickerStart.date)
            }
            cellStopTime.detailTextLabel?.text = getString(datePickerStop.date)
        }
    }

    // UITextFieldDelegate

    func textFieldDidEditing(textfield: UITextField) {
        // Nothing to e done?
    }
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 1:
                if editStart == true {
                    height = 219
                } else {
                    height = 0
                }
            case 3:
                if editStop == true {
                    height = 219
                } else {
                    height = 0
                }
            default: height = 30
            }
        default:
            height = 30
        }

        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        editStart = false
        editStop = false
        
        self.table.beginUpdates()
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                editStart = true
            case 2:
                editStop = true
            default:
                let x = 1
            }
        case 1:
            switch indexPath.row {
            default: 
                performSegueWithIdentifier("SelectTask", sender: self)
            }
        default:
            let x = 1
        }
        
        self.table.endUpdates()
    }
    
    // UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
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
                cellStartTime.textLabel?.text = "Start time"
                cellStartTime.detailTextLabel?.text = getString(datePickerStart.date)
                cell = cellStartTime
            case 1:
                cell = UITableViewCell()
                cell.contentView.addSubview(datePickerStart)
                cell.clipsToBounds = true
            case 2:
                cellStopTime.textLabel?.text = "Stop time"
                cellStopTime.detailTextLabel?.text = getString(datePickerStop.date)
                cell = cellStopTime
            case 3:
                cell = UITableViewCell()
                let datepicker = UIDatePicker()
                cell.contentView.addSubview(datePickerStop)
                cell.clipsToBounds = true
            default:
                cell = UITableViewCell()
                cell.textLabel?.text = "Configuration error"
            }
        case 1:
            switch indexPath.row {
            case 0:
                cellTask.textLabel?.text = "Task"
                if let t = taskSelected {
                    cellTask.detailTextLabel?.text = t.name                    
                }
                cellTask.accessoryType = .DisclosureIndicator
                cell = cellTask
            default:
                cell = UITableViewCell()
                cell.textLabel?.text = "Configuration error"
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell = UITableViewCell()
                cell.contentView.addSubview(textTaskEntryDescription)
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
        if segue.identifier == "SelectTask" {
            if let vc = segue.destinationViewController as? TaskSelectVC {
                vc.tasks = tasks
            }
        }
        if segue.identifier == "CancelTaskEntry" {
            // Do nothing
        }
        if segue.identifier == "SaveTaskEntry" {
            // Fill in TaskEntryResult
            taskEntryResult = TaskEntry(
                starttime: datePickerStart.date, 
                stoptime: datePickerStop.date,
                task: taskSelected!,
                description: textTaskEntryDescription.text
            )
        }
    }
    
    @IBAction func exitSelectTask(unwindSegue: UIStoryboardSegue ) {
        if unwindSegue.identifier == "DoneSelectTask" {
            if let vc = unwindSegue.sourceViewController as? TaskSelectVC,
                i = vc.taskIndexSelected {
                taskSelected = tasks[i]
                cellTask.detailTextLabel?.text = taskSelected!.name
            }
        }
    }

    // Utilities
    
    func getString(date: NSDate) -> String {
        let formatter = NSDateFormatter();
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyyMMddhhmmss", options: 0, locale: NSLocale.currentLocale())
        let timeString = formatter.stringFromDate(date)
        return timeString
    }
    
}

