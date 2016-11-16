//
//  TaskSelectVC.swift
//  ProgrammaticPropertyTable
//
//  Created by Per Ekskog on 2015-07-06.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

/*
Todo:

*/

import UIKit

class TaskSelectVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Input data
    var tasks: [Task]?
    
    // Output data
    var taskIndexSelected: Int?
    
    
    // Internal
    
    let cellReuseId = "SelectTask"
    
    let table = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Task"
        
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseId)
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 30
        self.view.addSubview(table)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = table.indexPathForSelectedRow {
            table.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewWillLayoutSubviews() {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        table.frame = CGRect(x: 5, y: 0, width: width-10, height: height-25)        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskIndexSelected = indexPath.row
        performSegue(withIdentifier: "DoneSelectTask", sender: self)
    }
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        if let t = tasks?[indexPath.row] {
            cell.textLabel?.text = t.name
        }

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let t = tasks {
            return t.count
        } else {
            return 0
        }
    }
    
}
