//
//  JMPaintView.h
//  YaoYao
//
//  Created by JM Zhao on 2016/12/22.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JMPaintViewVersion   1.0.0

typedef enum {
    JMPaintToolTypePen = 0,
    JMPaintToolTypeLine,
    JMPaintToolTypeArrow,
    JMPaintToolTypeRectagle,
    JMPaintToolTypeEllipse,
    JMPaintToolTypeImage,
    JMPaintToolTypeText,
    JMPaintToolTypeNet,
    
} JMPaintToolType;

@protocol JMPaintViewDelegate, JMPaintTool;

@interface JMPaintView : UIView

@property (nonatomic, assign) JMPaintToolType drawType;
@property (nonatomic, assign) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) BOOL lineDash;
@property (nonatomic, assign) BOOL isFill;
@property (nonatomic, strong) UIImage *image;

// 花表情
@property (nonatomic, copy) NSString *paintImage;
@property (nonatomic, copy) NSString *paintText;
@property (nonatomic, assign, readonly) NSUInteger undoSteps;
@property (nonatomic, weak) id<JMPaintViewDelegate> delegate;

- (BOOL)canUndo;
- (BOOL)canRedo;
- (void)clearAll;
- (void)undoLatestStep;
- (void)redoLatestStep;
- (void)startPaint;

@end

