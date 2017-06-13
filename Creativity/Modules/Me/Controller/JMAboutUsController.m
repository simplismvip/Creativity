//
//  JMAboutUsController.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/30.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMAboutUsController.h"

@interface JMAboutUsController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UITableView *tabView;
@property (nonatomic, strong) NSArray *memberArray;

@end

@implementation JMAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JMColor(240, 240, 240);
    self.memberArray = @[@"用户反馈", @"给应用评分", @"分享给朋友"];
    [self setUI];
}

- (void)setUI
{
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2-35, self.view.height*0.17, 70, 70)];
    logo.layer.cornerRadius = 16;
    logo.layer.masksToBounds = YES;
    logo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logo];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2-80, CGRectGetMaxY(logo.frame)+5, 160, 30)];
    label.text = @"Yao Yao";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:14.0];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = label.frame;
    [self.view addSubview:label];
    
    UIColor *color1 = [self randColor];
    UIColor *color2 = [self randColor];
    UIColor *color3 = [self randColor];
    UIColor *color4 = [self randColor];
    UIColor *color5 = [self randColor];
    layer.colors = @[(id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor, (id)color4.CGColor, (id)color5.CGColor];
    
    [self.view.layer addSublayer:layer];
    layer.mask = label.layer;
    label.frame = layer.bounds;
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.height*0.4, self.view.width, 132) style:(UITableViewStylePlain)];
    tabView.scrollEnabled = NO;
    [tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"aboutCell"];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.backgroundColor = JMTabViewBaseColor;
    [self.view addSubview:tabView];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){
        tabView.cellLayoutMarginsFollowReadableWidth = NO;
    }
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        [self customerFeedback];
        
    }else if (indexPath.row == 1){
    
    }else{
        
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
    
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>Hello</b> 在这里添加内容 !"];
    
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
