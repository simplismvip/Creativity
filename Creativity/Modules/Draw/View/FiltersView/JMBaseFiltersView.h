//
//  JMBaseFiltersView.h
//  JMAlertView
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMBaseFiltersViewDelegate <NSObject>

- (void)baseFiltersSelectIndex:(NSInteger)index;
- (void)removeSelf;
@end
@interface JMBaseFiltersView : UIView
@property (nonatomic, weak) id <JMBaseFiltersViewDelegate>delegate;
@end
