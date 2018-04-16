//
//  GVLGraph.m
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com.
//  MIT License
//

#import "GVLGraph.h"

extern gvplugin_library_t gvplugin_dot_layout_LTX_library;
// extern gvplugin_library_t gvplugin_neato_layout_LTX_library;
extern gvplugin_library_t gvplugin_core_LTX_library;
// extern gvplugin_library_t gvplugin_quartz_LTX_library;
// extern gvplugin_library_t gvplugin_visio_LTX_library;

char empty[] = "";
float _dpi = 72.0f;

#define kArrowPointCount 7

@implementation GVLNode {
    UIBezierPath *_bezierPath;
    CGRect _frame;
    CGRect _bounds;
    CGPoint _origin;
}

@synthesize label = _label;

- (void)setAttribute:(NSString *)value forKey:(NSString *)key {
    agsafeset(self.node, (char *)[key UTF8String], (char *)[value UTF8String],
              empty);
}

- (NSString *)getAttributeForKey:(NSString *)key {
    char *raw = agget(self.node, (char *)[key UTF8String]);
    if (raw) {
        return [NSString stringWithUTF8String:raw];
    }
    return @"";
}

- (NSString *)label {
    return _label;
}

- (void)setLabel:(NSString *)label {
    _label = label;
    [self setAttribute:label forKey:@"label"];
}

- (void)prepare {
    float width = ND_width(self.node) * _dpi;
    float height = ND_height(self.node) * _dpi;
    CGPathRef cgpath =
        [GVLUtils toPathWithType:ND_shape(self.node)->name
                            poly:(polygon_t *)ND_shape_info(self.node)
                           width:width
                          height:height];
    if (cgpath) {
        _bezierPath = [UIBezierPath bezierPathWithCGPath:cgpath];
    }
    float gheight = [GVLUtils getHeightForGraph:self.parent];
    CGPoint point = [GVLUtils toPointF:ND_coord(self.node) height:gheight];
    _origin = [GVLUtils centerToOrigin:point width:width height:height];
    _bounds = CGRectMake(0, 0, width, height);
    _frame = CGRectMake(_origin.x, _origin.y, width, height);
}

- (UIBezierPath *)path {
    return _bezierPath;
}

- (CGPoint)origin {
    return _origin;
}

- (CGRect)frame {
    return _frame;
}

- (CGRect)bounds {
    return _bounds;
}

@end

@implementation GVLEdge {
    CGRect _bounds;
    CGRect _frame;
    UIBezierPath *_bezierPath;
    UIBezierPath *_body;
    UIBezierPath *_head;
    UIBezierPath *_tail;
}
- (void)setAttribute:(NSString *)value forKey:(NSString *)key {
    agsafeset(self.edge, (char *)[key UTF8String], (char *)[value UTF8String],
              empty);
}

- (NSString *)getAttributeForKey:(NSString *)key {
    char *raw = agget(self.edge, (char *)[key UTF8String]);
    if (raw) {
        return [NSString stringWithUTF8String:raw];
    }
    return @"";
}

- (void)prepare {
    float gheight = [GVLUtils getHeightForGraph:self.parent];
    const splines *bodySpl = ED_spl(self.edge);
    CGPathRef bodyPath = [GVLUtils toPathWithSplines:bodySpl height:gheight];
    if (bodyPath) {
        _body = [UIBezierPath bezierPathWithCGPath:bodyPath];
        _bezierPath = [UIBezierPath bezierPathWithCGPath:bodyPath];
    }

    _head = [self toArrow:ED_spl(self.edge) withHeight:gheight];
    _tail = [self toArrow:ED_spl(self.edge) withHeight:gheight];

    if (_bezierPath) {
        if (_head) {
            [_bezierPath appendPath:_head];
        }
        if (_tail) {
            [_bezierPath appendPath:_tail];
        }
    }
    _frame = [_body bounds];
    if (_head) {
        _frame = CGRectUnion(_frame, [_head bounds]);
    }
    if (_tail) {
        _frame = CGRectUnion(_frame, [_tail bounds]);
    }
    _bounds = CGRectMake(0, 0, _frame.size.width, _frame.size.height);

    // normalize bezier paths
    CGAffineTransform move =
        CGAffineTransformMakeTranslation(-_frame.origin.x, -_frame.origin.y);
    [_body applyTransform:move];
    [_head applyTransform:move];
    [_tail applyTransform:move];
}

- (CGRect)frame {
    return _frame;
}

- (CGRect)bounds {
    return _bounds;
}

- (UIBezierPath *)path {
    return _bezierPath;
}

- (UIBezierPath *)body {
    return _body;
}

- (UIBezierPath *)headArrow {
    return _head;
}

- (UIBezierPath *)tailArrow {
    return _tail;
}

- (UIBezierPath *)toArrow:(const splines *)spl withHeight:(float)gheight {
    if ((spl->list != 0) && (spl->list->size % 3 == 1)) {
        if (spl->list->eflag) {
            CGPoint p1 = [GVLUtils toPointF:spl->list->list[spl->list->size - 1]
                                     height:gheight];
            CGPoint p2 = [GVLUtils toPointF:spl->list->ep height:gheight];
            return [GVLUtils arrowFrom:p1
                                    to:p2
                             tailWidth:0.5
                             headWidth:8
                            headLength:12];
        }
    }
    return NULL;
}

@end

@implementation GVLGraph {
    Agraph_t *_graph;
    GVC_t *_context;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *name = [NSString stringWithFormat:@"graph_%d", arc4random()];

        _context = gvContext();
        gvAddLibrary(_context, &gvplugin_dot_layout_LTX_library);
        // gvAddLibrary(_context, &gvplugin_neato_layout_LTX_library);
        gvAddLibrary(_context, &gvplugin_core_LTX_library);
        _graph = agopen((char *)[name UTF8String], Agdirected, NULL);

        self.nodes = [NSMutableArray array];
        self.edges = [NSMutableArray array];

        // Set graph attributes
        [self setAttribute:@"spline" forKey:@"splines"];
        [self setAttribute:@"scalexy" forKey:@"overlap"];
    }
    return self;
}

- (NSString *)getAttributeForKey:(NSString *)key {
    char *value = agget(_graph, (char *)[key UTF8String]);
    if (value) {
        return [NSString stringWithUTF8String:value];
    }
    return NULL;
}

- (void)setAttribute:(NSString *)value forKey:(NSString *)key {
    agsafeset(_graph, (char *)[key UTF8String], (char *)[value UTF8String],
              empty);
}

- (GVLNode *)addNode:(NSString *)label {
    GVLNode *node = [[GVLNode alloc] init];
    node.node = agnode(_graph, NULL, TRUE);
    if (!node.node) {
        NSLog(@"Error adding node %@", label);
    }
    node.parent = _graph;
    node.label = label;
    [self.nodes addObject:node];
    return node;
}

- (GVLEdge *)addEdgeWithSource:(GVLNode *)source andTarget:(GVLNode *)target {
    GVLEdge *edge = [[GVLEdge alloc] init];
    edge.edge = agedge(_graph, source.node, target.node, NULL, TRUE);
    if (!edge.edge) {
        NSLog(@"Error adding edge %@ - %@", source.label, target.label);
    }
    edge.parent = _graph;
    [self.edges addObject:edge];
    return edge;
}

- (BOOL)deleteNode:(GVLNode *)node {
    if ([self.nodes containsObject:node]) {
        agdelnode(_graph, node.node);
        [self.nodes removeObject:node];
        return YES;
    }
    return NO;
}

- (BOOL)deleteEdge:(GVLEdge *)edge {
    if ([self.edges containsObject:edge]) {
        agdeledge(_graph, edge.edge);
        [self.edges removeObject:edge];
        return YES;
    }
    return NO;
}

- (BOOL)loadLayout:(NSString *)text {
    const char *cp = [text cStringUsingEncoding:NSUTF8StringEncoding];
    Agraph_t *graph = agmemread(cp);
    if (gvLayout(_context, graph, (char *)"dot") != 0) {
        return NO;
    }
    [_nodes removeAllObjects];
    [_edges removeAllObjects];
    _graph = graph;
    int i = 0;
    for (Agnode_t *ag_node = agfstnode(_graph); ag_node != NULL;
         ag_node = agnxtnode(_graph, ag_node)) {
        GVLNode *node = [[GVLNode alloc] init];
        node.node = ag_node;
        node.parent = _graph;
        node.label = [node getAttributeForKey:@"label"];
        [_nodes addObject:node];
        [node prepare];
        for (Agedge_t *ag_edge = agfstout(_graph, ag_node); ag_edge != NULL;
             ag_edge = agnxtout(_graph, ag_edge)) {
            GVLEdge *edge = [[GVLEdge alloc] init];
            edge.edge = ag_edge;
            edge.parent = _graph;
            [_edges addObject:edge];
            [edge prepare];
        }
        i++;
    }
    return NO;
}

- (BOOL)applyLayout {
    if (gvLayout(_context, _graph, (char *)"dot") == 0) {
        for (GVLNode *node in self.nodes) {
            [node prepare];
        }
        for (GVLEdge *edge in self.edges) {
            [edge prepare];
        }
        return YES;
    }
    return NO;
}

- (CGSize)size {
    int width = GD_bb(_graph).UR.x;
    int height = GD_bb(_graph).UR.y;
    return CGSizeMake(width, height);
}

- (void)dealloc {
    gvFreeLayout(_context, _graph);
    agclose(_graph);
    gvFreeContext(_context);
    // delete graph;
    // delete context;
}

@end

@implementation GVLUtils
+ (float)getHeightForGraph:(Agraph_t *)graph {
    return GD_bb(graph).UR.y;
}

+ (NSMutableArray *)toPolygon:(const polygon_t *)poly
                        width:(float)width
                       height:(float)height {
    NSMutableArray *polygon = [NSMutableArray array];
    if (poly->peripheries != 1)
        NSLog(@"unsupported number of peripheries %d", poly->peripheries);

    const int sides = poly->sides;
    const pointf *vertices = poly->vertices;
    for (int side = 0; side < sides; side++) {
        CGPoint point = CGPointMake(vertices[side].x + width / 2,
                                    vertices[side].y + height / 2);
        [polygon addObject:[NSValue valueWithCGPoint:point]];
    }
    return polygon;
}

+ (CGPathRef)toPathWithType:(const char *)type
                       poly:(const polygon_t *)poly
                      width:(float)width
                     height:(float)height {
    if ((strcmp(type, "rectangle") == 0) || (strcmp(type, "box") == 0) ||
        (strcmp(type, "hexagon") == 0) || (strcmp(type, "polygon") == 0) ||
        (strcmp(type, "diamond") == 0) || (strcmp(type, "Mdiamond") == 0) ||
        (strcmp(type, "Msquare") == 0) || (strcmp(type, "star") == 0)) {
        NSMutableArray *points =
            [GVLUtils toPolygon:poly width:width height:height];
        [points addObject:[points firstObject]];
        return [GVLUtils toPath:points];
    } else if ((strcmp(type, "ellipse") == 0) ||
               (strcmp(type, "circle") == 0)) {
        NSMutableArray *points =
            [GVLUtils toPolygon:poly width:width height:height];
        CGPoint p1 = [points[0] CGPointValue];
        CGPoint p2 = [points[1] CGPointValue];
        CGRect rect = CGRectMake(p1.x, p1.y, p2.x, p2.y);
        return CGPathCreateWithEllipseInRect(rect, NULL);
    } else {
        NSLog(@"Unsupported shape %s", type);
    }
    return NULL;
}

+ (CGPathRef)toPathWithSplines:(const splines *)spl height:(float)height {
    CGMutablePathRef path = CGPathCreateMutable();
    if ((spl->list != 0) && (spl->list->size % 3 == 1)) {
        bezier bez = spl->list[0];
        // If there is a starting point, draw a line from it to the first curve
        // point
        if (bez.sflag) {
            CGPoint p1 = [GVLUtils toPointF:bez.sp height:height];
            CGPathMoveToPoint(path, NULL, p1.x, p1.y);
            CGPoint p2 = [GVLUtils toPointF:bez.list[0] height:height];
            CGPathAddLineToPoint(path, NULL, p2.x, p2.y);
        } else {
            CGPoint p = [GVLUtils toPointF:bez.list[0] height:height];
            CGPathMoveToPoint(path, NULL, p.x, p.y);
        }
        // Loop over the curve points
        for (int i = 1; i < bez.size; i += 3) {
            CGPoint p1 = [GVLUtils toPointF:bez.list[i] height:height];
            CGPoint p2 = [GVLUtils toPointF:bez.list[i + 1] height:height];
            CGPoint p3 = [GVLUtils toPointF:bez.list[i + 2] height:height];
            CGPathAddCurveToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, p3.x,
                                  p3.y);
        }

        // If there is an ending point, draw a line to it
        if (bez.eflag) {
            CGPoint p = [GVLUtils toPointF:bez.ep height:height];
            CGPathMoveToPoint(path, NULL, p.x, p.y);
        }
    }
    return path;
}

+ (CGPathRef)toPath:(NSArray *)points {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint start = [[points firstObject] CGPointValue];
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    for (int i = 1; points.count > i; i++) {
        CGPoint point = [points[i] CGPointValue];
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    return path;
}

+ (CGPoint)toPointF:(pointf)p height:(float)height {
    return CGPointMake(p.x, height - p.y);
}

+ (CGPoint)toPoint:(point)p height:(float)height {
    return CGPointMake(p.x, height - p.y);
}

+ (CGPoint)centerToOrigin:(CGPoint)point
                    width:(float)width
                   height:(float)height {
    return CGPointMake(point.x - width / 2, point.y - height / 2);
}

+ (CGColorRef)toColor:(NSString *)name {
    UIColor *color = [UIColor colorNamed:name];
    return color.CGColor;
}

+ (UIBezierPath *)arrowFrom:(CGPoint)start
                         to:(CGPoint)end
                  tailWidth:(CGFloat)tailWidth
                  headWidth:(CGFloat)headWidth
                 headLength:(CGFloat)headLength {

    CGFloat length = hypotf(end.x - start.x, end.y - start.y);
    CGFloat tailLength = length - headLength;

    CGPoint points[7];

    points[0] = CGPointMake(0, tailWidth / 2);
    points[1] = CGPointMake(tailLength, tailWidth / 2);
    points[2] = CGPointMake(tailLength, headWidth / 2);
    points[3] = CGPointMake(length, 0);
    points[4] = CGPointMake(tailLength, -headWidth / 2);
    points[5] = CGPointMake(tailLength, -tailWidth / 2);
    points[6] = CGPointMake(0, -tailWidth / 2);

    CGFloat cosine = (end.x - start.x) / length;
    CGFloat sine = (end.y - start.y) / length;

    CGAffineTransform transform =
        CGAffineTransformMake(cosine, sine, -sine, cosine, start.x, start.y);

    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathAddLines(cgPath, &transform, points, sizeof points / sizeof *points);

    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:cgPath];
    [bezierPath closePath];
    CGPathRelease(cgPath);
    return bezierPath;
}

@end

@implementation GVLConfig
+ (float)dpi {
    return _dpi;
}
+ (void)setDpi:(float)value {
    _dpi = value;
}
@end
