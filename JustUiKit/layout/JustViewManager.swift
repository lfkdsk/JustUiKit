//
// Created by 刘丰恺 on 2017/1/1.
// Copyright (c) 2017 ___FULL___. All rights reserved.
//

import UIKit

public protocol JustViewManager {

    func addView(view: UIView,
                 params: LayoutParams)

    func updateView(view: UIView,
                    params: LayoutParams)

    func removeView(view: UIView)
}