//
//  ColorUtil.swift
//  Routine
//
//  Created by mesird on 30/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

func color(with red: UInt8, green: UInt8, blue: UInt8) -> UIColor {
    return UIColor(red: CGFloat(Double(red) * 1.0/255), green: CGFloat(Double(green) * 1.0/255), blue: CGFloat(Double(blue) * 1.0/255), alpha: 1)
}
