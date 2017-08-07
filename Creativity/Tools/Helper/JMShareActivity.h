//
//  JMShareActivity.h
//  dsaf
//
//  Created by JM Zhao on 2017/8/7.
//  Copyright © 2017年 huaban. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMShareActivityDelegate <NSObject>

- (void)share:(NSString *)type;

@end
@interface JMShareActivity : UIActivity
@property (nonatomic, weak) id <JMShareActivityDelegate>delegate;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *urlString;
@property (nonatomic) NSString *shareDescription;
@property (nonatomic) NSString *shareTitle;
@property (nonatomic) UIImage *image;
- (instancetype)initWithTitle:(NSString *)title type:(NSString *)types;
@end
