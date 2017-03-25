//
//  WeekdayColorTableViewCell.swift
//  Routine
//
//  Created by mesird on 25/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class WeekdayColorTableViewCell: UITableViewCell {
    
    public var titleLabel: UILabel?
    public var colorView: UIView?

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
        titleLabel = UILabel(frame: CGRect(x: 15, y: 14, width: screenWidth - 30, height: 21))
        titleLabel!.textColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
        titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        self.addSubview(titleLabel!)
        
        colorView = UIView(frame: CGRect(x: screenWidth - 15 - 40, y: 5, width: 40, height: 40))
        colorView!.layer.cornerRadius = 8
        colorView!.layer.masksToBounds = true
        self.addSubview(colorView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
