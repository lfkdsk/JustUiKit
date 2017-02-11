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
import Foundation

public enum RelativeRule: Int {
    case NONE_RULE = -1
    /**
     * Rule that aligns a child's right edge with another child's left edge.
     */
    case LEFT_OF = 0;
    /**
     * Rule that aligns a child's left edge with another child's right edge.
     */
    case RIGHT_OF = 1;
    /**
     * Rule that aligns a child's bottom edge with another child's top edge.
     */
    case ABOVE = 2;
    /**
     * Rule that aligns a child's top edge with another child's bottom edge.
     */
    case BELOW = 3;

    /**
     * Rule that aligns a child's baseline with another child's baseline.
     */
    case ALIGN_BASELINE = 4;
    /**
     * Rule that aligns a child's left edge with another child's left edge.
     */
    case ALIGN_LEFT = 5;
    /**
     * Rule that aligns a child's top edge with another child's top edge.
     */
    case ALIGN_TOP = 6;
    /**
     * Rule that aligns a child's right edge with another child's right edge.
     */
    case ALIGN_RIGHT = 7;
    /**
     * Rule that aligns a child's bottom edge with another child's bottom edge.
     */
    case ALIGN_BOTTOM = 8;

    /**
     * Rule that aligns the child's left edge with its RelativeLayout
     * parent's left edge.
     */
    case ALIGN_PARENT_LEFT = 9;
    /**
     * Rule that aligns the child's top edge with its RelativeLayout
     * parent's top edge.
     */
    case ALIGN_PARENT_TOP = 10;
    /**
     * Rule that aligns the child's right edge with its RelativeLayout
     * parent's right edge.
     */
    case ALIGN_PARENT_RIGHT = 11;
    /**
     * Rule that aligns the child's bottom edge with its RelativeLayout
     * parent's bottom edge.
     */
    case ALIGN_PARENT_BOTTOM = 12;

    /**
     * Rule that centers the child with respect to the bounds of its
     * RelativeLayout parent.
     */
    case CENTER_IN_PARENT = 13;
    /**
     * Rule that centers the child horizontally with respect to the
     * bounds of its RelativeLayout parent.
     */
    case CENTER_HORIZONTAL = 14;
    /**
     * Rule that centers the child vertically with respect to the
     * bounds of its RelativeLayout parent.
     */
    case CENTER_VERTICAL = 15;

    fileprivate static let VERB_COUNT = 16;

    fileprivate static let RULES_VERTICAL = [
            ABOVE, BELOW, ALIGN_BASELINE, ALIGN_TOP, ALIGN_BOTTOM
    ]

    fileprivate static let RULES_HORIZONTAL = [
            LEFT_OF, RIGHT_OF, ALIGN_LEFT, ALIGN_RIGHT
    ]

    public func getValue() -> Int {
        return rawValue
    }
}

fileprivate enum BindType {
    case UNBIND
    case BIND
}


fileprivate struct BindViewWithRule {
    var RULE: RelativeRule = .NONE_RULE
    var VIEW: UIView?
    var TYPE: BindType = .UNBIND

    init(view: UIView, rule: RelativeRule) {
        RULE = rule
        VIEW = view
        TYPE = .BIND
    }

    private init() {

    }

    fileprivate static func generateDefaultBind() -> BindViewWithRule {
        return BindViewWithRule()
    }
}

public class RelativeLayoutParams: MarginLayoutParams {

    fileprivate var rules: [BindViewWithRule] =
            [BindViewWithRule](
                    repeating: BindViewWithRule.generateDefaultBind(),
                    count: RelativeRule.VERB_COUNT)

    public var layoutGravity: Gravity = Gravity.NO_GRAVITY

    public static let VALUE_NOT_SET: CGFloat = -1

    public var mLeft: CGFloat = VALUE_NOT_SET,
            mTop: CGFloat = VALUE_NOT_SET,
            mRight: CGFloat = VALUE_NOT_SET,
            mBottom: CGFloat = VALUE_NOT_SET

    public var alignWithParent: Bool = false

    override public init(_ source: LayoutParams) {
        super.init(source)
    }

    override public init(width: CGFloat, height: CGFloat) {
        super.init(width: width, height: height)
    }

    fileprivate func getRules() -> [BindViewWithRule] {
        return rules
    }

    public func addRule(rule: RelativeRule, view: UIView) {
        rules[rule.getValue()].VIEW = view
        rules[rule.getValue()].RULE = rule
        rules[rule.getValue()].TYPE = .BIND
        self.setAlignParentValue(rule, true)
    }

    public func addRule(rule: RelativeRule) {
        rules[rule.getValue()].RULE = rule
        rules[rule.getValue()].TYPE = .BIND
        self.setAlignParentValue(rule, true)
    }

    public func removeRule(rule: RelativeRule) {
        rules[rule.getValue()] = BindViewWithRule.generateDefaultBind()
        removeAlignParentValue()
    }

    private func setAlignParentValue(_ rule: RelativeRule,
                                     _ value: Bool) {
        switch rule {
        case .ALIGN_PARENT_RIGHT, .ALIGN_PARENT_LEFT, .ALIGN_PARENT_TOP, .ALIGN_PARENT_BOTTOM:
            self.alignWithParent = value
        default:
            break
        }
    }

    private func removeAlignParentValue() {
        var hasParentRule: Bool = false
        loop: for item in rules {
            switch item.RULE {
            case .ALIGN_PARENT_RIGHT, .ALIGN_PARENT_LEFT, .ALIGN_PARENT_TOP, .ALIGN_PARENT_BOTTOM:
                hasParentRule = true
                break loop
            default:
                continue
            }
        }

        self.alignWithParent = hasParentRule
    }

    public func alignParentTop() {
        addRule(rule: .ALIGN_PARENT_TOP)
    }

    public func alignParentLeft() {
        addRule(rule: .ALIGN_PARENT_LEFT)
    }

    public func alignParentBottom() {
        addRule(rule: .ALIGN_BOTTOM)
    }

    public func alignParentRight() {
        addRule(rule: .ALIGN_PARENT_RIGHT)
    }

    public func alignTopTo(top: UIView) {
        addRule(rule: .ALIGN_TOP, view: top)
    }

    public func alignLeftTo(left: UIView) {
        addRule(rule: .ALIGN_LEFT, view: left)
    }

    public func alignRightTo(right: UIView) {
        addRule(rule: .ALIGN_RIGHT, view: right)
    }

    public func alignBottomTo(bottom: UIView) {
        addRule(rule: .ALIGN_BOTTOM, view: bottom)
    }

    public func rightOf(_ target: UIView) {
        addRule(rule: .RIGHT_OF, view: target)
    }

    public func leftOf(_ target: UIView) {
        addRule(rule: .LEFT_OF, view: target)
    }

    public func aboveOf(_ target: UIView) {
        addRule(rule: .ABOVE, view: target)
    }

    public func bellowOf(_ target: UIView) {
        addRule(rule: .BELOW, view: target)
    }

    public func centerInParent() {
        addRule(rule: .CENTER_IN_PARENT)
    }

    public func centerInHorizontal() {
        addRule(rule: .CENTER_HORIZONTAL)
    }

    public func centerInVertical() {
        addRule(rule: .CENTER_VERTICAL)
    }

    public static func generateDefaultParams() -> RelativeLayoutParams {
        return RelativeLayoutParams(width: LayoutParams.WRAP_CONTENT,
                height: LayoutParams.WRAP_CONTENT)
    }
}

open class JustRelativeLayout: JustViewGroup {

    private var mSortedHorizontalChildren: [UIView] = []

    private var mSortedVerticalChildren: [UIView] = []

    private var mMeasuredView: [CGSize] = []

    private var mDGraph: DependencyGraph = DependencyGraph()

    private var mDirtyFresh = true

    private var layoutSize = CGSize.zero

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var childLayoutSize: CGSize = CGSize.zero
        childLayoutSize = measureChild(size)
        return uiViewExtension.padding.getMaxSize(size: childLayoutSize)
    }

    override public func onLayout(_ changed: Bool, _ top: CGFloat, _ left: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        super.onLayout(changed, top, left, right, bottom)

        for (_, child) in subviews.enumerated() {

            if child.isHidden {
                continue
            }

            let params = child.uiViewExtension.layoutParams as! RelativeLayoutParams

            child.frame = CGRect(
                    x: params.mLeft,
                    y: params.mTop,
                    width: params.width,
                    height: params.height)
            child.layoutSubviews()
        }
    }

    override public func onMeasure(_ size: CGSize) {
        super.onMeasure(size)
        layoutSize = measureChild(size)
    }

    private func measureChild(_ size: CGSize) -> CGSize {

        let selfSize = uiViewExtension.padding.getMinSize(size: size)

        let padding = uiViewExtension.padding

        let pTop = frame.origin.y + padding.paddingTop,
                pLeft = frame.origin.x + padding.paddingLeft,
                pRight = pLeft + size.width - padding.paddingRight,
                pBottom = pTop + size.height - padding.paddingBottom

        let height = selfSize.height
        let width = selfSize.width

        var minTop: CGFloat = 0
        var minLeft: CGFloat = 0
        var maxRight: CGFloat = 0
        var maxBottom: CGFloat = 0

        if mDirtyFresh {
            mDirtyFresh = false
            sortChildren()
        }

        var views: [UIView] = mSortedHorizontalChildren
        var count = views.count

        // initial params with first unhidden view
        var initFlag: Bool = true

        for index in 0 ..< count {

            let child: UIView = views[index]

            if child.isHidden {
                continue
            }

            let params: RelativeLayoutParams = child.getLayoutParams() as! RelativeLayoutParams
            var rules: [BindViewWithRule] = params.getRules()

            applyHorizontalSizeRules(params: params, width: width, rules: &rules)
            measureChildHorizontal(view: child, width: width, height: height)
            positionHorizontalChildViews(child: child, left: pLeft, right: pRight)

            if initFlag {
                initFlag = false
                minTop = params.mTop
                minLeft = params.mLeft
                maxBottom = params.mBottom
                maxRight = params.mRight
            }

            minTop = min(minTop, params.mTop)
            minLeft = min(minLeft, params.mLeft)
            maxBottom = max(maxBottom, params.mBottom)
            maxRight = max(maxBottom, params.mRight)
        }

        views = mSortedVerticalChildren
        count = views.count

        for index in 0 ..< count {
            let child: UIView = views[index]

            if child.isHidden {
                continue
            }

            let params: RelativeLayoutParams = child.getLayoutParams() as! RelativeLayoutParams
            var rules: [BindViewWithRule] = params.getRules()

            applyVerticalSizeRules(params: params, height: height, rules: &rules)
            measureChildVertical(view: child, width: width, height: height)
            positionVerticalChildViews(child: child, top: pTop, bottom: pBottom)

            minTop = min(minTop, params.mTop)
            minLeft = min(minLeft, params.mLeft)
            maxBottom = max(maxBottom, params.mBottom)
            maxRight = max(maxRight, params.mRight)
        }

        return CGSize(width: maxRight - minLeft, height: maxBottom - minTop)
    }

    private func applyVerticalSizeRules(params childParams: RelativeLayoutParams, height: CGFloat,
                                        rules: inout [BindViewWithRule]) {
        func hasBindView(rule: RelativeRule) -> Bool {
            let ruleValue: BindViewWithRule = rules[rule.getValue()]
            return ruleValue.VIEW != nil && ruleValue.TYPE == BindType.BIND
        }

        var anchorParams: RelativeLayoutParams?

        childParams.mTop = RelativeLayoutParams.VALUE_NOT_SET
        childParams.mBottom = RelativeLayoutParams.VALUE_NOT_SET

        anchorParams = getRelatedViewParams(rules: &rules, relation: .ABOVE)

        if anchorParams != nil {
            childParams.mBottom = anchorParams!.mTop - CGFloat(anchorParams!.topMargin +
                    childParams.bottomMargin)
        } else if childParams.alignWithParent && hasBindView(rule: .ABOVE) {
            if (height >= 0) {
                childParams.mBottom = height - CGFloat(childParams.bottomMargin)
            }
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .BELOW)

        if anchorParams != nil {
            childParams.mTop = anchorParams!.mBottom + CGFloat(anchorParams!.bottomMargin +
                    childParams.topMargin);
        } else if childParams.alignWithParent && hasBindView(rule: .BELOW) {
            childParams.mTop = CGFloat(childParams.topMargin)
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .ALIGN_TOP)

        if anchorParams != nil {
            childParams.mTop = anchorParams!.mTop + CGFloat(childParams.topMargin)
        } else if childParams.alignWithParent && hasBindView(rule: .ALIGN_TOP) {
            childParams.mTop = CGFloat(childParams.topMargin)
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .ALIGN_BOTTOM)

        if anchorParams != nil {
            childParams.mBottom = anchorParams!.mBottom - CGFloat(childParams.bottomMargin)
        } else if childParams.alignWithParent && hasBindView(rule: .ALIGN_BOTTOM) {
            if (height >= 0) {
                childParams.mBottom = height - CGFloat(childParams.bottomMargin)
            }
        }

        if hasBindView(rule: .ALIGN_PARENT_TOP) {
            childParams.mTop = CGFloat(childParams.topMargin)
        }

        if hasBindView(rule: .ALIGN_PARENT_BOTTOM) {
            if (height >= 0) {
                childParams.mBottom = height - CGFloat(childParams.bottomMargin)
            }
        }
    }

    private func measureChildVertical(view: UIView,
                                      width: CGFloat,
                                      height: CGFloat) {
        var childWidth: CGFloat = 0
        var childSize: CGSize = CGSize()
        let params: RelativeLayoutParams = view.uiViewExtension.layoutParams as! RelativeLayoutParams

        switch (params.width) {
        case LayoutParams.MATCH_PARENT:
            childWidth = width
        case LayoutParams.WRAP_CONTENT:
            childSize = view.sizeThatFits(
                    CGSize(width: width,
                            height: height))

            childWidth = childSize.width
        default:
            childWidth = params.width
        }

        childWidth = min(childWidth, width)

        params.width = childWidth
    }

    private func measureChildHorizontal(view: UIView,
                                        width: CGFloat,
                                        height: CGFloat) {
        let params: RelativeLayoutParams = view.uiViewExtension.layoutParams as! RelativeLayoutParams

        var childHeight: CGFloat = 0
        var childSize: CGSize = CGSize()

        switch params.height {
        case LayoutParams.MATCH_PARENT:
            childHeight = width
        case LayoutParams.WRAP_CONTENT:
            childSize = view.sizeThatFits(
                    CGSize(width: width,
                            height: height))
            childHeight = childSize.height
        default:
            childHeight = params.height
        }

        childHeight = min(childHeight, height)
        params.height = childHeight

        if childSize.height == childHeight {
            params.width = childSize.width
        }
    }

    public func positionVerticalChildViews(child: UIView,
                                           top: CGFloat,
                                           bottom: CGFloat) {

        let childParams: RelativeLayoutParams = child.uiViewExtension.layoutParams as! RelativeLayoutParams

        if childParams.mTop == RelativeLayoutParams.VALUE_NOT_SET && childParams.mBottom != RelativeLayoutParams.VALUE_NOT_SET {
            // set mLeft
            childParams.mTop = childParams.mBottom - childParams.height
        } else if childParams.mTop != RelativeLayoutParams.VALUE_NOT_SET && childParams.mBottom == RelativeLayoutParams.VALUE_NOT_SET {
            childParams.mBottom = childParams.mTop + childParams.height
        } else if childParams.mTop == RelativeLayoutParams.VALUE_NOT_SET && childParams.mBottom == RelativeLayoutParams.VALUE_NOT_SET {
            let verticalGravity = Gravity.getVerticalGravity(gravity: childParams.layoutGravity)
            let childHeight = childParams.height
            switch verticalGravity {
            case Gravity.CENTER_VERTICAL.getValue():
                childParams.mTop = (bottom - top - childHeight) / 2
                childParams.mTop += CGFloat(childParams.topMargin - childParams.bottomMargin)
            case Gravity.BOTTOM.getValue():
                childParams.mTop = bottom - top - childHeight
            default:
                childParams.mTop = top + CGFloat(childParams.topMargin)
            }
            childParams.mBottom = childParams.mTop + childParams.height
        }
    }

    public func positionHorizontalChildViews(child: UIView,
                                             left: CGFloat,
                                             right: CGFloat) {

        let childParams: RelativeLayoutParams = child.uiViewExtension.layoutParams as! RelativeLayoutParams
        let childWidth = childParams.width

        if childParams.mLeft == RelativeLayoutParams.VALUE_NOT_SET && childParams.mRight != RelativeLayoutParams.VALUE_NOT_SET {
            // set mLeft
            childParams.mLeft = childParams.mRight - childParams.width
        } else if childParams.mLeft != RelativeLayoutParams.VALUE_NOT_SET && childParams.mRight == RelativeLayoutParams.VALUE_NOT_SET {
            childParams.mRight = childParams.mLeft + childParams.height
        } else if childParams.mLeft == RelativeLayoutParams.VALUE_NOT_SET && childParams.mRight == RelativeLayoutParams.VALUE_NOT_SET {
            let horizontalGravity = Gravity.getHorizontalGravity(gravity: childParams.layoutGravity)
            switch horizontalGravity {
            case Gravity.CENTER_HORIZONTAL.getValue():
                childParams.mLeft = (right - left - childWidth) / 2 + left
                childParams.mLeft += (CGFloat(childParams.leftMargin - childParams.rightMargin))
            case Gravity.RIGHT.getValue():
                childParams.mLeft = right - left - childWidth - CGFloat(childParams.rightMargin)
            default:
                childParams.mLeft = left + CGFloat(childParams.leftMargin)
            }
            childParams.mRight = childParams.mLeft + childParams.width
        }
    }

    ///
    /// horizontal rules
    ///
    private func applyHorizontalSizeRules(params childParams: RelativeLayoutParams, width: CGFloat,
                                          rules: inout [BindViewWithRule]) {

        func hasBindView(rule: RelativeRule) -> Bool {
            let ruleValue: BindViewWithRule = rules[rule.getValue()]
            return ruleValue.VIEW != nil && ruleValue.TYPE == BindType.BIND
        }

        var anchorParams: RelativeLayoutParams?

        // min
        childParams.mLeft = RelativeLayoutParams.VALUE_NOT_SET
        childParams.mRight = RelativeLayoutParams.VALUE_NOT_SET

        // get the view left of current View
        anchorParams = getRelatedViewParams(rules: &rules, relation: .LEFT_OF)

        if anchorParams != nil {
            childParams.mRight = anchorParams!.mLeft
                    - CGFloat(anchorParams!.leftMargin + anchorParams!.rightMargin)
        } else if childParams.alignWithParent && hasBindView(rule: .LEFT_OF) {
            if width >= 0 {
                childParams.mRight = width - CGFloat(childParams.rightMargin)
            }
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .RIGHT_OF)

        if anchorParams != nil {
            childParams.mLeft = anchorParams!.mRight + CGFloat(anchorParams!.leftMargin + anchorParams!.rightMargin)
        } else if childParams.alignWithParent && hasBindView(rule: .RIGHT_OF) {
            childParams.mLeft = CGFloat(childParams.leftMargin)
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .ALIGN_LEFT)
        if anchorParams != nil {
            childParams.mLeft = anchorParams!.mLeft + CGFloat(childParams.leftMargin)
        } else if childParams.alignWithParent && hasBindView(rule: .ALIGN_LEFT) {
            childParams.mLeft = CGFloat(childParams.leftMargin)
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .ALIGN_RIGHT);
        if (anchorParams != nil) {
            childParams.mRight = anchorParams!.mRight - CGFloat(childParams.rightMargin)
        } else if childParams.alignWithParent && hasBindView(rule: .ALIGN_RIGHT) {
            if (width >= 0) {
                childParams.mRight = width - CGFloat(childParams.rightMargin)
            }
        }

        if hasBindView(rule: .ALIGN_PARENT_LEFT) {
            childParams.mLeft = CGFloat(childParams.leftMargin)
        }

        if hasBindView(rule: .ALIGN_PARENT_RIGHT) {
            if (width >= 0) {
                childParams.mRight = width - CGFloat(childParams.rightMargin)
            }
        }
    }


    private func getRelatedViewParams(rules: inout [BindViewWithRule], relation: RelativeRule) ->
            RelativeLayoutParams? {
        let view: UIView? = getRelatedView(rules: rules, relation: relation)

        if view != nil {
            let params: RelativeLayoutParams = view!.getLayoutParams() as! RelativeLayoutParams
            return params
        }

        return nil
    }

    private func getRelatedView(rules: [BindViewWithRule], relation: RelativeRule) -> UIView? {
        let view = rules[relation.getValue()].VIEW

        if view == nil {
            return view
        }

        let id = view!.getViewId()

        if id.viewId != 0 {
            var node: Node? = mDGraph.mKeyNodes.object(forKey: id)

            if node == nil {
                return nil
            }

            var view: UIView = (node?.view)!

            while view.isHidden {
                let l_rules: [BindViewWithRule] = (view.getLayoutParams() as! RelativeLayoutParams).getRules()
                node = mDGraph.mKeyNodes.object(forKey: l_rules[relation.getValue()].VIEW?.getViewId())
                if node == nil {
                    return nil
                }
                view = (node?.view)!
            }

            return view
        }

        return nil
    }

    private func sortChildren() {
        let graph = mDGraph

        for (_, child) in subviews.enumerated() {
            graph.add(view: child)
        }

        mSortedHorizontalChildren = graph.getSortedViews(rules: RelativeRule.RULES_HORIZONTAL)

        mSortedVerticalChildren = graph.getSortedViews(rules: RelativeRule.RULES_VERTICAL)
    }

    fileprivate class Node {
        var view: UIView!

        var dependents: NSMapTable = NSMapTable<Node, DependencyGraph>()

        var dependencies: NSMapTable = NSMapTable<InnerInteger, Node>()

        static var mPool: ReleasePool = ReleasePool<Node>()

        init(view: UIView) {
            self.view = view
        }

        init() {
            // none init
        }

        static func acquire(view: UIView) -> Node {
            var node: Node? = mPool.acquire()
            if node == nil {
                node = Node(view: view)
            } else {
                node!.view = view
            }
            return node!
        }

        public func release() {
            self.view = nil
            dependents.removeAllObjects()
            dependencies.removeAllObjects()
        }

        public static func ==(_ a: Node, _ b: Node) -> Bool {
            if (a.view?.getViewId())! == (b.view?.getViewId())! {
                return true
            }
            return false
        }
    }

    fileprivate class DependencyGraph {

        public var mNodes: Array = Array<Node>()

        public var mKeyNodes: NSMapTable = NSMapTable<InnerInteger, Node>()

        public var mRoots: Queue = Queue<Node>()

        public func clear() {
            var nodes = mNodes
            for item in nodes {
                item.release()
            }
            nodes.removeAll()
            mKeyNodes.removeAllObjects()
            mRoots.clear()
        }

        public func add(view: UIView) {
            let viewId = view.getViewId()
            let node = Node.acquire(view: view)

            if viewId.viewId != -1 {
                mKeyNodes.setObject(node, forKey: viewId)
            }

            mNodes.append(node)
        }

        public func getSortedViews(rules: [RelativeRule]) -> [UIView] {
            var roots: Queue<Node> = findRoots(rulesFilter: rules)
            var sorted: [UIView] = []

            while let node: Node? = roots.dequeue(), node != nil {
                let view: UIView = node!.view!
                let key: InnerInteger = view.getViewId()
                sorted.append(view)
                let dependents: NSMapTable<Node, DependencyGraph> = node!.dependents
                for dependent in dependents.keyEnumerator() {
                    let node = dependent as! Node
                    let dependencies = node.dependencies
                    dependencies.removeObject(forKey: key)
                    if dependencies.count == 0 {
                        roots.enqueue(node)
                    }
                }
            }

            return sorted
        }

        public func findRoots(rulesFilter: [RelativeRule]) -> Queue<Node> {
            let keyNodes = mKeyNodes
            let nodes = mNodes

            // Find roots can be invoked several times, so make sure to clear
            // all dependents and dependencies before running the algorithm
            for item in nodes {
                item.dependents.removeAllObjects()
                item.dependencies.removeAllObjects()
            }

            // Builds up the dependents and dependencies for each node of the graph
            for node: Node in nodes {
                let layoutParams = node.view!.uiViewExtension.layoutParams as! RelativeLayoutParams

                let rules = layoutParams.rules

                let ruleCount = rulesFilter.count

                for index in 0 ..< ruleCount {
                    let rule: BindViewWithRule = rules[rulesFilter[index].getValue()]

                    if rule.RULE.getValue() >= 0 {
                        let dependency = keyNodes.object(forKey: rule.VIEW?.getViewId())

                        if dependency == nil || dependency! == node {
                            continue
                        }

                        dependency?.dependents.setObject(self, forKey: node)
                        node.dependencies.setObject(dependency, forKey: rule.VIEW?.getViewId())
                    }
                }
            }

            var roots: Queue<Node> = mRoots
            roots.clear()

            for node: Node in nodes {
                if node.dependencies.count == 0 {
                    roots.enqueue(node)
                }
            }

            return roots
        }
    }

    public func addView(view: UIView, params: RelativeLayoutParams = RelativeLayoutParams.generateDefaultParams()) {
        view.uiViewExtension.layoutParams = params

        if view.superview != nil {
            return
        }

        if view is JustViewGroup {
            (view as! JustViewGroup).setParent(viewGroup: self)
        }

        addSubview(view)

        // bind view with params
        view.setViewId(id: UIView.generateViewId())
        params.bindWith(view: view)
    }

    override public func addView(view: UIView) {
        super.addView(view: view)
        self.addView(view: view, params: RelativeLayoutParams.generateDefaultParams())
    }
}
