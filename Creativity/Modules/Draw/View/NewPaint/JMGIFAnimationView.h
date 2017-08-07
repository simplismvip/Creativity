//
//  JMGIFAnimationView.h
//  Creativity
//
//  Created by JM Zhao on 2017/7/5.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^frameChange)(NSInteger index);
@interface JMGIFAnimationView : UIView
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) NSArray *imageSource;
@property (nonatomic, assign) CGFloat delayer;
@property (nonatomic, copy) frameChange frameChange;
- (void)startAnimation:(NSTimeInterval)timeInterval;
- (void)pauseAnimation;
- (void)restartAnimation;
- (void)stopAnimation;
@end
