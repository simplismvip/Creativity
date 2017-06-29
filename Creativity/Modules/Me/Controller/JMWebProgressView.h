//
//  JMWebProgressView.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/2.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface JMWebProgressView : CAShapeLayer
- (void)finishedLoad;
- (void)startLoad;
- (void)closeTimer;
@end
