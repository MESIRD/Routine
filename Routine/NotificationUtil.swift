//
//  NotificationUtil.swift
//  Routine
//
//  Created by mesird on 30/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

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
