//
//  Routine.swift
//  Routine
//
//  Created by xujie on 3/24/17.
//  Copyright © 2017 mesird. All rights reserved.
//

import Foundation

// Routine data structure
class Routine: NSObject, NSCoding {
    
    var id: String
    var name: String
    var start: Date
    var end: Date
    var needNotification: Bool
    
    init(name: String, start: Date, end: Date, needNotification: Bool) {
        self.id = NSUUID().uuidString
        self.name = name
        self.start = start
        self.end = end
        self.needNotification = needNotification
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        start = aDecoder.decodeObject(forKey: "start") as! Date
        end = aDecoder.decodeObject(forKey: "end") as! Date
        needNotification = aDecoder.decodeBool(forKey: "needNotification")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(start, forKey: "start")
        aCoder.encode(end, forKey: "end")
        aCoder.encode(needNotification, forKey: "needNotification")
    }
}
