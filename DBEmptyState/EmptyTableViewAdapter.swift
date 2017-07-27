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

import UIKit

extension EmptyContentScrollViewAdapter where View == UITableView {
    
    private static func updateTableViewOnChnage(newState: T, tableView: View) {
        if tableView.isEmptyDataSetVisible {
            tableView.tableFooterView = UIView()
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    /**
     Creates an EmptyScrollViewAdapter instance witch display empty content inside a tableView. Cell skeletons will be hidden, when empty state is visible.
     
     - parameter tableView: the tableView to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentDataSource: dataSource which provides the empty content.
     */
    public convenience init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource>
        (tableView: UITableView, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource)
        where StateManager.State == T, EmptyContentSource.EmptyState == T {
            self.init(view: tableView, stateManaging: stateManaging, emptyContentDataSource: emptyContentDataSource,
                      didChangeState: EmptyContentScrollViewAdapter.updateTableViewOnChnage)
    }
    
    /**
     Creates an EmptyScrollViewAdapter instance witch display empty content inside a tableView. Cell skeletons will be hidden, when empty state is visible.
     
     - parameter tableView: the tableView to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentDataSource: dataSource which provides the empty content.
     - parameter customViewDataSource: dataSource which custom empty state views.
     - parameter buttonDataSource: dataSource which provides button & actions for specific empty states.
     */
    public convenience init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource,
                CustomViewSource: CustomEmptyViewDataSource, ButtonDataSource: ActionButtonDataSource>
        (tableView: UITableView, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource,
         customViewDataSource: CustomViewSource, buttonDataSource: ButtonDataSource)
        where StateManager.State == T, EmptyContentSource.EmptyState == T, CustomViewSource.EmptyState == T, ButtonDataSource.EmptyState == T {
            self.init(view: tableView, stateManaging: stateManaging, emptyContentDataSource: emptyContentDataSource,
                       customViewDataSource: customViewDataSource, buttonDataSource: buttonDataSource,
                       didChangeState: EmptyContentScrollViewAdapter.updateTableViewOnChnage)
    }
    
    /**
     Creates an EmptyScrollViewAdapter instance witch display empty content inside a tableView. Cell skeletons will be hidden, when empty state is visible.
     
     - parameter tableView: the tableView to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentCustomViewDataSource: dataSource which provides the empty content & custom empty state views.
     */
    public convenience init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource & CustomEmptyViewDataSource>
        (tableView: UITableView, stateManaging: StateManager, emptyContentCustomViewDataSource: EmptyContentSource)
        where StateManager.State == T, EmptyContentSource.EmptyState == T {
            self.init(view: tableView, stateManaging: stateManaging, emptyContentCustomViewDataSource: emptyContentCustomViewDataSource,
                      didChangeState: EmptyContentScrollViewAdapter.updateTableViewOnChnage)
    }
    
    /**
     Creates an EmptyScrollViewAdapter instance witch display empty content inside a tableView. Cell skeletons will be hidden, when empty state is visible.
     
     - parameter tableView: the tableView to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentCustomViewDataSource: dataSource which provides the empty content,
        custom empty state views and button & actions for specific empty states.
     */
    public convenience init<StateManager: StateManaging,
                EmptyContentData: EmptyContentDataSource & CustomEmptyViewDataSource & ActionButtonDataSource>
        (tableView: UITableView, stateManaging: StateManager, dataSource: EmptyContentData) where StateManager.State == T, EmptyContentData.EmptyState == T {
        self.init(view: tableView, stateManaging: stateManaging,
                   emptyContentDataSource: dataSource, customViewDataSource: dataSource, buttonDataSource: dataSource,
                   didChangeState: EmptyContentScrollViewAdapter.updateTableViewOnChnage)
    }

}

public typealias EmptyContentTableViewAdapter<T: Equatable> =  EmptyContentScrollViewAdapter<T, UITableView>
