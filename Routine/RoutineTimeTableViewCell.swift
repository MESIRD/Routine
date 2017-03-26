//
//  RoutineTimeTableViewCell.swift
//  Routine
//
//  Created by mesird on 26/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class RoutineTimeTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel?
    var detailLabel: UILabel?
    

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
        
        titleLabel = UILabel(frame: CGRect(x: 15, y: 13, width: screenWidth - 30, height: 19))
        titleLabel!.textColor = color(with: 98, green: 98, blue: 98)
        titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        self.addSubview(titleLabel!)
        
        detailLabel = UILabel(frame: CGRect(x: 15, y: 13, width: screenWidth - 30, height: 19))
        detailLabel!.textColor = color(with: 175, green: 175, blue: 175)
        detailLabel!.textAlignment = .right
        detailLabel!.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight)
        self.addSubview(detailLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
