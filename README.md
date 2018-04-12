# GraphLayout

[![Version](https://img.shields.io/cocoapods/v/GraphLayout.svg?style=flat)](http://cocoapods.org/pods/GraphLayout)
[![License](https://img.shields.io/cocoapods/l/GraphLayout.svg?style=flat)](http://cocoapods.org/pods/GraphLayout)
[![Platform](https://img.shields.io/cocoapods/p/GraphLayout.svg?style=flat)](http://cocoapods.org/pods/GraphLayout)


GraphLayout - UI controls for graph visualization. It is powered by Graphviz. Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks. It has important applications in networking, bioinformatics,  software engineering, database and web design, machine learning, and in visual interfaces for other technical domains.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
<img alt="Screenshot1" src="https://raw.githubusercontent.com/bakhtiyork/GraphLayout/master/docs/images/screenshot1.png" width="384">

## Requirements
Xcode 9, iOS 11

## Installation

GraphLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GraphLayout'
```
Notice, please, GraphLayout doesn't support frameworks.

## Usage
Create graph, add nodes and edges.
```swift
let graph:Graph = Graph()
let node1 = graph.addNode("node 1")
let node2 = graph.addNode("node 2")
let node3 = graph.addNode("node 3")
let _ = graph.addEdge(from: node1, to: node2)
let _ = graph.addEdge(from: node1, to: node3)
let _ = graph.addEdge(from: node3, to: node2)
```
Apply graph layout (Graphviz powered)
```swift
graph.applyLayout()
```

### GraphView
GraphView is a view to draw graphs. Set graph property of GraphView.
```swift
graphView.graph = graph
graphView.setNeedsDisplay()
```

### GraphLayout
GraphLayout is UICollectionView layout and data source to display graphs.
```swift
let layout = GraphLayout()
layout.graph = graph
layout.setup(collectionView: collectionView)
layout.invalidateLayout()
```

## Credits

* Steve D. Lazaro [How-to: Use Graphviz to Draw Graphs in a Qt Graphics Scene](http://www.mupuf.org/blog/2010/07/08/how_to_use_graphviz_to_draw_graphs_in_a_qt_graphics_scene/)
* [qgv](https://github.com/nbergont/qgv) by [nbergont](https://github.com/nbergont)

## License

GraphLayout is available under the MIT license. See the LICENSE file for more info.
