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
#import "JMProHeaderView.h"
#import "JMUserDefault.h"
#import "CustomAlertView.h"

@interface JMBuyProViewController ()<SKPaymentTransactionObserver, SKProductsRequestDelegate, UITableViewDelegate, UITableViewDataSource, JMProHeaderViewDelegate>
@property (nonatomic, weak) UITableView *proView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JMProHeaderView *header;
@property (nonatomic, weak) MBProgressHUD *hud;
@end

@implementation JMBuyProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.rightTitle = NSLocalizedString(@"gif.base.alert.done", "");
//    self.leftTitle = NSLocalizedString(@"gif.BuyPro.LeftTitle.RestorePurchase", "");
    self.title = NSLocalizedString(@"gif.set.sectionZero.rowZero", "");
    [self reloadModels];
    
    UITableView *proView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    [proView registerClass:[JMProTableViewCell class] forCellReuseIdentifier:@"proCell"];
    proView.delegate = self;
    proView.dataSource = self;
    proView.sectionHeaderHeight = 0;
    proView.sectionFooterHeight = 0;
    proView.backgroundColor = JMColor(41, 41, 41);
    proView.separatorColor = proView.backgroundColor;
    proView.showsVerticalScrollIndicator = NO;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){proView.cellLayoutMarginsFollowReadableWidth = NO;}
    [self.view addSubview:proView];
    self.proView = proView;
    [proView mas_makeConstraints:^(MASConstraintMaker *make) {make.edges.mas_equalTo(self.view);}];
    
    JMProHeaderView *header = [[JMProHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*0.6)];
    header.delegate = self;
    header.backgroundColor = JMColor(41, 41, 41);
    proView.tableHeaderView = header;
    self.header = header;
}

- (void)rightTitleAction:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftTitleAction:(UIBarButtonItem *)sender
{
    // NSLog(@"恢复购买目录");
//    [JMUserDefault setBool:NO forKey:@"superUser"];
    
//    if ([JMBuyHelper getVip]) {
//        
//        [_header refruseView];
//        [self reloadModels];
//    };
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"proCell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.view.height - self.view.width*0.8-84)/4;
}

- (void)reloadModels
{
    [self.dataArray removeAllObjects];
    
    ProModel *model = [[ProModel alloc] init];
    [self.dataArray addObject:model];
    
    ProModel *model1 = [[ProModel alloc] init];
    [self.dataArray addObject:model1];
    
    ProModel *model2 = [[ProModel alloc] init];
    [self.dataArray addObject:model2];
    
    ProModel *model3 = [[ProModel alloc] init];
    [self.dataArray addObject:model3];
    
    if ([JMBuyHelper isVip]) {
        
        model.image = @"waterCap";
        model.title = NSLocalizedString(@"gif.BuyPro.headerGetSuperUser.VIP", "");
        model.subTitle = NSLocalizedString(@"gif.BuyPro.headerGetVip.watercap", "");
        
        model1.image = @"filter";
        model1.title = NSLocalizedString(@"gif.BuyPro.headerGetSuperUser.VIP", "");
        model1.subTitle = NSLocalizedString(@"gif.BuyPro.headerGetVip.filter", "");
        
        model2.image = @"ad";
        model2.title = NSLocalizedString(@"gif.BuyPro.headerGetSuperUser.VIP", "");
        model2.subTitle = NSLocalizedString(@"gif.BuyPro.headerGetVip.noAD", "");
        
        model3.image = @"limitline";
        model3.title = NSLocalizedString(@"gif.BuyPro.headerGetSuperUser.VIP", "");
        model3.subTitle = NSLocalizedString(@"gif.BuyPro.headerGetVip.nolimite", "");
    }else{
        
        model.image = @"waterCap";
        model.title = NSLocalizedString(@"gif.BuyPro.headerGetVip.onlyVip", "");
        model.subTitle = NSLocalizedString(@"gif.BuyPro.noVip.watercap", "");
        
        model1.image = @"filter";
        model1.title = NSLocalizedString(@"gif.BuyPro.headerGetVip.onlyVip", "");
        model1.subTitle = NSLocalizedString(@"gif.BuyPro.noVip.filter", "");
        
        model2.image = @"ad";
        model2.title = NSLocalizedString(@"gif.BuyPro.headerGetVip.onlyVip", "");
        model2.subTitle = NSLocalizedString(@"gif.BuyPro.noVip.noAD", "");
        
        model3.image = @"limitline";
        model3.title = NSLocalizedString(@"gif.BuyPro.headerGetVip.onlyVip", "");
        model3.subTitle = NSLocalizedString(@"gif.BuyPro.noVip.nolimite", "");
    }
    
    [self.proView reloadData];
}

# pragma mark -- JMProHeaderViewDelegate
- (void)buyPro
{
    [CustomAlertView showOneButtonWithTitle:NSLocalizedString(@"gif.BuyPro.headerGetVip.detailsTitle", "") Message:NSLocalizedString(@"gif.BuyPro.headerGetVip.details", "") ButtonType:CustomAlertViewButtonTypeDefault ButtonTitle:NSLocalizedString(@"gif.base.alert.sure", "") Click:^{

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        self.hud = hud;
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            // 1> 添加一个交易队列观察者
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            
            if ([SKPaymentQueue canMakePayments]) {
                
                [self requestProductData:@"com.JunMing.GifPlay"];
                
            }else{
                // NSLog(@"不允许程序内付费购买");
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gif.base.alert.alert", "") message:NSLocalizedString(@"gif.BuyPro.headerGetVip.purchasedFail", "") delegate:nil cancelButtonTitle:NSLocalizedString(@"gif.base.alert.close","") otherButtonTitles:nil];
                
                [alerView show];
            }
        });
    }];
}

#pragma mark -- 内购项目
// 去苹果服务器请求产品信息
- (void)requestProductData:(NSString *)productId {
    
    NSArray *productArr = [[NSArray alloc]initWithObjects:productId, nil];
    NSSet *productSet = [NSSet setWithArray:productArr];
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:productSet];
    request.delegate = self;
    [request start];
}

#pragma mark -- SKProductsRequestDelegate
// 收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    // 发送内购请求
    NSArray *myProduct = response.products;
    SKPayment *payment = [SKPayment paymentWithProduct:myProduct.firstObject];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)requestProUpgradeProductData
{
    // NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}


#pragma mark -- SKRequestDelegate
// 弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{[_hud hideAnimated:YES];});

    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"gif.base.alert.close","") otherButtonTitles:nil];
    [alerView show];
    
}

- (void)requestDidFinish:(SKRequest *)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_hud hideAnimated:YES];
    });

    // NSLog(@"----------反馈信息结束--------------");
}

// SKPaymentTransactionObserver 千万不要忘记绑定，代码如下：
// ----监听购买结果
// [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
- (void)PurchasedTransaction:(SKPaymentTransaction *)transaction
{
    // NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    // NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState){
                
            case SKPaymentTransactionStatePurchased:
                
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [self restoreTransaction:transaction];
                break;
                
            case SKPaymentTransactionStatePurchasing:
                
                // NSLog(@"-----商品添加进列表 --------");
                break;
                
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    // NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        
        if ([bookid length] > 0) {
            
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

// 购买成功, 记录交易
- (void)recordTransaction:(NSString *)product
{
    [JMBuyHelper setVIP];
    [_header refruseView];
    [self reloadModels];
}

// 处理下载内容
- (void)provideContent:(NSString *)product
{
    // NSLog(@"-----下载--------");
}

// 已经购买过该商品
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [JMBuyHelper setVIP];
    [_header refruseView];
    [self reloadModels];
    
    UIAlertView *alerView2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gif.base.alert.alert", "") message:NSLocalizedString(@"gif.BuyPro.headerGetVip.purchased", "") delegate:nil cancelButtonTitle:NSLocalizedString(@"gif.base.alert.close","") otherButtonTitles:nil];
    [alerView2 show];
}

// 购买失败, 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    // NSLog(@"-----交易失败 --------");gif.BuyPro.headerGetVip.payFail
    UIAlertView *alerView2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gif.base.alert.alert", "") message:NSLocalizedString(@"gif.BuyPro.headerGetVip.payFail", "")delegate:nil cancelButtonTitle:NSLocalizedString(@"close",nil) otherButtonTitles:nil];
    [alerView2 show];
}


// 不知道干啥用的还
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentTransaction *)transaction
{
    
}

- (void)paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // NSLog(@"test");
}


- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
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
