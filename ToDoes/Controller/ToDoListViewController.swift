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
    var toDoList = [Item]()
    
    // Create a UserDefaults
    let userDefaults = UserDefaults.standard
    
    //MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem1 = Item()
        newItem1.itemTitle = "Hello"
        toDoList.append(newItem1)
        
        let newItem2 = Item()
        newItem2.itemTitle = "Hello"
        toDoList.append(newItem2)
        
        let newItem3 = Item()
        newItem3.itemTitle = "Hello"
        toDoList.append(newItem3)
        

        // get the saved userDefault and set it as the value of toDoList
        if let items = userDefaults.array(forKey: toDoListArrayKey) as? [Item] {
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
            let newItem = Item()
            newItem.itemTitle = textField.text!
            self.toDoList.append(newItem) // append the new todo item to the array
            
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)  // Create a reusable cell
        
        let item = toDoList[indexPath.row]
        let toToItem: String = item.itemTitle // Get the todo item text
        
        cell.textLabel?.text = toToItem // bind the todo item to cell
        
        // If item status is true, then check it || if item status is false, then un-check it
        cell.accessoryType = item.itemStatus ? .checkmark : .none

        return cell
    }
    
    // Determine how many rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }

    // Triggers when user selects a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if item status is true, then set it to false || if item status is false, then set it to true
        toDoList[indexPath.row].itemStatus = toDoList[indexPath.row].itemStatus ? false : true
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // Create an animation when selecting a row

        
    }
    
}

