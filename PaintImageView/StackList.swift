//
//  StackList.swift
//  PaintImageView
//
//  Created by ios on 2018/7/31.
//  Copyright © 2018年 ios. All rights reserved.
//

import Foundation
import UIKit
class StackList<T> {
    public var array:[T]
    var isEmpty:Bool {
        return array.isEmpty
    }
    var top:T? {
       return self.array.last
    }
    
    var count:Int {
        return self.array.count
    }
    init() {
        self.array = [T]()
    }
    
    func push(_ newElement:T) {
        array.append(newElement    )
    }
    
    @discardableResult
    func pop() -> T? {
       return array.removeLast()
    }
    
}
