//
//  Transaction.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class Transaction: NSObject {
    
    var name: String
    var subtitle: String
    var amount: Int
    var category: Category
    var date: Date
    
    
    init (name: String, subtitle: String, amount: Int, category: Category, date: Date) {
        self.amount = amount
        self.name = name
        self.subtitle = subtitle
        self.category = category
        self.date = date
    }
}
