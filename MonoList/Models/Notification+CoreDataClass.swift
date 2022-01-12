//
//  Notification+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData


public class Notification: NSManagedObject {
    
    static private let calendar = Calendar(identifier: .gregorian)
    
    static var defaultDate: Date {
        calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    }
    
    static var weekDaySymbols: [String] {
        calendar.weekdaySymbols
    }
    
    static func sortedWeekdays(_ weekdays: String) -> String {
        weekdays.map { Int(String($0))! }.sorted { $0 < $1 }.map { String($0) }.joined()
    }
    
    var weekdaysString: String {
        let shortWeekdaySymbols = Self.calendar.shortWeekdaySymbols
        let weekdaysString = weekdays.map { weekdayNumberString -> String in
            let weekdayIndex = Int("\(weekdayNumberString)")!
            return shortWeekdaySymbols[weekdayIndex]
        }.joined(separator: ", ")
        return weekdaysString
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.calendar = Self.calendar
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        let timeString = formatter.string(from: time)
        return timeString
    }
}
