//
//  JMBaseWebViewController.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/2.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBaseWebViewController : UIViewController
@property (nonatomic, copy) NSString *urlString;

// 重新加载数据
- (void)reload;

// 停止加载数据
- (void)stopLoading;

// 返回上一级
- (void)goBack;

// 跳转下一级
- (void)goForward;
@end
