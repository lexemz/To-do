//
//  ViewController.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import RealmSwift
import UIKit

class TaskGroupsViewController: UIViewController {
    // MARK: IBOutlets

    @IBOutlet var tableView: UITableView!
    
    // MARK: Private properties

    private var taskGroups: Results<TaskGroup>!
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func segmentedContolIsToggled(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            taskGroups = taskGroups.sorted(byKeyPath: "date", ascending: true)
            reloadRowsWithAnimation(animation: .right)
        default:
            taskGroups = taskGroups.sorted(byKeyPath: "groupName", ascending: true)
            reloadRowsWithAnimation(animation: .left)
        }
    }
    
    // MARK: Private methods
    
    private func createDemoData() {
        DataManager.shared.createDemoData {
            self.tableView.reloadData()
        }
    }
    
    private func reloadRowsWithAnimation(animation: UITableView.RowAnimation) {
        var indexPathsToReload: [IndexPath] = []
        
        for index in taskGroups.indices {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathsToReload.append(indexPath)
        }
        
        tableView.reloadRows(at: indexPathsToReload, with: animation)
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
                self.saveGroup(groupTitle)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func saveGroup(_ groupName: String) {
        let newGroup = TaskGroup(value: [groupName])
        StorageManager.shared.save(newGroup)
        
        let rowIndex = IndexPath(row: taskGroups.index(of: newGroup) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
    
    private func defineSymbolForGroupTaskCount(group: TaskGroup) -> NSAttributedString {
        let groupActiveTasks = group.tasks.filter("isComplete = false").count
        let groupCompletedTasks = group.tasks.filter("isComplete = true").count
        
        switch (groupActiveTasks, groupCompletedTasks) {
        case _ where groupActiveTasks == 0 && groupCompletedTasks == 0:
            return NSAttributedString(string: "0")
        case _ where groupActiveTasks == 0 && groupCompletedTasks != 0:
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = (UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen))
            return NSAttributedString(attachment: imageAttachment)
        default:
            return NSAttributedString(string: "\(groupActiveTasks)")
        }
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
        content.secondaryAttributedText = defineSymbolForGroupTaskCount(group: groupOfTasks)
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskGroup = taskGroups[indexPath.row]

        let doneAction = UIContextualAction(style: .normal, title: "All Done") { _, _, isDone in
            StorageManager.shared.done(taskGroup)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        doneAction.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}
