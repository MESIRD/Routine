//
//  RoutineDeleteTableViewCell.swift
//  Routine
//
//  Created by mesird on 27/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

class RoutineDeleteTableViewCell: UITableViewCell {
    
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
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 45))
        titleLabel!.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        titleLabel!.text = NSLocalizedString("RoutineDeleteText", comment: "")
        titleLabel!.textColor = color(with: 255, green: 35, blue: 62)
        titleLabel!.textAlignment = .center
        self.contentView.addSubview(titleLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
