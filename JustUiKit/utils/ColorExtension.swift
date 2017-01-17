//
// Created by 刘丰恺 on 2017/1/15.
// Copyright (c) 2017 ___FULL___. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: UInt, alphaVal: CGFloat? = 1.0) {
        self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: CGFloat(alphaVal!)
        )
    }
}
