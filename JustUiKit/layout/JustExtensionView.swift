//
// Created by 刘丰恺 on 2017/1/2.
// Copyright (c) 2017 ___FULL___. All rights reserved.
//


import UIKit

public protocol ExtensionParams {
    func setLayoutParams(params: LayoutParams)

    func getLayoutParams() -> LayoutParams
}

public struct Padding {
    var paddingLeft: CGFloat = 0
    var paddingRight: CGFloat = 0
    var paddingBottom: CGFloat = 0
    var paddingTop: CGFloat = 0

    public init() {

    }

    public init(top: CGFloat, left: CGFloat, right: CGFloat, bottom: CGFloat) {
        self.paddingTop = top
        self.paddingLeft = left
        self.paddingRight = right
        self.paddingBottom = bottom
    }
    /**
    ** delete when size - padding < 0 (isHidden)
    */
    public func getMinSize(size: CGSize) -> CGSize {
        return CGSize(width: max(size.width - paddingLeft - paddingRight, 0),
                height: max(size.height - paddingTop - paddingBottom, 0))
    }

    public func getMaxSize(size: CGSize) -> CGSize {
        return CGSize(width: max(size.width + paddingLeft + paddingRight, 0),
                height: max(size.height + paddingTop + paddingBottom, 0))
    }
}