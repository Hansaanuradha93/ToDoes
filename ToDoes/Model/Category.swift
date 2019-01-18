//
//  Category.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/18/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    // Attributes
    @objc dynamic var categoryName : String = ""
    @objc dynamic var dateCreated : Date?
    
    // Reflects forward relationship between Category and Item (One to Many)
    let items = List<Item>()
}
