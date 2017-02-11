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

public struct UIViewExtension {
    public var padding: Padding
    internal var layoutParams: LayoutParams
    internal init(padding: Padding, params: LayoutParams) {
        self.padding = padding
        self.layoutParams = params
    }

    internal init() {
        self.padding = Padding()
        self.layoutParams = LayoutParams.generateDefaultLayoutParams()
    }
    
    public mutating func setLayoutParams(params: LayoutParams) {
        params.bindWith(view:layoutParams.bindView)
        self.layoutParams = params
    }
}

extension UIView: ExtensionParams {

    private struct Key {
        static var ExtensionKey = "ExtensionKey"
    }

    public var uiViewExtension: UIViewExtension {
        set {
            objc_setAssociatedObject(self, &Key.ExtensionKey,
                    newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            if let el = objc_getAssociatedObject(self, &Key.ExtensionKey) as? UIViewExtension {
                return el
            }
            let el = UIViewExtension()
            objc_setAssociatedObject(self, &Key.ExtensionKey,
                    el, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return el
        }
    }

    public func setLayoutParams(params: LayoutParams) {
        uiViewExtension.layoutParams = params
    }

    public func getLayoutParams() -> LayoutParams {
        return uiViewExtension.layoutParams
    }

    public func setPadding(top: CGFloat, left: CGFloat, right: CGFloat, bottom: CGFloat) {
        self.uiViewExtension.padding = Padding(top: top, left: left, right: right, bottom: bottom)
    }
}

extension UIView {

    private struct IdKey {
        static var ExtensionKey = "IdExtensionKey"
    }

    private static var atomicInteger = 1

    public class InnerInteger {
        let viewId: Int

        init(_ id: Int) {
            viewId = id
        }

        public static func ==(_ a: InnerInteger, _ b: InnerInteger) -> Bool {
            if a.viewId == b.viewId {
                return true
            }
            return false
        }
    }

    private var viewId: InnerInteger {
        set {
            objc_setAssociatedObject(self, &IdKey.ExtensionKey,
                    newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            if let el = objc_getAssociatedObject(self, &IdKey.ExtensionKey) as? InnerInteger {
                return el
            }
            let el = InnerInteger(-1)
            objc_setAssociatedObject(self, &IdKey.ExtensionKey,
                    el, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return el
        }
    }

    public static func generateViewId() -> Int {
        objc_sync_enter(atomicInteger)
        atomicInteger += 1
        objc_sync_exit(atomicInteger)
        return Int(atomicInteger)
    }

    public func setViewId(id: Int) {
        viewId = InnerInteger(id)
    }

    public func getViewId() -> InnerInteger {
        return viewId
    }
}
