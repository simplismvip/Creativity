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
#import "JMBaseWebViewController.h"
#import "SDImageCache.h"

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
    self.rightTitle = NSLocalizedString(@"gif.base.alert.done", "");
}

- (void)setUI
{
    self.title = NSLocalizedString(@"gif.set.navigation.title", "");
    UITableView *setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStyleGrouped)];
    [setTableView registerClass:[SetTableViewCell class] forCellReuseIdentifier:@"baseCell"];
    setTableView.delegate = self;
    setTableView.dataSource = self;
    setTableView.sectionHeaderHeight = 0;
    setTableView.sectionFooterHeight = 0;
    setTableView.backgroundColor = JMColor(41, 41, 41);
    setTableView.separatorColor = setTableView.backgroundColor;
    setTableView.showsVerticalScrollIndicator = NO;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){setTableView.cellLayoutMarginsFollowReadableWidth = NO;}
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JMAccountHeaderFooter *headView = [JMAccountHeaderFooter headViewWithTableView:tableView];
    if (section == 0) {
    
        headView.name.text = NSLocalizedString(@"gif.set.header.SectionZero", "");
        
    }else if (section == 1){
    
        headView.name.text = NSLocalizedString(@"gif.set.header.SectionTwo", "");
        
    }else if (section == 2){
    
        headView.name.text = NSLocalizedString(@"gif.set.header.SectionOne", "");
    }else{
    
        headView.name.text = NSLocalizedString(@"gif.set.header.SectionThree", "");
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     SetModel *model = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section==0 && indexPath.row==0) {
       
        JMBuyProViewController *pro = [[JMBuyProViewController alloc] init];
        JMMainNavController *nav = [[JMMainNavController alloc] initWithRootViewController:pro];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (indexPath.section == 1 && indexPath.row==0){
    
        JMBaseWebViewController *drawVC = [[JMBaseWebViewController alloc] init];
        drawVC.urlString = @"https://github.com/simplismvip/Creativity";
        [self.navigationController pushViewController:drawVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row==1){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            [JMFileManger clearCache:JMDocumentsPath];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                
                sleep(.5);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [hud hideAnimated:YES];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithTemplateName:@"Checkmark"]];
                    hud.square = YES;
                    hud.label.text = NSLocalizedString(@"gif.base.alert.success", "");
                    [hud hideAnimated:YES afterDelay:1.5f];
                });
            }];
        });
        
    }else if (indexPath.section==2 && indexPath.row==0) {
        
        JMLicenceController *about = [[JMLicenceController alloc] init];
        about.title = model.title;
        [self.navigationController pushViewController:about animated:YES];
        
    }else if (indexPath.section==2 && indexPath.row==1) {
        
        JMAboutUsController *about = [[JMAboutUsController alloc] init];
        about.title = model.title;
        [self.navigationController pushViewController:about animated:YES];
    }else{
        NSURL *url  = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1257334539"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)rightTitleAction:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
