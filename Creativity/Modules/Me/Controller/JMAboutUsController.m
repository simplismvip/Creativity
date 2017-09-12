//
//  JMAboutUsController.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/30.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMAboutUsController.h"
#import "MSCellAccessory.h"
#import <UShareUI/UShareUI.h>
#import "LivDownloadHelper.h"
#import "JMUserDefault.h"

@interface JMAboutUsController ()<UITableViewDelegate, UITableViewDataSource, UMSocialShareMenuViewDelegate>
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UITableView *tabView;
@property (nonatomic, strong) NSArray *memberArray;

@end

@implementation JMAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JMColor(240, 240, 240);
    self.memberArray = @[NSLocalizedString(@"gif.set.aboutUs.rowZero", ""), NSLocalizedString(@"gif.set.aboutUs.rowOne", ""), NSLocalizedString(@"gif.set.aboutUs.rowTwo", "")];
    [self setUI];
    
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Sina),]];
    
    // 设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
}

- (void)setUI
{
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2-35, self.view.height*0.17, 70, 70)];
    logo.layer.cornerRadius = 16;
    logo.layer.masksToBounds = YES;
    logo.image = [UIImage imageNamed:@"GifPlayer_Icon"];
    [self.view addSubview:logo];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logo.frame)+5, self.view.width, 30)];
    label.text = @"GifPlayer";// [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:14.0];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = label.frame;
    [self.view addSubview:label];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+5, self.view.width, 30)];
    version.text = [NSString stringWithFormat:@"Version : %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    version.textAlignment = 1;
    version.textColor = JMColor(170, 170, 170);
    version.font = [UIFont fontWithName:@"GujaratiSangamMN-Bold" size:16];
    [self.view addSubview:version];
    
    UIColor *color1 = [self randColor];
    UIColor *color2 = [self randColor];
    UIColor *color3 = [self randColor];
    UIColor *color4 = [self randColor];
    UIColor *color5 = [self randColor];
    layer.colors = @[(id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor, (id)color4.CGColor, (id)color5.CGColor];
    
    [self.view.layer addSublayer:layer];
    layer.mask = label.layer;
    label.frame = layer.bounds;
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(version.frame)+20, self.view.width, 132) style:(UITableViewStylePlain)];
    tabView.scrollEnabled = NO;
    [tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"aboutCell"];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.separatorColor = tabView.backgroundColor;
    [self.view addSubview:tabView];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){tabView.cellLayoutMarginsFollowReadableWidth = NO;}
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"aboutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.memberArray[indexPath.row];
    cell.textLabel.textColor = JMColor(55, 55, 55);
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:JMBaseColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        [self customerFeedback];
        
    }else if (indexPath.row == 1){
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppiTunesID_Creativity]];
        
    }else{
        [self showBottomCircleView:nil];
    }
}

// 用户反馈
- (void)customerFeedback
{
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"simplismvip@163.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"simplismvip@163.com", nil];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];

    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"simplismvip@163.com", nil];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    
    // 添加主题
    [mailUrl appendString:@"&subject=用户反馈"];
    
    NSString *appName = @"GifPlayer"; // [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *sysVersion= [[UIDevice currentDevice] systemVersion];
    NSString *device = [[UIDevice currentDevice] model];
    NSString *buildID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appVersionID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *emailString = [NSString stringWithFormat:@"&body=<b>应用名称: %@, 设备类型: %@, 系统版本: %@, build版本: %@, app版本: %@</b>", appName, device, sysVersion, buildID, appVersionID];
    [mailUrl appendString:emailString];
    
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet;
    NSString *email = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


- (UIColor *)randColor
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

// 这个比较好
- (void)showBottomCircleView:(id)shareImage
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"来自GifPlay的分享" descr:@"强大的GIF编辑生成工具" thumImage:[UIImage imageNamed:@"GifPlayer_Icon"]];
    
    //设置网页地址
    shareObject.webpageUrl = AppiTunesID_Creativity;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
