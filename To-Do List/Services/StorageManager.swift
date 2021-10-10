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
    
    func saveContext(_ taskGroups: [TaskGroup]) {
        try! realm.write {
            realm.add(taskGroups)
        }
    }
}
