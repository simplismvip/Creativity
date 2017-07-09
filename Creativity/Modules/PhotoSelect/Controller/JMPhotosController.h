//
//  JMPhotosController.h
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMBaseController.h"

@protocol JMPhotosControllerDelegate <NSObject>

@optional
- (void)pickerPhotosSuccess:(NSArray *)photos;
- (void)canclePicker;

@end

@interface JMPhotosController : JMBaseController
@property (nonatomic, weak) id <JMPhotosControllerDelegate>delegate;
@property (nonatomic, strong) NSArray *models;
@end
