//
//  MainTableViewCell.swift
//  Routine
//
//  Created by mesird on 23/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    var backView: UIView?
    var titleLabel: UILabel?
    var detailLabel: UILabel?
    var bellView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backView = UIView(frame: CGRect(x: 15, y: 0, width: screenWidth - 30, height: 60))
        backView!.backgroundColor = UIColor.white
        backView!.layer.cornerRadius = 8
        backView!.layer.masksToBounds = true
        self.addSubview(backView!)
        
        titleLabel = UILabel(frame: CGRect(x: 15, y: 17, width: screenWidth - 60, height: 26))
        titleLabel!.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightLight)
        titleLabel!.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)
        backView!.addSubview(titleLabel!)
        
        detailLabel = UILabel(frame: CGRect(x: 15, y: 24, width: screenWidth - 60, height: 17))
        detailLabel!.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        detailLabel!.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)
        detailLabel!.textAlignment = NSTextAlignment.right
        backView!.addSubview(detailLabel!)
        
        bellView = UIImageView(frame: CGRect(x: 0, y: 20, width: 20, height: 20))
        bellView!.image = UIImage.init(named: "bell")
        backView?.addSubview(bellView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bellView?.frame = CGRect(x: (titleLabel?.frame.origin.x)! + (titleLabel?.text?.width(withConstraintHeight: 26, font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightLight)))! + 10, y: 20, width: 20, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func _tapOnBackView(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            self.displayPressAnimation()
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            self.displayReleaseAnimation()
        }
    }
    

    func displayPressAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.backView?.alpha = 0.8
            self.backView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    func displayReleaseAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.backView?.alpha = 1
            self.backView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
