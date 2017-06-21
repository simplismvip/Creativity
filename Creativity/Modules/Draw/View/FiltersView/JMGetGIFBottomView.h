//
//  JMGetGIFBottomView.h
//  JMAlertView
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMGetGIFBottomViewDelegate <NSObject>
- (void)didSelectRowAtIndexPath:(NSInteger)index;
- (void)changeValue:(CGFloat)value;
@end
@interface JMGetGIFBottomView : UIView

@property (nonatomic, weak) id <JMGetGIFBottomViewDelegate>delegate;
@property (nonatomic, weak) UISlider *sliderA;
@property (nonatomic, strong) NSArray *subViews;
@end
