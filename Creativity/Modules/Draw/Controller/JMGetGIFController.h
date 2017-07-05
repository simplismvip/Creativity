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
@property (nonatomic, assign) CGFloat delayTime;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imagesFromDrawVC;
@property (nonatomic, strong) NSMutableArray *imagesFromHomeVC;

@end
