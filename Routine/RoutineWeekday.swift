//
//  RoutineWeekday.swift
//  Routine
//
//  Created by mesird on 23/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class RoutineWeekday: NSObject, NSCoding {
    
    var id: String?
    var name: String?
    var weekday: Int?
    var blockColor: UIColor?
    var routines: Array<Routine>?
    var bIsToday: Bool?
    var bNeedNotification: Bool?
    
    init(name: String, weekday: Int, blockColor: UIColor, routines: Array<Routine>, bIsToday: Bool) {
        self.id = UUID().uuidString
        self.name = name
        self.weekday = weekday
        self.blockColor = blockColor
        self.routines = routines
        self.bIsToday = bIsToday
        self.bNeedNotification = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String?
        name = aDecoder.decodeObject(forKey: "name") as! String?
        weekday = aDecoder.decodeInteger(forKey: "weekday")
        blockColor = aDecoder.decodeObject(forKey: "blockColor") as! UIColor?
        routines = aDecoder.decodeObject(forKey: "routines") as! Array<Routine>?
        bIsToday = aDecoder.decodeBool(forKey: "bIsToday")
        bNeedNotification = aDecoder.decodeBool(forKey: "bNeedNotification")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(weekday!, forKey: "weekday")
        aCoder.encode(blockColor, forKey: "blockColor")
        aCoder.encode(routines, forKey: "routines")
        aCoder.encode(bIsToday!, forKey: "bIsToday")
        aCoder.encode(bNeedNotification!, forKey: "bNeedNotification")
    }
}
