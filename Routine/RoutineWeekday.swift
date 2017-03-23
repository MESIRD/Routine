//
//  RoutineWeekday.swift
//  Routine
//
//  Created by mesird on 23/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit
import RoutineEntity

class RoutineWeekday: NSObject, NSCoding {
    
    public var name: String?
    public var blockColor: UIColor?
    public var routines: Array<Routine>?
    public var bIsToday: Bool?
    
    public init(name: String, blockColor: UIColor, routines: Array<Routine>, bIsToday: Bool) {
        self.name = name
        self.blockColor = blockColor
        self.routines = routines
        self.bIsToday = bIsToday
    }
    
    public required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String?
        blockColor = aDecoder.decodeObject(forKey: "blockColor") as! UIColor?
        routines = aDecoder.decodeObject(forKey: "routines") as! Array<Routine>?
        bIsToday = aDecoder.decodeBool(forKey: "bIsToday")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(blockColor, forKey: "blockColor")
        aCoder.encode(routines, forKey: "routines")
        aCoder.encode(bIsToday, forKey: "bIsToday")
    }
}
