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
#import "SetTableViewCell.h"

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
    
    self.dataSource = [NSMutableArray arrayWithArray:@[@[@"获取Pro"], @[@"帮助中心", @"反馈"], @[@"版本", @"软件许可"]]];
    [self setUI];
    
    self.leftImage = @"navbar_close_icon_black";
}

- (void)setItem:(UIBarButtonItem *)sender
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // SetModel *model = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section==0 && indexPath.row==0) {
       
        
    }else if (indexPath.section == 1 && indexPath.row==0){
    
        
    }else if (indexPath.section == 1 && indexPath.row==1){
        
        
    }else if (indexPath.section==2 && indexPath.row==0) {
        
        
    }else if (indexPath.section==2 && indexPath.row==1) {
    
        JMAboutUsController *about = [[JMAboutUsController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
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
