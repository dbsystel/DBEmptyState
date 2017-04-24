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

open class DZNEmptyTableViewDataSource: NSObject {
    weak var tableView: DZNEmptyDisplayingTableView?
    public weak var dataSource: EmptyContentDataSource?
    weak var retry: RetryProviding?
    weak var stateManaging: StateManaging?
    
    public init(tableView: DZNEmptyDisplayingTableView, stateManaging: StateManaging, dataSource: EmptyContentDataSource, retry: RetryProviding? = nil) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.retry = retry
        self.stateManaging = stateManaging
        super.init()
        stateManaging.onChange(execute: { [weak self] _ in
            self?.update()
        })
    }
    
    open func update() {
        tableView?.reloadEmptyDataSet()
        if tableView?.isEmptyDataSetVisible ?? false {
            tableView?.tableFooterView = UIView()
        } else {
            tableView?.tableFooterView = nil
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
        return dataSource?.customView()
    }
    
    func emptyContent() -> EmptyContent? {
        guard let state = stateManaging?.state else {
            return nil
        }
        return dataSource?.emptyContent(for: state)
    }
    
//    open func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
//        if let buttonTitle = retry?.buttonTitle, retry?.shouldDisplayRetryButton ?? false {
//            return retry?.buttonTitleStyle(for: state).style(buttonTitle)
//        }
//        
//        return nil
//    }
    
}
