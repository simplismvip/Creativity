//
//  JMMemberModel.h
//  YaoYao
//
//  Created by JM Zhao on 2017/2/14.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMMemberModel : NSObject

@property (nonatomic, assign) BOOL isHide;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *Thumbnail;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *showAndHide;
@property (nonatomic, strong) UIImage *thumbnailImage;
@end