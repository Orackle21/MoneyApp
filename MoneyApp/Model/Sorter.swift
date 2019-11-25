//
//  Sorter.swift
//  MoneyApp
//
//  Created by Orackle on 24.11.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation


public class Sorter {
    
    let dater = Dater()
    
    func sort( wallet: Wallet,
               broadDateInterval: DateInterval,
               daterRange: DaterRange   ) -> [DateInterval : [Transaction]] {
         
        var sortedTransactions = [DateInterval: [Transaction]]()
        
        var transactions = [Transaction]()
        let transactionDates = wallet.getTransactionsBy(dateInterval: broadDateInterval)
        
        for date in transactionDates {
            if  let transactionsByDate = wallet.allTransactionsGrouped[date] {
                transactions.append(contentsOf: transactionsByDate)
            }

            
        }
        
        switch daterRange {
        case .days: sortedTransactions = sortBy(calendarComponent: .day, transactionArray: transactions)
        case .weeks: sortedTransactions = sortBy(calendarComponent: .day, transactionArray: transactions)
        case .months : sortedTransactions = sortBy(calendarComponent: .day, transactionArray: transactions)
        case .year: sortedTransactions = sortBy(calendarComponent: .month, transactionArray: transactions)
        case .all: sortedTransactions = sortBy(calendarComponent: .year, transactionArray: transactions)
        default: sortedTransactions = sortBy(calendarComponent: .day, transactionArray: transactions)
        }
        
        
     //   print (sortedTransactions)
        
        
        return sortedTransactions
    }
    

    func sortBy(calendarComponent: Calendar.Component, transactionArray: [Transaction]) -> [DateInterval: [Transaction]] {
        
        var sortedTransactions = [DateInterval: [Transaction]]()
        
        for transaction in transactionArray {
            
            let date = transaction.date
            let dateInterval = dater.getTimeIntervalFor(date: date, using: calendarComponent)
            
             if var transactionArrayByDate = sortedTransactions[dateInterval] {
                 transactionArrayByDate.insert(transaction, at: 0)
                 sortedTransactions.updateValue(transactionArrayByDate, forKey: dateInterval)
             }
             else {
                 sortedTransactions.updateValue([transaction], forKey: dateInterval)
             }
        }
        
        return sortedTransactions
    }
    
    
}
