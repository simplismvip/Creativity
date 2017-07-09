//
//  JMPhotosAlertView.h
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMPhotosAlertViewDelegate <NSObject>
- (void)photoFromSource:(NSInteger)sourceType;
@end
@interface JMPhotosAlertView : UIView
@property (nonatomic, weak) id <JMPhotosAlertViewDelegate>delegate;
@end
