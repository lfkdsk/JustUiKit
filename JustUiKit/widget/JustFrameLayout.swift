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

/// FrameLayout Params
/// Params For FrameLayout
/// This params just has layoutGravity

public class FrameLayoutParams: MarginLayoutParams {
    public var layoutGravity: Gravity = Gravity.NO_GRAVITY

    public init(width: CGFloat, height: CGFloat, layoutGravity: Gravity) {
        super.init(width: width, height: height)
        self.layoutGravity = layoutGravity
    }

    public override init(width: CGFloat, height: CGFloat) {
        super.init(width: width, height: height)
    }

    public init(source: FrameLayoutParams) {
        super.init(source: source)
        self.layoutGravity = source.layoutGravity
    }

    /// init
    /// - LayoutParams params base generate method
    override init(_ source: LayoutParams) {
        super.init(source)
    }

    public static func generateDefaultParams() -> FrameLayoutParams {
        return FrameLayoutParams(width: LayoutParams.WRAP_CONTENT, height: LayoutParams.WRAP_CONTENT)
    }
}

open class JustFrameLayout: JustViewGroup {

    private var childViewSizes: [CGSize] = []

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let childSizes: [CGSize]
        var childLayoutSize = CGSize.zero
        var padding: Padding
        var index: Int = 0

        childSizes = measureChildren(size)

        for size in childSizes {
            padding = subviews[index].uiViewExtension.padding
            childLayoutSize.width = max(childLayoutSize.width, size.width + padding.paddingLeft + padding.paddingRight)
            childLayoutSize.height = max(childLayoutSize.height, size.height + padding.paddingTop + padding.paddingBottom)
            index += 1
        }
        return uiViewExtension.padding.getMaxSize(size: childLayoutSize)
    }


    override public func onLayout(_ changed: Bool, _ top: CGFloat, _ left: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        super.onLayout(changed, top, left, right, bottom)

        let padding = uiViewExtension.padding

        let pTop = top + padding.paddingTop,
                pLeft = left + padding.paddingLeft,
                pRight = right - padding.paddingRight,
                pBottom = bottom - padding.paddingBottom

        layoutChildren(changed, pTop, pLeft, pRight, pBottom)
    }

    override public func onMeasure(_ size: CGSize) {
        super.onMeasure(size)
        childViewSizes = measureChildren(size)
    }

    private func measureChildren(_ size: CGSize) -> [CGSize] {
        let selfSize = uiViewExtension.padding.getMinSize(size: size)

        var childSizes = [CGSize](repeating: CGSize(width: -1, height: -1), count: subviews.count)
        let height = selfSize.height
        let width = selfSize.width
        let maxHeightSize: CGFloat = height
        let maxWidthSize: CGFloat = width

        for (index, child) in subviews.enumerated() {
            if child.isHidden {
                continue
            }

            let params: FrameLayoutParams = child.uiViewExtension.layoutParams as! FrameLayoutParams

            var childHeight: CGFloat = 0
            var childSize: CGSize = CGSize()

            switch params.height {
            case LayoutParams.MATCH_PARENT:
                childHeight = maxHeightSize
            case LayoutParams.WRAP_CONTENT:
                childSize = child.sizeThatFits(
                        CGSize(width: maxWidthSize,
                                height: maxHeightSize))
                childHeight = childSize.height
            default:
                childHeight = params.height
            }

            childHeight = min(childHeight, maxHeightSize)
            childSizes[index].height = childHeight

            if childSize.height == childHeight {
                childSizes[index].width = childSize.width
            }

            var childWidth: CGFloat = 0
            childSize = CGSize.zero

            switch (params.width) {
            case LayoutParams.MATCH_PARENT:
                childWidth = maxWidthSize
            case LayoutParams.WRAP_CONTENT:
                childSize = child.sizeThatFits(
                        CGSize(width: maxWidthSize,
                                height: maxHeightSize))

                childWidth = childSize.width
            default:
                childWidth = params.width
            }

            childWidth = min(childWidth, maxWidthSize)

            childSizes[index].width = childWidth
        }
        return childSizes
    }

    private func layoutChildren(_ changed: Bool,
                                _ top: CGFloat,
                                _ left: CGFloat,
                                _ right: CGFloat,
                                _ bottom: CGFloat) {

        let height = bottom - top

        for (index, size) in childViewSizes.enumerated() {
            let child = subviews[index]

            if child.isHidden {
                continue
            }

            let childParams: FrameLayoutParams = child.uiViewExtension.layoutParams as! FrameLayoutParams
            let childWidth = size.width
            let childHeight = size.height
            var childTop: CGFloat = 0
            var childLeft: CGFloat = 0

            let verticalGravity = Gravity.getVerticalGravity(gravity: childParams.layoutGravity)
            let horizontalGravity = Gravity.getHorizontalGravity(gravity: childParams.layoutGravity)

            switch verticalGravity {
            case Gravity.CENTER_VERTICAL.getValue():
                childTop = (height - childHeight) / 2
                childTop += CGFloat(childParams.topMargin - childParams.bottomMargin)
            case Gravity.BOTTOM.getValue():
                childTop = height - childHeight
            default:
                childTop = CGFloat(childParams.topMargin)
            }

            switch horizontalGravity {
            case Gravity.CENTER_HORIZONTAL.getValue():
                childLeft = (right - left - childWidth) / 2 + left
                childLeft += (CGFloat(childParams.leftMargin - childParams.rightMargin))
            case Gravity.RIGHT.getValue():
                childLeft = right - left - childWidth - CGFloat(childParams.rightMargin);
            default:
                childLeft = left + CGFloat(childParams.leftMargin)
            }

            child.frame = CGRect(
                    x: childLeft,
                    y: childTop,
                    width: childWidth,
                    height: childHeight)
            child.layoutSubviews()
        }
    }

    public func addView(view: UIView, params: FrameLayoutParams) {
        view.uiViewExtension.layoutParams = params

        if view.superview != nil {
            return
        }

        if view is JustViewGroup {
            (view as! JustViewGroup).setParent(viewGroup: self)
        }

        addSubview(view)
    }

    override public func addView(view: UIView) {
        super.addView(view: view)
        var params: FrameLayoutParams = FrameLayoutParams.generateDefaultParams()
        self.addView(view: view, params: params)
    }
}
