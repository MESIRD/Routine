//
//  StringUtil.swift
//  Routine
//
//  Created by mesird on 30/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

extension String {
    
    func width(withConstraintHeight height: CGFloat, font: UIFont) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        return rect.width
    }
    
    func height(withConstraintWidth width: CGFloat, font: UIFont) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        return rect.height
    }
}
