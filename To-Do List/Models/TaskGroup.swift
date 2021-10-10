//
//  TaskGroup.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import RealmSwift

class TaskGroup: Object {
    @objc dynamic var groupName = ""
    @objc dynamic var date = Date()
    var tasks = List<Task>()
}

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}
