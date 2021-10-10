//
//  ViewController.swift
//  To-Do List
//
//  Created by Igor on 10.10.2021.
//

import UIKit

class TaskGroupsViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


// MARK: - UITableViewDataSource
extension TaskGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        return cell
    }
}
