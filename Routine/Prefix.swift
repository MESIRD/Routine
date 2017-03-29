//
//  Prefix.swift
//  Routine
//
//  Created by mesird on 19/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

// global definitions
let screenWidth: CGFloat  = UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height

let onePixel: CGFloat = 1 / UIScreen.main.scale

let appGroupId = "group.com.mesird.Routine"
let userDefaultsRoutineWeekdays = "UserDefaultsRoutineWeekdays"
let userDefaultsSecondLaunch = "UserDefaultsSecondLaunch"

// notification
let notificationWeekdaySaved    = "NotificationWeekdaySaved"
let notificationRoutineCreated  = "NotificationRoutineCreated"
let notificationRoutineModified = "NotificationRoutineModified"

// utilities
func dateTextFor(date: Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}

func weekdayForToday() -> Int {
    let calendar = Calendar.current
    let components = calendar.component(.weekday, from: Date())
    return components + 1
}

func dateFromString(dateText: String) -> Date {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
    return dateFormatter.date(from: dateText)!
}

func timeFromDate(date: Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    return dateFormatter.string(from: date)
}

// Sun:1, Mon:2, Tue:3, Wed:4, Thu:5, Fri:6, Sat:7
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

func color(with red: UInt8, green: UInt8, blue: UInt8) -> UIColor {
    return UIColor(red: CGFloat(Double(red) * 1.0/255), green: CGFloat(Double(green) * 1.0/255), blue: CGFloat(Double(blue) * 1.0/255), alpha: 1)
}

extension String {
    
    func width(withConstraintHeight height: CGFloat, font: UIFont) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        return rect.width
    }
    
    func height(withConstraintWidth width: CGFloat, font: UIFont) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        return rect.height
    }
}

// persistence
var globalRoutineWeekdays: Array<RoutineWeekday>?

func read() -> [RoutineWeekday] {
    
    if globalRoutineWeekdays != nil {
        return globalRoutineWeekdays!
    }
    let sharedUserDefaults: UserDefaults = UserDefaults(suiteName: appGroupId)!
    let tempRoutineWeekdays: Array<Data>? = sharedUserDefaults.object(forKey: userDefaultsRoutineWeekdays) as? Array<Data>
    if tempRoutineWeekdays != nil {
        var routineWeekdays: Array<RoutineWeekday> = []
        for data in tempRoutineWeekdays! {
            let routineWeekday = NSKeyedUnarchiver.unarchiveObject(with: data) as! RoutineWeekday
            routineWeekdays.append(routineWeekday)
        }
        globalRoutineWeekdays = routineWeekdays
        return routineWeekdays
    } else {
        return []
    }
}

func save() {
    
    if globalRoutineWeekdays == nil {
        return
    }
    
    let sharedUserDefaults: UserDefaults = UserDefaults(suiteName: appGroupId)!
    var tempRoutineWeekdays: Array<Data> = []
    for routineWeekday in globalRoutineWeekdays! {
        let tempRoutineWeekday = NSKeyedArchiver.archivedData(withRootObject: routineWeekday)
        tempRoutineWeekdays.append(tempRoutineWeekday)
    }
    sharedUserDefaults.setValue(tempRoutineWeekdays, forKey: userDefaultsRoutineWeekdays)
    sharedUserDefaults.synchronize()
}

func fetchRoutineWeekday(with id: String) -> RoutineWeekday? {
    
    for routineWeekday in globalRoutineWeekdays! {
        if routineWeekday.id == id {
            return routineWeekday
        }
    }
    return nil
}

func fetchRoutine(withId id: String, inRoutines routines: [Routine]) -> Routine? {
    
    for routine in routines {
        if routine.id == id {
            return routine
        }
    }
    return nil
}

func saveRoutineWeekday(routineWeekday: RoutineWeekday?) {
    
    if globalRoutineWeekdays == nil || routineWeekday == nil {
        return
    }
    for i in 0..<globalRoutineWeekdays!.count {
        if globalRoutineWeekdays![i].id == routineWeekday!.id {
            globalRoutineWeekdays![i] = routineWeekday!
            break
        }
    }
    save()
}

// notification
func createNotifications(routineWeekday: RoutineWeekday) {
    removeNotification(with: routineWeekday.id!)
    if !routineWeekday.bNeedNotification! {
        return
    }
    for routine in routineWeekday.routines! {
        scheduleLocalNotification(routine: routine, routineWeekday: routineWeekday)
    }
}

func removeNotification(with weekdayId: String) {
    let scheduledLocalNotifications: Array<UILocalNotification> = UIApplication.shared.scheduledLocalNotifications!
    for notification in scheduledLocalNotifications {
        let dict: Dictionary? = notification.userInfo
        if dict != nil {
            let tempWeekdayId: String? = dict!["weekdayId"] as? String
            if tempWeekdayId != nil && tempWeekdayId! == weekdayId {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
    }
}

func scheduleLocalNotification(routine: Routine, routineWeekday: RoutineWeekday) {
    let date = nextDate(for: routineWeekday.weekday!)
    let fireDate: Date = dateFromString(dateText: "\(dateTextFor(date: date)) \(timeFromDate(date: routine.start))")
    let localNotification: UILocalNotification = UILocalNotification()
    localNotification.fireDate = fireDate
    localNotification.timeZone = NSTimeZone.default
    localNotification.repeatInterval = NSCalendar.Unit.weekOfYear
    localNotification.soundName = UILocalNotificationDefaultSoundName
    localNotification.alertBody = "Time for '\(routine.name)'"
    localNotification.applicationIconBadgeNumber = 1
    localNotification.userInfo = ["identifier": routine.id, "weekdayId": routineWeekday.id!]
    UIApplication.shared.scheduleLocalNotification(localNotification)
}

func removeAllNotifications() {
    UIApplication.shared.cancelAllLocalNotifications()
}
