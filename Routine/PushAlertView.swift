//
//  PushAlertView.swift
//  Routine
//
//  Created by mesird on 30/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class PushAlertView: UIView {
    
    var backView: UIView?
    var bellView: UIImageView?
    var titleLabel: UILabel?
    var weekdayLabel: UILabel?
    var timeLabel: UILabel?

    init(routine: Routine, weekday: RoutineWeekday) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        backView = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 100))
        backView!.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        backView!.layer.cornerRadius = 10
        backView!.layer.masksToBounds = true
        backView!.backgroundColor = UIColor.white
        self.addSubview(backView!)
        
        bellView = UIImageView(frame: CGRect(x: 15, y: 10, width: 20, height: 20))
        bellView!.image = UIImage.init(named: "bell")
        backView!.addSubview(bellView!)
        
        titleLabel = UILabel(frame: CGRect(x: 15, y: 35, width: 230, height: 28))
        titleLabel!.textColor = color(with: 98, green: 98, blue: 98)
        titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel!.textAlignment = .center
        titleLabel!.text = routine.name
        backView!.addSubview(titleLabel!)
        
        weekdayLabel = UILabel(frame: CGRect(x: 15, y: 78, width: 230, height: 17))
        weekdayLabel!.textColor = color(with: 175, green: 175, blue: 175)
        weekdayLabel!.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        weekdayLabel!.text = weekday.name
        backView!.addSubview(weekdayLabel!)
        
        timeLabel = UILabel(frame: CGRect(x: 15, y: 78, width: 230, height: 17))
        timeLabel!.textColor = color(with: 175, green: 175, blue: 175)
        timeLabel!.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        timeLabel!.textAlignment = .right
        timeLabel!.text = "\(timeFromDate(date: routine.start)) - \(timeFromDate(date: routine.end))"
        backView!.addSubview(timeLabel!)
        
        self.alpha = 0
        backView!.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        UIView.animate(withDuration: 0.3) { 
            self.alpha = 1
            self.backView!.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 0
            self.backView!.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (finished: Bool) in
            self.removeFromSuperview()
        }
    }
}
