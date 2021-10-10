//
//  CustomAlertController.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import UIKit

class CustomAlert: UIAlertController {
    
    private var confirmButtonTitle = "Save"
    
    static func groupAlert(title: String, subtitle: String) -> CustomAlert {
        CustomAlert(title: title, message: subtitle, preferredStyle: .alert)
    }

    func addGroupAction(with taskGroup: TaskGroup? = nil, completionHandler: @escaping (String) -> Void) {
        
        if taskGroup != nil { confirmButtonTitle = "Edit" }
        
        let saveAction = UIAlertAction(title: confirmButtonTitle, style: .default) { _ in
            guard let groupName = self.textFields?.first?.text else { return }
            guard !groupName.isEmpty else { return }
            completionHandler(groupName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(cancelAction)
        addAction(saveAction)
        addTextField { textField in
            textField.placeholder = "Grop title"
            textField.text = taskGroup?.groupName
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(cancelAction)
        addAction(saveAction)
        addTextField { first in
            first.placeholder = "Task title"
        }
        addTextField { secondField in
            secondField.placeholder = "Note"
        }
    }
}
