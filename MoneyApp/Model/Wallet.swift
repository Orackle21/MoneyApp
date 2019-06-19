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
    
    var transactionDates = [Date]()
    
    var allTransactionGrouped = [Date: [Transaction]]()
    
    init( ) {
        let transactionTest0 = Transaction(name: "Burger", subtitle: " ", amount: 55, category: .Food, date: getRandomDate())
        let transactionTest1 = Transaction(name: "Internet", subtitle: " ", amount: 115, category: .Internet, date: getRandomDate())
        let transactionTest2 = Transaction(name: "Electricity", subtitle: " ", amount: 125, category: .Utilities, date: getRandomDate())
        
        addToAllTransactions(transaction: transactionTest0)
        addToAllTransactions(transaction: transactionTest1)
        addToAllTransactions(transaction: transactionTest2)
    }
    
    
    func addToAllTransactions (transaction: Transaction) {
        if let date = allTransactionGrouped[transaction.date] {
            var updatedTransactionsDay = date
            updatedTransactionsDay.insert(transaction, at: 0)
            allTransactionGrouped.updateValue(updatedTransactionsDay, forKey: transaction.date)
        }
        else {
            allTransactionGrouped.updateValue([transaction], forKey: transaction.date)
            transactionDates.append(transaction.date)
            transactionDates.sort()
            print(transactionDates.count)
            for date in transactionDates {
                print(date)
                
            }
        }
    }
    
    
    func removeTransaction(by date: Date, with index: Int) {
        allTransactionGrouped[date]?.remove(at: index)
        if allTransactionGrouped[date]!.isEmpty {
            allTransactionGrouped.removeValue(forKey: date)
           // transactionDates.remove(at: transactionDates.firstIndex(of: date)!)
            print (transactionDates.count)
            print ("alltransactionsCount is \(allTransactionGrouped.keys.count)")
        }
    }
    
    
    func newTransaction (in category: Category, name: String, subtitle: String, amount: Int) -> Transaction {
        let transaction = Transaction(name: name, subtitle: subtitle, amount: amount, category: category, date: getRandomDate())
        addToAllTransactions(transaction: transaction)
        return transaction
    }
    
    
    
    func getRandomDate() -> Date {
        let randomMonth = Int.random(in: 1...2)
        let randomDay = Int.random(in: 1...2)
        let randomDate = DateComponents(year: 2019, month: randomMonth, day: randomDay)
        
        let calendar = Calendar.current
        let date = calendar.date(from: randomDate)!
        return date
    }
    
}
