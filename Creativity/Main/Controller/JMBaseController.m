//
//  JMBaseController.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/13.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMBaseController.h"

@interface JMBaseController ()

@end

@implementation JMBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setItem:(UIBarButtonItem *)sender
{
    
    
}

- (void)newItem:(UIBarButtonItem *)sender
{
    
    
}

- (void)leftTitleItem:(UIBarButtonItem *)sender
{
    
    
}

- (void)rightTitleItem:(UIBarButtonItem *)sender
{
    
    
}

// @"toolbar_setting_icon_black"
//
- (void)setLeftImage:(NSString *)leftImage
{
    _leftImage = leftImage;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:leftImage] style:(UIBarButtonItemStyleDone) target:self action:@selector(setItem:)];
    self.navigationItem.leftBarButtonItem = left;
}

// @"navbar_plus_icon_black"
- (void)setRightImage:(NSString *)rightImage
{
    _rightImage = rightImage;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:rightImage] style:(UIBarButtonItemStyleDone) target:self action:@selector(newItem:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = leftTitle;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:(UIBarButtonItemStyleDone) target:self action:@selector(leftTitleItem:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:(UIBarButtonItemStyleDone) target:self action:@selector(rightTitleItem:)];
    self.navigationItem.rightBarButtonItem = right;
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
