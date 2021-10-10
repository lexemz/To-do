//
//  TasksTableViewController.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import RealmSwift

class TasksTableViewController: UITableViewController {
    
    var taskGroup: TaskGroup!
    
    private var activeTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = taskGroup.groupName
        
        activeTasks = taskGroup.tasks.filter("isComplete = false")
        completedTasks = taskGroup.tasks.filter("isComplete = true")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? activeTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Active Tasks" : "Completed Tasks"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = indexPath.section == 0 ? activeTasks[indexPath.row] : completedTasks[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = task.name
        content.secondaryText = task.note
        
        cell.contentConfiguration = content
        
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
}
