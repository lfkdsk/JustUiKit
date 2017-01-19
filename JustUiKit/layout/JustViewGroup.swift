//
// Created by 刘丰恺 on 2016/12/30.
// Copyright (c) 2016 ___FULL___. All rights reserved.
//

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
