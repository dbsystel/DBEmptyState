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

extension EmptyScrollViewAdapter where View == UITableView {
    
    private static func updateTableViewOnChnage(newState: T, tableView: View) {
        if tableView.isEmptyDataSetVisible {
            tableView.tableFooterView = UIView()
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    public convenience init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource>
        (tableView: UITableView, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource)
        where StateManager.State == T, EmptyContentSource.EmptyState == T {
            self.init(view: tableView, stateManaging: stateManaging, emptyContentDataSource: emptyContentDataSource,
                      didChangeState: EmptyScrollViewAdapter.updateTableViewOnChnage)
    }
    
    public convenience init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource,
                CustomViewSource: CustomEmptyViewDataSource, ButtonDataSource: ActionButtonDataSource>
        (tableView: UITableView, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource,
         customViewDataSource: CustomViewSource, buttonDataSource: ButtonDataSource)
        where StateManager.State == T, EmptyContentSource.EmptyState == T, CustomViewSource.EmptyState == T, ButtonDataSource.EmptyState == T {
            self.init(view: tableView, stateManaging: stateManaging, emptyContentDataSource: emptyContentDataSource,
                       customViewDataSource: customViewDataSource, buttonDataSource: buttonDataSource,
                       didChangeState: EmptyScrollViewAdapter.updateTableViewOnChnage)
    }
    
    public convenience init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource & CustomEmptyViewDataSource>
        (tableView: UITableView, stateManaging: StateManager, emptyContentCustomViewDataSource: EmptyContentSource)
        where StateManager.State == T, EmptyContentSource.EmptyState == T {
            self.init(view: tableView, stateManaging: stateManaging, emptyContentCustomViewDataSource: emptyContentCustomViewDataSource,
                      didChangeState: EmptyScrollViewAdapter.updateTableViewOnChnage)
    }
    
    public convenience init<StateManager: StateManaging,
                EmptyContentData: EmptyContentDataSource & CustomEmptyViewDataSource & ActionButtonDataSource>
        (tableView: UITableView, stateManaging: StateManager, dataSource: EmptyContentData) where StateManager.State == T, EmptyContentData.EmptyState == T {
        self.init(view: tableView, stateManaging: stateManaging,
                   emptyContentDataSource: dataSource, customViewDataSource: dataSource, buttonDataSource: dataSource,
                   didChangeState: EmptyScrollViewAdapter.updateTableViewOnChnage)
    }

}

public typealias EmptyTableViewAdapter<T: Equatable> =  EmptyScrollViewAdapter<T, UITableView>
