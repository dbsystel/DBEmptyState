# DBEmptyState

DBEmptyState helps you to manage your empty/error/whatever states inside your TableView. 
You can define states and representations which get displayed once your state is active.

## Example

Inside your ViewController, create and store a `EmptyTableViewAdapter` and a `StateMachine`.

```swift
let emptyState = StateMachine<EmptyState>(initialState: .initial)
var emptyDataSet: EmptyTableViewAdapter<EmptyState>!

override func viewDidLoad() {
    super.viewDidLoad()
    emptyDataSet = EmptyTableViewAdapter(tableView: tableView, stateManaging: emptyState, dataSource: self)
}
```

Provide content for the states you want by implementing at least `EmptyContentDataSource`.
```swift
extension ExampleViewController: EmptyContentDataSource {
    func emptyContent(for state: EmptyState) -> EmptyContent? {
        switch state {
        case .initial:
            return EmptyContent(title: "Initial State", subtitle: "This is an initial state with subtitles", image: UIImage(named: "image.png"))
        case .loading:
            return .customPresentation // needed when you want to display only a custom view
        case .error:
            return EmptyContent(title: "Error")
        default:
            return nil
        }
    } 
}
```
