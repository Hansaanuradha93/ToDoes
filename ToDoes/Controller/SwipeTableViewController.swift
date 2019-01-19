//
//  SwipeTableViewController.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/19/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    // MARK: - Properties
    fileprivate let cellID = "Cell"
    
    // MARK: - View Controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Increse the table view row height
        tableView.rowHeight = 60.0
        
        // Remove seperator line in tableview cells
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source || Swipe Cell Delegate methods
    
    // Triggered when table view looks for something to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SwipeTableViewCell
        
        // Set the delegate from SwipeTableViewCellDelegate
        cell.delegate = self

        return cell
    }
    
    
    // MARK: - Swipe Cell Delegate methods
    
    // Conform to SwipeTableViewCellDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?{
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            // Update model here
            self.updateDataModel(at: indexPath)
            
            
        }
        
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
    
    
    // MARK: - Supporting methods
    
    // Update the model
    func updateDataModel(at indexPath : IndexPath) {
        // Will be ovveridden
    }

}
