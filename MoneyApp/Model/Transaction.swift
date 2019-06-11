//
//  Transaction.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class Transaction {
    
    var name: String
    var subtitle: String
    var amount: Int
    var category: Category
    
    
    init (name: String, subtitle: String, amount: Int, category: Category) {
        self.amount = amount
        self.name = name
        self.subtitle = subtitle
        self.category = category
    }
}
