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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        clear()
        let weekdays: Array<RoutineWeekday> = read()
        if weekdays.count == 0 {
            return
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
        var routineTitle: String?
        if routines == nil {
            routineTitle = "No plan now"
        } else {
            let now: Date = Date()
            for routine in routines! {
                let todayStart: Date = dateFromString(dateText: "\(todayDate()) \(timeFromDate(date: routine.start))")
                let todayEnd: Date = dateFromString(dateText: "\(todayDate()) \(timeFromDate(date: routine.end))")
                if todayStart < now && todayEnd > now {
                    routineTitle = routine.name
                    break
                }
            }
        }
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 90))
        titleLabel?.textAlignment = NSTextAlignment.center
        if routineTitle != nil {
            titleLabel?.text = routineTitle
            titleLabel?.textColor = UIColor.darkGray
        } else {
            titleLabel?.text = "No plan now"
            titleLabel?.textColor = UIColor.white
        }
        titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightLight)
        self.view.addSubview(titleLabel!)
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
    
}
