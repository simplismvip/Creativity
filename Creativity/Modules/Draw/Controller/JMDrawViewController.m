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

@interface JMDrawViewController ()
@property (nonatomic, copy) NSString *folderPath;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger timeNum;
@property (nonatomic, weak) JMPaintView *paintView;

@property (nonatomic, strong) NSMutableArray *containSubView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *paintData;
@property (nonatomic, strong) NSMutableArray *paintBuff;
@end

@implementation JMDrawViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 首先创建画图View, 创建接收消息方法
    self.containSubView = [NSMutableArray array];
    self.paintBuff = [NSMutableArray array];
    self.paintData = [NSMutableArray array];
    
    [self creatCoverageAtindex:0 from:NO];
    self.dataSource = [NSMutableArray array];
    
    self.leftImage = @"navbar_close_icon_black";
    self.rightImage = @"navbar_next_icon_black";
}

- (void)setItem:(UIBarButtonItem *)sender
{
    JMPaintView *paint = self.paintView;
    UIImage *image = [UIImage imageWithCaptureView:self.view rect:paint.frame];
    UIImage *thubim = [image imageCompressForSize:image targetSize:CGSizeMake(64, 106)];
    NSData *data = UIImageJPEGRepresentation(thubim, 0.1);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)newItem:(UIBarButtonItem *)sender
{
    JMGetGIFController *gif = [[JMGetGIFController alloc] init];
    [self.navigationController pushViewController:gif animated:YES];
}

- (void)creatCoverageAtindex:(NSInteger)index from:(BOOL)from
{
    // mainBoard
    JMPaintView *pView = [[JMPaintView alloc] initWithFrame:self.view.bounds];
    pView.drawType = JMPaintToolTypePen;
    pView.lineDash = NO;
    self.paintView = pView;
    pView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:pView];
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

/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
