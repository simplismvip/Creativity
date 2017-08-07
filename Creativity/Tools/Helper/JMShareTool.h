//
//  JMShareTool.h
//  Creativity
//
//  Created by JM Zhao on 2017/8/7.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^shareWeChat)();

@interface JMShareTool : NSObject
@property (nonatomic, copy) shareWeChat share;

- (void)shareWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url image:(id)image completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler;
@end
