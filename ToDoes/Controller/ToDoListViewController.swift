//
//  ViewController.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/15/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    //MARK: - Properties
    
    fileprivate let cellID = "ToDoItemCell"
    let toDoListArrayKey = "ToDoListArray"
    
    // Create context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Create a array contains todo items
    var toDoList = [Item]()
    
    
    
    //MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Print the file path that has a data
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
        // Load items from database
        loadItems()
        
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
            let newItem = Item(context: self.context)
            newItem.itemTitle = textField.text!
            newItem.itemStatus = false
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
        let toDoItemText: String = item.itemTitle ?? "" // Get the todo item text
        
        cell.textLabel?.text = toDoItemText // bind the todo item to cell
        
        // If item status is true, then check it || if item status is false, then un-check it
        cell.accessoryType = item.itemStatus ? .checkmark : .none

        return cell
    }
   

    // Triggers when user selects a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if item status is true, then set it to false || if item status is false, then set it to true
        toDoList[indexPath.row].itemStatus = toDoList[indexPath.row].itemStatus ? false : true
        
//        context.delete(toDoList[indexPath.row]) // Remove NSObject from the context
//        toDoList.remove(at: indexPath.row) // Remove item from the array
        
        saveItems() // Commit the changes to database
        
        tableView.deselectRow(at: indexPath, animated: true) // Create an animation when selecting a row

    }
    
    
    //MARK: - Supporting methods
    
    // Saves items to persistent contriner from the context
    func saveItems() {
        do{
            try context.save()
        } catch {
            print("Errors saving context \(error)")
        }
        tableView.reloadData() // Reload the tableview
    }
    
    // Load items from the context which contains todo list items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        // Fetch the data using request
        do {
            toDoList = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        // Reload data
        tableView.reloadData()
    }
}


//MARK:- UISearchBar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    // Triggered when user type something in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            // Load all data
            loadItems()
            
            // Do it in the foreground
            DispatchQueue.main.async {
                // Close the search bar and go back to the original state
                searchBar.resignFirstResponder()
            }
        } else {
            // Search items
            searchItems(with: searchBar)
        }
    }
    
    // Search items
    func searchItems(with searchBar : UISearchBar) {
        // Create fetch request
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Create a predicate to query data || [cd] means no case and diacritic sansitive
        let predicate = NSPredicate(format: "itemTitle CONTAINS[cd] %@", searchBar.text!)
        
        // add the predicate to the request
        request.predicate = predicate
        
        // Sort data in ascending order
        let sortDescriptor = NSSortDescriptor(key: "itemTitle", ascending: true)
        
        // Add the sortDiscriptor to the request
        request.sortDescriptors = [sortDescriptor]
        
        // Load queried data
        loadItems(with: request)
    }
}

