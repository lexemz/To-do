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
    func save(_ task: Task, to taskGroup: TaskGroup) {
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
