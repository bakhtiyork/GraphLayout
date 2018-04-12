//
//  GraphLayoutViewController.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com. MIT License
//

import UIKit
import GraphLayout

class GraphLayoutViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!

    var graph: Graph = DataSource.createGraph()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.graph.applyLayout()
        
        let layout = GraphLayout()
        layout.graph = self.graph
        layout.setup(collectionView: self.collectionView)
        layout.invalidateLayout()
        
        self.collectionView.delegate = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == GraphLayoutCellType.Node.rawValue {
            let node = self.graph.nodes[indexPath.item]
            self.navigationItem.title = node.label
        }
    }

    

}

