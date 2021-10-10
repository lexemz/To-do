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
    
    // сохранение сущностей в Persistent
    func save(_ taskGroups: [TaskGroup]) {
        write {
            realm.add(taskGroups)
        }
    }
    
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
