//
//  Graph.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com.
//  MIT License
//

public enum Shape : String {
    case rectangle, box, hexagon, polygon, diamond, star, ellipse, circle
}

public class Edge {
    fileprivate var gvlEdge:GVLEdge?
    
    public var color: UIColor = UIColor.black
    public var width: Float = 1.0
    public var weight: Int {
        get {
            if let value = gvlEdge?.getAttributeForKey("weight") {
                if let weight = Int(value) {
                    return weight
                }
            }
            return 1
        }
        set {
            gvlEdge?.setAttribute(newValue.description, forKey: "weight")
        }
    }
    
    public init(from node1: Node, to node2: Node) {
    }
    
    public func getAttribute(name: String) -> String? {
        return gvlEdge?.getAttributeForKey(name)
    }
    
    public func setAttribute(name: String, value: String) {
        gvlEdge?.setAttribute(value, forKey: name)
    }
    
    public func frame() -> CGRect? {
        return gvlEdge?.frame()
    }
    
    public func bounds() -> CGRect? {
        return gvlEdge?.bounds()
    }
    
    public func body() -> UIBezierPath? {
        return gvlEdge?.body()
    }
    
    public func headArrow() -> UIBezierPath? {
        return gvlEdge?.headArrow()
    }
    
    public func tailArrow() -> UIBezierPath? {
        return gvlEdge?.tailArrow()
    }
}

public class Node {
    fileprivate var gvlNode:GVLNode?
    public let label: String
    public var color: UIColor = UIColor.white
    public var highlihtedColor: UIColor = UIColor.lightGray
    public var borderColor: UIColor = UIColor.black
    public var borderWidth: Float = 1.0
    public var textColor: UIColor = UIColor.black
    public var fontSize: Int {
        get {
            if let value = gvlNode?.getAttributeForKey("fontsize") {
                if let fontsize = Int(value) {
                    return fontsize
                }
            }
            return 14
        }
        set {
            gvlNode?.setAttribute(newValue.description, forKey: "fontsize")
        }
    }
    
    public init(label: String) {
        self.label = label
    }
    
    public func getAttribute(name: String) -> String? {
        return gvlNode?.getAttributeForKey(name)
    }
    
    public func setAttribute(name: String, value: String) {
        gvlNode?.setAttribute(value, forKey: name)
    }
    
    public func frame() -> CGRect? {
        return gvlNode?.frame()
    }
    
    public func bounds() -> CGRect? {
        return gvlNode?.bounds()
    }
    
    public func path() -> UIBezierPath? {
        return gvlNode?.path()
    }
    
    public var shape: Shape {
        get {
            let value = gvlNode?.getAttributeForKey("shape")
            let shape = Shape(rawValue: value!)
            return shape ?? Shape.ellipse
        }
        set {
            gvlNode?.setAttribute(String(describing: newValue), forKey: "shape")
        }
    }
}

public class SubGraph {

}

public enum Splines : String {
    case spline
    case polyline
    case ortho
    case curved
}

public class Graph {
    public private(set) var nodes = [Node]()
    public private(set) var edges = [Edge]()
    
    public var splines: Splines {
        get {
            if let value = gvlGraph.getAttributeForKey("splines") {
                if let splines = Splines(rawValue: value) {
                    return splines
                }
            }
            return .spline
        }
        set {
            gvlGraph.setAttribute(newValue.rawValue, forKey: "splines")
        
        }
    }
    
    
    fileprivate let gvlGraph: GVLGraph
    
    public init() {
        gvlGraph = GVLGraph()
    }
    
    public func addNode(_ label: String) -> Node {
        let node = Node(label: label)
        let gvlNode = gvlGraph.addNode(label)
        node.gvlNode = gvlNode
        nodes.append(node)
        return node
    }
    
    public func addEdge(from node1: Node, to node2: Node) -> Edge {
        let edge = Edge(from: node1, to: node2)
        let gvlEdge = gvlGraph.addEdge(withSource: node1.gvlNode, andTarget: node2.gvlNode)
        edge.gvlEdge = gvlEdge
        edges.append(edge)
        return edge
    }
    
    public func getAttribute(name: String) -> String? {
        return gvlGraph.getAttributeForKey(name)
    }
    
    public func setAttribute(name: String, value: String) {
        gvlGraph.setAttribute(value, forKey: name)
    }
    
    public func size() -> CGSize? {
        return gvlGraph.size()
    }
    
    public func applyLayout() {
        gvlGraph.applyLayout()
    }
}

