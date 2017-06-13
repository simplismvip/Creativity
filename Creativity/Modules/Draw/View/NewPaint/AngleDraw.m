//
//  AngleDraw.m
//  demo_Draw
//
//  Created by 成都成都 on 16/4/28.
//  Copyright © 2016年 影达科技有限公司. All rights reserved.
//

#import "AngleDraw.h"
#define pi 3.14159265358979323846
#define radiansToDegrees(x) (180.0 * x / pi)

@interface AngleDraw ()

@end

@implementation AngleDraw

//- (void)Draw
//{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    if (_isSecond == NO) {
//        UIBezierPath *bPath = [UIBezierPath new];
//        [bPath moveToPoint:self.firstStart];
//        [bPath addLineToPoint:self.firstEnd];
//        [bPath setLineWidth:self.width];
//        [self.color setStroke];
//        
//        [bPath stroke];
//        
//    }else
//    {
//        UIBezierPath *bPath = [UIBezierPath new];
//        [bPath moveToPoint:self.firstStart];
//        [bPath addLineToPoint:self.firstEnd];
//        [bPath setLineWidth:self.width];
//        [self.color setStroke];
//    
//        [bPath stroke];
//        
//        UIBezierPath *cPath = [UIBezierPath new];
//        [cPath moveToPoint:self.firstEnd];
//        [cPath addLineToPoint:self.end];
//        [cPath setLineWidth:self.width];
//        [self.color setStroke];
//        
//        [cPath stroke];
//        
//
//        CGPoint newStartPoint = CGPointMake(self.firstEnd.x - 20, self.firstEnd.y);
//        
//        /**
//         *  获取第一个条线的弧度
//         */
//        CGFloat indexStart = [self getAngleAndStart:self.firstStart andEnd:newStartPoint andCenter:self.firstEnd];
//        if (self.firstStart.y - newStartPoint.y > 0) {
//            indexStart = 360.0 - indexStart;
//        }
//        /**
//         *  获取第二个条线的弧度
//         */
//        CGFloat indexEnd = [self getAngleAndStart:self.end andEnd:newStartPoint andCenter:self.firstEnd];
//        if (self.end.y - newStartPoint.y > 0) {
//            indexEnd = 360.0 - indexEnd;
//        }
//        
//        
//        /**
//         *  画出弧度
//         */
//        CGContextAddArc(ctx,self.firstEnd.x,self.firstEnd.y, 10, -indexStart/90*M_PI_2,-indexEnd/90*M_PI_2,0);
//        CGContextStrokePath(ctx);
//        
//        CGFloat index = indexEnd - indexStart;
//        if (index < 0) {
//          
//            index = -index;
//        }else{
//            index =  360.0 - index;
//        }
//        
//        NSString *str = [NSString stringWithFormat:@"%.2f",index];
//        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//        CGRect cubeRect = CGRectMake(self.firstEnd.x, self.firstEnd.y, 35, 10);
//        attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.229 green:0.610 blue:0.547 alpha:1.000];
//        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
//        [str drawInRect:cubeRect withAttributes:attrs];
//
//    }
//}
//
///**
// *  计算弧度三点之间的弧度
// *
// *  @param start
// *  @param end
// *  @param center
// *
// *  @return
// */
//- (CGFloat)getAngleAndStart:(CGPoint)start andEnd:(CGPoint)end andCenter:(CGPoint)center
//{
//    CGFloat a = center.x - start.x;
//    CGFloat b = center.y - start.y;
//    CGFloat c = end.x - center.x;
//    CGFloat d = end.y - center.y;
//    
//    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
//    CGFloat index = radiansToDegrees(rads);
//    return index;
//}


@end
