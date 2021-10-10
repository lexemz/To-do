//
//  ViewController.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import RealmSwift
import Foundation

class TaskGroupsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    private var taskGroups: Results<TaskGroup>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createDemoData()
        taskGroups = StorageManager.shared.realm.objects(TaskGroup.self)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    private func createDemoData() {
        DataManager.shared.createDemoData {
            self.tableView.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource
extension TaskGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let groupOfTasks = taskGroups[indexPath.row]
        
        content.text = groupOfTasks.groupName
        content.secondaryText = "\(groupOfTasks.tasks.count)"
        
        
        cell.contentConfiguration = content
        
        return cell
    }
}
