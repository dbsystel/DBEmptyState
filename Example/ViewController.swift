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
    var emptyDataSet: DZNTableViewAdapter!

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataSet = DZNTableViewAdapter(tableView: tableView, stateManaging: emptyState, dataSource: self)
    }
    
    var stateIndex = 0
    let states: [EmptyState] = [.initial, .error]
    
    @IBAction func changeState(_ sender: Any) {
        stateIndex = (stateIndex + 1) % states.count
        emptyState.state = states[stateIndex]
    }

}

extension ExampleViewController: EmptyContentDataSource {
    func emptyContent(for state: EmptyState) -> EmptyContent? {
        switch state {
        case .error:
            return EmptyContent(title: "Error")
        case .initial:
            return EmptyContent(title: "Initial State", subtitle: "This is an initial state with subtitles", image: UIImage(named: "ic_impressum_dbkeks.png"))
        default:
            return nil
        }
    }
}

extension ExampleViewController: EmptyContentCustomViewDataSource {}
