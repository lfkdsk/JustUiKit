//
// Created by 刘丰恺 on 2017/1/24.
// Copyright (c) 2017 ___FULL___. All rights reserved.
//

import Foundation

public class ReleasePool<T> {
    var releasePool: Array = Array<T>()

    public func acquire() -> T? {
        if releasePool.count > 0 {
            let obj = releasePool.removeLast()
            return obj
        }
        return nil
    }

    public func release(instance: T) {
        releasePool.append(instance)
    }
}