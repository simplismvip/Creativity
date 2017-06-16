//
//  JMMainNavController.m
//  YaoYao
//
//  Created by JM Zhao on 16/9/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "JMMainNavController.h"
#import "NSObject+PYThemeExtension.h"

@interface JMMainNavController ()<UINavigationControllerDelegate>

@end

@implementation JMMainNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.navigationBar.barTintColor = JMNavTabBackGround;
//    self.navigationBar.barTintColor ＝ [UIColor blueColor];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackGround"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // 设置主题颜色
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    
    // 设置背景颜色
    [navBar py_addToThemeColorPool:@"barTintColor"];
    navBar.tintColor = JMColor(217, 51, 58);
    
    // 设置字体颜色
    NSDictionary *attr = @{
                           NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0]
                           };
    navBar.titleTextAttributes = attr;
    [self setValue:navBar forKey:@"navigationBar"];
    
    self.navigationBar.translucent = YES;
    self.delegate = self;
    
}

+ (void)setupNavTheme
{
    // 设置导航栏样式
    // UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置导航条背景 resizeImageWithName
    // [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置导航栏字体
    // NSDictionary *attrs =@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:30], NSForegroundColorAttributeName:[UIColor redColor]};
    // [navBar setTitleTextAttributes:attrs];
    
    NSDictionary *textAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:JMColor(52, 118, 237)];

    
    // 设置状态栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [super pushViewController:viewController animated:animated];
//    
//    
//}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//
//}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([viewController.class isSubclassOfClass:NSClassFromString(@"JMBaseViewController")] && ![viewController isKindOfClass:NSClassFromString(@"JMChatViewController")]) {
//        
//        viewController.tabBarController.tabBar.hidden = NO;
//    
//    }else{
//        viewController.tabBarController.tabBar.hidden = YES;
//    }
//    
//    JMLog(@"%@", viewController);
//}

- (BOOL)prefersStatusBarHidden
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
