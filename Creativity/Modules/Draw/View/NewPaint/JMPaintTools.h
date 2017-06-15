//
//  JMPaintTools.h
//  YaoYao
//
//  Created by JM Zhao on 2016/12/22.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_feature(objc_arc)
#define ACE_HAS_ARC 1
#define ACE_RETAIN(exp) (exp)
#define ACE_RELEASE(exp)
#define ACE_AUTORELEASE(exp) (exp)
#else
#define ACE_HAS_ARC 0
#define ACE_RETAIN(exp) [(exp) retain]
#define ACE_RELEASE(exp) [(exp) release]
#define ACE_AUTORELEASE(exp) [(exp) autorelease]
#endif

@protocol JMPaintTool <NSObject>

@property (nonatomic, strong) UIColor *linesColor;
@property (nonatomic, assign) CGFloat linesAlpha;
@property (nonatomic, assign) CGFloat linesWidth;
@property (nonatomic, assign) CGFloat linesOffSet;
@property (nonatomic, assign) BOOL LineDash;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;
- (void)draw;
- (void)transform;
@end

#pragma mark - 正常画线
@interface JMPaintPenTool : UIBezierPath<JMPaintTool>

@end

#pragma mark - 直线
@interface JMPaintLineTool : NSObject<JMPaintTool>

@end

#pragma mark - 矩形
@interface JMPaintRectangleTool : NSObject<JMPaintTool>
@property (nonatomic, assign) BOOL fill;
@end

#pragma mark - 椭圆
@interface JMPaintEllipseTool : NSObject<JMPaintTool>
@property (nonatomic, assign) BOOL fill;
@end

#pragma mark 箭头
@interface DrawingToolArrow : NSObject<JMPaintTool>

@end

#pragma mark 图片
@interface JMPaintToolImage : NSObject<JMPaintTool>
@property (nonatomic, copy) NSString *drawImage;
@property (nonatomic, strong) UIImage *image;
@end

#pragma mark 文字
@interface JMPaintToolText : NSObject<JMPaintTool>
@property (nonatomic, copy) NSString *drawText;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSInteger type;
@end

//#pragma mark 文字
//@interface JMPaintToolNet : NSObject<JMPaintTool>
//@property (nonatomic, assign) CGFloat width;
//@property (nonatomic, assign) CGFloat height;
//@property (nonatomic, assign) CGFloat distanceWidth;
//@property (nonatomic, assign) CGFloat distanceHeight;
//@end

