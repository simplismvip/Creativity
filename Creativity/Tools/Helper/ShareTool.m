//
//  ShareTool.m
//  dsaf
//
//  Created by 陈志超 on 2016/12/7.
//  Copyright © 2016年 huaban. All rights reserved.
//

#import "ShareTool.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NSString * const ActivityServiceWeixin = @"weixin";
NSString * const ActivityServiceWeixinFriends = @"weixin_friends";

@interface HBShareBaseActivity : UIActivity
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *urlString;
@property (nonatomic) NSString *shareDescription;
@property (nonatomic) NSString *shareTitle;
@property (nonatomic) UIImage *image;
- (instancetype)initWithTitle:(NSString *)title type:(NSString *)type;
@end

@implementation HBShareBaseActivity

- (instancetype)initWithTitle:(NSString *)title type:(NSString *)type
{
    if (self = [super init]) {
        self.title = title;
        self.type = type;
    }
    return self;
}
- (NSString *)activityTitle{
    return self.title;
}

- (NSString *)activityType{
    return self.type;
}

- (UIImage *)activityImage
{
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
}

- (void)performActivity
{
    if ([self.type isEqualToString:ActivityServiceWeixin]) {
        
        NSLog(@"在这里可以实现微信分享代码");
    }else{
        NSLog(@"在这里可以实现朋友圈分享代码");
    }
}
@end

@interface ShareTool()
@property (nonatomic, copy) UIActivityViewControllerCompletionHandler completionHandler;
@end
@implementation ShareTool

- (void)shareWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url image:(UIImage *)image completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler
{
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:title?:@""];
    if (image) { [items addObject:image];}
    
    if (url) { [items addObject:url];}
    
    NSMutableArray *activities = [NSMutableArray array];
    HBShareBaseActivity *weixinActivity = [[HBShareBaseActivity alloc] initWithTitle:@"微信" type:ActivityServiceWeixin];
    HBShareBaseActivity *weixinFriendsActivity = [[HBShareBaseActivity alloc] initWithTitle:@"朋友圈" type:ActivityServiceWeixinFriends];
    
    [@[weixinActivity, weixinFriendsActivity] enumerateObjectsUsingBlock:^(HBShareBaseActivity *activity, NSUInteger idx, BOOL *stop) {
        activity.urlString = url;
        activity.shareDescription = description;
        activity.shareTitle = title;
        activity.image = image;
    }];
    
    
    
    [activities addObjectsFromArray:@[weixinActivity, weixinFriendsActivity]];
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

@end
















