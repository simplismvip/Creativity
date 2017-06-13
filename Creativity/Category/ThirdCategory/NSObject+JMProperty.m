//
//  NSObject+JMProperty.m
//  ClassItem
//
//  Created by JM Zhao on 2017/3/3.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "NSObject+JMProperty.h"
#import <objc/runtime.h>

@implementation NSObject (JMProperty)

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    id model = [[self alloc] init];
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i ++) {
        
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *propery = [ivarName substringFromIndex:1];
        
        id value = dictionary[propery];
        if (!value) {
            
            if ([self instancesRespondToSelector:@selector(replacedKeyFromPropertyName)]) {
                
                NSString *replaceKey = [self replacedKeyFromPropertyName][propery];
                value = dictionary[replaceKey];
            }
        }
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex:range.location];
            Class modelClass = NSClassFromString(type);
            
            if (modelClass) {
                
                value = [modelClass objectWithDictionary:value];
            }
            
            
        }else if ([value isKindOfClass:[NSArray class]]){
        
            if ([self instancesRespondToSelector:@selector(objectClassInArray)]){
            
                NSMutableArray *models = [NSMutableArray array];
                NSString *type = [self objectClassInArray][propery];
                Class classModel = NSClassFromString(type);
                
                for (NSDictionary *dict in value) {
                    
                    id model = [classModel objectWithDictionary:dict];
                    [models addObject:model];
                }
                
                value = models;
            }
        }
        
        if (value) {
            
            [model setValue:value forKey:propery];
        }
    }
    
    free(ivars);
    return model;
}




@end
