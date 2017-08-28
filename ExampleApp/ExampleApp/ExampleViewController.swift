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
import DBEmptyState

class ExampleViewController: UITableViewController {
    
    let emptyState = StateMachine<EmptyState>(initialState: .initial)
    var emptyDataSet: EmptyContentTableViewAdapter<EmptyState>!

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataSet = EmptyContentTableViewAdapter(view: tableView, stateManaging: emptyState, dataSource: self,
                                                    whenStateChanges: EmptyContentTableViewAdapter.hideSkeletonCellsWhenEmptyStateIsVisable)
    }
    
    var stateIndex = 0
    let states: [EmptyState] = [.initial, .loading, .error]
    
    @IBAction func changeState(_ sender: Any) {
        stateIndex = (stateIndex + 1) % states.count
        emptyState.state = states[stateIndex]
    }

}
