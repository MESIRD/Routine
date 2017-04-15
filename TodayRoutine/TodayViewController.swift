//
//  TodayViewController.swift
//  TodayRoutine
//
//  Created by mesird on 19/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit
import NotificationCenter

// global definitions
let screenWidth: CGFloat  = UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var titleLabel: UILabel?
    var timeLabel: UILabel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        let currentRoutine: Routine? = self._getCurrentRoutine()
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: 19, width: screenWidth - 40, height: 48))
        titleLabel!.textAlignment = NSTextAlignment.center
        titleLabel!.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        titleLabel!.numberOfLines = 0
        self.view.addSubview(titleLabel!)
        if currentRoutine != nil {
            titleLabel!.text = currentRoutine?.name
            titleLabel!.textColor = color(with: 55, green: 55, blue: 55)
            
            timeLabel = UILabel(frame: CGRect(x: 10, y: 67, width: screenWidth - 40, height: 18))
            timeLabel!.textAlignment = .center
            timeLabel!.textColor = color(with: 98, green: 98, blue: 98)
            timeLabel!.text = "\(timeFromDate(date: (currentRoutine?.start)!)) - \(timeFromDate(date: (currentRoutine?.end)!))"
            timeLabel!.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight)
            self.view.addSubview(timeLabel!)
        } else {
            titleLabel!.text = NSLocalizedString("ExtNoPlanNow", comment: "")
            titleLabel!.textColor = UIColor.white
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func _getCurrentRoutine() -> Routine? {
        clear()
        
        let weekdays: Array<RoutineWeekday> = read()
        if weekdays.count == 0 {
            return nil
        }
        let todayWeekday: Int = weekdayForToday()
        var routineWeekday: RoutineWeekday?
        switch todayWeekday {
        case 1:
            routineWeekday = weekdays[6]
        case 2:
            routineWeekday = weekdays[0]
        case 3:
            routineWeekday = weekdays[1]
        case 4:
            routineWeekday = weekdays[2]
        case 5:
            routineWeekday = weekdays[3]
        case 6:
            routineWeekday = weekdays[4]
        case 7:
            routineWeekday = weekdays[5]
        default:
            routineWeekday = nil
        }
        let routines: Array<Routine>? = routineWeekday != nil ? routineWeekday?.routines : nil
        var currentRoutine: Routine? = nil
        if routines != nil {
            let now: Date = Date()
            for routine in routines! {
                let todayStart: Date = dateFromString(dateText: "\(todayDate()) \(timeFromDate(date: routine.start))")
                let todayEnd: Date = dateFromString(dateText: "\(todayDate()) \(timeFromDate(date: routine.end))")
                if todayStart < now && todayEnd > now {
                    currentRoutine = routine
                    break
                }
            }
        }
        
        return currentRoutine
    }
    
}
