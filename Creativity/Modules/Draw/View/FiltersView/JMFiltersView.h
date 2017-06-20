//
//  JMFiltersView.h
//  YaoYao
//
//  Created by JM Zhao on 2017/5/5.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^filterBlock)(NSInteger type);
@interface JMFiltersView : UIScrollView
@property (nonatomic, copy) filterBlock filter;
@property (nonatomic, strong) UIColor *tinColor;
@property (nonatomic, strong) NSArray *titles;
@end
