//
//  RoutineTextTableViewCell.swift
//  Routine
//
//  Created by mesird on 26/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class RoutineTextTableViewCell: UITableViewCell {
    
    var textField: UITextField?

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
        
        textField = UITextField(frame: CGRect(x: 15, y: 13, width: screenWidth - 30, height: 19))
        textField!.textColor = color(with: 98, green: 98, blue: 98)
        textField!.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        self.addSubview(textField!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
