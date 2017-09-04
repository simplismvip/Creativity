//
//  JMServerViewController.m
//  Creativity
//
//  Created by 赵俊明 on 2017/8/22.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMServerViewController.h"
#import "JMLicenceModel.h"
#import "JMLicenceCell.h"
#import "JMAccountHeaderFooter.h"
#import "JMLicenceViewModel.h"
#import "JMBaseWebViewController.h"

@interface JMServerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) UITableView *licence;
@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation JMServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    [self creatMitsLicence];
    [self setUI];
}

- (void)setUI
{
    UITableView *licence = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStyleGrouped)];
    [licence registerClass:[JMLicenceCell class] forCellReuseIdentifier:@"server"];
    licence.delegate = self;
    licence.dataSource = self;
    licence.sectionHeaderHeight = 0;
    licence.sectionFooterHeight = 0;
    licence.separatorColor = [UIColor clearColor];
    licence.showsVerticalScrollIndicator = NO;
    licence.backgroundColor = JMTabViewBaseColor;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){licence.cellLayoutMarginsFollowReadableWidth = NO;}
    [self.view addSubview:licence];
    self.licence = licence;
    
    [licence mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMLicenceViewModel *model = self.dataSource[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"server"];
    if (!cell) {cell = [[JMLicenceCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"server"];}
    cell.textLabel.text = model.model.lower;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JMAccountHeaderFooter *headView = [JMAccountHeaderFooter headViewWithTableView:tableView];
    JMLicenceViewModel *model = _dataSource[section];
    headView.name.text = model.model.headeTitle;
    headView.name.textColor = [UIColor blackColor];
    headView.name.font = [UIFont fontWithName:@"AlNile-Bold" size:22];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMLicenceViewModel *model = _dataSource[indexPath.section];
    return model.cellFrame;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMLicenceViewModel *model = _dataSource[indexPath.section];
    JMBaseWebViewController *drawVC = [[JMBaseWebViewController alloc] init];
    drawVC.urlString = model.model.copyright;
    if (drawVC.urlString) {[self.navigationController pushViewController:drawVC animated:YES];}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatMitsLicence
{
    JMLicenceViewModel *viewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *networking = [[JMLicenceModel alloc] init];
    [_dataSource addObject:viewModel];
    networking.headeTitle = @"使用协议";
    networking.lower = @"https://github.com/simplismvip/Privacy-Policy/blob/master/%E4%BD%BF%E7%94%A8%E5%8D%8F%E8%AE%AE.txt";
    viewModel.model = networking;
    
    JMLicenceViewModel *mjxtentViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *mjextension = [[JMLicenceModel alloc] init];
    [_dataSource addObject:mjxtentViewModel];
    mjextension.headeTitle = @"隐私政策";
    mjextension.lower = @"https://github.com/simplismvip/Privacy-Policy/blob/master/%E9%9A%90%E7%A7%81%E6%94%BF%E7%AD%96.txt";
    mjxtentViewModel.model = mjextension;
    
    
    JMLicenceViewModel *fmdbViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *fmdb = [[JMLicenceModel alloc] init];
    [_dataSource addObject:fmdbViewModel];
    fmdb.headeTitle = @"应用描述";
    fmdb.lower =@"https://github.com/simplismvip/Privacy-Policy/blob/master/%E5%BA%94%E7%94%A8%E6%8F%8F%E8%BF%B0.txt";
    fmdbViewModel.model = fmdb;
    
    JMLicenceViewModel *subViewModel = [[JMLicenceViewModel alloc] init];
    JMLicenceModel *sub = [[JMLicenceModel alloc] init];
    [_dataSource addObject:subViewModel];
    sub.headeTitle = @"使用指南";
    sub.lower = @"https://github.com/simplismvip/Privacy-Policy/blob/master/%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E.txt";
    subViewModel.model = sub;
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
