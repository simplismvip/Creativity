//
//  JMPainPath.h
//  
//
//  Created by Mac on 15/4/18.
//
//

#import <UIKit/UIKit.h>

@interface JMPainPath : UIBezierPath

@property (nonatomic, strong) UIColor *color;
+ (instancetype)paintArcWithWidth:(CGFloat)width color:(UIColor *)color CGRect:(CGRect)rect;
+ (instancetype)paintRectWithWidth:(CGFloat)width color:(UIColor *)color CGRect:(CGRect)rect;
+ (instancetype)paintEllipseWithWidth:(CGFloat)width color:(UIColor *)color CGRect:(CGRect)rect;
+ (instancetype)paintPathWithLineWidth:(CGFloat)width color:(UIColor *)color startPoint:(CGPoint)startP;
@end
