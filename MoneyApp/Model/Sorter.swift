////
////  Sorter.swift
////  MoneyApp
////
////  Created by Orackle on 24.11.2019.
////  Copyright © 2019 Orackle. All rights reserved.
////
//
//import Foundation
//
//
//public class Sorter {
//    
//    let dater: Dater
//    
//    init(dater: Dater) {
//        self.dater = dater
//    }
//    
//    func sort(wallet: Wallet, broadDateInterval: DateInterval) -> [DateInterval : [Transaction]] {
//         
//     //   let start = CFAbsoluteTimeGetCurrent()
//        //        let diff = CFAbsoluteTimeGetCurrent() - start
//        //        print("Took \(diff) seconds")
//        var sortedTransactions = [DateInterval: [Transaction]]()
//        var transactions = [Transaction]()
//        
//        
//        // Get all transactions by passed dates
//        let transactionDates = wallet.getTransactionDatesBy(dateInterval: broadDateInterval)
//        for date in transactionDates {
//            if  let transactionsByDate = wallet.allTransactionsGrouped[date] {
//                transactions.append(contentsOf: transactionsByDate)
//            }
//        }
//        
//        switch dater.daterRange {
//            case .days: sortedTransactions = sortBy(calendarComponent: .day, transactionArray: transactions)
//            case .weeks: sortedTransactions = sortBy(calendarComponent: .day, transactionArray: transactions)
//            case .months : sortedTransactions = sortBy(calendarComponent: .day, transactionArray: transactions)
//            case .year: sortedTransactions = sortBy(calendarComponent: .month, transactionArray: transactions)
//            case .all: sortedTransactions = sortBy(calendarComponent: .year, transactionArray: transactions)
//            default: sortedTransactions = sortBy(calendarComponent: .day, transactionArray: transactions)
//        }
//   
//
//        
//        
//        return sortedTransactions
//    }
//    
//
//    func sortBy(calendarComponent: Calendar.Component, transactionArray: [Transaction]) -> [DateInterval: [Transaction]] {
//        
//        var sortedTransactions = [DateInterval: [Transaction]]()
//        
//        for transaction in transactionArray{
//
//            let date = transaction.date
//            let dateInterval = dater.getDateIntervalFor(date: date, using: calendarComponent)
//
//            if var transactionArrayByDate = sortedTransactions[dateInterval] {
//                 transactionArrayByDate.insert(transaction, at: 0)
//                 sortedTransactions.updateValue(transactionArrayByDate, forKey: dateInterval)
//             }
//             else {
//                 sortedTransactions.updateValue([transaction], forKey: dateInterval)
//             }
//        }
//        
//        return sortedTransactions
//    }
//    
//    
//}
//
//
//extension Sorter {
//    
//    func getSortedDateIntervals () -> [DateInterval : [DateInterval]] {
//        
//        let timeIntervals = dater.getTimeIntervals()
//        
//        var sortedIntervals =  [DateInterval : [DateInterval]]()
//        let calendarComponent = getCalendarComponent(from: dater.daterRange)
//        
//
//        for innerInterval in timeIntervals {
//            
//            
//            let outerInterval = dater.getDateIntervalFor(date: innerInterval.start, using: calendarComponent)
//            
//            if var innerIntervalArray = sortedIntervals[outerInterval] {
//                innerIntervalArray.insert(innerInterval, at: 0)
//                innerIntervalArray = innerIntervalArray.sorted(by: >)
//                sortedIntervals.updateValue(innerIntervalArray, forKey: outerInterval)
//            }
//            else {
//                sortedIntervals.updateValue([innerInterval], forKey: outerInterval)
//            }
//        }
//        return sortedIntervals
//    }
//    
//    
//    func getCalendarComponent(from daterRange: DaterRange) -> Calendar.Component {
//        switch dater.daterRange {
//        case .days:
//            return .month
//        case .weeks:
//            return .month
//        case .months:
//            return .year
//        case .year:
//            return .era
//        default:
//            return .day
//        }
//    }
//}
