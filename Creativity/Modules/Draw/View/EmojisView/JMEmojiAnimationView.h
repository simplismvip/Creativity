//
//  JMEmojiAnimationView.h
//  YaoYao
//
//  Created by 赵俊明 on 2017/5/4.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^animationBlock)(id model);

@interface JMEmojiAnimationView : UIView
@property (nonatomic, copy) animationBlock animationBlock;
@end
