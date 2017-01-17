//
// Created by 刘丰恺 on 2017/1/4.
// Copyright (c) 2017 ___FULL___. All rights reserved.
//

public enum Gravity: Int {
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