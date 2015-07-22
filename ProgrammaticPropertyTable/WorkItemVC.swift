//
//  WorkItemVC.swift
//  TestStaticDynamicTable
//
//  Created by Per Ekskog on 2015-07-05.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

import UIKit

class WorkItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var editStart = false
    var editStop = false
    
    let table = UITableView()
    let datePickerStart = UIDatePicker()
    let datePickerStop = UIDatePicker()
    
    let cellStartTime = UITableViewCell(style: .Value1, reuseIdentifier: "EdtWorkVC-value1")
    let cellStopTime = UITableViewCell(style: .Value1, reuseIdentifier: "EdtWorkVC-value1")
    let cellTask = UITableViewCell(style: .Value1, reuseIdentifier: "EditWorkVC-value1")
    
    let items = ["App", "Coffee", "House", "TV"]

    
    // View lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = table.indexPathForSelectedRow() {
            table.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        table.frame = CGRectMake(5,20, width-10, height-25)
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
        
        let now = NSDate()
        datePickerStart.date = now
        datePickerStop.date = now
        datePickerStart.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
        datePickerStop.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat
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

        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        editStart = false
        editStop = false
        
        self.table.beginUpdates()
        
        switch indexPath.row {
        case 0:
            editStart = true
        case 2:
            editStop = true
        case 4:
            performSegueWithIdentifier("SelectItem", sender: self)
        default:
            let x = 1
        }
        
        self.table.endUpdates()
    }
    
    // UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
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
        case 4:
            cellTask.textLabel?.text = "Task"
            cellTask.detailTextLabel?.text = "task"
            cellTask.accessoryType = .DisclosureIndicator
            cell = cellTask
        default:
            cell = UITableViewCell()
            cell.textLabel?.text = "Configuration error"
        }
        return cell
    }

    // GUI targets
    
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
    
    // Segue handling
    
    @IBAction func exitSelectItem(unwindSegue: UIStoryboardSegue ) {
        if unwindSegue.identifier == "ExitSelectItem" {
            let vc = unwindSegue.sourceViewController as! SelectFromListVC
            if let i = vc.itemSelected {
                cellTask.detailTextLabel?.text = items[i]
            }
        }
    }

    @IBAction func exitEditList(unwindSegue: UIStoryboardSegue) {
        // Do nothing here
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectItem" {
            let vc = segue.destinationViewController as! SelectFromListVC
            vc.items = self.items
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

