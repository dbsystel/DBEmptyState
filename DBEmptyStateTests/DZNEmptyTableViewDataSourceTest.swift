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
import UIKit
import DZNEmptyDataSet
@testable import DBEmptyState

class EmptyContentDataSourceMock: EmptyContentDataSource, CustomEmptyViewDataSource, ActionButtonDataSource {
    var memoryCheck: EmptyTableViewAdapter<EmptyStateMock>?
    var emptyContentReturning: EmptyContent?
    var customViewReturning: UIView?
    var capturedState: EmptyStateMock?
    
    func emptyContent(for state: EmptyStateMock) -> EmptyContent? {
        capturedState = state
        return emptyContentReturning
    }
    
    func customView(for state: EmptyStateMock, with content: EmptyContent) -> UIView? {
        return customViewReturning
    }
    
    func button(for state: EmptyStateMock) -> ButtonModel? {
        return nil
    }
}

class StateManagingMock: StateManaging {
    
    var callback: ((EmptyStateMock) -> Void)?
    
    init(state: EmptyStateMock) {
        self.state = state
    }
    
    var state: EmptyStateMock
    
    func onChange(execute: @escaping (EmptyStateMock) -> Void) {
        callback = execute
    }
}

class DZNEmptyTableViewDataSourceTest: XCTestCase {
    var tableView: UITableView!
    var emptyDataSource: EmptyTableViewAdapter<EmptyStateMock>!
    var emptyContentDataSource: EmptyContentDataSourceMock!
    var stateManagingMock: StateManagingMock!
    
    override func setUp() {
        super.setUp()
        tableView = UITableView()
        emptyContentDataSource = EmptyContentDataSourceMock()
        stateManagingMock = StateManagingMock(state: .initial)
        emptyDataSource = EmptyTableViewAdapter(tableView: tableView, stateManaging: stateManagingMock, dataSource: emptyContentDataSource)
    }
    
    func testInit() {
        //Given
        let tableView = UITableView()
        
        //When
        let emptyDataSource = EmptyTableViewAdapter(tableView: tableView, stateManaging: stateManagingMock, dataSource: emptyContentDataSource)
        
        //Then
        XCTAssertNotNil(emptyDataSource.tableView)
        XCTAssertNotNil(emptyDataSource.dataSource)
        XCTAssertNotNil(emptyDataSource.stateManaging)
    }
    
    func testAgainstMemoryLeaks() {
        //Given
        let tableView = UITableView()
        var emptyContentDataSource: EmptyContentDataSourceMock? = EmptyContentDataSourceMock()
        emptyContentDataSource?.memoryCheck = EmptyTableViewAdapter(tableView: tableView, stateManaging: stateManagingMock, dataSource: emptyContentDataSource!)
        weak var emptyDataSource = emptyContentDataSource?.memoryCheck
        
        //When
        emptyContentDataSource = nil
        
        //
        XCTAssertNil(emptyDataSource)
        
    }

//    func testUpdateWithVisibileEmptyDataSet() {
//        //Given
//        tableView.isEmptyDataSetVisible = true
//        
//        //When
//        stateManagingMock.callback?(.error)
//        
//        //Then
//        XCTAssertEqual(tableView.reloadCount, 1)
//        XCTAssertNotNil(tableView.tableFooterView)
//    }
//
//    func testUpdateWithoutVisibileEmptyDataSet() {
//        //Given
//        tableView.isEmptyDataSetVisible = false
//        
//        //When
//        stateManagingMock.callback?(.error)
//        
//        //Then
//        XCTAssertEqual(tableView.reloadCount, 1)
//        XCTAssertNil(tableView.tableFooterView)
//    }

    func testTitle() {
        //Given
        emptyContentDataSource.emptyContentReturning = EmptyContent(title: "Title")
        stateManagingMock.state = .error
        
        //When
        let title = emptyDataSource.title(forEmptyDataSet: UIScrollView(frame: .zero))
        
        //Then
        XCTAssertEqual(title?.string, "Title")
        XCTAssertEqual(emptyContentDataSource.capturedState, .error)
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
        emptyContentDataSource.emptyContentReturning = .customPresentation
        
        //When
        let returningView = emptyDataSource.customView(forEmptyDataSet: UIScrollView(frame: .zero))
        
        //Then
        XCTAssertEqual(view, returningView)
    }
}
