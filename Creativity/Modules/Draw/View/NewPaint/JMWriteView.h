//
//  JMWriteView.h
//  YaoYao
//
//  Created by JM Zhao on 2016/12/22.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMWriteView : UIView
@property (nonatomic, strong) UIColor *linesColor;
@property (nonatomic, assign) CGFloat linesAlpha;
@property (nonatomic, assign) CGFloat linesWidth;

- (BOOL)canUndo;
- (BOOL)canRedo;
- (void)clear;
- (void)undoLatestStep;
- (void)redoLatestStep;

@end
