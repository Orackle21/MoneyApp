//
//  Extensions.swift
//  MoneyApp
//
//  Created by Orackle on 01/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

extension Date {
    
    func getMonths() -> [Date] {
        var date = self
        let calendar = Calendar.current
        var dates = [Date]()
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
        components.timeZone = TimeZone.init(abbreviation: "GMT")
        date = calendar.date(from: components)!
        
        dates.append(date)
        
        for _ in 0...11 {
            date = calendar.date(byAdding: .month, value: -1, to: date)!
            dates.append(date)
        }
        return dates
    }
    
    
    func getMonthInterval () -> DateInterval {
        let date = self
        let calendar = Calendar.current
        var beginningOfMonth: Date?
        var endOfMonth: Date?
        beginningOfMonth = calendar.dateInterval(of: .month, for: date)?.start
        endOfMonth = calendar.dateInterval(of: .month, for: date)?.end
        return DateInterval(start: beginningOfMonth!, end: endOfMonth!)
    }
    
}


// MARK: - Comparable

extension NSDecimalNumber: Comparable {}

public func ==(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
    return lhs.compare(rhs) == .orderedSame
}

public func <(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}

// MARK: - Arithmetic Operators

public prefix func -(value: NSDecimalNumber) -> NSDecimalNumber {
    return value.multiplying(by: NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true))
}

public func +(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
    return lhs.adding(rhs)
}

public func -(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
    return lhs.subtracting(rhs)
}

public func *(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
    return lhs.multiplying(by: rhs)
}

public func /(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
    return lhs.dividing(by: rhs)
}

public func ^(lhs: NSDecimalNumber, rhs: Int) -> NSDecimalNumber {
    return lhs.raising(toPower: rhs)
}
