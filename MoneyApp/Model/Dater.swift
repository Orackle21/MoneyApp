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
        daterRange = .months
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
    
    func getRelevantTimeRangesFrom(date: Date) -> [DateInterval] {
        var date = date
        var dates = [DateInterval]()
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.quarter], from: date)
        components.timeZone = TimeZone(abbreviation: "GMT")
        date = calendar.date(from: components)!
        let dateInterval = getTimeIntervalFor(date: date)
        dates.append(dateInterval)
        
        for _ in 0...24 {
            date = calendar.date(byAdding: selectedTimeRange, value: -1, to: date)!
            let dateInterval = getTimeIntervalFor(date: date)
            dates.append(dateInterval)
        }
        return dates
    }
    
    
    private func getTimeIntervalFor (date: Date) -> DateInterval {
        var beginningOf: Date?
        var endOf: Date?
        beginningOf = calendar.dateInterval(of: selectedTimeRange, for: date)?.start
        endOf = calendar.dateInterval(of: selectedTimeRange, for: date)?.end
        return DateInterval(start: beginningOf!, end: endOf!)
    }
    
    
    
    
}

enum DaterRange {

    case days
    case weeks
    case months
    case quarters
    case year
    case all
    case customRange
}
