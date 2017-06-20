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

@interface JMBuyProViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *proView;
@end

@implementation JMBuyProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)setUI
{
    UITableView *proView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStyleGrouped)];
    [proView registerClass:[JMProTableViewCell class] forCellReuseIdentifier:@"proCell"];
    proView.delegate = self;
    proView.dataSource = self;
    proView.sectionHeaderHeight = 0;
    proView.sectionFooterHeight = 0;
    proView.separatorColor = proView.backgroundColor;
    proView.showsVerticalScrollIndicator = NO;
    proView.backgroundColor = JMTabViewBaseColor;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){
        proView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.view addSubview:proView];
    self.proView = proView;
    
    [proView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    
    
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"proCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
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
