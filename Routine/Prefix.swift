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

let appGroupId: String = "group.com.mesird.Routine"

let userDefaultsRoutines = "UserDefaultsRoutines"

let notificationRoutineCreated = "NotificationRoutineCreated"

// Routine data structure
public class Routine: NSObject, NSCoding {
    
    var name: String
    var start: Date
    var end: Date
    var needNotification: Bool
    
    init(name: String, start: Date, end: Date, needNotification: Bool) {
        self.name = name
        self.start = start
        self.end = end
        self.needNotification = needNotification
    }
    
    required public init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        start = aDecoder.decodeObject(forKey: "start") as! Date
        end = aDecoder.decodeObject(forKey: "end") as! Date
        needNotification = aDecoder.decodeObject(forKey: "needNotification") as! Bool? ?? false
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(start, forKey: "start")
        aCoder.encode(end, forKey: "end")
        aCoder.encode(needNotification, forKey: "needNotification")
    }
}

public func saveRoutines(routines: Array<Routine>) {
    
    let sharedUserDefaults: UserDefaults = UserDefaults(suiteName: appGroupId)!
    var temRoutines: Array<Data> = []
    for routine in routines {
        let temRoutine = NSKeyedArchiver.archivedData(withRootObject: routine)
        temRoutines.append(temRoutine)
    }
    sharedUserDefaults.setValue(temRoutines, forKey: userDefaultsRoutines)
    sharedUserDefaults.synchronize()
}

public func readRoutines() -> Array<Routine> {
    
    let sharedUserDefaults: UserDefaults = UserDefaults(suiteName: appGroupId)!
    let tempRoutines: Array<Data>? = sharedUserDefaults.object(forKey: userDefaultsRoutines) as? Array<Data>
    if tempRoutines != nil {
        var routines: Array<Routine> = []
        for data in tempRoutines! {
            let routine = NSKeyedUnarchiver.unarchiveObject(with: data) as! Routine
            routines.append(routine)
        }
        return routines
    } else {
        return []
    }
}
