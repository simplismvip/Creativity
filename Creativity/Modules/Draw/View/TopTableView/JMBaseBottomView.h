//
//  JMBaseBottomView.h
//  JMAlertView
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMBaseBottomViewDelegate <NSObject>
- (void)didSelectRowAtIndexPath:(NSInteger)index;
@end
@interface JMBaseBottomView : UIView
- (instancetype)initWithCount:(NSArray *)subViews;
@property (nonatomic, weak) id <JMBaseBottomViewDelegate>delegate;
@end
