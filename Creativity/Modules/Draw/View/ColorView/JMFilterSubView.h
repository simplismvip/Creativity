//
//  JMFilterSubView.h
//  YaoYao
//
//  Created by JM Zhao on 2017/5/5.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMFilterSubView : UIView
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *tinColor;
@end
