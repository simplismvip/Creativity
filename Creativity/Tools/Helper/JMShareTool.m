//
//  JMShareTool.m
//  Creativity
//
//  Created by JM Zhao on 2017/8/7.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMShareTool.h"
#import "AppDelegate.h"
#import "JMShareActivity.h"

@interface JMShareTool()<JMShareActivityDelegate>
@property (nonatomic, copy) UIActivityViewControllerCompletionHandler completionHandler;
@end

@implementation JMShareTool

- (void)shareWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url image:(id)image completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler
{
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:title?:@""];
    
    if (image) {[items addObject:image];}
    if (url) {[items addObject:url];}
    
    NSMutableArray *activities = [NSMutableArray array];
    JMShareActivity *weixinActivity = [[JMShareActivity alloc] initWithTitle:@"微信" type:@"weixin"];
    weixinActivity.delegate = self;
    weixinActivity.urlString = url;
    weixinActivity.shareDescription = description;
    weixinActivity.shareTitle = title;
    weixinActivity.image = image;
    [activities addObjectsFromArray:@[weixinActivity]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:activities];
    NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMail, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToTwitter]];
    
    activityViewController.excludedActivityTypes = excludedActivityTypes;
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
    
    activityViewController.completionHandler = ^(NSString *activityType, BOOL complted){
        
        if (completionHandler) {
            
            completionHandler(activityType, complted);
            self.completionHandler = nil;
        }
    };
}

- (void)share:(NSString *)type
{
    if (self.share) {self.share();}
    NSLog(@"在这里可以实现微信分享代码");
}

@end
