//
//  GraphLayoutViewController.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com. MIT License
//

import GraphLayout
import UIKit

class GraphLayoutViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!

    var graph: Graph = DataSource.createGraph()
    var layout: GraphLayout!
    var selectedNodeIndexPath: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = GraphLayout()
        layout.graph = graph
        layout.setup(collectionView: collectionView)
        collectionView.delegate = self
        updateLayout()
    }

    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == GraphLayoutCellType.Node.rawValue {
            let node = graph.nodes[indexPath.item]
            graph.removeNode(node: node)
            updateLayout()
        }
    }

    func updateLayout() {
        graph.applyLayout()
        collectionView.reloadData()
        layout.invalidateLayout()
    }
}
