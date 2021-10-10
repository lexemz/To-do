//
//  DataManager.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func createDemoData(_ completion: @escaping () -> Void) {
        if !UserDefaults.standard.bool(forKey: "createdDemoData") {
            UserDefaults.standard.set(true, forKey: "createdDemoData")
            
            let shoppingGroup = TaskGroup()
            shoppingGroup.groupName = "Shopping"
            
            let milkTask = Task()
            milkTask.name = "Milk"
            milkTask.note = "2 Liters"
            
            shoppingGroup.tasks.append(milkTask)
            
            let breadTask = Task(value:["Bread", "", Date(), true]) // массив
            let applesTask = Task(value: ["name": "Apples", "note": "2KG"]) // словарь
            
            shoppingGroup.tasks.insert(contentsOf: [breadTask, applesTask], at: 1) // массив сущностей и индекс вставки
        }
    }
}
