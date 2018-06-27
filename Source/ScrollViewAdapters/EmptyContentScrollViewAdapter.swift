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

import UIKit
import DZNEmptyDataSet

//EmptyContentScrollViewAdapter display empty content inside
open class EmptyContentScrollViewAdapter<State: Equatable, View: UIScrollView>: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    public var emptyContentDataSource: AnyEmptyContentDataSource<State>?
    public var customViewDataSource: AnyCustomEmptyViewDataSource<State>?
    public var actionButtonDataSource: AnyActionButtonDataSource<State>?
    public var emptyContentPresentationDelegate: AnyPresentation<State>?
    
    let view: View
    let stateManaging: AnyStateManaging<State>
    let whenStateChanges: ((State, View) -> Void)?
    
    /**
     Creates an `EmptyContentScrollViewAdapter` instance which display empty content inside a scrollView subclass.
     
     - parameter view: the scrollView subclass to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentDataSource: dataSource which provides the empty content.
     - parameter customViewDataSource: dataSource which custom empty state views.
     - parameter buttonDataSource: dataSource which provides button & actions for specific empty states.
     - parameter presentation: delegate which provides details for presentation settings
     - parameter whenStateChanges: handle a state change. One can hide or display specific view elements on this event.
     */
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource,
        CustomViewSource: CustomEmptyViewDataSource, ButtonDataSource: ActionButtonDataSource, Presentation: EmptyContentPresentationDelegate>
        (view: View, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource,
         customViewDataSource: CustomViewSource, buttonDataSource: ButtonDataSource, presentation: Presentation, whenStateChanges: ((State, View) -> Void)? = nil)
        where StateManager.State == State, EmptyContentSource.EmptyState == State, CustomViewSource.EmptyState == State, ButtonDataSource.EmptyState == State, Presentation.EmptyState == State {
            self.view = view
            self.emptyContentDataSource = AnyEmptyContentDataSource(emptyContentDataSource)
            self.customViewDataSource = AnyCustomEmptyViewDataSource(customViewDataSource)
            self.actionButtonDataSource = AnyActionButtonDataSource(buttonDataSource)
            self.stateManaging = AnyStateManaging(stateManaging)
            self.whenStateChanges = whenStateChanges
            self.emptyContentPresentationDelegate = AnyPresentation(presentation)
            super.init()
            setup()
    }
    
    /**
     Creates an `EmptyContentScrollViewAdapter` instance which display empty content inside a scrollView subclass.
     
     - parameter view: the scrollView subclass to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentDataSource: dataSource which provides the empty content.
     - parameter customViewDataSource: dataSource which custom empty state views.
     - parameter buttonDataSource: dataSource which provides button & actions for specific empty states.
     - parameter whenStateChanges: handle a state change. One can hide or display specific view elements on this event.
     */
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource,
        CustomViewSource: CustomEmptyViewDataSource, ButtonDataSource: ActionButtonDataSource>
        (view: View, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource,
         customViewDataSource: CustomViewSource, buttonDataSource: ButtonDataSource, whenStateChanges: ((State, View) -> Void)? = nil)
        where StateManager.State == State, EmptyContentSource.EmptyState == State, CustomViewSource.EmptyState == State, ButtonDataSource.EmptyState == State {
            self.view = view
            self.emptyContentDataSource = AnyEmptyContentDataSource(emptyContentDataSource)
            self.customViewDataSource = AnyCustomEmptyViewDataSource(customViewDataSource)
            self.actionButtonDataSource = AnyActionButtonDataSource(buttonDataSource)
            self.stateManaging = AnyStateManaging(stateManaging)
            self.whenStateChanges = whenStateChanges
            super.init()
            setup()
    }
    
    /**
     Creates an `EmptyContentScrollViewAdapter` instance which display empty content inside a scrollView subclass.
     
     - parameter view: the scrollView subclass to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentCustomViewDataSource: dataSource which provides the empty content & custom empty state views.
     - parameter whenStateChanges: handle a state change. One can hide or display specific view elements on this event.
     */
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource & CustomEmptyViewDataSource>
        (view: View, stateManaging: StateManager, emptyContentCustomViewDataSource: EmptyContentSource, whenStateChanges: ((State, View) -> Void)? = nil)
        where StateManager.State == State, EmptyContentSource.EmptyState == State {
            self.view = view
            self.emptyContentDataSource = AnyEmptyContentDataSource(emptyContentCustomViewDataSource)
            self.customViewDataSource = AnyCustomEmptyViewDataSource(emptyContentCustomViewDataSource)
            self.stateManaging = AnyStateManaging(stateManaging)
            self.whenStateChanges = whenStateChanges
            super.init()
            setup()
    }
    
    /**
     Creates an `EmptyContentScrollViewAdapter` instance which display empty content inside a scrollView subclass.
     
     - parameter view: the scrollView subclass to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter emptyContentDataSource: dataSource which provides the empty content.
     - parameter whenStateChanges: handle a state change. One can hide or display specific view elements on this event.
     */
    public init<StateManager: StateManaging, EmptyContentSource: EmptyContentDataSource>
        (view: View, stateManaging: StateManager, emptyContentDataSource: EmptyContentSource, whenStateChanges: ((State, View) -> Void)? = nil)
        where StateManager.State == State, EmptyContentSource.EmptyState == State {
            self.view = view
            self.emptyContentDataSource = AnyEmptyContentDataSource(emptyContentDataSource)
            self.stateManaging = AnyStateManaging(stateManaging)
            self.whenStateChanges = whenStateChanges
            super.init()
            setup()
    }
    
    /**
     Creates an `EmptyContentScrollViewAdapter` instance which display empty content inside a scrollView subclass.
     
     - parameter view: the scrollView subclass to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter dataSource: dataSource which provides the empty content,
     custom empty state views and button & actions and presentation settings for specific empty states.
     */
    public convenience init<StateManager: StateManaging, EmptyContentData: EmptyContentDataSource &
        CustomEmptyViewDataSource & ActionButtonDataSource & EmptyContentPresentationDelegate>(view: View, stateManaging: StateManager,
                dataSource: EmptyContentData, whenStateChanges: ((State, View) -> Void)? = nil)
        where StateManager.State == State, EmptyContentData.EmptyState == State {
            self.init(view: view, stateManaging: stateManaging, emptyContentDataSource: dataSource,
                      customViewDataSource: dataSource, buttonDataSource: dataSource, presentation: dataSource, whenStateChanges: whenStateChanges)
        }
    
    /**
     Creates an `EmptyContentScrollViewAdapter` instance which display empty content inside a scrollView subclass.
     
     - parameter view: the scrollView subclass to display the empty content.
     - parameter stateManaging: managing the empty state.
     - parameter dataSource: dataSource which provides the empty content,
     custom empty state views and button & actions for specific empty states.
     */
    public convenience init<StateManager: StateManaging, EmptyContentData: EmptyContentDataSource &
        CustomEmptyViewDataSource & ActionButtonDataSource>(view: View, stateManaging: StateManager, dataSource: EmptyContentData, whenStateChanges: ((State, View) -> Void)? = nil)
        where StateManager.State == State, EmptyContentData.EmptyState == State {
            self.init(view: view, stateManaging: stateManaging, emptyContentDataSource: dataSource,
                      customViewDataSource: dataSource, buttonDataSource: dataSource, whenStateChanges: whenStateChanges)
    }
    
    private func setup() {
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        update()
        stateManaging.onChange(execute: { [weak self] newState in
            guard let strongSelf = self else {
                return
            }
            self?.update()
            self?.whenStateChanges?(newState, strongSelf.view)
        })
        whenStateChanges?(stateManaging.state, view)
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
    
    /**
    
     Delegate function of DZNEmptyDataSet if empty content should allow touch
     
     - parameter _: the scrollView subclass to display the empty content.
     
    */
    open func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return emptyContentPresentationDelegate?.shouldAllowTouch(for: stateManaging.state) ?? true
    }
    
    /**
     
     Delegate function of DZNEmptyDataSet if empty content should allow scroll
     
     - parameter _: the scrollView subclass to display the empty content.
     
     */
    open func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return emptyContentPresentationDelegate?.shouldAllowScroll(for: stateManaging.state) ?? false
    }
    
    /**
     
     Delegate function of DZNEmptyDataSet if image view of empty content should animate
     
     - parameter _: the scrollView subclass to display the empty content.
     
     */
    open func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return emptyContentPresentationDelegate?.shouldAllowImageViewAnimate(for: stateManaging.state) ?? false
    }
    
}
