//
//  Item.swift
//  ToDoes
//
//  Created by Hansa Anuradha on 1/16/19.
//  Copyright © 2019 Hansa Anuradha. All rights reserved.
//

import Foundation

// "Item" class conforms to Codable (Means "Item" class conforms to both Encodable and Decodable)
class Item: Codable {
    
    var itemTitle : String = "" // ToDo item text
    var itemStatus : Bool = false// Done or not done
    
}
