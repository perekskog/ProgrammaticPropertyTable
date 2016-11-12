//
//  Model.swift
//  ProgrammaticPropertyTable
//
//  Created by Per Ekskog on 2015-07-06.
//  Copyright (c) 2015 Per Ekskog. All rights reserved.
//

/*
Todo:

*/

import Foundation


///////////////////////////////////
// Task

var allTasks: [Task] = [
	Task(name: "Vill", description: "Intressen, hobbies"),
    Task(name: "Behöver", description: "Behöver göras även om jag inte vill"),
    Task(name: "Skräp", description: "Vad jag varken vill eller behöver göra")
]

class Task {
	var name: String
	var description: String

    init(name: String, description: String) {
        self.name = name
        self.description = description
    }

	class func find() -> [Task] {
		return allTasks
	}

	class func save(tasks: [Task]) {
		allTasks = tasks
	}
}

////////////////////////////////////
// TaskEntry

class TaskEntry {
	var starttime: NSDate
	var stoptime: NSDate
	var task: Task
	var description: String

    init(starttime: NSDate, stoptime: NSDate, task: Task, description: String) {
        self.starttime = starttime
        self.stoptime = stoptime
        self.task = task
        self.description = description
    }
}

///////////////////////////////////
// Session

var allSessions: [Session] = [
	Session(name: "Hemma", taskEntries: []),
	Session(name: "Jobb", taskEntries: [])
]

class Session {
	var name: String
	var taskEntries: [TaskEntry]
    
    init(name: String, taskEntries: [TaskEntry]) {
        self.name = name
        self.taskEntries = taskEntries
    }

	class func find() -> [Session] {
		return allSessions
	}

	class func save(sessions: [Session]) {
		allSessions = sessions
	}
}
