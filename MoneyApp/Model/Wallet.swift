//
//  Wallet.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation
import UIKit

class Wallet: NSObject {
  
    var name: String
    var balance: Decimal
    var currency: Currency
    var categoryList: CategoryList
    var color: UIColor
    var isSelected = false
    var transactionDates: [Date] {
        return  Array(allTransactionsGrouped.keys).sorted(by: >)
    }
    var allTransactionsGrouped = [Date: [Transaction]]() {
        didSet {
            calculateBalance()
        }
    }
    
    
    init(name: String, initialBalance: Decimal, currency: Currency) {
        self.name = name
        self.currency = currency
        self.balance = 0
        self.categoryList = CategoryList()
        self.color = Colors().getRandomColor()
        super.init()
        let _ = newTransaction(in: categoryList.listOfAllCategories[0], name: "Balance Update", amount: initialBalance, date: getTodaysDate())
        for _ in 0...1000 {
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
            }
            transaction.date = newDate
            addToAllTransactions(transaction: transaction)
        }
    }
    
    // Creates new transaction, calls "addToAllTransactions", returns said transaction.
    @discardableResult func newTransaction (in category: Category, name: String, amount: Decimal, date: Date) -> Transaction {
        let transaction = Transaction(name: name, amount: amount, category: category, date: date, currency: self.currency)
        addToAllTransactions(transaction: transaction)
        return transaction
    }
    
    // Adds a transaction to allTransactionGroped dict. Adds transaction.date to transactionsDate for future use.
    private func addToAllTransactions (transaction: Transaction) {
        if var transactionArrayByDate = allTransactionsGrouped[transaction.date] {
            transactionArrayByDate.insert(transaction, at: 0)
            allTransactionsGrouped.updateValue(transactionArrayByDate, forKey: transaction.date)
        }
        else {
            allTransactionsGrouped.updateValue([transaction], forKey: transaction.date)
        }
    }
    
    
    // Removes transaction by date from "allTransactionGrouped" dict
    func removeTransaction(by date: Date, with index: Int) {
        allTransactionsGrouped[date]?.remove(at: index)

    }
    
    func removeTransactionContainer (with date: Date) {
        if allTransactionsGrouped[date]!.isEmpty {
            allTransactionsGrouped.removeValue(forKey: date)
        }
    }
    
    func getTransactionsBy (dateInterval: DateInterval) -> [Date] {
        var dateArray = transactionDates.filter {
            dateInterval.contains($0)
        }
        dateArray.sort(by: >)
        return dateArray
    }
    
    func getTotalByInterval (dateInterval: DateInterval) -> Decimal {
        var dateArray = transactionDates.filter {
            dateInterval.contains($0)
        }
        dateArray.sort(by: >)
        var total: Decimal = 0
        for date in dateArray {
            for transaction in allTransactionsGrouped[date]! {
                total += transaction.amount
            }
        }
        return total
    }
   
    func getTotalByIntervalNoSort (dateInterval: DateInterval) -> Decimal {
        var dateArray = transactionDates.filter {
            dateInterval.contains($0)
        }
        dateArray.sort(by: <)
        var total: Decimal = 0
        for date in dateArray {
            for transaction in allTransactionsGrouped[date]! {
                total += transaction.amount
            }
        }
        return total
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
                                         amount: Decimal(getRandomAmount()),
                                         date: getRandomDate())
    }
    
    // Gets random Date for Testing Purposes
    func getRandomDate() -> Date {
        let randomMonth = Int.random(in: 0...11)
        let randomDay = Int.random(in: 1...31)
        let randomYear = Int.random(in: 2005...2019)
        let randomDate = DateComponents( timeZone: TimeZone(abbreviation: "GMT"), year: randomYear, month: randomMonth, day: randomDay)
        
        let calendar = Calendar.current
        let date = calendar.date(from: randomDate)!
        return date
    }
    
    func getTodaysDate() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: Date())
        components.timeZone = TimeZone(abbreviation: "GMT")
        let date = calendar.date(from: components)
        return date!
    }
    
    func getRandomAmount() -> Int {
            return Int.random(in: -1500...1500)
    }
    
   
    struct Colors {
        let list = [#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)]
        
        func getRandomColor() -> UIColor {
            return list[Int.random(in: 0...list.count-1)]
        }
    }
    
}
