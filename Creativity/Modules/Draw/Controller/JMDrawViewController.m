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
#import "JMMembersView.h"
#import "JMAttributeTextInputView.h"
#import "JMAttributeStringAnimationView.h"
#import "JMAnimationView.h"
#import "JMEmojiAnimationView.h"
#import "JMSubImageModel.h"
#import <UMMobClick/MobClick.h>
#import "JMPopView.h"
#import "JMTopBarModel.h"
#import "JMBottomModel.h"
#import "Masonry.h"

#define kMargin 10.0

@interface JMDrawViewController ()<JMTopTableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger timeNum;
@property (nonatomic, weak) JMPaintView *paintView;
@property (nonatomic, weak) JMMembersView *memberView;
@property (nonatomic, strong) JMGetGIFController *GIFController;
@property (nonatomic, strong) NSMutableArray *subViews;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *memberViewData;
@property (nonatomic, strong) NSMutableArray *memberViewBuff;
@end

@implementation JMDrawViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = JMColor(41, 41, 41);
    [MobClick beginLogPageView:@"JMDrawViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMDrawViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的画板";
    
    // 首先创建画图View, 创建接收消息方法
    self.subViews = [NSMutableArray array];
    self.memberViewBuff = [NSMutableArray array];
    self.memberViewData = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    
    // 这里创建bottomView
    self.dataSource = [JMHelper getTopBarModel];
    JMTopTableView *topbar = [[JMTopTableView alloc] initWithFrame:CGRectMake(0, kH-44, kW, 44)];
    topbar.delegate = self;
    topbar.dataSource = _dataSource;
    [self.view addSubview:topbar];
}

// 从home界面弹出
- (void)addNewPaintView
{
    self.leftImage = @"navbar_close_icon_black";
    self.rightImage = @"navbar_next_icon_black";
    
    JMPaintView *pView = [[JMPaintView alloc] init];
    pView.drawType = (JMPaintToolType)[StaticClass getPaintType];
    pView.lineDash = [StaticClass getDashType];
    pView.paintText = [StaticClass getPaintText];
    pView.paintImage = [StaticClass getPaintImage];
    self.paintView = pView;
    [self.view addSubview:pView];
    [self.subViews insertObject:pView atIndex:0];
    
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.mas_equalTo(self.view.width);
    }];
}

// 从getGIF界面弹出
- (void)presentDrawViewController:(JMGetGIFController *)parentController images:(NSArray *)images
{
    self.GIFController = parentController;
    self.rightTitle = @"完成";
    
    [self.view addSubview:self.memberView];
    for (UIImage *image in images) {
        
        JMPaintView *pView = [[JMPaintView alloc] init];
        pView.image = image;
        self.paintView = pView;
        [self.view addSubview:pView];
        [self.subViews insertObject:pView atIndex:0];
        
        [pView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(self.view.width);
        }];
    }
}

// 完成按钮
- (void)rightTitleItem:(UIBarButtonItem *)sender
{
    [self.GIFController.images removeAllObjects];
    
    for (JMPaintView *memberView in self.subViews) {
        
        if (memberView.image) {
            
            [self.GIFController.images addObject:memberView.image];
        }
    }
    [self.GIFController dismissFromDrawViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    gif.filePath = [self.folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [JMHelper timerString]]];
    
    NSMutableArray *images = [NSMutableArray array];
    for (JMPaintView *memberView in self.subViews) {
        
        UIImage *imageNew = [UIImage imageWithCaptureView:memberView rect:CGRectMake(0, 0, kW, kW)];
        [images addObject:imageNew];
        
//        if (memberView.image) {
//        
//            [images addObject:memberView.image];
//        }
    }
    
    gif.images = images;
    [self.navigationController pushViewController:gif animated:YES];
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
    NSString *title = nil;
    
    JMTopBarModel *tModel = self.dataSource[indexPath.section];
    if (tModel.models.count == 1) {
        
        title = tModel.title;
        
    }else{
    
        JMBottomModel *bModel = [_dataSource[indexPath.section] models][row];
        title = bModel.title;
    }
    
    if (bottomType == JMTopBarTypeAdd){
        
        [JMPopView popView:self.view title:title];
        
        JMPaintView *pView = [[JMPaintView alloc] init];
        pView.drawType = (JMPaintToolType)[StaticClass getPaintType];
        pView.lineDash = [StaticClass getDashType];
        pView.paintText = [StaticClass getPaintText];
        pView.paintImage = [StaticClass getPaintImage];
        self.paintView = pView;
        [self.view addSubview:pView];
        [self.subViews insertObject:pView atIndex:0];
        
        [pView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(self.view.width);
            // make.height.mas_equalTo(self.view.width*1.2);
        }];
        
    }else if (bottomType == JMTopBarTypeLayerManger){
        
        [JMPopView popView:self.view title:title];
        [JMMembersView initMemberDataArray:self.subViews isEditer:NO addDelegate:self];
        
    }else if (bottomType == JMTopBarTypeAdd && row==2){
        
        
    }else if (bottomType == JMTopBarTypePaint){
        
        [JMPopView popView:self.view title:title];
        _paintView.drawType = (JMPaintToolType)row;
        [StaticClass setPaintType:row];
        
        if (row == 5){
            
            JMSelf(ws);
            JMEmojiAnimationView *animation = [[JMEmojiAnimationView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:animation];
            animation.animationBlock = ^(id model) {
                
                JMSubImageModel *emojiModel = (JMSubImageModel *)model;
                ws.paintView.paintImage = emojiModel.name;
                [StaticClass setPaintImage:emojiModel.name];
            };
            
            [UIView animateWithDuration:0.3 animations:^{animation.alpha = 1.0;}];
            
        }else if (row == 6){
            
            JMSelf(ws);
            JMAttributeTextInputView *attribute = [[JMAttributeTextInputView alloc] initWithFrame:CGRectMake(0,self.view.height, self.view.width, 50)];
            attribute.textViewMaxLine = 5;
            attribute.placeholderLabel.text = @"请输入...";
            attribute.inputAttribute = ^(NSString *sendContent) {ws.paintView.paintText = sendContent;[StaticClass setPaintText:sendContent];};
            [self.view addSubview:attribute];
            [attribute.textInput becomeFirstResponder];
        }
        
    }else if (bottomType == JMTopBarTypeClear && row==0){
        
        [JMPopView popView:self.view title:title];
        [_paintView undoLatestStep];

    }else if (bottomType == JMTopBarTypeClear && row==1){
        
        [JMPopView popView:self.view title:title];
        [_paintView clearAll];
        
    }else if (bottomType == JMTopBarTypeClear && row==2){
        
        [JMPopView popView:self.view title:title];
        [_paintView redoLatestStep];
        
    }else if (bottomType == JMTopBarTypeNote && row==0){
        
        [JMPopView popView:self.view title:title];
        _paintView.lineDash = !_paintView.lineDash;
        [StaticClass setDashType:_paintView.lineDash];
        
    }else if (bottomType == JMTopBarTypeNote && row==1){
        
        [JMPopView popView:self.view title:title];
        _paintView.isFill = !_paintView.isFill;
        [StaticClass setFillType:_paintView.isFill];
    }else if (bottomType == JMTopBarTypeNote && row==2){
        
        NSLog(@"添加图片");
        
    }else if (bottomType == JMTopBarTypeFontSet){
        
        NSLog(@"文字设置");
        JMAttributeStringAnimationView *animation = [[JMAttributeStringAnimationView alloc] initWithFrame:self.view.bounds];
        animation.alpha = 0.0;
        animation.attributeString = ^(NSString *fontName) {[StaticClass setFontName:fontName];};
        [self.view addSubview:animation];
        [UIView animateWithDuration:0.3 animations:^{animation.alpha = 1.0;}];
    
    }else if (bottomType == JMTopBarTypeColor){
        
        JMAnimationView *animation = [[JMAnimationView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:animation];
        [UIView animateWithDuration:0.3 animations:^{animation.alpha = 1.0;}];
    }
}

- (void)moveCoverageAtIndexPath:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    JMPaintView *from = self.subViews[fromIndex];
    JMPaintView *to = self.subViews[toIndex];
    [self.view insertSubview:from aboveSubview:to];
    
    [self.subViews removeObjectAtIndex:fromIndex];
    [self.subViews insertObject:from atIndex:toIndex];
}

- (void)removeCoverageAtIndex:(NSInteger)index
{
    JMPaintView *pView = self.subViews[index];
    [pView removeFromSuperview];
    [self.subViews removeObjectAtIndex:index];
}

- (void)hideCoverageAtIndex:(NSInteger)index isHide:(BOOL)isHide
{
    JMPaintView *pView = self.subViews[index];
    pView.hidden = isHide;
}

#pragma mark -- ****************初始化图片选择器
- (void)getImageFromLibrary
{
    JMSelf(ws);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    // 相机
    [alertController addAction:[UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {[ws initImagePicker:1];}
    }]];
    
    // 相册
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {[ws initImagePicker:0];}
    }]];
    
    // 取消
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    if (IS_IPAD) {
        
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        
        if (popover){
            popover.sourceView = self.navigationController.navigationBar;
            popover.sourceRect = self.navigationController.navigationBar.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
        }
    }
}

#pragma mark -- 初始化图片选择器
- (void)initImagePicker:(NSInteger)number
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64);
    picker.delegate = self;
    picker.sourceType = number;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//添加代码，处理选中图像又取消的情况
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    JMLog(@"取消选中");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    // Dispose of any resources that can be recreated.
}

/*
 NSInteger row = indexPath.row;

 
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
