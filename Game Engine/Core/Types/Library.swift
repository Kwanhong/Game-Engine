//
//  Library.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/18.
//

import Foundation

protocol Library {
    
    func initialize()
    
}

class EmptyLibrary: Library {
    
    func initialize() { }
    
}

class GenericLibrary<T: Hashable, K: NSObjectProtocol>: Library {
    
    internal var library: [T: K] = [:]
    
    init() {
        initialize()
    }
    
    internal func initialize() { }
    
    subscript(_ type: T)->K {
        return library[type]!
    }
    
}
