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
    
    func addTaskAction(with task: Task? = nil, completionHandler: @escaping (String, String) -> Void) {
        
        if task != nil { confirmButtonTitle = "Edit" }
        
        let saveAction = UIAlertAction(title: confirmButtonTitle, style: .default) { _ in
            guard let taskTitle = self.textFields?.first?.text else { return }
            guard let taskNote = self.textFields?.last?.text else { return }
            guard !taskTitle.isEmpty else { return }
            completionHandler(taskTitle, taskNote)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(cancelAction)
        addAction(saveAction)
        addTextField { first in
            first.placeholder = "Task title"
            first.text = task?.name
        }
        addTextField { secondField in
            secondField.placeholder = "Note"
            secondField.text = task?.note
        }
    }
}
