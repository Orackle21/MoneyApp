//
//  Wallet.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

class Wallet: Equatable {
  
    var name: String
    var balance: Int
    var currency: Currency
    var categoryList: CategoryList
    var color: UIColor
    var isSelected = false
    var transactionDates = [Date]()
    var allTransactionsGrouped = [Date: [Transaction]]() {
        didSet {
            calculateBalance()
        }
    }
    
    
    init(name: String, initialBalance: Int, currency: Currency) {
        self.name = name
        self.currency = currency
        self.balance = 0
        self.categoryList = CategoryList()
        self.color = Colors().getRandomColor()
        let _ = newTransaction(in: categoryList.listOfAllCategories[0], name: "Balance Update", amount: initialBalance, date: getTodaysDate())
        for _ in 0...100 {
            createRandomTransaction()
        }
    }
    
   
    // Changes transaction date and moves it into an appropriate array by date. If the old array container is empty - deletes it and deletes its date from the array.
    func changeDate (transaction: Transaction, newDate: Date) {
        if let transactionArrayByDate = allTransactionsGrouped[transaction.date],
           let index = transactionArrayByDate.firstIndex(of: transaction) {
            
            allTransactionsGrouped[transaction.date]?.remove(at: index)
            if allTransactionsGrouped[transaction.date]!.isEmpty {
                allTransactionsGrouped.removeValue(forKey: transaction.date)
                transactionDates.remove(at: transactionDates.firstIndex(of: transaction.date)!)
            }
            transaction.date = newDate
            addToAllTransactions(transaction: transaction)
        }
    }
    
    // Creates new transaction, calls "addToAllTransactions", returns said transaction.
    func newTransaction (in category: Category, name: String, amount: Int, date: Date) -> Transaction {
        let transaction = Transaction(name: name, amount: amount, category: category, date: date, currency: self.currency)
        addToAllTransactions(transaction: transaction)
        return transaction
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
    
    
    // Removes transaction by date from "allTransactionGrouped" dict. DOES NOT remove empty dates from transactionDates
    func removeTransaction(by date: Date, with index: Int) {
        allTransactionsGrouped[date]?.remove(at: index)
        if allTransactionsGrouped[date]!.isEmpty {
            allTransactionsGrouped.removeValue(forKey: date)
        }
    }
    
    func getTransactionBy (dateInterval: DateInterval) -> [Date] {
        var dateArray = transactionDates.filter {
            dateInterval.contains($0)
        }
        dateArray.sort(by: >)
        return dateArray
    }
   
    
    // Calculates balance for wallet based on its transactions
    func calculateBalance () {
        balance = 0
        for key in allTransactionsGrouped.keys {
            guard let arrayOfTransactions = allTransactionsGrouped[key] else { return }
            for transaction in arrayOfTransactions {
                balance += transaction.amount
            }
        }
    }
    
    
    //////////////////////////////////////////////////////////////////////////
    ////Random testing stuff//////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    func createRandomTransaction() {
        let _ = newTransaction(in: categoryList.listOfAllCategories[Int.random(in: 0...categoryList.listOfAllCategories.count - 1)],
                                         name: " ",
                                         amount: getRandomAmount(),
                                         date: getRandomDate())
    }
    
    // Gets random Date for Testing Purposes
    func getRandomDate() -> Date {
        let randomMonth = Int.random(in: 5...8)
        let randomDay = Int.random(in: 1...31)
        let randomDate = DateComponents( timeZone: TimeZone.init(abbreviation: "GMT"), year: 2019, month: randomMonth, day: randomDay)
        
        let calendar = Calendar.current
        let date = calendar.date(from: randomDate)!
        return date
    }
    
    func getTodaysDate() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: Date())
        components.timeZone = TimeZone.init(abbreviation: "GMT")
        let date = calendar.date(from: components)
        print (date!)
        return date!
    }
    
    func getRandomAmount() -> Int {
            return Int.random(in: -1500...1500)
    }
    
    static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        if lhs.name == rhs.name &&
           lhs.balance == rhs.balance {
            // ADD CURRENCY
            return true
        } else {
            return false
        }
    }
    
    struct Colors {
        let list = [#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)]
        
        func getRandomColor() -> UIColor {
            return list[Int.random(in: 0...list.count-1)]
        }
    }
    
}
