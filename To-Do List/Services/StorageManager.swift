//
//  StorageManager.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    // MARK: - Group methods
    
    // save groups
    func save(_ taskGroups: [TaskGroup]) {
        write {
            realm.add(taskGroups)
        }
    }
    
    // save group
    func save(_ taskGroup: TaskGroup) {
        write {
            realm.add(taskGroup)
        }
    }
    
    // detele droup
    func delete(_ taskGroup: TaskGroup) {
        write {
            realm.delete(taskGroup.tasks)
            realm.delete(taskGroup)
        }
    }
    
    // edit gruop title
    func edit(_ taskGroup: TaskGroup, newTitle: String) {
        write {
            taskGroup.groupName = newTitle
        }
    }
    
    // complete all tasks in group
    func done(_ taskGroup: TaskGroup) {
        write {
            taskGroup.tasks.setValue(true, forKey: "isComplete")
        }
    }

    // MARK: - Task methods
    
    // save task
    func save(task: Task, to taskGroup: TaskGroup) {
        write {
            taskGroup.tasks.append(task)
        }
    }
    
    // delete task
    func delete(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    // edit tasl
    func edit(_ task: Task, newTitle: String, newNote: String) {
        write {
            task.name = newTitle
            task.note = newNote
        }
    }
    
    // edit complete status for task
    func editStatus(_ task: Task, status: Bool) {
        write {
            task.isComplete = status
        }
    }
    
    // MARK: - Database reading
    
    // safe reading database
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
