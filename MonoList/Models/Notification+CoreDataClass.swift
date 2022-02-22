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
        calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date().addingTimeInterval(24*60*60)) ?? Date()
    }
    
    static var weekdaySymbols: [String] {
        calendar.weekdaySymbols
    }
    
    static var shortWeekdaySymbols: [String] {
        calendar.shortWeekdaySymbols
    }
    
    static func sortedWeekdays(_ weekdays: String) -> String {
        weekdays.map { Int(String($0))! }.sorted { $0 < $1 }.map { String($0) }.joined()
    }
    
    var isRepeat: Bool {
        !weekdays.isEmpty
    }
    
    var weekdaysString: String {
        if weekdays == "0123456" {
            return K.weekday.everyday
        } else if weekdays == "12345" {
            return K.weekday.weekdays
        } else if weekdays.count == 1 {
            let weekdaysString = weekdays.map { weekdayNumberString -> String in
                let weekdayIndex = Int("\(weekdayNumberString)")!
                return Self.weekdaySymbols[weekdayIndex]
            }.joined(separator: ", ")
            return "\(K.weekday.every) \(weekdaysString)"
        } else {
            let shortWeekdaysString = weekdays.map { weekdayNumberString -> String in
                let weekdayIndex = Int("\(weekdayNumberString)")!
                return Self.shortWeekdaySymbols[weekdayIndex]
            }.joined(separator: ", ")
            return shortWeekdaysString
        }
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.calendar = Self.calendar
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        let timeString = formatter.string(from: time)
        return timeString
    }
    
    var dateAndTimeString: String {
        let formatter = DateFormatter()
        formatter.calendar = Self.calendar
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMdE Hm", options: 0, locale: Locale.current)
        let timeString = formatter.string(from: time)
        return timeString
    }
    
    var year: Int {
        Self.calendar.component(.year, from: time)
    }
    
    var month: Int {
        Self.calendar.component(.month, from: time)
    }
    
    var day: Int {
        Self.calendar.component(.day, from: time)
    }
    
    var hour: Int {
        Self.calendar.component(.hour, from: time)
    }
    
    var minute: Int {
        Self.calendar.component(.minute, from: time)
    }
    
    func data() -> NotificationData {
        return NotificationData(creationDate: creationDate,
                                id: id,
                                time: time,
                                weekdays: weekdays)
    }
}
