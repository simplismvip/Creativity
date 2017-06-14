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
#import "JMCreatPaintView.h"

@interface JMDrawViewController ()<JMCreatPaintViewDelegate>
@property (nonatomic, copy) NSString *folderPath;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger timeNum;
@property (nonatomic, weak) JMPaintView *paintView;
@property (nonatomic, weak) JMCreatPaintView *paint;

@property (nonatomic, strong) NSMutableArray *subViews;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 首先创建画图View, 创建接收消息方法
    self.subViews = [NSMutableArray array];
    self.paintBuff = [NSMutableArray array];
    self.paintData = [NSMutableArray array];
    
    [self creatCoverageAtindex:0 from:NO];
    self.dataSource = [NSMutableArray array];
    
    self.leftImage = @"navbar_close_icon_black";
    self.rightImage = @"navbar_next_icon_black";
}

- (void)setItem:(UIBarButtonItem *)sender
{
//    JMPaintView *paint = self.paintView;
//    UIImage *image = [UIImage imageWithCaptureView:self.view rect:paint.frame];
//    UIImage *thubim = [image imageCompressForSize:image targetSize:CGSizeMake(64, 106)];
//    NSData *data = UIImageJPEGRepresentation(thubim, 0.1);
//    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)newItem:(UIBarButtonItem *)sender
{
    JMGetGIFController *gif = [[JMGetGIFController alloc] init];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (JMPaintView *paint in self.subViews) {
        
        [images addObject:paint.image];
    }
    
    gif.images = images;
    [self.navigationController pushViewController:gif animated:YES];
}

- (void)creatCoverageAtindex:(NSInteger)index from:(BOOL)from
{
    CGFloat margin = 5;
    JMCreatPaintView *paint = [[JMCreatPaintView alloc] initWithFrame:CGRectMake(0, 44+margin, self.view.width, 44)];
    paint.delegate = self;
    paint.backgroundColor = [UIColor grayColor];
    [self.view addSubview:paint];
    self.paint = paint;
    
    // mainBoard
    JMPaintView *pView = [[JMPaintView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(paint.frame)+margin, self.view.width, self.view.height-54)];
    pView.drawType = JMPaintToolTypePen;
    pView.lineDash = NO;
    self.paintView = pView;
    [self.view addSubview:pView];
    [self.subViews addObject:pView];
}

- (void)newCallback
{
    // mainBoard
    CGFloat margin = 5;
    JMPaintView *pView = [[JMPaintView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_paint.frame)+margin, self.view.width, self.view.height-54)];
    pView.drawType = JMPaintToolTypePen;
    pView.lineDash = NO;
    self.paintView = pView;
    [self.view addSubview:pView];
    [self.subViews addObject:pView];
    
    [self.paint reloadData:pView.image];
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



/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
