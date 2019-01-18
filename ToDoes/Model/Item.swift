//
//  Item.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/18/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    // Attributes
    @objc dynamic var itemTitle : String = ""
    @objc dynamic var itemStatus : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // Reflects inverse or backwards relationship between Item and Category (One to One)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
