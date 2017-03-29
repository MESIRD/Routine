//
//  ToastView.swift
//  Routine
//
//  Created by mesird on 29/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class ToastView: UIView {
    
    var titleLabel: UILabel?

    init(title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: title.width(withConstraintHeight: 20, font: UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)) + 50, height: 50))
        self.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        titleLabel!.text = title
        titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        titleLabel!.textColor = UIColor.white
        titleLabel!.textAlignment = .center
        self.addSubview(titleLabel!)
        
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(inSeconds seconds: TimeInterval) {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 1
        }) { (finished: Bool) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: {
                self.hide()
            })
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 0
        }) { (finished: Bool) in
            self.removeFromSuperview()
        }
    }

}
