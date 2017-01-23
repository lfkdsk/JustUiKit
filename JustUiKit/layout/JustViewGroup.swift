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

import Foundation
import UIKit

open class JustViewGroup: UIView, JustViewParent, JustViewManager {

    private var parentView: JustViewParent? = nil;

    private var isChanged: Bool = false

    public init() {
        super.init(frame: CGRect.zero)
        isChanged = false
    }

    public override init(frame groupFrame: CGRect) {
        super.init(frame: groupFrame)
        isChanged = false
    }

    public init(frame groupFrame: CGRect,
                parentView: JustViewParent) {
        super.init(frame: groupFrame)
        self.parentView = parentView
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func onLayout(_ changed: Bool = false,
                         _ top: CGFloat,
                         _ left: CGFloat,
                         _ right: CGFloat,
                         _ bottom: CGFloat) {

    }

    public func onMeasure(_ size: CGSize) {

    }

    override open func layoutSubviews() {

        let top = frame.origin.y
        let left = frame.origin.x
        let right = frame.size.width + left
        let bottom = frame.size.height + top

        onMeasure(frame.size)

        onLayout(isChanged, top, left, right, bottom)
    }

    public func getParent() -> JustViewParent {
        return parentView!
    }

    public func requestLayout() {

    }

    public func setParent(viewGroup: JustViewParent) {
        self.parentView = viewGroup
    }


    public func hasParent() -> Bool {
        return parentView != nil
    }


    public func addView(view: UIView, params: LayoutParams) {

    }

    public func updateView(view: UIView, params: LayoutParams) {

    }

    public func removeView(view: UIView) {
//        self.willRemoveSubview(view)
    }
}
