//
//  JMGIFAnimationView.h
//  Creativity
//
//  Created by JM Zhao on 2017/7/5.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMGIFAnimationView : UIView
@property (nonatomic, strong) NSArray *imageSource;
@property (nonatomic, assign) CGFloat delayer;
- (void)startAnimation:(NSTimeInterval)timeInterval;
- (void)pauseAnimation;
- (void)restartAnimation;
@end
