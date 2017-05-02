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
import DZNEmptyDataSet

open class GenericDZNTableViewAdapter<T: Equatable>: NSObject, DZNEmptyDataSetSource {
    let tableView: UITableView
    public var dataSource: AnyEmptyContentDataSource<T>?
    weak var retry: RetryProviding?
    let stateManaging: AnyStateManaging<T>
    
    public init<StateManager: StateManaging, EmptyContentData: EmptyContentDataSource & EmptyContentCustomViewDataSource>(tableView: UITableView, stateManaging: StateManager, dataSource: EmptyContentData, retry: RetryProviding? = nil) where StateManager.State == T, EmptyContentData.EmptyState == T {
        self.tableView = tableView
        self.dataSource = AnyEmptyContentDataSource(dataSource)
        self.retry = retry
        self.stateManaging = AnyStateManaging(stateManaging)
        super.init()
        tableView.emptyDataSetSource = self
        update()
        stateManaging.onChange(execute: { [weak self] _ in
            self?.update()
        })
    }
    
    open func update() {
        tableView.reloadEmptyDataSet()
        if tableView.isEmptyDataSetVisible {
            tableView.tableFooterView = UIView()
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    open func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return emptyContent()?.title.flatMap { dataSource?.titleStyle.style($0) }
    }
    
    open func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return emptyContent()?.subtitle.flatMap { dataSource?.subtitleStyle.style($0) }
    }
    
    open func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return emptyContent()?.image
    }
    
    open func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return dataSource?.customView(for: stateManaging.state)
    }
    
    func emptyContent() -> EmptyContent? {
        return dataSource?.emptyContent(for: stateManaging.state)
    }

    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        let top = scrollView.contentInset.top / 2
        let bottom = scrollView.contentInset.bottom / 2
        
        return top - bottom
    }
    
//    open func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
//        if let buttonTitle = retry?.buttonTitle, retry?.shouldDisplayRetryButton ?? false {
//            return retry?.buttonTitleStyle(for: state).style(buttonTitle)
//        }
//        
//        return nil
//    }
    
}

open class DZNTableViewAdapter: GenericDZNTableViewAdapter<EmptyState> {
    public override init<StateManager: StateManaging, EmptyContentData: EmptyContentDataSource & EmptyContentCustomViewDataSource>(tableView: UITableView, stateManaging: StateManager, dataSource: EmptyContentData, retry: RetryProviding? = nil) where StateManager.State == EmptyState, EmptyContentData.EmptyState == EmptyState {
        super.init(tableView: tableView, stateManaging: stateManaging, dataSource: dataSource, retry: retry)
    }
}

