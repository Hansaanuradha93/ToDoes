//
//  CategoryViewControllerTableViewController.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/17/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    // MARK: - Properties
    
    // Reusable cell id
    fileprivate let cellID = "CategoryCell"
    fileprivate let segueID = "goToItems"
    
    var categoryList = [Category]()
    // Create context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load categories from the database
        loadCategories()
        
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
            let newCategory = Category(context: self.context)
            newCategory.categoryName = textField.text!
            self.categoryList.append(newCategory)
            
            // Save the items to the database
            self.saveItems()
            
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
        return categoryList.count
    }
    
    // Triggered when table view looks for something to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let category = categoryList[indexPath.row]
        
        cell.textLabel?.text = category.categoryName
        
        return cell
    }
    
    
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
                destinationViewController.selectedCategory = categoryList[indexPath.row]
                
            }
        }
    }
    
    
    // MARK: - Data Manipulation methods
    
    // Saves items to persistent contriner from the context
    func saveItems() {
        do{
            try context.save()
        } catch {
            print("Errors saving context \(error)")
        }
        tableView.reloadData() // Reload the tableview
    }
    
    // load categories from the database
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        // Fetch the categories using request
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("Error fetching categories from context")
        }
        
        // Reload da tabel view data
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
        
        // Create a fetch request
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        // Create a predicate to query data || [cd] meand no case and diacritic sensitive
        let predicate = NSPredicate(format: "categoryName CONTAINS[cd] %@", searchBar.text!)
        
        // Add the predicate to the request
        request.predicate = predicate
        
        // Sort categories in ascending order
        let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
        
        // Add the sortDiscriptor to the request
        request.sortDescriptors = [sortDescriptor]
        
        // Load queried categories
        loadCategories(with: request)
        
    }
    
}
