//
//  Copyright (C) 2017 Lukas Schmidt.
//
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//
//
//  RetryProviding.swift
//  EmptyCaseStates
//
//  Created by Lukas Schmidt on 20.03.17.
//

import UIKit

public struct ButtonModel {
    public let action: () -> Void
    public let title: String
}

public protocol ActionButtonDataSource: class {
    associatedtype EmptyState: Equatable
    
    func button(for state: EmptyState) -> ButtonModel?
    
    func buttonTitleStyle(for buttonState: UIControlState, with emptyState: EmptyState) -> StringStyle
    
}

extension ActionButtonDataSource {
    public func buttonTitleStyle(for buttonState: UIControlState, with emptyState: EmptyState) -> StringStyle {
        return .default
    }
}

public class AnyActionButtonDataSource<EmptyState: Equatable>: ActionButtonDataSource {
    private let butonFor: (EmptyState) -> ButtonModel?
    private let buttonTitleStyleFor: (UIControlState, EmptyState) -> StringStyle
    
    init<D: ActionButtonDataSource>(_ buttonActionProviding: D) where D.EmptyState == EmptyState {
        butonFor = buttonActionProviding.button
        buttonTitleStyleFor = buttonActionProviding.buttonTitleStyle
    }
    
    public func button(for state: EmptyState) -> ButtonModel? {
        return butonFor(state)
    }
    
    public func buttonTitleStyle(for buttonState: UIControlState, with emptyState: EmptyState) -> StringStyle {
        return buttonTitleStyleFor(buttonState, emptyState)
    }
}
