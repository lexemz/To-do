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
}

// MARK: - Alert Controller

extension TasksTableViewController {
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        let alert = CustomAlert.groupAlert(title: "Add task", subtitle: "What do you want to add?")

        alert.addTaskAction(with: task) { newTitle, newNote in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, newTitle: newTitle, newNote: newNote)
                completion()
            } else {
                self.save(newTitle, newNote)
            }
        }

        present(alert, animated: true)
    }

    private func save(_ taskTitle: String, _ taskNote: String?) {
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

// MARK: - UITableViewDelegate

extension TasksTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? activeTasks[indexPath.row] : completedTasks[indexPath.row]

        let deteleAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(with: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }

            isDone(true)
        }
        editAction.backgroundColor = .systemOrange

        return UISwipeActionsConfiguration(actions: [editAction, deteleAction])
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            let task = activeTasks[indexPath.row]

            let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
                StorageManager.shared.editStatus(task, status: true)
                isDone(true)

                let completedTasksRowIndex = IndexPath(row: self.completedTasks.index(of: task) ?? 0, section: 1)
                self.tableView.moveRow(at: indexPath, to: completedTasksRowIndex)
            }
            doneAction.backgroundColor = .systemGreen

            return UISwipeActionsConfiguration(actions: [doneAction])
        }

        let task = completedTasks[indexPath.row]

        let undoneAction = UIContextualAction(style: .normal, title: "Undone") { _, _, isDone in
            StorageManager.shared.editStatus(task, status: false)
            isDone(true)

            let activeTasksRowIndex = IndexPath(row: self.activeTasks.index(of: task) ?? 0, section: 0)
            self.tableView.moveRow(at: indexPath, to: activeTasksRowIndex)
        }
        undoneAction.backgroundColor = .systemPink

        return UISwipeActionsConfiguration(actions: [undoneAction])
    }
}
