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
        let routines: Array<Routine>? = readRoutines()
        var text: String?
        let now: Date = Date()
        for routine in routines! {
            let todayStart: Date = _dateFromString(dateText: "\(_todayDate()) \(_timeFromDate(date: routine.start))")
            let todayEnd: Date = _dateFromString(dateText: "\(_todayDate()) \(_timeFromDate(date: routine.end))")
            if todayStart < now && todayEnd > now {
                text = routine.name
                break
            }
        }
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 90))
        titleLabel?.textAlignment = NSTextAlignment.center
        if text != nil {
            titleLabel?.text = text
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
    
    // functions
    func _todayDate() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    func _dateFromString(dateText: String) -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        return dateFormatter.date(from: dateText)!
    }
    
    func _timeFromDate(date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
}
