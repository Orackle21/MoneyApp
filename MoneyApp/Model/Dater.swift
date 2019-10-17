//
//  Dater.swift
//  MoneyApp
//
//  Created by Orackle on 02/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class Dater {
    
    
    private var daterRange: DaterRange
    private let calendar = Calendar.current
    
    
    var dateFormatter = DateFormatter()
    let sectionHeaderDateFormatter = DateFormatter()
    
    
    init() {
        daterRange = .months
        sectionHeaderDateFormatter.dateFormat = "MMMM d"
    }
    
    func setDaterRange (_ daterRange: DaterRange) {
        self.daterRange = daterRange
    }
    
    
    func getTimeIntervals() -> [DateInterval] {
        
        switch daterRange {
        case .days: return calculateDateIntervals(timeRange: .day)
        case .weeks: return calculateDateIntervals(timeRange: .weekOfMonth)
        case .months: return calculateDateIntervals(timeRange: .month)
        case .quarters: return calculateDateIntervals(timeRange: .quarter)
        case .year: return calculateDateIntervals(timeRange: .year)
        case .all: return calculateDateIntervals(timeRange: .era)
            //  case .customRange:
        }
        
        
    }
    
    private func calculateDateIntervals (timeRange: Calendar.Component) -> [DateInterval] {
        setDateFormatter(timeRange: timeRange)
        var date = Date()
        var dates = [DateInterval]()
        let upperRange = getUpperRange(for: timeRange)
        
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.quarter], from: date)
        components.timeZone = TimeZone(abbreviation: "GMT")
        date = calendar.date(from: components)!
        
        let dateInterval = getTimeIntervalFor(date: date, using: timeRange)
        dates.append(dateInterval)
        
        for _ in 0...upperRange {
            date = calendar.date(byAdding: timeRange, value: -1, to: date)!
            let dateInterval = getTimeIntervalFor(date: date, using: timeRange)
            dates.append(dateInterval)
        }
        
        return dates
        
    }
    
    private func getUpperRange(for timeRange: Calendar.Component) -> Int {
        switch timeRange {
        case .day: return 30
        case .month: return 12
        case .weekOfMonth: return 12
        case .quarter: return 100
        case .year: return 20
        case .era: return 1
        default: return 7
        }
    }
    
    private func getTimeIntervalFor (date: Date, using selectedTimeRange: Calendar.Component) -> DateInterval {
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
