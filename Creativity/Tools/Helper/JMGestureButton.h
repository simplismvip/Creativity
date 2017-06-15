//
//  JMGestureButton.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/19.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMGestureButtonDelegate <NSObject>
- (void)didRemove;
@end

@interface JMGestureButton : UIButton
@property (nonatomic, weak) id <JMGestureButtonDelegate>delegate;
+ (JMGestureButton *)creatGestureButton;
+ (JMGestureButton *)creatGestureButton:(UIView *)suView;
+ (JMGestureButton *)getGestureButton;
- (void)rem_GestureBtn:(JMGestureButton *)sender;
@end
