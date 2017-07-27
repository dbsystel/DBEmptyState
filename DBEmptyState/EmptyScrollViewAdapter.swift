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

open class EmptyContentScrollViewAdapter<T: Equatable, View: UIScrollView>: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    public var emptyContentDataSource: AnyEmptyContentDataSource<T>?
    public var customViewDataSource: AnyCustomEmptyViewDataSource<T>?
    public var actionButtonDataSource: AnyActionButtonDataSource<T>?
    
    let view: View
    let stateManaging: AnyStateManaging<T>
    let didChangeState: ((T, View) -> Void)?
    
    /**
     Creates an EmptyScrollViewAdapter instance witch display empty content inside a scrollView subclasses.
     
     - parameter tableView: the tableView to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentDataSource: dataSource which provides the empty content.
     - parameter customViewDataSource: dataSource which custom empty state views.
     - parameter buttonDataSource: dataSource which provides button & actions for specific empty states.
     - parameter didChangeState: handle a state change. One can hide or display specific view elements on this event.
     */
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource,
                CustomViewSource: CustomEmptyViewDataSource, ButtonDataSource: ActionButtonDataSource>
        (view: View, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource,
         customViewDataSource: CustomViewSource, buttonDataSource: ButtonDataSource, didChangeState: ((T, View) -> Void)? = nil)
        where StateManager.State == T, EmptyContentSource.EmptyState == T, CustomViewSource.EmptyState == T, ButtonDataSource.EmptyState == T {
            self.view = view
            self.emptyContentDataSource = AnyEmptyContentDataSource(emptyContentDataSource)
            self.customViewDataSource = AnyCustomEmptyViewDataSource(customViewDataSource)
            self.actionButtonDataSource = AnyActionButtonDataSource(buttonDataSource)
            self.stateManaging = AnyStateManaging(stateManaging)
            self.didChangeState = didChangeState
            super.init()
            setup()
    }
    
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource & CustomEmptyViewDataSource>
        (view: View, stateManaging: StateManager, emptyContentCustomViewDataSource: EmptyContentSource, didChangeState: ((T, View) -> Void)? = nil)
        where StateManager.State == T, EmptyContentSource.EmptyState == T {
            self.view = view
            self.emptyContentDataSource = AnyEmptyContentDataSource(emptyContentCustomViewDataSource)
            self.customViewDataSource = AnyCustomEmptyViewDataSource(emptyContentCustomViewDataSource)
            self.stateManaging = AnyStateManaging(stateManaging)
            self.didChangeState = didChangeState
            super.init()
            setup()
    }
    
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource>
        (view: View, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource, didChangeState: ((T, View) -> Void)? = nil)
        where StateManager.State == T, EmptyContentSource.EmptyState == T {
            self.view = view
            self.emptyContentDataSource = AnyEmptyContentDataSource(emptyContentDataSource)
            self.stateManaging = AnyStateManaging(stateManaging)
            self.didChangeState = didChangeState
            super.init()
            setup()
    }
    
    public convenience init<StateManager: StateManaging, EmptyContentData: EmptyContentDataSource &
        CustomEmptyViewDataSource & ActionButtonDataSource>(view: View, stateManaging: StateManager,
                dataSource: EmptyContentData, didChangeState: ((T, View) -> Void)? = nil)
        where StateManager.State == T, EmptyContentData.EmptyState == T {
            self.init(view: view, stateManaging: stateManaging, emptyContentDataSource: dataSource,
                      customViewDataSource: dataSource, buttonDataSource: dataSource, didChangeState: didChangeState)
        }
    
    private func setup() {
        view.emptyDataSetSource = self
        update()
        stateManaging.onChange(execute: { [weak self] newState in
            guard let strongSelf = self else {
                return
            }
            self?.update()
            self?.didChangeState?(newState, strongSelf.view)
        })
    }
    
    open func update() {
        view.reloadEmptyDataSet()
    }
    
    open func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return emptyContent()?.title.flatMap { emptyContentDataSource?.titleStyle.style($0) }
    }
    
    open func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return emptyContent()?.subtitle.flatMap { emptyContentDataSource?.subtitleStyle.style($0) }
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
    
    private func emptyContent() -> EmptyContent? {
        return emptyContentDataSource?.emptyContent(for: stateManaging.state)
    }
    
    private func button() -> ButtonModel? {
        return actionButtonDataSource?.button(for: stateManaging.state)
    }
    
    open func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        return button().flatMap { actionButtonDataSource?.buttonTitleStyle(for: state, with: stateManaging.state).style($0.title) }
    }
    
    open func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.button()?.action()
    }
    
}
