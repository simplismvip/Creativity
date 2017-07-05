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
@property (nonatomic, assign) CGFloat delayTime;

// @property (nonatomic, weak) UIImageView *imageView;
//@property (nonatomic, weak) UIImage *imagefromHome;

@property (nonatomic, strong) NSMutableArray *imagesFromDrawVC;
@property (nonatomic, strong) NSMutableArray *imagesFromHomeVC;

@end
