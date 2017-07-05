//
//  JMWriteView.m
//  YaoYao
//
//  Created by JM Zhao on 2016/12/22.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMWriteView.h"

@interface JMWriteView()
{
    CGPoint lastPoint;
    CGPoint prePreviousPoint;
    CGPoint previousPoint;
    CGPoint mid1;
    CGPoint mid2;
    CGPoint currentPoint;
}

@property (nonatomic, strong) UIImage *paintImage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;

// 记录点
@property (nonatomic, strong) NSMutableArray *points;

@end

@implementation JMWriteView

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {self.dataArray = [NSMutableArray array];}
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.linesWidth = 4.0;
        self.linesColor = [UIColor blackColor];
        self.linesAlpha = 1.0;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    previousPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    prePreviousPoint = previousPoint;
    previousPoint = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    // calculate mid point
    mid1 = [self calculateMidPointForPoint:previousPoint andPoint:prePreviousPoint];
    mid2 = [self calculateMidPointForPoint:currentPoint andPoint:previousPoint];
    
    // 1> 开启画板上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.paintImage drawInRect:self.bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, previousPoint.x, previousPoint.y, mid2.x, mid2.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    _linesWidth = [self writeModel:previousPoint currentPoint:currentPoint width:_linesWidth];
    [[self linesColor] setStroke];
    CGContextSetAlpha(context, self.linesAlpha);
    CGContextSetLineWidth(context, self.linesWidth);
    
    CGContextStrokePath(context);
    
    self.paintImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (CGFloat)writeModel:(CGPoint)prePoint currentPoint:(CGPoint)currPoint width:(CGFloat)width
{
    CGFloat xDist = (prePoint.x - currPoint.x); //[2]
    CGFloat yDist = (prePoint.y - currPoint.y); //[3]
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

- (CGPoint)calculateMidPointForPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    
    return CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setLinesWidth:1.0];
}

- (void)drawRect:(CGRect)rect
{
    [self.paintImage drawInRect:self.bounds];
}

- (void)clear
{
    self.paintImage = nil;
    [self setNeedsDisplay];
}

@end
