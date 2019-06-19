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
    //  var color: WalletColors
    //  let currency: Currency
    
    var allTransactions = [Transaction]() {
        didSet {
            allTransactionGrouped = regroup()
        }
    }
    var allTransactionGrouped = [Date: [Transaction]]()
    
    init( ) {
        let transactionTest0 = Transaction(name: "Burger", subtitle: " ", amount: 55, category: .Food, date: getRandomDate())
        let transactionTest1 = Transaction(name: "Internet", subtitle: " ", amount: 115, category: .Internet, date: getRandomDate())
        let transactionTest2 = Transaction(name: "Electricity", subtitle: " ", amount: 125, category: .Utilities, date: getRandomDate())
        allTransactions.append(contentsOf: [transactionTest0, transactionTest1, transactionTest2])
        allTransactionGrouped = regroup()
    }
    
    func newTransaction (in category: Category, name: String, subtitle: String, amount: Int) -> Transaction {
        let transaction = Transaction(name: name, subtitle: subtitle, amount: amount, category: category, date: getRandomDate())
        allTransactions.append(transaction)
        allTransactionGrouped = regroup()
        return transaction
    }
    
    func regroup() -> Dictionary<Date, [Transaction]> {
        if !allTransactions.isEmpty {
            return Dictionary(grouping: allTransactions) { $0.date }
        }
        return [Date: [Transaction]]()
    }
    
    func getRandomDate() -> Date {
        let randomMonth = Int.random(in: 1...3)
        let randomDay = Int.random(in: 1...3)
        let randomDate = DateComponents(year: 2019, month: randomMonth, day: randomDay)
        
        let calendar = Calendar.current
        let date = calendar.date(from: randomDate)!
        return date
    }
    
}
