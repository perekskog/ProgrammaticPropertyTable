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

        self.edgesForExtendedLayout = UIRectEdge()
        self.title = "TaskEntry list"

        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseId)
        table.dataSource = self
        table.delegate = self
        table.setEditing(isEditingMode, animated: true)
        self.view.addSubview(table)      

        // Navigation bar
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(TaskEntryListVC.addItem(_:)))
//        editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editItems:")
        editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TaskEntryListVC.editItems(_:)))

        self.navigationItem.rightBarButtonItems = [addButton, editButton]
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = table.indexPathForSelectedRow {
            table.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewWillLayoutSubviews() {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        table.frame = CGRect(x: 5, y: 0, width: width-10, height: height)        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // GUI actions
    
    func editItems(_ sender: UIButton) {
        isEditingMode = !isEditingMode
        if isEditingMode {
            editButton.title = "Done"
            editButton.style = .done
        } else {
            editButton.title = "Edit"
            editButton.style = .plain
        }
        table.setEditing(isEditingMode, animated: true)
    }
    
    func addItem(_ sender: UIButton) {
        performSegue(withIdentifier: "AddTaskEntry", sender: self)
        selectedTaskEntryIndex = -1
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTaskEntryIndex = indexPath.row
        performSegue(withIdentifier: "EditTaskEntry", sender: self)
    }
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        
        let t = taskEntries[indexPath.row]
        cell.textLabel?.text = "\(t.task.name): \(getStringNoDate(t.starttime))-\(getStringNoDate(t.stoptime)))"
        cell.showsReorderControl = true
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskEntries.count
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = taskEntries[sourceIndexPath.row]
        taskEntries.remove(at: sourceIndexPath.row)
        taskEntries.insert(item, at: destinationIndexPath.row)
        dumpItems()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            taskEntries.remove(at: indexPath.row)
        }
        dumpItems()
    }
    
    // Segue handling
    
    override
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nvc = segue.destination as? UINavigationController {
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

    @IBAction func exitTaskEntry(_ unwindSegue: UIStoryboardSegue ) {
        if unwindSegue.identifier == "CancelTaskEntry" {
            // Do nothing
        }
        if unwindSegue.identifier == "SaveTaskEntry" {
            if let vc = unwindSegue.source as? TaskEntryPropVC,
                let t = vc.taskEntryResult {
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
        print("---")
        for item in taskEntries {
            print(item)
        }
    }
    
}
