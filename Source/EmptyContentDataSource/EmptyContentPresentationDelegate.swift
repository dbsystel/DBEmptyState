//
//  PresentationDelegate.swift
//  DBEmptyState
//
//  Created by Dennis Post on 26.06.18.
//  Copyright © 2018 DBSystel. All rights reserved.
//

import Foundation

public protocol EmptyContentPresentationDelegate: class {
    associatedtype EmptyState: Equatable
    
    func shouldAllowTouch(for state: EmptyState) -> Bool
    func shouldAllowScroll(for state: EmptyState) -> Bool
    func shouldAllowImageViewAnimate(for state: EmptyState) -> Bool
}

extension EmptyContentPresentationDelegate {
    
    public func shouldAllowTouch(for state: EmptyState) -> Bool {
        return true
    }
    
    public func shouldAllowScroll(for state: EmptyState) -> Bool {
        return false
    }
    
    public func shouldAllowImageViewAnimate(for state: EmptyState) -> Bool {
        return false
    }
}
