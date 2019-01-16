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
    
    // Create a data file path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    // Create a array contains todo items
    var toDoList = [Item]()
    
    
    //MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems() // Load items from the plist

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
            
            self.saveItems() // Save items to a plist
            
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
    
    
    // Determine how many rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
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
   

    // Triggers when user selects a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if item status is true, then set it to false || if item status is false, then set it to true
        toDoList[indexPath.row].itemStatus = toDoList[indexPath.row].itemStatus ? false : true
        
        saveItems() // Update the itemStatus in plist and save it
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // Create an animation when selecting a row

        
    }
    
    
    //MARK: - Supporting methods
    
    // Saves items
    func saveItems() {
        // Create a proprety list encoder
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(toDoList) // Encode data
            try data.write(to: dataFilePath!) // write data to the file path
        } catch {
            print("Endoing failed \(error)")
        }
    }
    
    // Load items from the plist which contains todo list items
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            // Create decoder
            let decoder = PropertyListDecoder()
            do {
            toDoList = try decoder.decode([Item].self, from: data)  // fill the toDoList array with decoded data
            } catch {
                print("Decoding failed \(error)")
            }
        }
    
    }
}

