//
//  JMCreatPaintView.h
//  DateDemo
//
//  Created by JM Zhao on 2017/6/14.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMCreatPaintView;
@protocol JMCreatPaintViewDelegate <NSObject>
- (void)newCallback;
- (void)touchItem:(NSInteger)index;
@end

@interface JMCreatPaintView : UIView
@property (nonatomic, weak) id <JMCreatPaintViewDelegate>delegate;
- (void)reloadData:(UIImage *)newImage;
@end
