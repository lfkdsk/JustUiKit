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

    public var mLeft: CGFloat = 0,
            mTop: CGFloat = 0,
            mRight: CGFloat = 0,
            mBottom: CGFloat = 0

    public var alignWithParent: Bool = false

    override init(_ source: LayoutParams) {
        super.init(source)
    }

    override init(width: CGFloat, height: CGFloat) {
        super.init(width: width, height: height)
    }

    fileprivate func getRules() -> [BindViewWithRule] {
        return rules
    }

    public func addRule(rule: RelativeRule, view: UIView) {
        var bind = rules[rule.getValue()]
        bind.VIEW = view
        bind.RULE = rule
        bind.TYPE = .BIND
        self.setAlignParentValue(rule, true)
    }

    public func addRule(rule: RelativeRule) {
        var bind = rules[rule.getValue()]
        bind.RULE = rule
        bind.TYPE = .BIND
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

    override init(frame groupFrame: CGRect) {
        super.init(frame: groupFrame)
    }
    override init(frame groupFrame: CGRect, parentView: JustViewParent) {
        super.init(frame: groupFrame, parentView: parentView)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func onLayout(_ changed: Bool, _ top: CGFloat, _ left: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        super.onLayout(changed, top, left, right, bottom)

        let padding = uiViewExtension.padding

        let pTop = top + padding.paddingTop,
                pLeft = left + padding.paddingLeft,
                pRight = right - padding.paddingRight,
                pBottom = bottom - padding.paddingBottom

    }

    override public func onMeasure(_ size: CGSize) {
        super.onMeasure(size)

        let selfSize = uiViewExtension.padding.getMinSize(size: size)

        let height = selfSize.height
        let width = selfSize.width

        if mDirtyFresh {
            mDirtyFresh = false
            sortChildren()
        }

        var views: [UIView] = mSortedHorizontalChildren
        var count = views.count

        var childSizes = [CGSize](repeating: CGSize(width: -1, height: -1), count: count)

        for index in 0 ..< count {
            var child: UIView = views[index]

            if child.isHidden {
                continue
            }

            var params: RelativeLayoutParams = child.getLayoutParams() as! RelativeLayoutParams
            var rules: [BindViewWithRule] = params.getRules()

            applyHorizontalSizeRules(params: &params, width: width, rules: &rules)
            measureChildHorizontal(view: &child, group: &childSizes[index], width: width, height: height)

            applyVerticalSizeRules(params: &params, width: width, rules: &rules)
            measureChildVertical(view: &child, group: &childSizes[index], width: width, height: height)
        }
    }

    private func applyVerticalSizeRules(params: inout RelativeLayoutParams, width: CGFloat,
                                        rules: inout [BindViewWithRule]) {

    }

    private func measureChildVertical(view: inout UIView,
                                      group: inout CGSize,
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

        group.width = childWidth
    }

    private func measureChildHorizontal(view: inout UIView,
                                        group: inout CGSize,
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
        group.height = childHeight

        if childSize.height == childHeight {
            group.width = childSize.width
        }
    }

    ///
    /// horizontal rules
    ///
    private func applyHorizontalSizeRules(params: inout RelativeLayoutParams, width: CGFloat,
                                          rules: inout [BindViewWithRule]) {

        func hasBindView(rule: RelativeRule) -> Bool {
            let ruleValue: BindViewWithRule = rules[rule.getValue()]
            return ruleValue.VIEW != nil && ruleValue.TYPE == BindType.BIND
        }

        var anchorParams: RelativeLayoutParams?

        // min
        params.mLeft = CGFloat(Int.min)
        params.mRight = CGFloat(Int.min)

        // get the view left of current View
        anchorParams = getRelatedViewParams(rules: &rules, relation: .LEFT_OF)

        if anchorParams != nil {
            params.mRight = anchorParams!.mLeft
                    - CGFloat(anchorParams!.leftMargin + anchorParams!.rightMargin)
        } else if params.alignWithParent && hasBindView(rule: .LEFT_OF) {
            if width >= 0 {
                params.mRight = width - CGFloat(params.rightMargin)
            }
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .RIGHT_OF)

        if anchorParams != nil {
            params.mLeft = anchorParams!.mRight + CGFloat(anchorParams!.leftMargin + anchorParams!.rightMargin)
        } else if params.alignWithParent && hasBindView(rule: .RIGHT_OF) {
            params.mLeft = CGFloat(params.leftMargin)
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .ALIGN_LEFT)
        if anchorParams != nil {
            params.mLeft = anchorParams!.mLeft + CGFloat(params.leftMargin)
        } else if params.alignWithParent && hasBindView(rule: .ALIGN_LEFT) {
            params.mLeft = CGFloat(params.leftMargin)
        }

        anchorParams = getRelatedViewParams(rules: &rules, relation: .ALIGN_RIGHT);
        if (anchorParams != nil) {
            params.mRight = anchorParams!.mRight - CGFloat(params.rightMargin)
        } else if params.alignWithParent && hasBindView(rule: .ALIGN_RIGHT) {
            if (width >= 0) {
                params.mRight = width - CGFloat(params.rightMargin)
            }
        }

        if hasBindView(rule: .ALIGN_PARENT_LEFT) {
            params.mLeft = CGFloat(params.leftMargin)
        }

        if hasBindView(rule: .ALIGN_PARENT_RIGHT) {
            if (width >= 0) {
                params.mRight = width - CGFloat(params.rightMargin)
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
            var sorted: [UIView] = []
            var roots: Queue<Node> = findRoots(rulesFilter: rules)

            var index = 0

            while let node = roots.dequeue(), isKind(of: Node.self) {
                let view: UIView = node.view!
                let key: InnerInteger = view.getViewId()
                sorted[index] = view
                index += 1
                let dependents: NSMapTable<Node, DependencyGraph> = node.dependents
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

                let ruleCount = rules.count

                for index in 0 ..< ruleCount {
                    let rule: BindViewWithRule = rules[rulesFilter[index].getValue()]

                    if rule.RULE.getValue() > 0 {
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

    override public func addView(view: UIView, params: inout LayoutParams) {
        super.addView(view: view, params: &params)

        view.uiViewExtension.layoutParams = params as! RelativeLayoutParams

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
        var params: LayoutParams = RelativeLayoutParams.generateDefaultParams()
        self.addView(view: view, params: &params)
    }
}
