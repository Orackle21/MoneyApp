//
//  Wallet.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class Wallet {
    
    var name = ""
    var balance = 0
    var allTransactions = [Transaction]()
    
    //  var color: WalletColors
    //  let currency: Currency
    
    func newTransaction (in category: Category, name: String, subtitle: String, amount: Int) {
        let transaction = Transaction(name: name, subtitle: subtitle, amount: amount, category: category)
        allTransactions.append(transaction)
    }
    
}
