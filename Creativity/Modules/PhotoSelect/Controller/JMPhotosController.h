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

@protocol JMPhotosControllerDelegate <NSObject>

@optional
- (void)pickerPhotosSuccess:(NSArray *)photos;
- (void)canclePicker;

@end

@interface JMPhotosController : JMBaseController
@property (nonatomic, weak) id <JMPhotosControllerDelegate>delegate;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, assign) ImageType type;
@end
