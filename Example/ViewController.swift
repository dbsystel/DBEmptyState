//
//  ViewController.swift
//  Example
//
//  Created by Lukas Schmidt on 27.04.17.
//  Copyright © 2017 DBSystel. All rights reserved.
//

import UIKit
import DBEmptyState

class ExampleViewController: UITableViewController {
    
    let emptyState = StateMachine<EmptyState>(initialState: .initial)
    var emptyDataSet: EmptyTableViewAdapter<EmptyState>!

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataSet = EmptyTableViewAdapter(view: tableView, stateManaging: emptyState, dataSource: self)
    }
    
    var stateIndex = 0
    let states: [EmptyState] = [.initial, .loading, .error]
    
    @IBAction func changeState(_ sender: Any) {
        stateIndex = (stateIndex + 1) % states.count
        emptyState.state = states[stateIndex]
    }

}
