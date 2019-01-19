//
//  ViewController.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/15/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

    //MARK: - Properties
    
    // Create Realm instance
    let realm = try! Realm()
    
    fileprivate let cellID = "ToDoItemCell"
    let toDoListArrayKey = "ToDoListArray"
    
    
    // Create a Results that contains Catorgory type objects || Results is an auto updating container in Realm so everytime category is added to Realm database, it will automatically update the Results
    var toDoList : Results<Item>?
    
    // Create selected category
    var selectedCategory: Category? {
        didSet {
            // Load items from database
            loadItems()
        }
    }
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - UIViewController methods
    
    // Triggers when view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
    
    // Trggers when view will just about to appear || after viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
        guard let categoryHexColor = selectedCategory?.categoryColor else { fatalError() }
            
        // Update navbar
        updateNavBar(withHexCode: categoryHexColor)
            
        // Set navigation bar title to selected catagory name
        title = selectedCategory?.categoryName
    }
    
    // Trggers when view will just about to disappear || after viewWillAppear
    override func viewWillDisappear(_ animated: Bool) {
        
        // Reset navbar with original color
        updateNavBar(withHexCode: "#58B1F8")
        
    }
    
    // MARK: - NabBar Setup

    func updateNavBar(withHexCode colorHexCode : String) {
        // If navBar does not exsits, then fatal error will be thrown
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist" ) }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        // Set Navigation bar color
        navBar.barTintColor = navBarColor
        
        // tint color property reffers to all the navbar items
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: navBarColor, isFlat:true)
        
        // Set large title text attributes of navbar
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn: navBarColor, isFlat:true)]
        
        // Set the search bar tint color
        searchBar.barTintColor = navBarColor
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
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    // Commit changes to the Realm database
                    try self.realm.write {
                        // Add the new ToDo item
                        let newItem = Item()
                        newItem.itemTitle = textField.text!
                        newItem.dateCreated = Date()
                        
                        // Append the new item to the current category or selected category
                        currentCategory.items.append(newItem)
                        
                        // Reload tableview data
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error saving items to Realm database \(error)")
                }

            }
            
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
    
    
    //MARK: - TabelView Datasource methods
    
    // Determine how many rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList?.count ?? 1
    }
    
    // Triggered when table view looks for something to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a reusable cell || This time we use the cell created in the super class SwipeTableViewController
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = toDoList?[indexPath.row] {
            
            // bind the todo item to cell
            cell.textLabel?.text = item.itemTitle
            
            // If item status is true, then check it || if item status is false, then un-check it
            cell.accessoryType = item.itemStatus ? .checkmark : .none
            
            
            // Generate cell backdound color by darkening
            let cellBackgroundColor = UIColor(hexString: selectedCategory?.categoryColor ?? "#58B1F8")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoList!.count))
            
            // Generate text color matching to background color
            let textColor = UIColor(contrastingBlackOrWhiteColorOn:cellBackgroundColor!, isFlat:true)
            
            // Set cell background color
            cell.backgroundColor = cellBackgroundColor
            // Set cell text color
            cell.textLabel?.textColor = textColor
            
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }


        return cell
    }

    
    //MARK: - TabelView Delegate methods
   
    // Triggers when user selects a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = toDoList?[indexPath.row] {
            
            do {
                
                try realm.write {
                    // Update itemStatus and save it in the Real database
                    item.itemStatus = !item.itemStatus
                }
                
            } catch {
                print("Error updating Realm database \(error)")
            }
        }
        
        // Reload tebleview data
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // Create an animation when selecting a row

    }
    
    
    //MARK: - Data Manipulation methods
    
    // Saves items to persistent contriner from the context
    func saveItems(item : Item) {
        tableView.reloadData() // Reload the tableview
    }
    
    // Load items from the context which contains todo list items
    func loadItems() {
        
        toDoList = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        // Reload da tabel view data
        tableView.reloadData()
    }
    
    
    // MARK: - Dalete Data From Swipe
    
    // Delete todo items in database
    override func updateDataModel(at indexPath: IndexPath) {
        if let itemFromDeletion = self.selectedCategory?.items[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemFromDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
            
        }
        
    }
    
}



//MARK:- UISearchBar methods

extension ToDoListViewController : UISearchBarDelegate {

    // Triggered when user type something in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            // Load all items
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
        
        // Create predicate to query data
        let predicate = NSPredicate(format: "itemTitle CONTAINS[cd] %@", searchBar.text!)
        
        // Query and sort data
        toDoList = toDoList?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
        
        // Reload tableview data
        tableView.reloadData()
    }
}

