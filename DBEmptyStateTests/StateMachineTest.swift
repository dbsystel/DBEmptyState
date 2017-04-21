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
//  StateMachineTest.swift
//  EmptyCaseStates
//
//  Created by Lukas Schmidt on 20.03.17.
//

import XCTest
@testable import DBEmptyState


enum DataEmptyState: StateRepresenting {
    case initial
    case empty
}

enum NetworkState: GlobalStateRepresenting {
    case noNetwork
    
    var rank: Int { return 1 }
}


class GlobalStateManagingMock: GlobalStateManaging {
    var state: GlobalStateManaging.State?
    var observer: ((State) -> Void)?
    
    func enter(newState: State) {
    }
    
    func leave(state: State) {
    }
    
    func addObserver(execute: @escaping (State) -> Void) -> NSObjectProtocol {
        observer = execute
        return "" as NSObjectProtocol
    }
    
    func removeObserver(_ observer: NSObjectProtocol) {
    }
}

class StateMachineTest: XCTestCase {
    
    var stateMachine: StateManaging!
    var globalStateManagingMock: GlobalStateManagingMock!
    
    override func setUp() {
        super.setUp()
        globalStateManagingMock = GlobalStateManagingMock()
        stateMachine = StateMachine(initialState: DataEmptyState.initial, globalStateManaging: globalStateManagingMock)
        XCTAssert(stateMachine.state.isSame(as: DataEmptyState.initial))
    }
    
    override func tearDown() {
        stateMachine = nil
        super.tearDown()
    }

    func testWhenStateChanges_CorrectEvent() {
        //Given
        var newState: StateRepresenting?
        let whenStateChanges = {(int: StateRepresenting) in
            newState = int
        }
        stateMachine.on(DataEmptyState.initial, execute: whenStateChanges)
        
        //When
        stateMachine.transition(to: DataEmptyState.initial)
        
        //Then
        XCTAssert(newState?.isSame(as: DataEmptyState.initial) ?? false)
        XCTAssert(stateMachine.state.isSame(as: DataEmptyState.initial))
    }
    
    func testWhenGlobalStateChanges_CorrectEvent() {
        //Given
        var newState: StateRepresenting?
        let whenStateChanges = {(int: StateRepresenting) in
            newState = int
        }
        stateMachine.on(NetworkState.noNetwork, execute: whenStateChanges)
        
        //When
        globalStateManagingMock.state = NetworkState.noNetwork
        globalStateManagingMock.observer?(NetworkState.noNetwork)
        
        //Then
        XCTAssert(newState?.isSame(as: NetworkState.noNetwork) ?? false)
        XCTAssert(stateMachine.state.isSame(as: NetworkState.noNetwork))
    }
    
    func testWhenStateChanges_withoutTheCorrectEvent() {
        //Given
        var newState: StateRepresenting?
        let whenStateChanges = {(int: StateRepresenting) in
            newState = int
        }
        stateMachine.on(DataEmptyState.initial, execute: whenStateChanges)
        
        //When
        stateMachine.transition(to: DataEmptyState.empty)
        
        //Then
        XCTAssertNil(newState)
    }
    
    func testWhenGlobalStateIaAvailabe() {
        //Given
        let newState = DataEmptyState.empty
        globalStateManagingMock.state = NetworkState.noNetwork
        
        //When
        stateMachine.transition(to: newState)
        
        //Then
        XCTAssert(stateMachine.state.isSame(as: NetworkState.noNetwork))
    }
}
