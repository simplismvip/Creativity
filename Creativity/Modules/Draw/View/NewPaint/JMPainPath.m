//
//  JMPainPath.m
//  
//
//  Created by Mac on 15/4/18.
//
//

#import "JMPainPath.h"

@implementation JMPainPath

+ (instancetype)paintPathWithLineWidth:(CGFloat)width color:(UIColor *)color startPoint:(CGPoint)startP
{
    JMPainPath *path = [[self alloc] init];
    path.lineWidth = width;
    path.color = color;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:startP];
    return path;
}

+ (instancetype)paintArcWithWidth:(CGFloat)width color:(UIColor *)color CGRect:(CGRect)rect
{
    JMPainPath *path = [JMPainPath bezierPathWithArcCenter:CGPointMake(rect.origin.x, rect.origin.y) radius:rect.size.width startAngle:0 endAngle:180 clockwise:YES];
    path.lineWidth = width;
    path.color = color;
    return path;
}

+ (instancetype)paintRectWithWidth:(CGFloat)width color:(UIColor *)color CGRect:(CGRect)rect
{
    JMPainPath *path = [JMPainPath bezierPathWithRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    path.lineWidth = width;
    path.color = color;
    return path;
}

+ (instancetype)paintEllipseWithWidth:(CGFloat)width color:(UIColor *)color CGRect:(CGRect)rect
{
    JMPainPath *path = [JMPainPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    path.lineWidth = width;
    path.color = color;
    return path;
}

@end
