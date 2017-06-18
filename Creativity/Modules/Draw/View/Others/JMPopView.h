//
//  JMPopView.h
//  Local_Notifacation
//
//  Created by JM Zhao on 2017/5/2.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMPopView : UIView
@property (nonatomic, copy) NSString *content;
- (void)animationActive;
+ (void)popView:(UIView *)superView title:(NSString *)title;
@end
