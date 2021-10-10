//
//  TasksTableViewController.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import RealmSwift

class TasksTableViewController: UITableViewController {
    // MARK: Public Properties

    var taskGroup: TaskGroup!

    // MARK: Private Properties

    private var activeTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    // MARK: Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        title = taskGroup.groupName

        activeTasks = taskGroup.tasks.filter("isComplete = false")
        completedTasks = taskGroup.tasks.filter("isComplete = true")
    }

    // MARK: IBActions

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAlert()
    }

    // MARK: Private Methods

    private func showAlert() {
        let alert = CustomAlert.groupAlert(title: "Add task", subtitle: "What do you want to add?")

        alert.addTaskAction { taskTitle, taskNote in
            self.saveNewTask(taskTitle: taskTitle, taskNote: taskNote)
        }

        present(alert, animated: true)
    }

    private func saveNewTask(taskTitle: String, taskNote: String?) {
        let newTask = Task(value: [taskTitle, taskNote])
        StorageManager.shared.save(task: newTask, to: taskGroup)

        let rowIndex = IndexPath(row: activeTasks.index(of: newTask) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}

// MARK: - Table view data source

extension TasksTableViewController {
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
}
