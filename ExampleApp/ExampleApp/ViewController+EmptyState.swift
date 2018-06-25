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

import Foundation
import DBEmptyState

extension ExampleViewController: EmptyContentDataSource {
    func emptyContent(for state: EmptyState) -> EmptyContent? {
        switch state {
        case .initial:
            return EmptyContent(title: "Initial State", subtitle: "This is an initial state with subtitles wich is also scrollable", image: UIImage(named: "ic_impressum_dbkeks.png"), shouldAllowScroll: true)
        case .loading:
            return .customPresentation
        case .error:
            return EmptyContent(title: "Error")
        default:
            return nil
        }
    }
    
}

extension ExampleViewController: CustomEmptyViewDataSource {
    func customView(for state: EmptyState, with content: EmptyContent) -> UIView? {
        switch state {
        case .loading:
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            
            return spinner
        default:
            return nil
        }
    }
}

extension ExampleViewController: ActionButtonDataSource {
    func button(for state: EmptyState) -> ButtonModel? {
        switch state {
        case .error:
            return ButtonModel(title: "Retry", action: {
                print("Action")
            })
        default:
            return nil
        }
    }
}
