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


open class EmptyTableViewAdapter<T: Equatable>: NSObject, DZNEmptyDataSetSource {
    public var dataSource: AnyEmptyContentDataSource<T>?
    public var customViewDataSource: AnyCustomEmptyViewDataSource<T>?
    public var actionButtonDataSource: AnyActionButtonDataSource<T>?
    
    let tableView: UITableView
    let stateManaging: AnyStateManaging<T>
    
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource, CustomViewSource: CustomEmptyViewDataSource, ButtonDataSource: ActionButtonDataSource>
        (tableView: UITableView, stateManaging: StateManager, dataSource: EmptyContentSource?, customViewDataSource: CustomViewSource? = nil, buttonDataSource: ButtonDataSource? = nil)
            where StateManager.State == T, EmptyContentSource.EmptyState == T, CustomViewSource.EmptyState == T, ButtonDataSource.EmptyState == T {
        self.tableView = tableView
        self.dataSource = dataSource.map { AnyEmptyContentDataSource($0) }
        self.customViewDataSource = customViewDataSource.map { AnyCustomEmptyViewDataSource($0) }
        self.actionButtonDataSource = buttonDataSource.map { AnyActionButtonDataSource($0) }
        self.stateManaging = AnyStateManaging(stateManaging)
        super.init()
        tableView.emptyDataSetSource = self
        update()
        stateManaging.onChange(execute: { [weak self] _ in
            self?.update()
        })
    }
    
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource>
        (tableView: UITableView, stateManaging: StateManager, dataSource: EmptyContentSource?)
        where StateManager.State == T, EmptyContentSource.EmptyState == T {
            self.tableView = tableView
            self.dataSource = dataSource.map { AnyEmptyContentDataSource($0) }
            self.customViewDataSource = nil
            self.actionButtonDataSource = nil
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
        guard let emptyContent = emptyContent() else {
            return nil
        }
        return customViewDataSource?.customView(for: stateManaging.state, with: emptyContent)
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

extension EmptyTableViewAdapter {
    public convenience init<StateManager: StateManaging, EmptyContentData: EmptyContentDataSource & CustomEmptyViewDataSource, ButtonDataSource: ActionButtonDataSource>(tableView: UITableView, stateManaging: StateManager, dataSource: EmptyContentData, buttonDataSource: ButtonDataSource? = nil) where StateManager.State == T, EmptyContentData.EmptyState == T, ButtonDataSource.EmptyState == T  {
        self.init(tableView: tableView, stateManaging: stateManaging, dataSource: dataSource, customViewDataSource: dataSource, buttonDataSource: buttonDataSource)
    }
    
    public convenience init<StateManager: StateManaging, EmptyContentData: EmptyContentDataSource & CustomEmptyViewDataSource & ActionButtonDataSource>(tableView: UITableView, stateManaging: StateManager, dataSource: EmptyContentData) where StateManager.State == T, EmptyContentData.EmptyState == T  {
        self.init(tableView: tableView, stateManaging: stateManaging, dataSource: dataSource, customViewDataSource: dataSource, buttonDataSource: dataSource)
    }

}


