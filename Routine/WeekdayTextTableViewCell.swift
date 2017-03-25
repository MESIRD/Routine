//
//  WeekdayTextTableViewCell.swift
//  Routine
//
//  Created by mesird on 25/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class WeekdayTextTableViewCell: UITableViewCell {
    
    public var titleLabel: UILabel?
    public var textField: UITextField?

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
        
        textField = UITextField(frame: CGRect(x: screenWidth - 165, y: 14, width: 150, height: 21))
        textField!.borderStyle = .none
        textField!.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        textField!.textColor = UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1)
        textField!.textAlignment = .right
        self.addSubview(textField!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
