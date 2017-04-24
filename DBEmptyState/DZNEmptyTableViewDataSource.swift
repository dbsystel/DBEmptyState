//
//  EmptyStates.swift
//  Leichatletik
//
//  Created by Lukas Schmidt on 11.03.17.
//  Copyright © 2017 freiraum. All rights reserved.
//

import UIKit

open class DZNEmptyTableViewDataSource: NSObject {
    weak var tableView: DZNEmptyDisplayingTableView?
    weak var dataSource: EmptyContentDataSource?
    weak var retry: RetryProviding?
    weak var stateManaging: StateManaging?
    
    public init(tableView: DZNEmptyDisplayingTableView, stateManaging: StateManaging, dataSource: EmptyContentDataSource, retry: RetryProviding? = nil) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.retry = retry
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
        return dataSource?.emptyContent(for: state) ?? (state as? DefaultContentProviding)?.emptyContent
        
    }
    
//    open func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
//        if let buttonTitle = retry?.buttonTitle, retry?.shouldDisplayRetryButton ?? false {
//            return retry?.buttonTitleStyle(for: state).style(buttonTitle)
//        }
//        
//        return nil
//    }
    
}
