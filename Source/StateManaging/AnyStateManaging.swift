//
//  Copyright (C) DB Systel GmbH.
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


import Foundation

public class AnyStateManaging<State: Equatable>: StateManaging {
    private let getState: () -> State
    private let setState: (State) -> Void
    
    private let registerOn: (State, @escaping (State) -> Void) -> Void
    private let registerOnChange: (@escaping (State) -> Void) -> Void
    
    init<T: StateManaging>(_ stateManaging: T) where T.State == State {
        self.getState = { stateManaging.state }
        self.setState = { stateManaging.state = $0 }
        
        registerOn = { stateManaging.on($0, execute: $1) }
        registerOnChange = { stateManaging.onChange(execute: $0) }
    }
    
    public var state: State {
        get { return getState() }
        set { setState(newValue) }
    }
    
    public func onChange(execute: @escaping (State) -> Void) {
        registerOnChange(execute)
    }
    
    public func on(_ event: State, execute: @escaping (State) -> Void) {
        registerOn(event, execute)
    }
}
