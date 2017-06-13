//
//  NSObject+JMProperty.h
//  ClassItem
//
//  Created by JM Zhao on 2017/3/3.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol replacedDelegate <NSObject>

@optional
+ (NSDictionary *)objectClassInArray;
+ (NSDictionary *)replacedKeyFromPropertyName;

@end

@interface NSObject (JMProperty) <replacedDelegate>

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
@end
