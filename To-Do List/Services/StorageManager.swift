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
    
    // сохранение задачи в Persistent с ссылкой на TaskGroup
    func save(task: Task, to taskGroup: TaskGroup) {
        write {
            taskGroup.tasks.append(task)
        }
    }
    
    // сохранение сущностей в Persistent
    func save(_ taskGroups: [TaskGroup]) {
        write {
            realm.add(taskGroups)
        }
    }
    
    // сохранение одной сущности
    func save(_ taskGroup: TaskGroup) {
        write {
            realm.add(taskGroup)
        }
    }
    
    // удаление группы задач
    func delete(_ taskGroup: TaskGroup) {
        write {
            realm.delete(taskGroup.tasks)
            realm.delete(taskGroup)
        }
    }
    
    func delete(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    // изменение заголовка группы задач
    func edit(_ taskGroup: TaskGroup, newTitle: String) {
        write {
            taskGroup.groupName = newTitle
        }
    }
    
    func edit(_ task: Task, newTitle: String, newNote: String) {
        write {
            task.name = newTitle
            task.note = newNote
        }
    }
    
    // массовая отметка выполненых задач
    func done(_ taskGroup: TaskGroup) {
        write {
            taskGroup.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    func editStatus(_ task: Task, status: Bool) {
        write {
            task.isComplete = status
        }
    }
    
    // безопасное чтение БД
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
}
