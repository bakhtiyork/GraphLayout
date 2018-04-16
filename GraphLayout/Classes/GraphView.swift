//
//  GraphView.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com.
//  MIT License
//

public class GraphView: UIView {
    public var graph: Graph?
    public var padding: CGFloat = 8

    public func calcSize(graph: Graph) -> CGSize {
        if graph.size != CGSize.zero {
            let size = graph.size
            return CGSize(width: size.width + 2 * padding, height: size.height + 2 * padding)
        }
        return CGSize.zero
    }

    public override func draw(_ rect: CGRect) {
        if let graph = self.graph, let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            UIColor.white.setFill()
            UIRectFill(rect)
            context.translateBy(x: padding, y: padding)

            for edge in graph.edges {
                if let path = edge.body(), let frame = edge.frame() {
                    context.saveGState()
                    let edgeWidth = CGFloat(edge.width)
                    edge.color.setFill()
                    edge.color.setStroke()

                    let origin = frame.origin
                    context.translateBy(x: origin.x, y: origin.y)
                    path.lineWidth = edgeWidth
                    path.stroke()
                    if let head = edge.headArrow() {
                        head.lineWidth = edgeWidth
                        head.fill()
                        head.stroke()
                    }
                    if let tail = edge.tailArrow() {
                        tail.lineWidth = edgeWidth
                        tail.fill()
                        tail.stroke()
                    }
                    context.restoreGState()
                }
            }

            let paraStyle = NSMutableParagraphStyle()
            paraStyle.alignment = NSTextAlignment.center
            for node in graph.nodes {
                if let path = node.path(), let frame = node.frame() {
                    context.saveGState()
                    let origin = frame.origin
                    context.translateBy(x: origin.x, y: origin.y)
                    node.color.setFill()
                    node.borderColor.setStroke()
                    path.lineWidth = CGFloat(node.borderWidth)
                    path.fill()
                    path.stroke()

                    let attributes = [
                        NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(node.fontSize)),
                        NSAttributedStringKey.foregroundColor: node.textColor,
                        NSAttributedStringKey.paragraphStyle: paraStyle,
                    ]
                    let label = node.label
                    let labelSize = label.size(withAttributes: attributes)
                    let labelFrame = CGRect(
                        x: (node.bounds()!.size.width - labelSize.width) / 2,
                        y: (node.bounds()!.size.height - labelSize.height) / 2,
                        width: labelSize.width,
                        height: labelSize.height
                    )
                    label.draw(in: labelFrame, withAttributes: attributes)
                    context.restoreGState()
                }
            }

            context.restoreGState()
        }
    }
}
