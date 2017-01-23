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

public class LinearLayoutParams: MarginLayoutParams {
    var weight: CGFloat = 0
    var layoutGravity: Int = Gravity.NO_GRAVITY.rawValue
    var minHeight: CGFloat = 0
    var minWidth: CGFloat = 0
    var maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    var maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude

    override public init(width: CGFloat, height: CGFloat) {
        super.init(width: width, height: height)
        self.layoutGravity = Gravity.NO_GRAVITY.rawValue
    }

    public init(width: CGFloat, height: CGFloat, layoutGravity: Int) {
        super.init(width: width, height: height)
        self.layoutGravity = layoutGravity
    }

    public init(linear: LinearLayoutParams) {
        super.init(source: linear)
        self.weight = linear.weight
        self.layoutGravity = linear.layoutGravity
        self.minHeight = linear.minHeight
        self.maxHeight = linear.maxHeight
        self.minWidth = linear.minWidth
        self.maxWidth = linear.maxWidth
    }

    override public init(source: MarginLayoutParams) {
        super.init(source: source)
    }

    override public init(_ params: LayoutParams) {
        super.init(params)
    }
}

fileprivate struct Rect {
    public var width, height, x, y: CGFloat

    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    public init(rect: Rect) {
        self.x = rect.x
        self.y = rect.y
        self.width = rect.width
        self.height = rect.height
    }

    public func toCGRect() -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

fileprivate extension CGRect {
    fileprivate func toRect() -> Rect {
        return Rect(x: origin.x, y: origin.y, width: width, height: height)
    }
}

private struct BindViewWithRect {
    public var view: UIView
    public var rect: Rect

    public init(view: UIView, rect: Rect) {
        self.view = view
        self.rect = rect
    }

    public init(bind: BindViewWithRect) {
        self.view = bind.view
        self.rect = bind.rect
    }
}

open class JustLinearLayout: JustViewGroup {
    private var marginFlag: Int = Gravity.TOP | Gravity.LEFT

    private var currentChildLayoutTop: CGFloat = 0.0
    private var currentChildLayoutLeft: CGFloat = 0.0

    private var childViewSizes: [CGSize] = []

    private var orientation: Orientation = Orientation.Vertical {
        didSet {
            setNeedsLayout()
        }
    }

    public init(orientation: Orientation) {
        super.init()
        self.orientation = orientation
    }

    public init(frame groupFrame: CGRect, orientation: Orientation) {
        super.init(frame: groupFrame)
        self.orientation = orientation
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let childSizes: [CGSize]
        var childLayoutSize = CGSize.zero

        if orientation == .Horizontal {
            var padding: Padding
            var index: Int = 0
            childSizes = measureHorizontal(size)
            for size in childSizes {
                padding = subviews[index].uiViewExtension.padding
                childLayoutSize.width += size.width + padding.paddingLeft + padding.paddingRight
                childLayoutSize.height = max(childLayoutSize.height, size.height + padding.paddingTop + padding.paddingBottom)
                index += 1
            }
        } else {
            var padding: Padding
            var index: Int = 0
            childSizes = measureVertical(size)
            for size in childSizes {
                padding = subviews[index].uiViewExtension.padding
                childLayoutSize.width = max(childLayoutSize.width, size.width + padding.paddingLeft + padding.paddingRight)
                childLayoutSize.height += size.height + padding.paddingTop + padding.paddingBottom
                index += 1
            }
        }
        return uiViewExtension.padding.getMaxSize(size: childLayoutSize)
    }


    public func measureHorizontal(_ size: CGSize) -> [CGSize] {
        let selfSize = uiViewExtension.padding.getMinSize(size: size)

        let height = selfSize.height
        let width = selfSize.width

        let maxHeightSize: CGFloat = height
        var maxWidthSize: CGFloat = width

        var totalWeight: CGFloat = 0.0

        var childSizes = [CGSize](repeating: CGSize(width: -1, height: -1), count: subviews.count)

        for (index, child) in subviews.enumerated() {
            if child.isHidden {
                continue
            }

            let params: LinearLayoutParams = child.uiViewExtension.layoutParams as! LinearLayoutParams

            totalWeight += params.weight
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

            childHeight = max(childHeight, params.minHeight)
            childHeight = min(childHeight, params.maxHeight)
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

            childWidth = max(childWidth, params.minWidth)
            childWidth = min(childWidth, params.maxWidth)
            childWidth = min(childWidth, maxWidthSize)

            childSizes[index].width = childWidth

            maxWidthSize -= (childWidth)
        }

        if totalWeight > 0.0 {
            let layoutEx = uiViewExtension.padding
            maxWidthSize = width - layoutEx.paddingLeft - layoutEx.paddingRight
            for (index, child) in subviews.enumerated() {
                if child.isHidden {
                    continue
                }

                let params: LinearLayoutParams = child.uiViewExtension.layoutParams as! LinearLayoutParams

                if params.weight > 0.0 && maxWidthSize > 0.0 {
                    let childWidth: CGFloat = params.weight * maxWidthSize / totalWeight
                    if childWidth > 0.0 {
                        childSizes[index].width = childWidth
                        continue
                    }
                } else {
                    childSizes[index].height = 0
                    childSizes[index].width = 0
                }
            }
        }

        return childSizes
    }

    private func measureVertical(_ size: CGSize) -> [CGSize] {
        let selfSize = uiViewExtension.padding.getMinSize(size: size)

        let height = selfSize.height
        let width = selfSize.width

        let layoutEx = uiViewExtension.padding

        var maxHeightSize: CGFloat = height
        let maxWidthSize: CGFloat = width

        var totalWeight: CGFloat = 0.0

        // all sub view size
        var childSizes = [CGSize](repeating: CGSize(width: -1, height: -1), count: subviews.count)

        for (index, child) in subviews.enumerated() {
            if (child.isHidden) {
                continue
            }

            let params: LinearLayoutParams = child.uiViewExtension.layoutParams as! LinearLayoutParams

            totalWeight += params.weight

            var childWidth: CGFloat = 0
            var childSize: CGSize = CGSize()

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

            childWidth = max(childWidth, params.minWidth)
            childWidth = min(childWidth, params.maxWidth)
            childWidth = min(childWidth, maxWidthSize)

            childSizes[index].width = childWidth

            if childSize.width == childWidth {
                childSizes[index].height = childSize.height
            }


//            maxWidthSize -= (childWidth + marginWidth)

            ////////////////////////////////////////////
            var childHeight: CGFloat = 0
            childSize = CGSize()

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

            childHeight = max(childHeight, params.minHeight)
            childHeight = min(childHeight, params.maxHeight)
            childHeight = min(childHeight, maxHeightSize)

            childSizes[index].height = childHeight

            maxHeightSize -= (childHeight)
        }

        if totalWeight > 0.0 {

            maxHeightSize = height - layoutEx.paddingTop - layoutEx.paddingBottom

            for (index, child) in subviews.enumerated() {
                if child.isHidden {
                    continue
                }

                let params: LinearLayoutParams = child.uiViewExtension.layoutParams as! LinearLayoutParams

                if params.weight > 0.0 && maxHeightSize > 0.0 {
                    let childHeight: CGFloat = params.weight * maxHeightSize / totalWeight
                    if childHeight > 0.0 {
                        childSizes[index].height = childHeight
                        continue
                    }
                } else {
                    childSizes[index].height = 0
                    childSizes[index].width = 0
                }
            }
        }

        return childSizes
    }

    public func layoutVertical(_ top: CGFloat,
                               _ left: CGFloat,
                               _ right: CGFloat,
                               _ bottom: CGFloat) {
//        let height = bottom - top
//        let padding = uiViewExtension.padding

        currentChildLayoutTop = top

        var childViewRect: [BindViewWithRect] = []

        for (index, size) in childViewSizes.enumerated() {

            let child = subviews[index]

            if child.isHidden {
                continue
            }

            let childParams: LinearLayoutParams = child.uiViewExtension.layoutParams as! LinearLayoutParams
            let childWidth = size.width
            let childHeight = size.height
            var childTop: CGFloat = 0
            var childLeft: CGFloat = 0

//            let verticalGravity = childParams.layoutGravity & JustLinearLayout.VERTICAL_GRAVITY_MASK
//
//            var specialComFlag = false

//            switch verticalGravity {
//            case Gravity.CENTER_VERTICAL.getValue():
//                childTop = (height - childHeight) / 2
//                childTop += CGFloat(childParams.topMargin - childParams.bottomMargin)
//            case Gravity.BOTTOM.getValue():
//                specialComFlag = true
//                childTop = height - childHeight
//            default:
//                childTop = currentChildLayoutTop + CGFloat(childParams.topMargin)
//            }
            childTop = currentChildLayoutTop + CGFloat(childParams.topMargin)

            let horizontalGravity = childParams.layoutGravity & Gravity.HORIZONTAL_GRAVITY_MASK

            switch horizontalGravity {
            case Gravity.CENTER_HORIZONTAL.getValue():
//                if verticalGravity == Gravity.CENTER_VERTICAL.getValue()
//                           || verticalGravity == Gravity.BOTTOM.getValue() {
//                    specialComFlag = true
//                }
                childLeft = (right - left - childWidth) / 2 + left
                childLeft += (CGFloat(childParams.leftMargin - childParams.rightMargin))
            case Gravity.RIGHT.getValue():
//                if verticalGravity == Gravity.BOTTOM.getValue() {
//                    specialComFlag = true
//                }
                childLeft = right - left - childWidth - CGFloat(childParams.rightMargin);
            default:
                childLeft = left + CGFloat(childParams.leftMargin)
//                if hasParent() && verticalGravity == Gravity.BOTTOM.getValue() {
//                    childLeft -= left
//                }
            }


            if hasParent() {
                childTop -= top
                childLeft -= left
            }

//            if childViewRect.count == 0 {
//                childLeft += padding.paddingLeft
//                childTop += padding.paddingTop
//            }

            child.frame = CGRect(
                    x: childLeft,
                    y: childTop,
                    width: childWidth,
                    height: childHeight)
            child.layoutSubviews()

            childViewRect.append(BindViewWithRect(
                    view: child,
                    rect: child.frame.toRect()))

//            if !specialComFlag {
            currentChildLayoutTop += size.height
//            }
        }

        var localBinders: [BindViewWithRect] = childViewRect.sorted { (first, second) -> Bool in
            return first.rect.y < second.rect.y
        }

        var index: Int = 0

        for item in localBinders {

            if index == localBinders.endIndex - 1 {
                break
            }

            var nextView = localBinders[index + 1]
            let itemBottom = item.rect.y + item.rect.height
            let nextTop = nextView.rect.y

            if nextTop <= itemBottom {
                let oldFrame = nextView.rect

                nextView.rect = Rect(
                        x: oldFrame.x,
                        y: itemBottom,
                        width: oldFrame.width,
                        height: oldFrame.height
                )
                nextView.view.frame = nextView.rect.toCGRect()
                nextView.view.layoutSubviews()
            }
            index += 1
        }
    }


    public func layoutHorizontal(_ top: CGFloat,
                                 _ left: CGFloat,
                                 _ right: CGFloat,
                                 _ bottom: CGFloat) {
//        let width = right - left
        let height = bottom - top
//        let padding = uiViewExtension.padding

        currentChildLayoutLeft = left

        var childViewRect: [BindViewWithRect] = []

        for (index, size) in childViewSizes.enumerated() {

            let child = subviews[index]

            if child.isHidden {
                continue
            }

            let childParams: LinearLayoutParams = child.uiViewExtension.layoutParams as! LinearLayoutParams
            let childWidth = size.width
            let childHeight = size.height
            var childTop: CGFloat = 0
            var childLeft: CGFloat = 0

//            let horizontalGravity = childParams.layoutGravity & JustLinearLayout.HORIZONTAL_GRAVITY_MASK
//
//            var specialComFlag = false
//
//            switch horizontalGravity {
//            case Gravity.RIGHT.getValue():
//                childLeft = width - childWidth - CGFloat(childParams.rightMargin);
//            case Gravity.CENTER_HORIZONTAL.getValue():
//                childLeft = (right - left - childWidth) / 2
//                childLeft += (CGFloat(childParams.leftMargin - childParams.rightMargin))
//            default:
//                childLeft = currentChildLayoutLeft + CGFloat(childParams.leftMargin)
//            }

            childLeft = currentChildLayoutLeft + CGFloat(childParams.leftMargin)

            let verticalGravity = childParams.layoutGravity & Gravity.VERTICAL_GRAVITY_MASK

            switch verticalGravity {
            case Gravity.CENTER_VERTICAL.getValue():
                childTop = (height - childHeight) / 2 + top
                childTop += CGFloat(childParams.topMargin - childParams.bottomMargin)
            case Gravity.BOTTOM.getValue():
                childTop = bottom - childHeight
            default:
                childTop = top + CGFloat(childParams.topMargin)
            }

            if hasParent() {
                childTop -= top
                childLeft -= left
            }
//
//            if childViewRect.count == 0 {
//                childLeft += padding.paddingLeft
//                childTop += padding.paddingTop
//            }

            child.frame = CGRect(
                    x: childLeft,
                    y: childTop,
                    width: childWidth,
                    height: childHeight)
            child.layoutSubviews()

//            if !specialComFlag {
            currentChildLayoutLeft += size.width
//            }

            childViewRect.append(BindViewWithRect(
                    view: child,
                    rect: child.frame.toRect()))
        }

        var localBinders: [BindViewWithRect] = childViewRect.sorted { (first, second) -> Bool in
            return first.rect.x < second.rect.x
        }

        var index: Int = 0

        for item in localBinders {

            if index == localBinders.endIndex - 1 {
                break
            }

            var nextView = localBinders[index + 1]
            let itemRight = item.rect.x + item.rect.width
            let nextLeft = nextView.rect.x

            if nextLeft <= itemRight {
                let oldFrame = nextView.rect

                nextView.rect = Rect(
                        x: itemRight,
                        y: oldFrame.y,
                        width: oldFrame.width,
                        height: oldFrame.height
                )
                nextView.view.frame = nextView.rect.toCGRect()
                nextView.view.layoutSubviews()
            }
            index += 1
        }
    }

    override public func onLayout(_ changed: Bool,
                                  _ top: CGFloat,
                                  _ left: CGFloat,
                                  _ right: CGFloat,
                                  _ bottom: CGFloat) {
        super.onLayout(changed, top, left, right, bottom)
        let padding = uiViewExtension.padding

        let pTop = top + padding.paddingTop,
                pLeft = left + padding.paddingLeft,
                pRight = right - padding.paddingRight,
                pBottom = bottom - padding.paddingBottom

        if orientation == Orientation.Horizontal {
            layoutHorizontal(
                    pTop, pLeft, pRight, pBottom)
        } else {
            layoutVertical(
                    pTop, pLeft, pRight, pBottom)
        }
    }

    override public func onMeasure(_ size: CGSize) {
        super.onMeasure(size)

        if orientation == Orientation.Horizontal {
            childViewSizes = measureHorizontal(size)
        } else {
            childViewSizes = measureVertical(size)
        }
    }

    override public func addView(view: UIView, params: LayoutParams) {
        super.addView(view: view, params: params)

        view.uiViewExtension.layoutParams = params as! LinearLayoutParams

        if view.superview != nil {
            return
        }

        if view is JustViewGroup {
            (view as! JustViewGroup).setParent(viewGroup: self)
        }

        addSubview(view)
    }

}
