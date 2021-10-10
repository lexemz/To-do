//
//  CustomAlertController.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import UIKit

class UICustomAlert: UIAlertController {
    
    private let alert: UIAlertController
    
    init(title: String, subtitle: String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGroupAction(completionHandler: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let groupName = self.textFields?.first?.text else { return }
            guard !groupName.isEmpty else { return }
            completionHandler(groupName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        addAction(cancelAction)
        addAction(saveAction)
        addTextField { textField in
            textField.placeholder = "Grop Name"
        }
    }
    
    func addTaskAction(completionHandler: @escaping (String, String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let taskName = self.textFields?.first?.text else { return }
            guard !taskName.isEmpty else { return }
            
            if let taskNote = self.textFields?.last?.text, !taskNote.isEmpty {
                completionHandler(taskName, taskNote)
            } else {
                
                completionHandler(taskName, "")
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        addAction(cancelAction)
        addAction(saveAction)
        addTextField { first in
            first.placeholder = "Grop Name"
        }
        addTextField { secondField in
            secondField.placeholder = "Note"
        }
    }
    
}
