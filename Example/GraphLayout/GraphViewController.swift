//
//  GraphViewController.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com. MIT License
//

import UIKit
import GraphLayout

class GraphViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView?
    
    var graph: Graph = DataSource.createGraph()
    var graphView: GraphView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.graphView = GraphView()
        self.graph.applyLayout()
        
        self.graphView.graph = self.graph
        self.graphView.frame = CGRect(origin: CGPoint.zero, size: self.graphView.calcSize(graph: self.graph))
        self.scrollView?.addSubview(self.graphView)
        self.scrollView?.contentSize = self.graphView.bounds.size
        self.graphView.setNeedsDisplay()
    }
}

