//
//  JMFilterItem.h
//  JMAlertView
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMFilterItem : UIView
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *vip;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *tinColor;
@end
