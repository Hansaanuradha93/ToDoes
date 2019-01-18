//
//  CategoryViewControllerTableViewController.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/17/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController{

    // MARK: - Properties
    
    // Create Realm instance
    let realm = try! Realm()
    
    // Reusable cell id
    fileprivate let cellID = "CategoryCell"
    fileprivate let segueID = "goToItems"
    
    // Create a Results that contains Catorgory type objects || Results is an auto updating container in Realm so everytime category is added to Realm database, it will automatically update the Results
    var categoryList : Results<Category>?
    // Create context
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load categories from the database
        loadCategories()
        
        // Increse the table view row height
        tableView.rowHeight = 60.0
        
    }

    
    // MARK: - IBActions
    
    // Triggered when add bar button pressed
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create a text field
        var textField = UITextField()
        
        // Create alert
        let alert = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert)
        
        // Create action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Add a new category
            let newCategory = Category()
            newCategory.categoryName = textField.text!
            newCategory.dateCreated = Date()
            
            // Save the items to the database
            self.save(category: newCategory)
            
        }
        
        // Add a text field to the alert
        alert.addTextField { (alertTextField) in
            // add a placeholder to the test field
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        // Add the action to the alert
        alert.addAction(action)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - TableView Datasource methods
    
    // Determine how many rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    // Triggered when table view looks for something to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.text = categoryList?[indexPath.row].categoryName ?? "No Categories Added"
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    // MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to ToDoListViewController
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            
            // Create desination view controller
            let destinationViewController = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                // Set the selectedCategory in CategoryViewController
                destinationViewController.selectedCategory = categoryList?[indexPath.row]
                
            }
        }
    }
    
    
    // MARK: - Data Manipulation methods
    
    // Saves items to persistent contriner from the context
    func save(category : Category) {
        do{
            // Commit changes to Realm database
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Errors saving context \(error)")
        }
        tableView.reloadData() // Reload the tableview
    }
    
    // load categories from the database
    func loadCategories() {
        
        // Load all the categories from Realm database
        categoryList = realm.objects(Category.self)
        
        // Reload tableview data
        tableView.reloadData()
    }

}


//MARK:- UISearchBar methods

extension CategoryViewController : UISearchBarDelegate {
    
    // Triggered when user type something in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            // load all categories
            loadCategories()
            
            // Do it in the foreground
            DispatchQueue.main.async {
                // Close the search bar and go back to the original state
                searchBar.resignFirstResponder()
            }
        } else {
            // Search categories
            searchCategories(with: searchBar)
        }
    }
    
    func searchCategories(with searchBar : UISearchBar) {
        
        // Create predicate to query data
        let predicate = NSPredicate(format: "categoryName CONTAINS[cd] %@", searchBar.text!)
        
        // Query data and sort them in dateCreated
        categoryList = categoryList?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
        
        // Reload tableview data
        tableView.reloadData()
        
    }
    
}


//MARK:- Swipe Cell Delegate methods

extension CategoryViewController : SwipeTableViewCellDelegate {
    
    // Conform to SwipeTableViewCellDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?{
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            if let categoryForDeletion = self.categoryList?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category \(error)")
                }

            }        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        
        return [deleteAction]
    }
    
    // Customize the behaviour of swipe actions
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
}
