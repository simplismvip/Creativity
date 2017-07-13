//
//  JMEditerDetailController.h
//  Creativity
//
//  Created by 赵俊明 on 2017/7/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMBaseController.h"

typedef void(^EditerDetailDone)(UIImage *image);
@interface JMEditerDetailController : JMBaseController
@property (nonatomic, strong) UIImage *editerImage;
@property (nonatomic, copy) EditerDetailDone editerDetailDone;
@end
