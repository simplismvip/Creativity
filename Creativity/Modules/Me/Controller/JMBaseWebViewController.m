//
//  JMBaseWebViewController.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/2.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMBaseWebViewController.h"
#import "JMWebProgressView.h"
#import "UIView+Extension.h"

@interface JMBaseWebViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *cloudShareView;
@property (nonatomic, strong) JMWebProgressView *progressLayer;
@property (nonatomic, weak) MBProgressHUD *hud;
@end

@implementation JMBaseWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    self.hud = hud;
    [self loadRequest:self.urlString];
    
}

- (void)loadRequest:(NSString *)urlString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    UIWebView *cloudShareView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    cloudShareView.delegate = self;
    cloudShareView.scalesPageToFit = YES;
    [cloudShareView loadRequest:request];
    
    self.progressLayer = [JMWebProgressView new];
    _progressLayer.frame = CGRectMake(0, 42, self.view.width, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    [self.view addSubview:cloudShareView];
    self.cloudShareView = cloudShareView;
}

#pragma mark -- private Method
- (void)reload
{
    if (_cloudShareView.loading) {
        
        [_cloudShareView reload];
    }
}

- (void)stopLoading
{
    [_cloudShareView stopLoading];
}

- (void)goBack
{
    if (_cloudShareView.canGoBack) {
        
        [_cloudShareView goBack];
    }
}

- (void)goForward
{
    if (_cloudShareView.canGoForward) {
        
        [_cloudShareView goForward];
    }
}

#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestStr = [[request.URL absoluteString] stringByRemovingPercentEncoding];
    JMLog(@"%@", requestStr);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressLayer finishedLoad];
    self.title = @"帮助中心";// [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud hideAnimated:YES];
    });

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_progressLayer finishedLoad];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud hideAnimated:YES];
    });

}

- (void)dealloc
{
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
