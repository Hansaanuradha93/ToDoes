//
//  ViewController.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/15/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    //MARK: - Properties
    fileprivate let cellID = "ToDoItemCell"
    
    let toDoList = ["Learn ios", "Learn android", "Learn material design", "complete one question on the assignment"]
    
    //MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - TableView Datasource methods
    
    // Triggered when table view looks for something to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let toToItem: String = toDoList[indexPath.row]
        
        cell.textLabel?.text = toToItem
        
        return cell
    }
    
    // Determine how many rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }

    // Triggers when user selects a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(toDoList[indexPath.row])  // Print selected item
        
        tableView.deselectRow(at: indexPath, animated: true) // Create an animation when selecting a row
        
        // Check the row has a checkmark or not
        if ((tableView.cellForRow(at: indexPath)?.accessoryType ) == .checkmark) { // Row has a check mark
            tableView.cellForRow(at: indexPath)?.accessoryType = .none // Hide the check mark when user diselect the row
        } else { // Row does not have a check mark
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark // Display a check mark in the row when user selects it
        }
        
    }
    
}

