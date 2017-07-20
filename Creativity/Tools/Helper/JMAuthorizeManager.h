//
//  JMAuthorizeManager.h
//  Creativity
//
//  Created by JM Zhao on 2017/7/20.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMAuthorizeManager : NSObject
/**
 单例方法
 
 @return 实例
 */
+ (instancetype)sharedInstance;
- (BOOL)requestPhotoAccessCompletionHandler:(void (^)(BOOL, NSError *))handler;
- (BOOL)requestVideoAccessCompletionHandler:(void(^)(BOOL,NSError *))handler;
- (BOOL)requestMediaCapturerAccessWithCompletionHandler:(void (^)(BOOL, NSError*))handler;
@end
