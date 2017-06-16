//
//  JMDrawViewController.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/9.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMBaseController.h"

@interface JMDrawViewController : JMBaseController
@property (nonatomic, copy) NSString *folderPath;
@property (nonatomic, assign) BOOL fromGif;
- (void)creatGifNew;
- (void)creatGif:(NSArray *)images;
@end
