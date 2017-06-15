//
//  JMTopBarModel.h
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/29.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMTopBarModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, assign) BOOL isSelect;
@end
