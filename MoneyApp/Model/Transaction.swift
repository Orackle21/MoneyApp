//
//  Transaction.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class Transaction: NSObject, Comparable{
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.date < rhs.date
    }
    
    
    var name: String
    var amount: Decimal
    var category: Category?
    var date: Date
    var currency: Currency
    
    init (name: String, amount: Decimal, category: Category, date: Date, currency: Currency) {
        self.amount = amount
        self.name = name
        self.category = category
        self.date = date
        self.currency = currency
    }
    
    
}
