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
//  EmptyStateMachine.swift
//  EmptyCaseStates
//
//  Created by Lukas Schmidt on 20.03.17.
//

import Foundation

public class StateMachine: StateManaging {
    public typealias State = StateRepresenting
    var registrations: [(State) -> Void] = []
    public var state: StateRepresenting {
        return globalStateManaging?.state ?? internalState
    }
    
    var internalState: StateRepresenting {
        didSet { notify() }
    }
    let globalStateManaging: GlobalStateManaging?
    var observerToken: NSObjectProtocol?
    
    public init(initialState: State, globalStateManaging: GlobalStateManaging? = nil) {
        internalState = initialState
        self.globalStateManaging = globalStateManaging
        observerToken = globalStateManaging?.addObserver(execute: { [weak self] newState in
           self?.notify()
        })
    }
    
    deinit {
        observerToken.map { globalStateManaging?.removeObserver($0) }
    }
    
    public func transition(to newState: State) {
        internalState = newState
    }
    
    public func onChange(execute: @escaping (State) -> Void) {
        registrations.append(execute)
    }
    
    func notify() {
        registrations.forEach { $0(state) }
    }
}
