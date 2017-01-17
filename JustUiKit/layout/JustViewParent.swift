//
// Created by 刘丰恺 on 2016/12/30.
// Copyright (c) 2016 ___FULL___. All rights reserved.
//

import Foundation
import UIKit

public protocol JustViewParent {
    func getParent() -> JustViewParent

    func requestLayout()

    func setParent(viewGroup: JustViewParent)

    func hasParent() -> Bool
}
