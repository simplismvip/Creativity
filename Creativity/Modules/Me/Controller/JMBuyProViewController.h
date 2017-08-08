//
//  JMBuyProViewController.h
//  Creativity
//
//  Created by JM Zhao on 2017/6/20.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMBaseController.h"
#import <StoreKit/StoreKit.h>

@interface JMBuyProViewController : JMBaseController
- (void)requestProUpgradeProductData;
- (void)buyPro;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void)PurchasedTransaction: (SKPaymentTransaction *)transaction;
- (void)completeTransaction: (SKPaymentTransaction *)transaction;
- (void)failedTransaction: (SKPaymentTransaction *)transaction;
- (void)paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;
- (void)paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void)restoreTransaction:(SKPaymentTransaction *)transaction;
- (void)provideContent:(NSString *)product;
- (void)recordTransaction:(NSString *)product;
@end
