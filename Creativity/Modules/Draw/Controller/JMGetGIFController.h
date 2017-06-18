//
//  JMGetGIFController.h
//  Creativity
//
//  Created by JM Zhao on 2017/6/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMGetGIFController : UIViewController
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) BOOL isHome;
@end
