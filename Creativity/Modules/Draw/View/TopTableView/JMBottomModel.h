//
//  JMBottomModel.h
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/29.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMBottomModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isSelect;
@end
