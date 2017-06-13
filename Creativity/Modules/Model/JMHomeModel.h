//
//  JMHomeModel.h
//  YaoYao
//
//  Created by JM Zhao on 2017/3/8.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHomeModel : NSObject
@property (nonatomic, copy) NSString *pngName;
@property (nonatomic, copy) NSString *jpegName;
@property (nonatomic, copy) NSString *creatDate;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *jsonName;
@property (nonatomic, copy) NSString *folderName;
@property (nonatomic, assign) BOOL isVoice;
@end
