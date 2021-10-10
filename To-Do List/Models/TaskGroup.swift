//
//  TaskGroup.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import RealmSwift

class TaskGroup: Object {
    @Persisted var groupName: String
    @Persisted var date = Date()
    var tasks = List<Task>()
}

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
