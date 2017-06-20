//
//  JMBuyProViewController.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMBuyProViewController.h"
#import "JMProTableViewCell.h"
#import "ProModel.h"
#import "JMProHeaderView.h"

@interface JMBuyProViewController ()<UITableViewDelegate, UITableViewDataSource, JMProHeaderViewDelegate>
@property (nonatomic, weak) UITableView *proView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JMBuyProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    ProModel *model = [[ProModel alloc] init];
    model.image = @"pro_Image";
    model.title = @"删除水印";
    model.subTitle = @"不再显示Creativity的水印图标";
    [self.dataArray addObject:model];
    
    ProModel *model1 = [[ProModel alloc] init];
    model1.image = @"pro_color";
    model1.title = @"多种多样滤镜";
    model1.subTitle = @"多种多样滤镜创造更多有趣图片";
    [self.dataArray addObject:model1];
    
    ProModel *model2 = [[ProModel alloc] init];
    model2.image = @"pro_AD";
    model2.title = @"删除广告";
    model2.subTitle = @"享受无广告的乐趣";
    [self.dataArray addObject:model2];
    
    self.rightTitle = @"完成";
    self.leftTitle = @"恢复购买目录";
    [self setUI];
}

- (void)rightTitleItem:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftTitleItem:(UIBarButtonItem *)sender
{
    NSLog(@"恢复购买目录");
}

- (void)buyPro
{
    NSLog(@"购买Pro");
}

- (void)setUI
{
    UITableView *proView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    [proView registerClass:[JMProTableViewCell class] forCellReuseIdentifier:@"proCell"];
    proView.delegate = self;
    proView.dataSource = self;
    proView.sectionHeaderHeight = 0;
    proView.sectionFooterHeight = 0;
    proView.backgroundColor = JMColor(65, 65, 65);
    proView.separatorColor = proView.backgroundColor;
    proView.showsVerticalScrollIndicator = NO;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){
        proView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.view addSubview:proView];
    self.proView = proView;
    
    [proView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
        
    }];
    
    JMProHeaderView *header = [[JMProHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*0.7)];
    header.delegate = self;
    header.backgroundColor = JMColor(41, 41, 41);
    proView.tableHeaderView = header;
    
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"proCell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.view.height - self.view.width*0.8-84)/3;
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
