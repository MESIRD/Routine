//
//  DateTimeUtil.swift
//  Routine
//
//  Created by mesird on 30/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import Foundation

// utilities


/// The date text in `yyyy-MM-dd` format for the given date
///
/// - Parameter date: the given date
/// - Returns: The date text
func dateTextFor(date: Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}


/// The weekday for today
///
/// - Returns: the weekday for today, Sun:1, Mon:2, Tue:3, Wed:4, Thu:5, Fri:6, Sat:7
func weekdayForToday() -> Int {
    let calendar = Calendar.current
    let components = calendar.component(.weekday, from: Date())
    return components
}


/// The weekday for the given date
///
/// - Parameter date: the given date
/// - Returns: the weekday for the given date
func weekday(forDate date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.component(.weekday, from: date)
    return components
}


/// The date string for today in `yyyy-MM-dd` format
///
/// - Returns: The date string for today
func todayDate() -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: Date())
}


/// The date for the given date text, text is in `yyyy-MM-dd hh:mm` format
///
/// - Parameter dateText: given date text
/// - Returns: The date for the given date text
func dateFromString(dateText: String) -> Date {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
    return dateFormatter.date(from: dateText)!
}


/// The time text in `hh:mm` fromat for the given date
///
/// - Parameter date: the given date
/// - Returns: the time text
func timeFromDate(date: Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    return dateFormatter.string(from: date)
}


/// The next date of the given weekday
///
/// - Parameter weekday: the given weekday
/// - Returns: the date
func nextDate(for weekday: Int) -> Date {
    let calendar = Calendar.current
    let today = Date()
    let todayWeekday: Int = calendar.component(.weekday, from: today)
    var interval: Int = weekday - todayWeekday
    interval = interval >= 0 ? interval : interval + 7
    var intervalComponents = DateComponents()
    intervalComponents.day = interval
    return calendar.date(byAdding: intervalComponents, to: today)!
}
