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

import XCTest
import UIKit
import DZNEmptyDataSet
import DBEmptyState

class CollectionViewAdapterTest: XCTestCase {
    var collectionView: UICollectionView!
    var emptyDataSource: EmptyContentCollectionViewAdapter<EmptyStateMock>!
    var emptyContentDataSource: EmptyContentDataSourceMock!
    var stateManagingMock: StateManagingMock!
    
    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        emptyContentDataSource = EmptyContentDataSourceMock()
        stateManagingMock = StateManagingMock(state: .initial)
        emptyDataSource = EmptyContentCollectionViewAdapter(view: collectionView, stateManaging: stateManagingMock, dataSource: emptyContentDataSource)
    }
    
    func testInit() {
        //Given
        
        //When
        var didCallUpdate = false
        let emptyDataSource = EmptyContentCollectionViewAdapter(view: collectionView, stateManaging: stateManagingMock,
                                                                emptyContentDataSource: emptyContentDataSource,
                                                                customViewDataSource: emptyContentDataSource,
                                                                buttonDataSource: emptyContentDataSource, whenStateChanges: { _, _ in
                                                                    didCallUpdate = true
        })
        
        //Then
        XCTAssertNotNil(emptyDataSource.emptyContentDataSource)
        XCTAssertNotNil(emptyDataSource.customViewDataSource)
        XCTAssertNotNil(emptyDataSource.actionButtonDataSource)
        XCTAssertNotNil(collectionView.emptyDataSetSource)
        XCTAssertNotNil(stateManagingMock.callback)
        XCTAssert(didCallUpdate)
    }
    
    func testInit2() {
        //Given
        
        //When
        var didCallUpdate = false
        let emptyDataSource = EmptyContentCollectionViewAdapter(view: collectionView, stateManaging: stateManagingMock,
                                                                emptyContentDataSource: emptyContentDataSource,
                                                                customViewDataSource: emptyContentDataSource,
                                                                buttonDataSource: emptyContentDataSource, whenStateChanges: { _, _ in
                                                                    didCallUpdate = true
        })
        
        //Then
        XCTAssertNotNil(emptyDataSource.emptyContentDataSource)
        XCTAssertNotNil(emptyDataSource.customViewDataSource)
        XCTAssertNotNil(emptyDataSource.actionButtonDataSource)
        XCTAssertNotNil(collectionView.emptyDataSetSource)
        XCTAssertNotNil(stateManagingMock.callback)
        XCTAssert(didCallUpdate)
    }
    
    func testWhenStateChangesCallUpdate() {
        //Given
        var didCallUpdate = false
        let emptyDataSource = EmptyContentCollectionViewAdapter(view: collectionView, stateManaging: stateManagingMock,
                                                         emptyContentDataSource: emptyContentDataSource,
                                                         customViewDataSource: emptyContentDataSource,
                                                         buttonDataSource: emptyContentDataSource, whenStateChanges: { _, _ in
                                                            didCallUpdate = true
                                                            })
        
        //When
        stateManagingMock.callback?(.error)
        
        //Then
        XCTAssert(didCallUpdate)
    }
    
    func testPartialInitViewContentDataSource() {
        //Given
        
        //When
        let emptyDataSource = EmptyContentCollectionViewAdapter(view: collectionView, stateManaging: stateManagingMock,
                                                    emptyContentCustomViewDataSource: emptyContentDataSource)
        //Then
        XCTAssertNotNil(emptyDataSource.emptyContentDataSource)
        XCTAssertNotNil(emptyDataSource.customViewDataSource)
    }
    
    func testPartialInitContentDataSource() {
        //Given
        
        //When
        let emptyDataSource = EmptyContentCollectionViewAdapter(view: collectionView, stateManaging: stateManagingMock,
                                                    emptyContentDataSource: emptyContentDataSource)
        //Then
        XCTAssertNotNil(emptyDataSource.emptyContentDataSource)
    }
    
    func testAgainstMemoryLeaks() {
        //Given
        var emptyContentDataSource: EmptyContentDataSourceMock! = EmptyContentDataSourceMock()
        emptyContentDataSource?.memoryCheck = EmptyContentCollectionViewAdapter(view: collectionView,
                                                                         stateManaging: stateManagingMock, dataSource: emptyContentDataSource)
        weak var emptyDataSource = emptyContentDataSource?.memoryCheck
        
        //When
        emptyContentDataSource = nil
        
        //
        XCTAssertNil(emptyDataSource)
    }
    
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
    
    func testButonTitle() {
        //Given
        let button = ButtonModel(title: "Title", action: {})
        emptyContentDataSource.buttonReturning = button
        
        //When
        let returningTitle = emptyDataSource.buttonTitle(forEmptyDataSet: UIScrollView(frame: .zero), for: .normal)
        
        //Then
        XCTAssertEqual(returningTitle?.string, "Title")
    }
    
    func testButtonAction() {
        //Given
        var didCallAction = false
        let button = ButtonModel(title: "Title", action: { didCallAction = true })
        emptyContentDataSource.buttonReturning = button
        
        //When
        emptyDataSource.emptyDataSet( UIScrollView(frame: .zero), didTap: UIButton(frame: .zero))
        
        //Then
        XCTAssertTrue(didCallAction)
    }
}
