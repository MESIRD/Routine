//
//  RoutineStorage.swift
//  Routine
//
//  Created by mesird on 30/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import Foundation

let appGroupId = "group.com.mesird.Routine"
let userDefaultsRoutineWeekdays = "UserDefaultsRoutineWeekdays"
let userDefaultsSecondLaunch = "UserDefaultsSecondLaunch"

// persistence
var globalRoutineWeekdays: Array<RoutineWeekday>?

func clear() {
    globalRoutineWeekdays = nil
}

func read() -> [RoutineWeekday] {
    if globalRoutineWeekdays != nil {
        return globalRoutineWeekdays!
    }
    let sharedUserDefaults: UserDefaults = UserDefaults(suiteName: appGroupId)!
    let tempRoutineWeekdays: Array<Data>? = sharedUserDefaults.object(forKey: userDefaultsRoutineWeekdays) as? Array<Data>
    if tempRoutineWeekdays != nil {
        var routineWeekdays: Array<RoutineWeekday> = []
        for data in tempRoutineWeekdays! {
            NSKeyedUnarchiver.setClass(RoutineWeekday.self, forClassName: "RoutineWeekday")
            NSKeyedUnarchiver.setClass(Routine.self, forClassName: "Routine")
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
        NSKeyedArchiver.setClassName("RoutineWeekday", for: RoutineWeekday.self)
        NSKeyedArchiver.setClassName("Routine", for: Routine.self)
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
