//
//  GVLGraph.h
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com.
//  MIT License
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "gvc.h"

@interface GVLNode : NSObject
@property Agraph_t* parent;
@property Agnode_t* node;
@property NSString* label;
-(void)setAttribute:(NSString*)value forKey:(NSString*)key;
-(NSString*)getAttributeForKey:(NSString*)key;
-(void)prepare;
-(UIBezierPath*)path;
-(CGPoint)origin;
-(CGRect)frame;
-(CGRect)bounds;
@end

@interface GVLEdge : NSObject
@property Agraph_t* parent;
@property Agedge_t* edge;
-(void)setAttribute:(NSString*)value forKey:(NSString*)key;
-(NSString*)getAttributeForKey:(NSString*)key;
-(void)prepare;
-(CGRect)frame;
-(CGRect)bounds;
-(UIBezierPath*)path;
-(UIBezierPath*)body;
-(UIBezierPath*)headArrow;
-(UIBezierPath*)tailArrow;
@end

@interface GVLGraph : NSObject

@property NSMutableArray<GVLNode*>* nodes;
@property NSMutableArray<GVLEdge*>* edges;

-(NSString*)getAttributeForKey:(NSString*)key;

-(void)setAttribute:(NSString*)value forKey:(NSString*)key;

-(GVLNode*)addNode:(NSString*)label;
-(GVLEdge*)addEdgeWithSource:(GVLNode*)source andTarget:(GVLNode*)target;
//-(id)addSubGraph;

-(BOOL)deleteNode:(GVLNode*)node;
-(BOOL)deleteEdge:(GVLEdge*)edge;
-(BOOL)loadLayout:(NSString*)text;
-(BOOL)applyLayout;
-(CGSize)size;

@end

@interface GVLUtils : NSObject
+(float)getHeightForGraph:(Agraph_t*)graph;
+(NSMutableArray*)toPolygon:(const polygon_t*)poly width:(float)width height:(float)height;
+(CGPathRef)toPathWithType:(const char*)type poly:(const polygon_t *)poly width:(float)width height:(float)height;
+(CGPathRef)toPathWithSplines:(const splines*)spl height:(float)height;
+(CGPathRef)toPath:(NSArray*)points;
+(CGPoint)toPointF:(pointf)p height:(float)height;
+(CGPoint)toPoint:(point)p height:(float)height;
+(CGPoint)centerToOrigin:(CGPoint)point width:(float)width height:(float)height;
// +(?)toBrushStyle:(NSString*) style;
// +(?)toPenStyle:(NSString*)style;
+(CGColorRef)toColor:(NSString*)name;
+(UIBezierPath*)arrowFrom:(CGPoint)start to:(CGPoint)end tailWidth:(CGFloat)tailWidth headWidth:(CGFloat)headWidth headLength:(CGFloat)headLength;
@end

@interface GVLConfig : NSObject
+(float)dpi;
+(void)setDpi:(float)value;
@end
