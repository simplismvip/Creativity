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
#import "JMServerViewController.h"
#import "JMHeaderFooterModel.h"
#import "JMHeaderFooterView.h"

@interface JMMeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, weak) UITableView *setTableView;
@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, strong) NSMutableArray *headerFooterSource;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JMMeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dataSource = [JMHelper getSetModel];
    self.headerFooterSource = [NSMutableArray array];
    
    [self setUI];
    self.rightTitle = NSLocalizedString(@"gif.base.alert.done", "");
}

- (void)setUI
{
    self.title = NSLocalizedString(@"gif.set.navigation.title", "");
    NSDictionary *dic1 = @{@"leftImage":@"0", @"leftTitle":NSLocalizedString(@"gif.set.header.SectionTwo", "")};
    NSDictionary *dic2 = @{@"leftImage":@"0", @"leftTitle":NSLocalizedString(@"gif.set.header.SectionOne", "")};
    NSDictionary *dic3 = @{@"leftImage":@"0", @"leftTitle":NSLocalizedString(@"gif.set.header.SectionThree", "")};
    NSArray *sections = @[dic1, dic2, dic3];
    
    for (NSDictionary *dic in sections) {
        
        JMHeaderFooterModel *model = [[JMHeaderFooterModel alloc] init];
        model.leftImage = dic[@"leftImage"];
        model.leftTitle = dic[@"leftTitle"];
        [_headerFooterSource addObject:model];
    }
    
    UITableView *setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-54) style:(UITableViewStyleGrouped)];
    [setTableView registerClass:[SetTableViewCell class] forCellReuseIdentifier:@"baseCell"];
    setTableView.delegate = self;
    setTableView.dataSource = self;
    setTableView.sectionHeaderHeight = 0;
    setTableView.sectionFooterHeight = 0;
    setTableView.separatorColor = JMColorRGBA(230, 230, 230, 0.8);
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
    static NSString *ID = @"baseCell";
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {cell = [[SetTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JMHeaderFooterView *headView = [JMHeaderFooterView initHeaderFooterWithTableView:tableView];
    headView.model = self.headerFooterSource[section];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     SetModel *model = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row==0){
    
        JMBaseWebViewController *drawVC = [[JMBaseWebViewController alloc] init];
        drawVC.urlString = @"https://github.com/simplismvip/Creativity";
        [self.navigationController pushViewController:drawVC animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row==1){
        
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
        
    }else if (indexPath.section==1 && indexPath.row==0) {
        
        JMAboutUsController *about = [[JMAboutUsController alloc] init];
        about.title = model.title;
        [self.navigationController pushViewController:about animated:YES];
    
    }else if (indexPath.section==1 && indexPath.row==1) {
        
        JMServerViewController *server = [[JMServerViewController alloc] init];
        server.title = NSLocalizedString(@"gif.base.alert.appServer", "");
        [self.navigationController pushViewController:server animated:YES];
        
    }else if (indexPath.section==2 && indexPath.row==0) {
        
        NSURL *url  = [NSURL URLWithString:AppiTunesID_Locker];
        [[UIApplication sharedApplication] openURL:url];
        
    }else if (indexPath.section==2 && indexPath.row==1) {
        
        NSURL *url  = [NSURL URLWithString:AppiTunesID_ebookReader];
        [[UIApplication sharedApplication] openURL:url];
    
    }else if (indexPath.section==2 && indexPath.row==2) {
        
        NSURL *url  = [NSURL URLWithString:AppiTunesID_ToolBox];
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
