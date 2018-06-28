//
//  AnyEmptyContentPresentation.swift
//  DBEmptyState
//
//  Created by Dennis Post on 26.06.18.
//  Copyright © 2018 DBSystel. All rights reserved.
//

public class AnyEmptyContentPresentation<EmptyState: Equatable>: EmptyContentPresentationDelegate {
    
    private let shouldAllowTouch: (EmptyState) -> Bool?
    private let shouldAllowScroll: (EmptyState) -> Bool?
    private let shouldAllowImageViewAnimate: (EmptyState) -> Bool?
    
    public init<D: EmptyContentPresentationDelegate>(_ emptyContentPresentationDelegate: D) where D.EmptyState == EmptyState {
        unowned let weakEmptyContentPresentationDelegate = emptyContentPresentationDelegate
        shouldAllowTouch = { weakEmptyContentPresentationDelegate.shouldAllowTouch(for: $0) }
        shouldAllowScroll = { weakEmptyContentPresentationDelegate.shouldAllowScroll(for: $0) }
        shouldAllowImageViewAnimate = { weakEmptyContentPresentationDelegate.shouldAllowImageViewAnimate(for: $0) }
    }
    
    public func shouldAllowScroll(for state: EmptyState) -> Bool? {
        return shouldAllowScroll(state)
    }
    
    public func shouldAllowTouch(for state: EmptyState) -> Bool? {
        return shouldAllowTouch(state)
    }
    
    public func shouldAllowImageViewAnimate(for state: EmptyState) -> Bool? {
        return shouldAllowImageViewAnimate(state)
    }
}
