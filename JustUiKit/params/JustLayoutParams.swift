//
// Created by 刘丰恺 on 2016/12/30.
// Copyright (c) 2016 ___FULL___. All rights reserved.
//

import UIKit

public class LayoutParams {

    public static let MATCH_PARENT: CGFloat = -1
    public static let WRAP_CONTENT: CGFloat = -2

    var width: CGFloat = 0
    var height: CGFloat = 0

    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    public init(_ params: LayoutParams) {
        self.width = params.width
        self.height = params.height
    }

    public static func generateDefaultLayoutParams() -> LayoutParams {
        return LayoutParams(width: 0, height: 0)
    }
}

public class MarginLayoutParams: LayoutParams {
    private static let DEFAULT_MARGIN: Int = 0;

    public var leftMargin = DEFAULT_MARGIN
    public var rightMargin = DEFAULT_MARGIN
    public var topMargin = DEFAULT_MARGIN
    public var bottomMargin = DEFAULT_MARGIN

    public var startMargin = DEFAULT_MARGIN
    public var endMargin = DEFAULT_MARGIN

    override public init(_ source: LayoutParams) {
        super.init(source)
    }

    override public init(width: CGFloat, height: CGFloat) {
        super.init(width: width, height: height)
    }

    public init(source: MarginLayoutParams) {
        super.init(width: source.width, height: source.height)
        self.leftMargin = source.leftMargin
        self.rightMargin = source.rightMargin
        self.topMargin = source.topMargin
        self.bottomMargin = source.bottomMargin
    }

    public func setMargins(left: Int, top: Int, right: Int, bottom: Int) {
        leftMargin = left;
        topMargin = top;
        rightMargin = right;
        bottomMargin = bottom;
    }
}
