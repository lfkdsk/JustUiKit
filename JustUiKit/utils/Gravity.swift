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


public enum Gravity: Int {
    static let VERTICAL_GRAVITY_MASK = 112
    static let HORIZONTAL_GRAVITY_MASK = 7

    case NO_GRAVITY = 0
    case TOP = 48
    case BOTTOM = 80
    case LEFT = 3
    case RIGHT = 5
    case CENTER_VERTICAL = 16
    case CENTER_HORIZONTAL = 1
    case CENTER = 17

    public static func |(left: Gravity, right: Gravity) -> Int {
        return left.getValue() | right.getValue()
    }

    public func getValue() -> Int {
        return rawValue
    }

}