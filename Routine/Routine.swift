//
//  Routine.swift
//  Routine
//
//  Created by xujie on 3/24/17.
//  Copyright © 2017 mesird. All rights reserved.
//

import Foundation

let appGroupId: String = "group.com.mesird.Routine"

let userDefaultsRoutines = "UserDefaultsRoutines"

// Routine data structure
public class Routine: NSObject, NSCoding {
    
    public var id: String
    public var name: String
    public var start: Date
    public var end: Date
    public var needNotification: Bool
    
    public init(name: String, start: Date, end: Date, needNotification: Bool) {
        self.id = NSUUID().uuidString
        self.name = name
        self.start = start
        self.end = end
        self.needNotification = needNotification
    }
    
    public required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        start = aDecoder.decodeObject(forKey: "start") as! Date
        end = aDecoder.decodeObject(forKey: "end") as! Date
        needNotification = aDecoder.decodeBool(forKey: "needNotification")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
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
