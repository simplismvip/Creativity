//
//  JMHomeCollectionController.h
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMBaseController.h"

@interface JMHomeCollectionController : JMBaseController
- (void)refreshData;
//- (void)leftSwitchEditerStatus;
@property (nonatomic, copy) NSString *key;
@end
