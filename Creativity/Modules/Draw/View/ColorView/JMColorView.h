//
//  JMColorView.h
//  YaoYao
//
//  Created by JM Zhao on 2017/5/2.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^colorBlock)(UIColor *color);
@interface JMColorView : UIView
@property (nonatomic, copy) colorBlock colorBlock;
@property (nonatomic, copy) NSString *color_Alpha;
@end
