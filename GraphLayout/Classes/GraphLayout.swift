//
//  GraphLayout.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com.
//  MIT License
//


public class GraphLayoutNodeView : UICollectionViewCell {
    class func kind() -> String {
        return String(describing: GraphLayoutNodeView.self)
    }
    
    public var label: UILabel!
    public var maskLayer: CAShapeLayer!
    public var shapeLayer: CAShapeLayer!
    public fileprivate(set) var node: Node? {
        get {
            return _node
        }
        set {
            _node = newValue
            if let node = _node {
                self.label.text = node.label
                self.label.font = UIFont.systemFont(ofSize: CGFloat(node.fontSize))
                self.label.textColor = node.textColor
                if let bezierPath = node.path(), let frame = node.bounds() {
                    maskLayer.frame = frame
                    maskLayer.path = bezierPath.cgPath
                    
                    shapeLayer.frame = frame
                    shapeLayer.path = bezierPath.cgPath
                    shapeLayer.lineWidth = UIScreen.main.scale * CGFloat(node.borderWidth)
                    shapeLayer.fillColor = node.color.cgColor
                    shapeLayer.strokeColor = node.borderColor.cgColor
                } else {
                    maskLayer.frame = frame
                    shapeLayer.frame = frame
                    shapeLayer.path = nil
                }
            }
        }
    }
    
    private var _node: Node?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal func setup() {
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        
        maskLayer = CAShapeLayer()
        self.layer.mask = maskLayer
        shapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeLayer)
        
        label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.autoresizingMask = .flexibleHeight
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

public class GraphLayoutEdgeView : UICollectionViewCell {
    class func kind() -> String {
        return String(describing: GraphLayoutEdgeView.self)
    }
    static let padding: CGFloat = 8
    
    public fileprivate(set) var edge: Edge?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal func setup() {
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let edge = edge, let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            context.translateBy(x: GraphLayoutEdgeView.padding, y: GraphLayoutEdgeView.padding)
            edge.color.setStroke()
            edge.color.setFill()
            let edgeWidth = CGFloat(edge.width)
            
            if let path = edge.body() {
                path.lineWidth = edgeWidth
                path.stroke()
            }
            
            if let headArrow = edge.headArrow() {
                headArrow.lineWidth = edgeWidth
                headArrow.fill()
                headArrow.stroke()
            }
            
            if let tailArrow = edge.tailArrow() {
                tailArrow.lineWidth = edgeWidth
                tailArrow.fill()
                tailArrow.stroke()
            }
            context.restoreGState()
        }
    }
}

public enum GraphLayoutCellType: Int {
    case Node = 0
    case Edge = 1
}

public class GraphLayout: UICollectionViewLayout, UICollectionViewDataSource {
    public var graph:Graph? = nil
    /// :nodoc:
    internal var cachedAttributes = [NSIndexPath: UICollectionViewLayoutAttributes]()
    
    public func setup(collectionView: UICollectionView) {
        collectionView.register(GraphLayoutNodeView.self, forCellWithReuseIdentifier: "node")
        collectionView.register(GraphLayoutEdgeView.self, forCellWithReuseIdentifier: "edge")
        collectionView.dataSource = self
        collectionView.collectionViewLayout = self
    }
    
    /// :nodoc:
    public override func prepare() {
        super.prepare()
        cachedAttributes.removeAll()
        if let graph = self.graph {
            let nodes = graph.nodes
            let edges = graph.edges
            
            for (index, node) in nodes.enumerated() {
                let indexPath = IndexPath(item: index, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let frame = node.bounds()!
                let center = node.frame()!.origin
                attributes.frame = frame
                attributes.center = CGPoint(x: center.x + frame.width/2, y: center.y + frame.height/2)
                cachedAttributes[indexPath as NSIndexPath] = attributes
            }
            for (index, edge) in edges.enumerated() {
                let indexPath = IndexPath(item: index, section: 1)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let bounds = edge.frame()!
                attributes.bounds = CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: bounds.size.width + 2 * GraphLayoutEdgeView.padding, height: bounds.size.height + 2 * GraphLayoutEdgeView.padding))
                attributes.center = CGPoint(x: bounds.midX, y: bounds.midY)
                attributes.zIndex = -1
                cachedAttributes[indexPath as NSIndexPath] = attributes
            }
        }
    }
    /// :nodoc:
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath as NSIndexPath]
    }
    
    /// :nodoc:
    public override var collectionViewContentSize: CGSize {
        return graph?.size() ?? CGSize(width: 0, height: 0)
    }
    
    /// :nodoc:
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for (_, attributes) in cachedAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let graph = self.graph {
            switch section {
            case GraphLayoutCellType.Node.rawValue:
                return graph.nodes.count
            case GraphLayoutCellType.Edge.rawValue:
                return graph.edges.count
            default:
                return 0
            }
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == GraphLayoutCellType.Node.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "node", for: indexPath) as! GraphLayoutNodeView
            cell.node = graph!.nodes[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "edge", for: indexPath) as! GraphLayoutEdgeView
            cell.edge = graph!.edges[indexPath.row]
            cell.setNeedsDisplay()
            return cell
        }
    }
}
