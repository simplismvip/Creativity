//
//  JMDrawViewController.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/9.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMDrawViewController.h"
#import "JMPaintView.h"
#import "JMWriteView.h"
#import "JMGetGIFController.h"
#import "JMTopTableView.h"
#import "UIImage+JMImage.h"
#import "JMMembersView.h"
#import "JMHelper.h"


#define kMargin 10.0

@interface JMDrawViewController ()<JMTopTableViewDelegate>
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger timeNum;
@property (nonatomic, weak) JMPaintView *memberViewView;
@property (nonatomic, weak) JMMembersView *memberView;

@property (nonatomic, strong) NSMutableArray *subViews;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *memberViewData;
@property (nonatomic, strong) NSMutableArray *memberViewBuff;
@end

@implementation JMDrawViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的画板";
    
    // 首先创建画图View, 创建接收消息方法
    self.subViews = [NSMutableArray array];
    self.memberViewBuff = [NSMutableArray array];
    self.memberViewData = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    self.leftImage = @"navbar_close_icon_black";
    self.rightImage = @"navbar_next_icon_black";
    
    // 这里创建bottomView
    self.dataSource = [JMHelper getTopBarModel];
    JMTopTableView *topbar = [[JMTopTableView alloc] initWithFrame:CGRectMake(0, self.view.height-44, self.view.width, 44)];
    topbar.delegate = self;
    topbar.dataSource = _dataSource;
    [self.view addSubview:topbar];
}

- (void)creatGifNew
{
    JMPaintView *pView = [[JMPaintView alloc] initWithFrame:CGRectMake(0, 44+kMargin, self.view.width, self.view.height-108)];
    pView.drawType = JMPaintToolTypePen;
    pView.lineDash = NO;
    self.memberViewView = pView;
    [self.view addSubview:pView];
    [self.subViews addObject:pView];
}

- (void)creatGif:(NSArray *)images
{
    [self.view addSubview:self.memberView];
    for (UIImage *image in images) {
        
        JMPaintView *pView = [[JMPaintView alloc] initWithFrame:CGRectMake(0, 44+kMargin, self.view.width, self.view.height-108)];
        pView.drawType = JMPaintToolTypePen;
        pView.lineDash = NO;
        pView.image = image;
        self.memberViewView = pView;
        [self.view addSubview:pView];
        [self.subViews addObject:pView];
    }
}

- (void)setItem:(UIBarButtonItem *)sender
{
//    JMmemberViewView *memberView = self.memberViewView;
//    UIImage *image = [UIImage imageWithCaptureView:self.view rect:memberView.frame];
//    UIImage *thubim = [image imageCompressForSize:image targetSize:CGSizeMake(64, 106)];
//    NSData *data = UIImageJPEGRepresentation(thubim, 0.1);
//    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)newItem:(UIBarButtonItem *)sender
{
    JMGetGIFController *gif = [[JMGetGIFController alloc] init];
    gif.folderPath = self.folderPath;
    
    NSMutableArray *images = [NSMutableArray array];
    for (JMPaintView *memberView in self.subViews) {
        
        if (memberView.image) {
        
            [images addObject:memberView.image];
        }else{
        
            [images addObject:memberView.image];
        }
    }
    
    gif.images = images;
    [self.navigationController pushViewController:gif animated:YES];
}

- (void)newCallback
{
    [self creatGifNew];
}

- (void)touchItem:(NSInteger)index
{
    [self.view bringSubviewToFront:self.subViews[index]];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    JMLog(@"内存警告 -- didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    JMLog(@"JMDrawViewController - 销毁");
}

- (JMMembersView *)memberView
{
    if (!_memberView) {
        
        JMMembersView *memberView = [[JMMembersView alloc] initWithFrame:CGRectMake(0, 44+kMargin, self.view.width, 44)];
        memberView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:memberView];
        self.memberView = memberView;
    }
    
    return _memberView;
}

#pragma mark -- ****************JMTopTableViewDelegate

- (void)topTableView:(JMBottomType)bottomType didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (bottomType == JMTopBarTypeShare && row==0){
        
        
    }else if (bottomType == JMTopBarTypeShare && row==1){
        
        
    }else if (bottomType == JMTopBarTypeShare && row==2){
        
        
    }else if (bottomType == JMTopBarTypeAdd && row==0){
        
        
    }else if (bottomType == JMTopBarTypeAdd && row==1){
        
        
    }else if (bottomType == JMTopBarTypeAdd && row==2){
        
        
    }else if (bottomType == JMTopBarTypeAdd && row==3){
        
        
    }else if (bottomType == JMTopBarTypeAdd && row==4){
        
        
    }else if (bottomType == JMTopBarTypepaint){
        
        
    }else if (bottomType == JMTopBarTypeclear && row==0){
        
        
    }else if (bottomType == JMTopBarTypeclear && row==1){
        
        
    }else if (bottomType == JMTopBarTypeclear && row==2){
        
        
    }else if (bottomType == JMTopBarTypeNote && row==0){
        
        
    }else if (bottomType == JMTopBarTypeNote && row==1){
        
        
    }else if (bottomType == JMTopBarTypeNote && row==2){
        
        
    }else if (bottomType == JMTopBarTypeNote && row==3){
        

    }else if (bottomType == JMTopBarTypeNote && row==4){
        
        
    }else if (bottomType == JMTopBarTypeNote && row==5){
        
        
    }
}


/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
