//
//  Dater.swift
//  MoneyApp
//
//  Created by Orackle on 02/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class Dater {
    
    
    var daterRange: DaterRange {
        
        didSet {
            setReportsHeaderDateFormatter(timeRange: daterRange)
            setSectionHeaderDateFormatter(timeRange: daterRange)
        }
    }
    
    
    private let calendar = Calendar.current

    let dateFormatter = DateFormatter()
    let sectionHeaderDateFormatter = DateFormatter()
    let reportsHeaderDateFormatter = DateFormatter()
    
    
    init() {
        daterRange = .months
        setReportsHeaderDateFormatter(timeRange: daterRange)
        setSectionHeaderDateFormatter(timeRange: daterRange)
    }
    

    
    // Starts from the refference date. Goes back in time using provided Calendar.Component. Is constrained by "limit".
    // Ex. Passing today's Date, with ".day" component and a limit of "1" will return previous day in DateInterval format, meaning that it bears day's start and end.
    
    func calculateDateIntervals (startingFrom date: Date = Date(),
                                 with timeRange: Calendar.Component? = nil,
                                 upTo limit: Int = 0)    -> [DateInterval] {
        

        var date = date
        var limit = limit
        var dates = [DateInterval]()
        
        var timeRange = timeRange
        if timeRange == nil {
            timeRange = getComponentForDaterRange()
        }
        
        if limit <= 0 {
            limit = getUpperRange(for: timeRange!)
        }
        
        
        
        if let timeRange = timeRange{
            
            let dateInterval = getDateIntervalFor(date: date, using: timeRange)
            
            dates.append(dateInterval)
            
            if limit > 0 && timeRange != .era {
                for _ in 0..<limit - 1 {
                    
                    date = calendar.date(byAdding: timeRange, value: -1, to: date)!
                    let dateInterval = getDateIntervalFor(date: date, using: timeRange)
                    dates.append(dateInterval)
                }
                
            }
            
        }
        setDateFormatter(timeRange: timeRange!)
        return dates
        
    }
    
    
    private func getComponentForDaterRange() -> Calendar.Component {
        
        
        switch daterRange {
        case .days: return Calendar.Component.day
        case .weeks: return  Calendar.Component.weekOfMonth
        case .months: return Calendar.Component.month
        case .quarters: return Calendar.Component.quarter
        case .year: return Calendar.Component.year
        case .all: return Calendar.Component.era
            //  case .customRange:
        }
        
        
    }
    
    private func getUpperRange(for timeRange: Calendar.Component) -> Int {
        switch timeRange {
        case .day: return 30
        case .month: return 12
        case .weekOfYear: return 12
        case .quarter: return 10
        case .year: return 48
        case .era: return 0
        default: return 7
        }
    }
    
    func getDateIntervalFor (date: Date, using selectedTimeRange: Calendar.Component) -> DateInterval {
        var beginningOf: Date?
        var endOf: Date?
        beginningOf = calendar.dateInterval(of: selectedTimeRange, for: date)?.start
        endOf = calendar.dateInterval(of: selectedTimeRange, for: date)?.end
        
        return DateInterval(start: beginningOf!, end: endOf!)
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
        case .quarters: sectionHeaderDateFormatter.dateFormat = "MMMM yy"
        case .year: sectionHeaderDateFormatter.dateFormat = "MMMM"
        case .all: sectionHeaderDateFormatter.dateFormat = "yyyy"
        }
    }
    
    private func setReportsHeaderDateFormatter(timeRange: DaterRange){
           switch timeRange {
           case .days: reportsHeaderDateFormatter.dateFormat = "MMMM"
           case .weeks: reportsHeaderDateFormatter.dateFormat =  "MMMM"
           case .months: reportsHeaderDateFormatter.dateFormat = "yyyy"
           case .quarters: reportsHeaderDateFormatter.dateFormat = "MMMM yy"
           case .year: reportsHeaderDateFormatter.dateFormat = " "
           case .all: reportsHeaderDateFormatter.dateFormat = "yyyy"
           }
       }
    
}

enum DaterRange {
    case days
    case weeks
    case months
    case quarters
    case year
    case all
    // case customRange
}

enum ReportsDaterRange {
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
        
        var sortedIntervals =  [DateInterval : [DateInterval]]()
        let calendarComponent = getReportComponent(from: self.daterRange)

        
        
        
        let timeIntervals = calculateDateIntervals(startingFrom: Date(), with: getComponentForDaterRange(), upTo: 100)

        
       
        
        
        for innerInterval in timeIntervals {
            
            
            let outerInterval = self.getDateIntervalFor(date: innerInterval.start, using: calendarComponent)
            
            
            
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
