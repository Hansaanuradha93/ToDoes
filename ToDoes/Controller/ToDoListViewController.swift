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
    let toDoListArrayKey = "ToDoListArray"
    
    // Create a array contains todo items
    var toDoList = ["Learn ios", "Learn android", "Learn material design", "complete one question on the assignment"]
    
    // Create a UserDefaults
    let userDefaults = UserDefaults.standard
    
    //MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the saved userDefault and set it as the value of toDoList
        if let items = userDefaults.array(forKey: toDoListArrayKey) as? [String] {
            toDoList = items
        }
    }
    
    
    // MARK: - IBActions
    
    // Add new todo item
    @IBAction func addNewToDoItemButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create a text field
        var textField = UITextField()

        // Create alert
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        // Create action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Add the new ToDo item in to the list
            self.toDoList.append(textField.text!) // append the new todo item to the array
            
            self.userDefaults.set(self.toDoList, forKey: self.toDoListArrayKey) // Save the todo list array in userDefaults
            
            self.tableView.reloadData() // Reload the tableview with the newly added data
        }
        
        // Add a text field to the alert
        alert.addTextField { (alertTextField) in
            // Add a placeholder to the text field
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // Add action to the alert
        alert.addAction(action)
        
        // Present alert
        present(alert, animated: true, completion: nil)
        
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

