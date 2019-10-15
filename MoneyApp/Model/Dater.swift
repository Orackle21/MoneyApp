//
//  Dater.swift
//  MoneyApp
//
//  Created by Orackle on 02/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import Foundation

class Dater {
    
    private let calendar = Calendar.current
    
    var daterRange: DaterRange
    
    var selectedTimeRange: Calendar.Component {
        didSet {
            setDateFormatter()
        }
    }
    var dateFormatter = DateFormatter()
    let sectionHeaderDateFormatter = DateFormatter()
    
    init() {
        selectedTimeRange = .month
        daterRange = .thisMonth
        setDateFormatter()
        sectionHeaderDateFormatter.dateFormat = "MMMM d"
       
    }
    
    private func setDateFormatter(){
        switch selectedTimeRange {
        case .day: dateFormatter.dateFormat = "dd MMM"
        case .weekOfMonth: dateFormatter.dateFormat =  "dd MMM"
        case .month: dateFormatter.dateFormat = "MMM"
        case .quarter: dateFormatter.dateFormat = "MMMM yy"
        case .year: dateFormatter.dateFormat = "yyyy"
        default: dateFormatter.dateFormat = "dd MMMM yyyy"
        }
    }
    
    func getRelevantTimeRangesFrom(date: Date) -> [Date] {
        var date = date
        var dates = [Date]()
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.quarter], from: date)
        components.timeZone = TimeZone(abbreviation: "GMT")
        date = calendar.date(from: components)!
        dates.append(date)
        
        for _ in 0...24 {
            date = calendar.date(byAdding: selectedTimeRange, value: -1, to: date)!
            dates.append(date)
        }
        return dates
    }
    
    
    func getTimeIntervalFor (date: Date) -> DateInterval {
        var beginningOf: Date?
        var endOf: Date?
        beginningOf = calendar.dateInterval(of: selectedTimeRange, for: date)?.start
        endOf = calendar.dateInterval(of: selectedTimeRange, for: date)?.end
        return DateInterval(start: beginningOf!, end: endOf!)
    }
    
    
    
    
}

enum DaterRange {
    
    
    case days
    case thisWeek
    case lastWeek
    case thisMonth
    case lastMonth
    case lastThreeMonths
    case quarter
    case halfAYear
    case year
    case all
    case customRange
}
