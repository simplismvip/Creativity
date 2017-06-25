//
//  JMMeViewController.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/2.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMMeViewController.h"
#import "JMAboutUsController.h"
#import "SetModel.h"
#import "JMHelper.h"
#import "SetTableViewCell.h"
#import "JMAccountHeaderFooter.h"
#import "JMFileManger.h"
#import "JMBuyProViewController.h"
#import "JMMainNavController.h"
#import "JMLicenceController.h"

@interface JMMeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, weak) UITableView *setTableView;
@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JMMeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dataSource = [JMHelper getSetModel];
    [self setUI];
    self.rightTitle = @"完成";
}

- (void)rightTitleItem:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUI
{
    self.title = @"设置";
    UITableView *setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStyleGrouped)];
    [setTableView registerClass:[SetTableViewCell class] forCellReuseIdentifier:@"baseCell"];
    setTableView.delegate = self;
    setTableView.dataSource = self;
    setTableView.sectionHeaderHeight = 0;
    setTableView.sectionFooterHeight = 0;
    setTableView.separatorColor = setTableView.backgroundColor;
    setTableView.showsVerticalScrollIndicator = NO;
    setTableView.backgroundColor = JMTabViewBaseColor;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){
        setTableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.view addSubview:setTableView];
    self.setTableView = setTableView;
    
    [setTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sections = self.dataSource[indexPath.section];
    SetModel *model = sections[indexPath.row];
    SetTableViewCell *cell = [SetTableViewCell setCell:tableView IndexPath:indexPath model:model];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JMAccountHeaderFooter *headView = [JMAccountHeaderFooter headViewWithTableView:tableView];
    
    if (section == 0) {
    
        headView.name.text = @"Creativity Pro";
        
    }else if (section == 1){
    
        headView.name.text = @"关于";
        
    }else{
    
        headView.name.text = @"支持中心";
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // SetModel *model = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section==0 && indexPath.row==0) {
       
        JMBuyProViewController *pro = [[JMBuyProViewController alloc] init];
        JMMainNavController *nav = [[JMMainNavController alloc] initWithRootViewController:pro];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (indexPath.section == 1 && indexPath.row==0){
    
        
    }else if (indexPath.section == 1 && indexPath.row==1){
        
        [self customerFeedback];
        
    }else if (indexPath.section == 1 && indexPath.row==2){
        
        [JMFileManger clearCache:JMDocumentsPath];
        
    }else if (indexPath.section==2 && indexPath.row==0) {
        
        JMLicenceController *about = [[JMLicenceController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
        
    }else if (indexPath.section==2 && indexPath.row==1) {
    
        JMAboutUsController *about = [[JMAboutUsController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
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
