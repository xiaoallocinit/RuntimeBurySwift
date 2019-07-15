//
//  XZB.swift
//  RuntimePageTimes
//
//  Created by 🍎上的豌豆 on 2019/7/14.
//  Copyright © 2019 xiao. All rights reserved.
//

import Foundation

public struct XZB<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol XZBCompatible {
    
    associatedtype CompatibleType
    
    static var xzb: XZB<CompatibleType>.Type { get }
    
    var xzb: XZB<CompatibleType> { get }
}

extension XZBCompatible {
    public static var xzb: XZB<Self>.Type {
        get {
            return XZB<Self>.self
        }
    }
    
    public var xzb: XZB<Self> {
        get {
            return XZB(self)
        }
    }
}

import class Foundation.NSObject

extension NSObject: XZBCompatible { }
