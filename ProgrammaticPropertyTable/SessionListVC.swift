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
    func save(_ taskEntries: [TaskEntry])
}

class SessionLongPressRecognizer:
        UILongPressGestureRecognizer {

    var sessionIndex: Int

    init(sessionIndex: Int, target: SessionListVC) {
        self.sessionIndex = sessionIndex
        super.init(target: target, action: #selector(SessionListVC.handleEditSession(_:)))
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

        self.edgesForExtendedLayout = UIRectEdge()
        self.title = "Session list"

        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseId)
        table.dataSource = self
        table.delegate = self
        table.setEditing(isEditingMode, animated: true)
        self.view.addSubview(table)      

        // Navigation bar
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(SessionListVC.addItem(_:)))
        editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SessionListVC.editItems(_:)))

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
        performSegue(withIdentifier: "AddSession", sender: self)
        selectedSessionIndex = -1
    }

//    func handleEditSession(sender: UILongPressGestureRecognizer) {
//        performSegueWithIdentifier("EditSession", sender: self)
//    }
    
    func handleEditSession(_ sender: SessionLongPressRecognizer) {
        selectedSessionIndex = sender.sessionIndex
        performSegue(withIdentifier: "EditSession", sender: self)
    }
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSessionIndex = indexPath.row
        performSegue(withIdentifier: "NavigateToTaskEntry", sender: self)
    }
        // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        
        let s = sessions[indexPath.row]
        cell.textLabel?.text = "\(s.name)"
        cell.showsReorderControl = true
//        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleEditSession:"))
        cell.addGestureRecognizer(SessionLongPressRecognizer(sessionIndex: indexPath.row, target: self))
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = sessions[sourceIndexPath.row]
        sessions.remove(at: sourceIndexPath.row)
        sessions.insert(item, at: destinationIndexPath.row)
        dumpItems()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            sessions.remove(at: indexPath.row)
        }
        dumpItems()
    }
    
    // Segue handling
    
    override
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NavigateToTaskEntry" {
            if let vc = segue.destination as? TaskEntryListVC {
                vc.taskEntries = sessions[selectedSessionIndex].taskEntries
                vc.sessionListDelegate = self
            }
        }
        if segue.identifier == "AddSession" {
            if let nvc = segue.destination as? UINavigationController,
                let vc = nvc.topViewController as? SessionPropVC {
                vc.segue = "AddSession"
            }
        }
        if segue.identifier == "EditSession" {
            if let nvc = segue.destination as? UINavigationController,
                let vc = nvc.topViewController as? SessionPropVC {
                vc.sessionTemplate = sessions[selectedSessionIndex]
                vc.segue = "EditSession"
            }
        }
    }

    @IBAction func exitSessionProp(_ unwindSegue: UIStoryboardSegue ) {
        if unwindSegue.identifier == "CancelSessionProp" {
            // Do nothing
        }
        if unwindSegue.identifier == "SaveSessionProp" {
            if let vc = unwindSegue.source as? SessionPropVC,
                let s = vc.sessionResult {
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
    func save(_ taskEntries: [TaskEntry]) {
        sessions[selectedSessionIndex].taskEntries = taskEntries
    }
    
    // Utilities
    
    func dumpItems() {
        print("---")
        for item in sessions {
            print(item)
        }
    }
    
}
