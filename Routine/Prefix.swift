//
//  Prefix.swift
//  Routine
//
//  Created by mesird on 19/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit
import RoutineEntity

// global definitions
let screenWidth: CGFloat  = UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height

// notification
let notificationRoutineCreated  = "NotificationRoutineCreated"
let notificationRoutineModified = "NotificationRoutineModified"

// functions
func todayDate() -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: Date())
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

// notification
func scheduleLocalNotification(routine: Routine) {
    let fireDate: Date = dateFromString(dateText: "\(todayDate()) \(timeFromDate(date: routine.start))")
    let localNotification: UILocalNotification = UILocalNotification()
    localNotification.fireDate = fireDate
    localNotification.timeZone = NSTimeZone.default
    localNotification.repeatInterval = NSCalendar.Unit.day
    localNotification.soundName = UILocalNotificationDefaultSoundName
    localNotification.alertBody = "Time to \(routine.name)"
    localNotification.applicationIconBadgeNumber = 1
    localNotification.userInfo = ["identifier": routine.id]
    UIApplication.shared.scheduleLocalNotification(localNotification)
}

func removeLocalNotification(routine: Routine) {
    let scheduledLocalNotifications: Array<UILocalNotification> = UIApplication.shared.scheduledLocalNotifications!
    for notification in scheduledLocalNotifications {
        let dict: Dictionary? = notification.userInfo
        if dict != nil {
            let identifier: String? = dict!["identifier"] as? String
            if identifier != nil && routine.id == identifier {
                UIApplication.shared.cancelLocalNotification(notification)
                break
            }
        }
    }
}
