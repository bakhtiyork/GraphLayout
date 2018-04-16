//
//  GraphViewController.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com. MIT License
//

import GraphLayout
import UIKit

class GraphViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView?

    var graph: Graph = DataSource.createGraph()
    var graphView: GraphView!
    override func viewDidLoad() {
        super.viewDidLoad()

        graphView = GraphView()
        graph.applyLayout()

        graphView.graph = graph
        graphView.frame = CGRect(origin: CGPoint.zero, size: graphView.calcSize(graph: graph))
        scrollView?.addSubview(graphView)
        scrollView?.contentSize = graphView.bounds.size
        graphView.setNeedsDisplay()
    }
}
