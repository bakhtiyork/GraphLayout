//
//  DataSource.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com. MIT License
//

import GraphLayout

class DataSource {
    static func createGraph() -> Graph {
        let graph:Graph = Graph()
        let node1 = graph.addNode("The quick\nbrown fox jumps\nover the lazy\ndog")
        let node2 = graph.addNode("node 2")
        let node3 = graph.addNode("node 3")
        let node4 = graph.addNode("node\n4")
        let node5 = graph.addNode("A picture\nis worth\na thousand\nwords")
        let node6 = graph.addNode("node 6")
        let node7 = graph.addNode("node \n 7")
        let node8 = graph.addNode("node 8")
        let node9 = graph.addNode("node 9")
        let node10 = graph.addNode("node \n 10")
        let node11 = graph.addNode("node 11")
        let node12 = graph.addNode("node \n 12")
        let node13 = graph.addNode("node 13")
        let node14 = graph.addNode("node \n 14")
        let node15 = graph.addNode("node 15")
        let _ = graph.addEdge(from: node1, to: node2)
        let _ = graph.addEdge(from: node1, to: node5)
        let _ = graph.addEdge(from: node3, to: node4)
        let _ = graph.addEdge(from: node2, to: node3)
        let _ = graph.addEdge(from: node4, to: node5)
        let _ = graph.addEdge(from: node3, to: node5)
        let _ = graph.addEdge(from: node6, to: node7)
        let _ = graph.addEdge(from: node7, to: node8)
        let _ = graph.addEdge(from: node8, to: node9)
        let _ = graph.addEdge(from: node9, to: node10)
        let _ = graph.addEdge(from: node1, to: node10)
        let _ = graph.addEdge(from: node5, to: node10)
        let _ = graph.addEdge(from: node5, to: node6)
        let _ = graph.addEdge(from: node6, to: node5)
        let e1_8 = graph.addEdge(from: node1, to: node8)
        
        let _ = graph.addEdge(from: node8, to: node1)
        let e3_10 = graph.addEdge(from: node3, to: node10)
        let _ = graph.addEdge(from: node4, to: node9)
        let _ = graph.addEdge(from: node3, to: node7)
        let _ = graph.addEdge(from: node2, to: node8)
        let _ = graph.addEdge(from: node4, to: node8)
        let _ = graph.addEdge(from: node5, to: node7)
        let _ = graph.addEdge(from: node5, to: node5)
        
        let _ = graph.addEdge(from: node11, to: node12)
        let _ = graph.addEdge(from: node12, to: node15)
        let _ = graph.addEdge(from: node11, to: node13)
        let _ = graph.addEdge(from: node15, to: node14)
        let _ = graph.addEdge(from: node15, to: node11)
        let _ = graph.addEdge(from: node11, to: node1)
        let _ = graph.addEdge(from: node12, to: node1)
        let _ = graph.addEdge(from: node10, to: node15)
        let _ = graph.addEdge(from: node13, to: node6)
        let e9_1 = graph.addEdge(from: node9, to: node1)
        let _ = graph.addEdge(from: node9, to: node11)
        let _ = graph.addEdge(from: node13, to: node3)
        node2.shape = .box
        node4.shape = .hexagon
        node1.color = UIColor.yellow
        node3.fontSize = 24
        node3.textColor = UIColor.blue
        
        e9_1.color = UIColor.red
        e3_10.color = UIColor.green
        e1_8.weight = 10
        e1_8.width = 2
        e3_10.weight = 50
        e3_10.width = 3
        e9_1.weight = 100
        e9_1.width = 4
        
        return graph
    }
}
