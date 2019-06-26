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
    
   
    var allTransactionsGrouped = [Date: [Transaction]]()
    var transactionDates = [Date]()
    
    init() {
        let transactionTest0 = Transaction(name: "Burger", amount: 55, category: .Food, date: getRandomDate())
        let transactionTest1 = Transaction(name: "Internet", amount: 115, category: .Internet, date: getRandomDate())
        let transactionTest2 = Transaction(name: "Electricity", amount: 125, category: .Utilities, date: getRandomDate())
        
        addToAllTransactions(transaction: transactionTest0)
        addToAllTransactions(transaction: transactionTest1)
        addToAllTransactions(transaction: transactionTest2)
    }
    
    // Adds a transaction to allTransactionGroped dict. Adds transaction.date to transactionsDate for future use.
    func addToAllTransactions (transaction: Transaction) {
        if var transactionArrayByDate = allTransactionsGrouped[transaction.date] {
            transactionArrayByDate.insert(transaction, at: 0)
            allTransactionsGrouped.updateValue(transactionArrayByDate, forKey: transaction.date)
        }
        else {
            allTransactionsGrouped.updateValue([transaction], forKey: transaction.date)
            if transactionDates.contains(transaction.date) {
                return
            } else {
                transactionDates.append(transaction.date)
                transactionDates.sort(by: >)
            }
        }
    }
    
    func changeDate (transaction: Transaction, newDate: Date) {
        if let transactionArrayByDate = allTransactionsGrouped[transaction.date] {
            if let index = transactionArrayByDate.firstIndex(of: transaction) {
                allTransactionsGrouped[transaction.date]?.remove(at: index)
                if allTransactionsGrouped[transaction.date]!.isEmpty {
                    allTransactionsGrouped.removeValue(forKey: transaction.date)
                    transactionDates.remove(at: transactionDates.firstIndex(of: transaction.date)!)
                }
                transaction.date = newDate
                addToAllTransactions(transaction: transaction)
            }
            
        }
    }
    
    // Removes transaction by date from "allTransactionGrouped" dict. DOES NOT remove empty dates for transactionDates
    func removeTransaction(by date: Date, with index: Int) {
        allTransactionsGrouped[date]?.remove(at: index)
        if allTransactionsGrouped[date]!.isEmpty {
            allTransactionsGrouped.removeValue(forKey: date)
        }
    }
    
    // Creates new transaction, calls "addToAllTransactions", returns said transaction.
    func newTransaction (in category: Category, name: String, amount: Int, date: Date) -> Transaction {
        let transaction = Transaction(name: name, amount: amount, category: category, date: date)
        addToAllTransactions(transaction: transaction)
        print(transaction.date)
        return transaction
    }
    
    //    func moveTransaction (transaction: Transaction) {
    //        if var transactionArrayByDate = allTransactionsGrouped[transaction.date] {
    //            if let index = transactionArrayByDate.firstIndex(of: transaction) {
    //                let transactionToMove = transactionArrayByDate.remove(at: index)
    //                addToAllTransactions(transaction: transactionToMove)
    //            }
    //            if transactionArrayByDate.isEmpty {
    //                allTransactionsGrouped.removeValue(forKey: transaction.date)
    //                transactionDates.remove(at: transactionDates.firstIndex(of: transaction.date)!)
    //            }
    //        }
    //    }

    
    // Gets random Date for Testing Purposes
    func getRandomDate() -> Date {
        let randomMonth = Int.random(in: 1...2)
        let randomDay = Int.random(in: 1...2)
        let randomDate = DateComponents(year: 2019, month: randomMonth, day: randomDay)
        
        let calendar = Calendar.current
        let date = calendar.date(from: randomDate)!
        return date
    }
    
}
