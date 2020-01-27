//
//  Budget+CoreDataClass.swift
//  MoneyApp
//
//  Created by Orackle on 23.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Budget)
public class Budget: NSManagedObject {
    
    
    func getAmountSpent(coreDataStack: CoreDataStack) -> NSDecimalNumber {
        
        
        var amountSum : NSDecimalNumber = 0
        let startDate = NSNumber(value: self.startDate)
        let endDate = NSNumber(value: self.endDate)
        
        
        // Fetch Request
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Transaction")
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let predicate = NSPredicate(format: "simpleDate >=  %@ AND simpleDate <  %@ AND wallet == %@ AND category == %@ AND amount < 0", startDate, endDate, wallet!, category! )
        fetchRequest.predicate = predicate
        
        
        //Expression
        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sumAmounts"
        
        let transactionsAmountSum =  NSExpression(forKeyPath: #keyPath(Transaction.amount))
        sumExpressionDesc.expression = NSExpression(
            forFunction: "sum:",
            arguments: [transactionsAmountSum])
        sumExpressionDesc.expressionResultType = .decimalAttributeType
        
        
        fetchRequest.propertiesToFetch = [sumExpressionDesc]
        
        
        
        do {
            let results = try coreDataStack.managedContext.fetch(fetchRequest)
            let resultDict = results.first!
            amountSum = resultDict["sumAmounts"] as! NSDecimalNumber
        } catch let error as NSError {
            NSLog("Error when summing amounts: \(error.localizedDescription)")
        }
        
        return -amountSum
        
    }
    
}
