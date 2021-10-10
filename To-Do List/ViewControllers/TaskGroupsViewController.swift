//
//  ViewController.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import Foundation
import RealmSwift

class TaskGroupsViewController: UIViewController {
    // MARK: IBOutlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    // MARK: Private properties

    private var taskGroups: Results<TaskGroup>!
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createDemoData()
        taskGroups = StorageManager.shared.realm.objects(TaskGroup.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        // TODO: completed tasks check
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tappedRow = sender as? Int else { return }
        guard let taskTableVC = segue.destination as? TasksTableViewController else { return }
        
        let taskGroup = taskGroups[tappedRow]
        taskTableVC.taskGroup = taskGroup
    }

    // MARK: IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAlert()
    }

    // MARK: Private methods
    
    private func createDemoData() {
        DataManager.shared.createDemoData {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Alet Controller

extension TaskGroupsViewController {
    private func showAlert(with taskGroup: TaskGroup? = nil, completion: (() -> Void)? = nil) {
        let alert = CustomAlert.groupAlert(title: "Add New Group", subtitle: "Type group title")
        
        alert.addGroupAction(with: taskGroup) { groupTitle in
            if let taskGroup = taskGroup, let completion = completion {
                StorageManager.shared.edit(taskGroup, newTitle: groupTitle)
                completion()
            } else {
                self.save(groupTitle)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func save(_ groupName: String) {
        let newGroup = TaskGroup(value: [groupName])
        StorageManager.shared.save(newGroup)
        
        let rowIndex = IndexPath(row: taskGroups.index(of: newGroup) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}

// MARK: - UITableViewDataSource

extension TaskGroupsViewController: UITableViewDataSource {
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

// MARK: - UITableViewDelegate

extension TaskGroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "fromGroupToTasks", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskGroup = taskGroups[indexPath.row]
        
        let deteleAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(taskGroup)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(with: taskGroup) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [editAction, deteleAction])
    }
}
