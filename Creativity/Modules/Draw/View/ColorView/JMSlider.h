//
//  JMSlider.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/26.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMSlider;
typedef void(^SliderValue)(JMSlider *value);
typedef void(^SliderDragUp)(BOOL hide);
typedef void(^SliderDragUpEnd)(BOOL hide);

@interface JMSlider : UIView
@property (nonatomic, copy) SliderValue value;
@property (nonatomic, copy) SliderDragUp dragUp;
@property (nonatomic, copy) SliderDragUpEnd dragUpEnd;
/**
 *UISlider 的值
 */
@property (nonatomic, assign) CGFloat sValue;
@property (nonatomic, weak) UILabel *title;
/**
 *UISlider
 */
@property (nonatomic, weak) UISlider *slider;
@end
