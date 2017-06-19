//
//  JMBaseColorView.h
//  YaoYao
//
//  Created by 赵俊明 on 2017/6/6.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^colorBlock)(UIColor *color);
@interface JMBaseColorView : UIScrollView
@property (nonatomic, copy) colorBlock colorBlock;
@end
