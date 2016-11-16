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
    
    let cellStartTime = UITableViewCell(style: .value1, reuseIdentifier: "TaskEntry-type1")
    let cellStopTime = UITableViewCell(style: .value1, reuseIdentifier: "TaskEntry-type2")
    let cellTask = UITableViewCell(style: .value1, reuseIdentifier: "TaskEntry-type3")

    // Hold TaskEntry attributes while editing
    let datePickerStart = UIDatePicker()
    let datePickerStop = UIDatePicker()
    var taskSelected: Task?
    let textTaskEntryDescription = UITextField()
    
    // View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()

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
        
        self.table = UITableView(frame: self.view.frame, style: .grouped)

        let buttonCancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TaskEntryPropVC.cancel(_:)))
        self.navigationItem.leftBarButtonItem = buttonCancel
        let buttonSave = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TaskEntryPropVC.save(_:)))
        self.navigationItem.rightBarButtonItem = buttonSave

        
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
        
        let now = Date()
        datePickerStart.date = now
        datePickerStop.date = now
        datePickerStart.addTarget(self, action: #selector(TaskEntryPropVC.datePickerChanged(_:)), for: UIControlEvents.valueChanged)
        datePickerStop.addTarget(self, action: #selector(TaskEntryPropVC.datePickerChanged(_:)), for: UIControlEvents.valueChanged)

        textTaskEntryDescription.placeholder = "Description"
        textTaskEntryDescription.delegate = self

        if let t = taskEntryTemplate {
            datePickerStart.date = t.starttime as Date
            datePickerStop.date = t.stoptime as Date
            taskSelected = t.task
            textTaskEntryDescription.text = t.description
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

        textTaskEntryDescription.frame = CGRect(x: 10, y: 0, width: width-20, height: 30)

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // GUI actions

    func cancel(_ sender: UIButton) {
        performSegue(withIdentifier: "CancelTaskEntry", sender: self)
    }
    
    func save(_ sender: UIButton) {
        if taskSelected != nil {
            // Must have selected a task to save the task entry
            performSegue(withIdentifier: "SaveTaskEntry", sender: self)            
        }
    }
    
    func datePickerChanged(_ sender: UIDatePicker) {
        if sender == datePickerStart {
            if datePickerStart.date.compare(datePickerStop.date) == .orderedDescending {
                datePickerStop.date = datePickerStart.date
                cellStopTime.detailTextLabel?.text = getString(datePickerStop.date)
            }
            cellStartTime.detailTextLabel?.text = getString(datePickerStart.date)
        }
        if sender == datePickerStop {
            if datePickerStop.date.compare(datePickerStart.date) == .orderedAscending {
                datePickerStart.date = datePickerStop.date
                cellStartTime.detailTextLabel?.text = getString(datePickerStart.date)
            }
            cellStopTime.detailTextLabel?.text = getString(datePickerStop.date)
        }
    }

    // UITextFieldDelegate

    @nonobjc func textFieldDidEditing(_ textfield: UITextField) {
        // Nothing to e done?
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                _ = 1
            }
        case 1:
            switch indexPath.row {
            default: 
                performSegue(withIdentifier: "SelectTask", sender: self)
            }
        default:
            _ = 1
        }
        
        self.table.endUpdates()
    }
    
    // UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
                cellTask.accessoryType = .disclosureIndicator
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectTask" {
            if let vc = segue.destination as? TaskSelectVC {
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
                description: textTaskEntryDescription.text!
            )
        }
    }
    
    @IBAction func exitSelectTask(_ unwindSegue: UIStoryboardSegue ) {
        if unwindSegue.identifier == "DoneSelectTask" {
            if let vc = unwindSegue.source as? TaskSelectVC,
                let i = vc.taskIndexSelected {
                taskSelected = tasks[i]
                cellTask.detailTextLabel?.text = taskSelected!.name
            }
        }
    }

    // Utilities
    
    func getString(_ date: Date) -> String {
        let formatter = DateFormatter();
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMddhhmmss", options: 0, locale: Locale.current)
        let timeString = formatter.string(from: date)
        return timeString
    }
    
}

