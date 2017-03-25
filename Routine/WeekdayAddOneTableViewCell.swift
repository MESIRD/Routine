//
//  WeekdayAddOneTableViewCell.swift
//  Routine
//
//  Created by mesird on 25/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class WeekdayAddOneTableViewCell: UITableViewCell {
    
    var backView: UIView?
    var titleLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self._initUI()
    }
    
    func _initUI() {
        backView = UIView(frame: CGRect(x: 15, y: 5, width: screenWidth - 30, height: 50))
        backView!.backgroundColor = UIColor.white
        backView!.layer.borderWidth = onePixel * 1.2
        backView!.layer.borderColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1).cgColor
        backView!.layer.cornerRadius = 8
        backView!.layer.masksToBounds = true
        self.addSubview(backView!)
        
        titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: screenWidth - 60, height: 50))
        titleLabel!.textColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
        titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        titleLabel!.textAlignment = .center
        titleLabel!.text = "Add new routine"
        backView!.addSubview(titleLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
