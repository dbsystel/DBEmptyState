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

import XCTest
@testable import DBEmptyState

class EmptyContentDataSourceMock: EmptyContentDataSource {
    var emptyContentReturning: EmptyContent?
    var customViewReturning: UIView?
    var capturedState: StateRepresenting?
    
    func emptyContent(for state: StateRepresenting) -> EmptyContent? {
        capturedState = state
        return emptyContentReturning
    }
    
    func customView() -> UIView? {
        return customViewReturning
    }
}

class StateManagingMock: StateManaging {
    
    var callback: ((StateManaging.State) -> Void)?
    
    init(state: StateManaging.State) {
        self.state = state
    }
    
    var state: StateManaging.State
    func transition(to newState: StateManaging.State) {
        
    }
    func onChange(execute: @escaping (StateManaging.State) -> Void) {
        callback = execute
    }
}

enum MockState: StateRepresenting {
    case initial
    case empty
}

class DZNEmptyTableViewDataSourceTest: XCTestCase {
    var tableView: DZNEmptyDisplayingTableViewMock!
    var emptyDataSource: DZNEmptyTableViewDataSource!
    var emptyContentDataSource: EmptyContentDataSourceMock!
    var stateManagingMock: StateManagingMock!
    
    override func setUp() {
        super.setUp()
        tableView = DZNEmptyDisplayingTableViewMock()
        emptyContentDataSource = EmptyContentDataSourceMock()
        stateManagingMock = StateManagingMock(state: MockState.initial)
        emptyDataSource = DZNEmptyTableViewDataSource(tableView: tableView, stateManaging: stateManagingMock, dataSource: emptyContentDataSource)
    }
    
    func testInit() {
        //Given
        let tableView = DZNEmptyDisplayingTableViewMock()
        
        //When
        let emptyDataSource = DZNEmptyTableViewDataSource(tableView: tableView, stateManaging: stateManagingMock, dataSource: emptyContentDataSource)
        
        //Then
        XCTAssertNotNil(emptyDataSource.tableView)
        XCTAssertNotNil(emptyDataSource.dataSource)
        XCTAssertNotNil(emptyDataSource.stateManaging)
    }
    
    func testUpdateWithVisibileEmptyDataSet() {
        //Given
        tableView.isEmptyDataSetVisible = true
        
        //When
        stateManagingMock.callback?(MockState.empty)
        
        //Then
        XCTAssertEqual(tableView.reloadCount, 1)
        XCTAssertNotNil(tableView.tableFooterView)
    }
    
    func testUpdateWithoutVisibileEmptyDataSet() {
        //Given
        tableView.isEmptyDataSetVisible = false
        
        //When
        stateManagingMock.callback?(MockState.empty)
        
        //Then
        XCTAssertEqual(tableView.reloadCount, 1)
        XCTAssertNil(tableView.tableFooterView)
    }
    
    func testTitle() {
        //Given
        emptyContentDataSource.emptyContentReturning = EmptyContent(title: "Title")
        stateManagingMock.state = MockState.empty
        
        //When
        let title = emptyDataSource.title(forEmptyDataSet: UIScrollView(frame: .zero))
        
        //Then
        XCTAssertEqual(title?.string, "Title")
        XCTAssert(emptyContentDataSource.capturedState?.isSame(as: MockState.empty) ?? false)
    }
    
    func testSubtitle() {
        //Given
        emptyContentDataSource.emptyContentReturning = EmptyContent(subtitle: "Title")
        
        //When
        let subtitle = emptyDataSource.description(forEmptyDataSet: UIScrollView(frame: .zero))
        
        //Then
        XCTAssertEqual(subtitle?.string, "Title")
    }
    
    func testImage() {
        //Given
        let image = UIImage()
        emptyContentDataSource.emptyContentReturning = EmptyContent(image: image)
        
        //When
        let returningImage = emptyDataSource.image(forEmptyDataSet: UIScrollView(frame: .zero))
        
        //Then
        XCTAssertEqual(image, returningImage)
    }
    
    func testCustomView() {
        //Given
        let view = UIView()
        emptyContentDataSource.customViewReturning = view
        
        //When
        let returningView = emptyDataSource.customView(forEmptyDataSet: UIScrollView(frame: .zero))
        
        //Then
        XCTAssertEqual(view, returningView)
    }
}
