//
//  JMDrawViewController.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/9.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMBaseController.h"

@class JMGetGIFController;
@interface JMDrawViewController : JMBaseController
@property (nonatomic, copy) NSString *folderPath;
// - (void)addNewPaintView;
// - (void)presentDrawViewController:(JMGetGIFController *)parentController images:(NSArray *)images;
- (void)initPaintBoard:(JMGetGIFController *)parentController images:(NSArray *)images;
@end
