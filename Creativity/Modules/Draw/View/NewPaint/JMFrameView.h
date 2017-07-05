//
//  JMFrameView.h
//  Creativity
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMFrameView : UIView
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) CGFloat delayTimer;
- (void)pauseAnimation;
- (void)restartAnimation;
@end
