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


public class Gravity {
    static let VERTICAL_GRAVITY_MASK = 112
    static let HORIZONTAL_GRAVITY_MASK = 7

    fileprivate static let NO_GRAVITY_V = 0
    fileprivate static let TOP_V = 48
    fileprivate static let BOTTOM_V = 80
    fileprivate static let LEFT_V = 3
    fileprivate static let RIGHT_V = 5
    fileprivate static let CENTER_VERTICAL_V = 16
    fileprivate static let CENTER_HORIZONTAL_V = 1
    fileprivate static let CENTER_V = 17

    public static let NO_GRAVITY = Gravity(value: NO_GRAVITY_V)
    public static let TOP = Gravity(value: TOP_V)
    public static let BOTTOM = Gravity(value: BOTTOM_V)
    public static let LEFT = Gravity(value: LEFT_V)
    public static let RIGHT = Gravity(value: RIGHT_V)
    public static let CENTER_VERTICAL = Gravity(value: CENTER_VERTICAL_V)
    public static let CENTER_HORIZONTAL = Gravity(value: CENTER_HORIZONTAL_V)
    public static let CENTER = Gravity(value: CENTER_V)

    fileprivate var value: Int = NO_GRAVITY.getValue()

    public init(value: Int) {
        self.value = value
    }

    public static func |(left: Gravity, right: Gravity) -> Gravity {
        return Gravity(value: left.getValue() | right.getValue())
    }

    public static func getHorizontalGravity(gravity: Gravity) -> Int {
        return gravity.getValue() & HORIZONTAL_GRAVITY_MASK
    }

    public static func getVerticalGravity(gravity: Gravity) -> Int {
        return gravity.getValue() & VERTICAL_GRAVITY_MASK
    }

    public func getValue() -> Int {
        return value
    }

}