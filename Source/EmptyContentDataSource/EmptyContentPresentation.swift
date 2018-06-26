//
//  PresentationDelegate.swift
//  DBEmptyState
//
//  Created by Dennis Post on 26.06.18.
//  Copyright © 2018 DBSystel. All rights reserved.
//

import Foundation

public protocol EmptyContentPresentation: class {
    associatedtype EmptyState: Equatable
    
    func shouldAllowTouch(for state: EmptyState) -> Bool?
    func shouldAllowScroll(for state: EmptyState) -> Bool?
    func shouldAllowImageViewAnimate(for state: EmptyState) -> Bool?
}

extension EmptyContentPresentation {
    
    public func shouldAllowTouch(for state: EmptyState) -> Bool? {
        return false
    }
    
    public func shouldAllowScroll(for state: EmptyState) -> Bool? {
        return false
    }
    
    public func shouldAllowImageViewAnimate(for state: EmptyState) -> Bool? {
        return false
    }
}
