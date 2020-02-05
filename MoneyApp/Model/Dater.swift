//
//  Dater.swift
//  MoneyApp
//
//  Created by Orackle on 02/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class Dater {
    
    
    var daterRange: DaterRange
    
    private let calendar = Calendar.current
    
    let dateFormatter = DateFormatter()
    let sectionHeaderDateFormatter = DateFormatter()
    let reportsHeaderDateFormatter = DateFormatter()
    
    
    init(daterRange: DaterRange = .months) {
        self.daterRange = daterRange
        setReportsHeaderDateFormatter(timeRange: daterRange)
        setSectionHeaderDateFormatter(timeRange: daterRange)
    }
    
    
    func setDaterRange (daterRange: DaterRange) -> [DateInterval: [DateInterval]]{
        
        self.daterRange = daterRange
        setReportsHeaderDateFormatter(timeRange: daterRange)
        setSectionHeaderDateFormatter(timeRange: daterRange)
        
        switch daterRange {
        case .days:
            return get(numberOf: 365, .day, in: 1, .year, grouped: false, startingFrom: Date())
        case .weeks:
           return get(numberOf: 52, .weekOfMonth, in: 1, .year, grouped: false, startingFrom: Date())
        case .months:
            return get(numberOf: 24, .month, in: 2, .year, grouped: false, startingFrom: Date())
        case .year:
            return get(numberOf: 20, .year, in: 1, .era, grouped: false, startingFrom: Date())
        case .all:
            return get(numberOf: 1, .era, in: 1, .era, grouped: false, startingFrom: Date())

        case .thisWeek:
            return get(numberOf: 7, .day, in: 1, .weekOfMonth, grouped: true, startingFrom: Date())
        case .thisMonth:
            return get(numberOf: 31, .day, in: 1, .month, grouped: true, startingFrom: Date())
        case .lastMonth:
            return get(numberOf: 62, .day, in: 2, .month, grouped: true, startingFrom: Date())
        case .halfAYear:
            return get(numberOf: 183, .day, in: 6, .month, grouped: true, startingFrom: Date())
        case .thisYear:
            return get(numberOf: 12, .month, in: 1, .year, grouped: true, startingFrom: Date())
        case .lastYear:
            return get(numberOf: 12, .month, in: 1, .year, grouped: true, startingFrom: Date())
        case .allYears:
            return get(numberOf: 20, .year, in: 1, .era, grouped: true, startingFrom: Date())
        }
        
    }
    
    /// Starts from the refference date. Goes back in time using provided Calendar.Component. Is constrained by "limit". Ex. Passing today's Date, with ".day" component and a limit of "1" will return previous day in DateInterval format, meaning that it contains day's start and end.
    
    private func calculateDateIntervals (startingFrom date: Date,
                                 with timeRange: Calendar.Component,
                                 upTo limit: Int)    -> [DateInterval] {
        
        var date = date
        var limit = limit
        var dates = [DateInterval]()
        
        
        if limit <= 0 {
            limit = getUpperRange(for: timeRange)
        }
            var todaysDateInterval = date.convertToDateInterval(using: timeRange)
            
            if timeRange == .month || timeRange == .weekOfMonth || timeRange == .year {
                todaysDateInterval.end = calendar.dateInterval(of: .day, for: date)!.end
        }
            
            
            dates.append(todaysDateInterval)
            
            if limit > 0 && timeRange != .era {
                for _ in 0..<limit - 1 {
                    
                    date = calendar.date(byAdding: timeRange, value: -1, to: date)!
                    let dateInterval = date.convertToDateInterval(using: timeRange)
                    dates.append(dateInterval)
                }
                
            }
            
        
        setDateFormatter(timeRange: timeRange)
        return dates
        
    }
    
    private func get(numberOf innerLimit: Int,  _ innerIntervalComponent: Calendar.Component,
             in broadLimit: Int,        _ broadIntervalComponent: Calendar.Component,
             grouped: Bool, startingFrom date: Date) -> [DateInterval: [DateInterval]] {
        
        let ungroupedInterval = DateInterval()
        var dateIntervalDictionary = [DateInterval: [DateInterval]]()
        
        let innerIntervals = calculateDateIntervals(startingFrom: date, with: innerIntervalComponent, upTo: innerLimit)

        if grouped {
            for innerInterval in innerIntervals {
                
                let broadInterval = innerInterval.start.convertToDateInterval(using: broadIntervalComponent)
                
                if var innerIntervalArray = dateIntervalDictionary[broadInterval] {
                    innerIntervalArray.append(innerInterval)
                    dateIntervalDictionary.updateValue(innerIntervalArray, forKey: broadInterval)
                }
                else {
                    if dateIntervalDictionary.keys.count == broadLimit { break }
                    dateIntervalDictionary.updateValue([innerInterval], forKey: broadInterval)
                }
            }
        }
        
        // Sets "ungroupedInterval" start and end values as the erliest and latest dates in "broadIntervals"
        else {
            
            dateIntervalDictionary.updateValue(innerIntervals, forKey: ungroupedInterval)

        }
        
        
        
        return dateIntervalDictionary
    }
    
    
    private func getComponentForDaterRange() -> Calendar.Component {
        
        
        switch daterRange {
        case .days: return .day
        case .weeks: return  .weekOfMonth
        case .months: return .month
        case .year: return .year
        case .all: return .era
            //  case .customRange:
        case .thisWeek:
            return .month
        case .thisMonth:
            return .month
        case .lastMonth:
            return .month
        case .halfAYear:
            return .month
        case .thisYear:
            return .month
        case .lastYear:
            return .month
        case .allYears:
            return .month
        }
        
        
    }
    
    private func getUpperRange(for timeRange: Calendar.Component) -> Int {
        switch timeRange {
        case .day: return 31
        case .month: return 12
        case .weekOfYear: return 12
        case .quarter: return 10
        case .year: return 48
        case .era: return 0
        default: return 7
        }
    }
    
    
    private func setDateFormatter(timeRange: Calendar.Component){
        switch timeRange {
        case .day: dateFormatter.dateFormat = "dd MMM"
        case .weekOfMonth: dateFormatter.dateFormat =  "dd MMM"
        case .month: dateFormatter.dateFormat = "MMMM"
        case .quarter: dateFormatter.dateFormat = "MMMM yy"
        case .year: dateFormatter.dateFormat = "yyyy"
        default: dateFormatter.dateFormat = "dd MMMM yyyy"
        }
    }
    
    private func setSectionHeaderDateFormatter(timeRange: DaterRange){
        switch timeRange {
        case .days: sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        case .weeks: sectionHeaderDateFormatter.dateFormat =  "dd MMMM"
        case .months: sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        case .year: sectionHeaderDateFormatter.dateFormat = "MMMM"
        case .all: sectionHeaderDateFormatter.dateFormat = "yyyy"
        case .thisWeek:
            sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        case .thisMonth:
            sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        case .lastMonth:
            sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        case .halfAYear:
            sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        case .thisYear:
            sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        case .lastYear:
            sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        case .allYears:
            sectionHeaderDateFormatter.dateFormat = "dd MMMM"
        }
    }
    
    private func setReportsHeaderDateFormatter(timeRange: DaterRange){
        switch timeRange {
        case .days: reportsHeaderDateFormatter.dateFormat = "MMMM"
        case .weeks: reportsHeaderDateFormatter.dateFormat =  "MMMM"
        case .months: reportsHeaderDateFormatter.dateFormat = "yyyy"
        case .year: reportsHeaderDateFormatter.dateFormat = " "
        case .all: reportsHeaderDateFormatter.dateFormat = "yyyy"
        case .thisWeek:
            reportsHeaderDateFormatter.dateFormat = "MMMM"
        case .thisMonth:
            reportsHeaderDateFormatter.dateFormat = "MMMM"
        case .lastMonth:
            reportsHeaderDateFormatter.dateFormat = "MMMM"
        case .halfAYear:
            reportsHeaderDateFormatter.dateFormat = "MMMM"
        case .thisYear:
            reportsHeaderDateFormatter.dateFormat = "MMMM"
        case .lastYear:
            reportsHeaderDateFormatter.dateFormat = "MMMM"
        case .allYears:
            reportsHeaderDateFormatter.dateFormat = "MMMM"
        }
    }
    
}

enum DaterRange {
    case days
    case weeks
    case months
    case year
    case all
    
    case thisWeek
    case thisMonth
    case lastMonth
    case halfAYear
    case thisYear
    case lastYear
    case allYears
    // case customRange
}



extension Dater {
    
    
    func getReportsIntervals (broad: Int) -> [DateInterval : [DateInterval]] {
        
        var sortedIntervals = [DateInterval : [DateInterval]]()
        let calendarComponent = getReportComponent(from: self.daterRange)
        
        let timeIntervals = calculateDateIntervals(startingFrom: Date(), with: getComponentForDaterRange(), upTo: 100)
        
        
        for innerInterval in timeIntervals {
            
            
            let outerInterval = innerInterval.start.convertToDateInterval(using: calendarComponent)
            
            if var innerIntervalArray = sortedIntervals[outerInterval] {
                innerIntervalArray.append(innerInterval)
                sortedIntervals.updateValue(innerIntervalArray, forKey: outerInterval)
            }
            else {
                if sortedIntervals.keys.count == 5 { break }
                sortedIntervals.updateValue([innerInterval], forKey: outerInterval)
            }
        }
        return sortedIntervals
    }
    
    
    func getReportComponent(from daterRange: DaterRange) -> Calendar.Component {
        switch self.daterRange {
        case .days:
            return .month
        case .weeks:
            return .weekOfMonth
        case .months:
            return .year
        case .year:
            return .era
        default:
            return .day
        }
    }
    
    
    
}
