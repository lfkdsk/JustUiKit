///    MIT License
///
///    Copyright (c) 2017 JustWe
///
///    Permission is hereby granted, free of charge, to any person obtaining a copy
///    of this software and associated documentation files (the "Software"), to deal
///    in the Software without restriction, including without limitation the rights
///    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
///    copies of the Software, and to permit persons to whom the Software is
///    furnished to do so, subject to the following conditions:
///
///    The above copyright notice and this permission notice shall be included in all
///    copies or substantial portions of the Software.
///
///    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
///    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
///    SOFTWARE.


import UIKit

public class LayoutParams {

    public static let MATCH_PARENT: CGFloat = -1
    public static let WRAP_CONTENT: CGFloat = -2

    public var width: CGFloat = 0
    public var height: CGFloat = 0

    public var bindView: UIView? = nil

    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    public func bindWith(view: UIView?) {
        self.bindView = view
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
