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

class StateMachineTest: XCTestCase {
    
    var stateMachine: AnyStateManaging<EmptyStateMock>!
    
    override func setUp() {
        super.setUp()
        stateMachine = AnyStateManaging(StateMachine(initialState: .initial))
    }
    
    override func tearDown() {
        stateMachine = nil
        super.tearDown()
    }

    func testWhenStateChanges_CorrectEvent() {
        //Given
        var newState: EmptyStateMock?
        let whenStateChanges = {(int: EmptyStateMock) in
            newState = int
        }
        stateMachine.on(.initial, execute: whenStateChanges)
        
        //When
        stateMachine.state = .initial
        
        //Then
        XCTAssertEqual(newState, .initial)
        XCTAssertEqual(stateMachine.state, .initial)
    }
    
    
    func testWhenStateChanges_withoutTheCorrectEvent() {
        //Given
        var newState: EmptyStateMock?
        let whenStateChanges = {(int: EmptyStateMock) in
            newState = int
        }
        stateMachine.on(.initial, execute: whenStateChanges)
        
        //When
        stateMachine.state = .error
        
        //Then
        XCTAssertNil(newState)
    }
    
    func testOnChange() {
        //Given
        var newState: EmptyStateMock?
        let whenStateChanges = {(int: EmptyStateMock) in
            newState = int
        }
        stateMachine.onChange(execute: whenStateChanges)
        
        //When
        stateMachine.state = .initial
        
        //Then
        XCTAssertEqual(newState, .initial)
        XCTAssertEqual(stateMachine.state, .initial)
    }
}
