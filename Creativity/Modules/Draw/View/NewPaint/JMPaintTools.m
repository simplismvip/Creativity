//
//  JMPaintTools.m
//  YaoYao
//
//  Created by JM Zhao on 2016/12/22.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMPaintTools.h"
#import "StaticClass.h"

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - JMPaintPenTool
@implementation JMPaintPenTool

@synthesize LineDash = _LineDash;
@synthesize linesOffSet = _linesOffSet;
@synthesize linesColor = _linesColor;
@synthesize linesAlpha = _linesAlpha;
@synthesize linesWidth = _linesWidth;

- (id)init
{
    self = [super init];
    if (self != nil) {
        
        self.lineCapStyle = kCGLineCapRound;
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    [self moveToPoint:firstPoint];
    self.lineWidth = _linesWidth;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    // _linesWidth = [self writeModel:startPoint currentPoint:endPoint width:_linesWidth];
    // self.lineWidth = _linesWidth;
    
    [self addQuadCurveToPoint:midPoint(endPoint, startPoint) controlPoint:startPoint];
}

- (void)draw
{
    [self.linesColor setStroke];
    
    if (self.LineDash) {
        
        CGFloat dashPattern[] = {5,5};
        [self setLineDash:dashPattern count:2 phase:0];
    }
    
    JMLog(@"dash == %d", self.LineDash);
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.linesAlpha];
}

// 矩阵操作
- (void)transform
{

}

- (CGFloat)writeModel:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint width:(CGFloat)width
{
    CGFloat xDist = (previousPoint.x - currentPoint.x); //[2]
    CGFloat yDist = (previousPoint.y - currentPoint.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
    
    distance = distance / 10;
    
    if (distance > 10) {
        distance = 10.0;
    }
    
    distance = distance / 10;
    distance = distance * 3;
    
    if (4.0 - distance > width) {
        width = width + 0.3;
    } else {
        width = width - 0.3;
    }
    
    return width;

}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark - JMPaintLineTool
@interface JMPaintLineTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -
@implementation JMPaintLineTool

@synthesize linesOffSet = _linesOffSet;
@synthesize LineDash = _LineDash;
@synthesize linesColor = _linesColor;
@synthesize linesAlpha = _linesAlpha;
@synthesize linesWidth = _linesWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.linesColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.linesWidth);
    CGContextSetAlpha(context, self.linesAlpha);
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    
    if (self.LineDash) {
        
        CGFloat arr[] = {5,5};
        CGContextSetLineDash(context, 0, arr, 2);
    }
    
    CGContextStrokePath(context);
}

// 矩阵操作
- (void)transform
{
    
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark - JMPaintRectangleTool

@interface JMPaintRectangleTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -
@implementation JMPaintRectangleTool

@synthesize linesOffSet = _linesOffSet;
@synthesize LineDash = _LineDash;
@synthesize linesColor = _linesColor;
@synthesize linesAlpha = _linesAlpha;
@synthesize linesWidth = _linesWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.linesAlpha);
    
    // draw the rectangle
    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    if (self.fill) {
        
        CGContextSetFillColorWithColor(context, self.linesColor.CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    } else {
        
        if (self.LineDash) {
            
            CGFloat arr[] = {5,5};
            CGContextSetLineDash(context, 0, arr, 2);
        }
        
        CGContextSetStrokeColorWithColor(context, self.linesColor.CGColor);
        CGContextSetLineWidth(context, self.linesWidth);
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

// 矩阵操作
- (void)transform
{
    
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark - JMPaintEllipseTool
@interface JMPaintEllipseTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -
@implementation JMPaintEllipseTool

@synthesize linesOffSet = _linesOffSet;
@synthesize LineDash = _LineDash;
@synthesize linesColor = _linesColor;
@synthesize linesAlpha = _linesAlpha;
@synthesize linesWidth = _linesWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.linesAlpha);
    
    // draw the ellipse
    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    if (self.fill) {
        
        CGContextSetFillColorWithColor(context, self.linesColor.CGColor);
        CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    } else {
        
        if (self.LineDash) {
            
            CGFloat arr[] = {5,5};
            CGContextSetLineDash(context, 0, arr, 2);
        }
        
        CGContextSetStrokeColorWithColor(context, self.linesColor.CGColor);
        CGContextSetLineWidth(context, self.linesWidth);
        CGContextStrokeEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

// 矩阵操作
- (void)transform
{
    
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif


@end


#pragma mark 箭头
@interface DrawingToolArrow ()

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;

@end
#pragma mark -
@implementation DrawingToolArrow

@synthesize linesOffSet = _linesOffSet;
@synthesize LineDash = _LineDash;
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;
@synthesize linesColor = _linesColor;
@synthesize linesAlpha = _linesAlpha;
@synthesize linesWidth = _linesWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat capHeight = self.linesWidth * 4;
    
    // 设置属性
    CGContextSetStrokeColorWithColor(context, self.linesColor.CGColor);
    CGContextSetLineWidth(context, self.linesWidth);
    CGContextSetAlpha(context, self.linesAlpha);
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    // 设置箭头曲线
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    
    // 绘制箭头帽
    CGFloat angle = [self angleWithFirstPoint:self.firstPoint andSecondPoint:self.lastPoint];
    CGPoint p1Point = [self pointWithAngle:angle+7.0f*M_PI/8.0f andDistant:capHeight];
    CGPoint p2Point = [self pointWithAngle:angle-7.0f*M_PI/8.0f andDistant:capHeight];
    CGPoint endPointOffset = [self pointWithAngle:angle andDistant:self.linesWidth];
    
    p1Point = CGPointMake(self.lastPoint.x+p1Point.x, self.lastPoint.y+p1Point.y);
    p2Point = CGPointMake(self.lastPoint.x+p2Point.x, self.lastPoint.y+p2Point.y);
    
    CGContextMoveToPoint(context, p1Point.x, p1Point.y);
    CGContextAddLineToPoint(context, endPointOffset.x+self.lastPoint.x, endPointOffset.y+self.lastPoint.y);
    CGContextAddLineToPoint(context, p2Point.x, p2Point.y);
    
    if (self.LineDash) {
        
        CGFloat arr[] = {5,5};
        CGContextSetLineDash(context, 0, arr, 2);
    }

    CGContextStrokePath(context);
}

- (CGFloat)angleWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint
{
    CGFloat dx = secondPoint.x - firstPoint.x;
    CGFloat dy = secondPoint.y - firstPoint.y;
    CGFloat angle = atan2f(dy, dx);
    return angle;
}

- (CGPoint)pointWithAngle:(CGFloat)angle andDistant:(CGFloat)distant
{
    CGFloat x = distant * cos(angle);
    CGFloat y = distant * sin(angle);
    
    return CGPointMake(x, y);
}

// 矩阵操作
- (void)transform
{
    
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark 图片
@interface JMPaintToolImage ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

@implementation JMPaintToolImage

@synthesize linesOffSet = _linesOffSet;
@synthesize LineDash = _LineDash;
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;

@synthesize linesColor = _linesColor;
@synthesize linesAlpha = _linesAlpha;
@synthesize linesWidth = _linesWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    if (self.image) {
        
        CGPoint point = CGPointMake(0, 0);
        [_image drawAtPoint:point];
        _image = nil;
        
    }else {
    
        UIImage *image = [[UIImage imageNamed:self.drawImage] imageByApplyingAlpha:_linesAlpha];
        CGPoint point = CGPointMake(_lastPoint.x-self.linesOffSet, _lastPoint.y-self.linesOffSet);
        [image drawAtPoint:point];
        image = nil;
    }
}

// 矩阵操作
- (void)transform
{
    
}

#if !ACE_HAS_ARC
- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif
@end

#pragma mark 文字绘制
#import "JMAttributeString.h"
@interface JMPaintToolText()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

@implementation JMPaintToolText

@synthesize linesOffSet = _linesOffSet;
@synthesize LineDash = _LineDash;
@synthesize firstPoint = _firstPoint;
@synthesize lastPoint = _lastPoint;
@synthesize linesColor = _linesColor;
@synthesize linesAlpha = _linesAlpha;
@synthesize linesWidth = _linesWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    NSDictionary *dic = [JMAttributeString attributeString:self.type color1:self.linesColor color2:[UIColor blackColor] fontSize:self.fontSize+20.0 fontName:self.fontName];
    CGPoint point = CGPointMake(_lastPoint.x-self.linesOffSet*2, _lastPoint.y-self.linesOffSet*0.5);
    [self.drawText drawAtPoint:point withAttributes:dic];
}

// 矩阵操作
- (void)transform
{
    
}

#if !ACE_HAS_ARC
- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif
@end

//#pragma mark 绘制网格
//@interface JMPaintToolNet()
//@property (nonatomic, assign) CGPoint firstPoint;
//@property (nonatomic, assign) CGPoint lastPoint;
//@end
//
//@implementation JMPaintToolNet
//
//@synthesize LineDash = _LineDash;
//@synthesize firstPoint = _firstPoint;
//@synthesize lastPoint = _lastPoint;
//@synthesize linesColor = _linesColor;
//@synthesize linesAlpha = _linesAlpha;
//@synthesize linesWidth = _linesWidth;
//
//- (void)setInitialPoint:(CGPoint)firstPoint
//{
//    self.firstPoint = firstPoint;
//}
//
//- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
//{
//    self.lastPoint = endPoint;
//}
//
//- (void)draw
//{
//    while (_distanceWidth < self.width) {
//        
//        CGPoint pointStart = CGPointMake(_distanceWidth, 0);
//        CGPoint pointEnd = CGPointMake(_distanceWidth, self.height);
//        _distanceWidth = _distanceWidth + 20;
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetStrokeColorWithColor(context, self.linesColor.CGColor);
//        CGContextSetLineCap(context, kCGLineCapRound);
//        CGContextSetLineWidth(context, self.linesWidth);
//        CGContextSetAlpha(context, self.linesAlpha);
//        CGContextMoveToPoint(context, pointStart.x, pointStart.y);
//        CGContextAddLineToPoint(context, pointEnd.x, pointEnd.y);
//        
//        if (self.LineDash) {
//            
//            CGFloat arr[] = {5,5};
//            CGContextSetLineDash(context, 0, arr, 2);
//        }
//        
//        CGContextStrokePath(context);
//        
//    }
//    
//    while (_distanceHeight < self.height) {
//        
//        CGPoint pointStart = CGPointMake(0, _distanceHeight);
//        CGPoint pointEnd = CGPointMake(self.width, _distanceHeight);
//        _distanceHeight = _distanceHeight + 20;
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetStrokeColorWithColor(context, self.linesColor.CGColor);
//        CGContextSetLineCap(context, kCGLineCapRound);
//        CGContextSetLineWidth(context, self.linesWidth);
//        CGContextSetAlpha(context, self.linesAlpha);
//        CGContextMoveToPoint(context, pointStart.x, pointStart.y);
//        CGContextAddLineToPoint(context, pointEnd.x, pointEnd.y);
//        
//        if (self.LineDash) {
//            
//            CGFloat arr[] = {5,5};
//            CGContextSetLineDash(context, 0, arr, 2);
//        }
//        
//        CGContextStrokePath(context);
//    }
//}
//
//// 矩阵操作
//- (void)transform
//{
//    
//}
//
//#if !ACE_HAS_ARC
//- (void)dealloc
//{
//    self.lineColor = nil;
//    [super dealloc];
//}
//
//#endif
//@end


