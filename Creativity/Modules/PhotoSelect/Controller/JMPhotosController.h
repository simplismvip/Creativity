//
//  JMPhotosController.h
//  NavigationTest
//
//  Created by JM Zhao on 2017/7/7.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMBaseController.h"

typedef enum : NSUInteger {
    ImageTypePhoto = 0,
    ImageTypePhotoLivePhoto,
    ImageTypePhotoBursts, // 连拍快照
    ImageTypePhotoGIF
} ImageType;

@interface JMPhotosController : JMBaseController
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, assign) ImageType type;
@end
