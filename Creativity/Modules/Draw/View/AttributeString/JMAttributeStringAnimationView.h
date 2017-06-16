//
//  JMAttributeStringAnimationView.h
//  YaoYao
//
//  Created by JM Zhao on 2017/5/19.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^attributeStringSet)(NSString *fontName);
@interface JMAttributeStringAnimationView : UIView
@property (nonatomic, copy) attributeStringSet attributeString;
@end
