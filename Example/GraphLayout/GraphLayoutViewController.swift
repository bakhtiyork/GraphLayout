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
    override func viewDidLoad() {
        super.viewDidLoad()
        graph.applyLayout()

        let layout = GraphLayout()
        layout.graph = graph
        layout.setup(collectionView: collectionView)
        layout.invalidateLayout()

        collectionView.delegate = self
    }

    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == GraphLayoutCellType.Node.rawValue {
            let node = graph.nodes[indexPath.item]
            navigationItem.title = node.label
        }
    }
}
