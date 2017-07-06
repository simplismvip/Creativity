//
//  JMProHeaderView.h
//  Creativity
//
//  Created by 赵俊明 on 2017/6/20.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMProHeaderViewDelegate <NSObject>

- (void)buyPro;

@end
@interface JMProHeaderView : UIView
- (void)refruseView;
@property (nonatomic, weak) id <JMProHeaderViewDelegate>delegate;
@end
