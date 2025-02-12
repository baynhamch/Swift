# NavigationStack
#### Structure

### A view that displays a root view and enables you to present additional views over the root view.

```swift
@MainActor @preconcurrency
struct NavigationStack<Data, Root> where Root : View
```

## Overview
Use a navigation stack to present a stack of views over a root view. People can add views to the top of the stack by clicking or tapping a NavigationLink, and remove views using built-in, platform-appropriate controls, like a Back button or a swipe gesture. The stack always displays the most recently added view that hasn’t been removed, and doesn’t allow the root view to be removed.
To create navigation links, associate a view with a data type by adding a navigationDestination(for:destination:) modifier inside the stack’s view hierarchy. Then initialize a NavigationLink that presents an instance of the same kind of data. The following stack displays a ParkDetails view for navigation links that present data of type Park:

```swift
NavigationStack {
    List(parks) { park in
        NavigationLink(park.name, value: park)
    }
    .navigationDestination(for: Park.self) { park in
        ParkDetails(park: park)
    }
}
```

In this example, the List acts as the root view and is always present. Selecting a navigation link from the list adds a ParkDetails view to the stack, so that it covers the list. Navigating back removes the detail view and reveals the list again. The system disables backward navigation controls when the stack is empty and the root view, namely the list, is visible.

## Manage navigation state
By default, a navigation stack manages state to keep track of the views on the stack. However, your code can share control of the state by initializing the stack with a binding to a collection of data values that you create. The stack adds items to the collection as it adds views to the stack and removes items when it removes views. For example, you can create a State property to manage the navigation for the park detail view:

```swift
@State private var presentedParks: [Park] = []
```

Initializing the state as an empty array indicates a stack with no views. Provide a Binding to this state property using the dollar sign ($) prefix when you create a stack using the init(path:root:) initializer:
```swift
NavigationStack(path: $presentedParks) {
    List(parks) { park in
        NavigationLink(park.name, value: park)
    }
    .navigationDestination(for: Park.self) { park in
        ParkDetails(park: park)
    }
}
```




