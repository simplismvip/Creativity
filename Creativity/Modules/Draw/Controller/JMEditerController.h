//
//  JMEditerController.h
//  Creativity
//
//  Created by 赵俊明 on 2017/7/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMBaseController.h"

typedef void(^EditerDone)(NSMutableArray *images);
@interface JMEditerController : JMBaseController
@property (nonatomic, strong) NSMutableArray *editerImages;
@property (nonatomic, copy) EditerDone editerDone;
@end
