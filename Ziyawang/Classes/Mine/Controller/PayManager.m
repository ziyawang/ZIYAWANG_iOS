//
//  PayManager.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/27.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PayManager.h"
#import <StoreKit/StoreKit.h>


#define AppStoreInfoLocalFilePath [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"EACEF35FE363A75A"]

@interface PayManager ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *product;
@property (nonatomic,strong) NSMutableDictionary *param;
@property (nonatomic,strong) NSString *URL;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UIButton *rechargeButton;
@end
@implementation PayManager
+(PayManager *)payManager
{
    static PayManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[PayManager alloc]init];
    });
    return defaultManager;
}

-(void)PayForPruduct:(NSString *)pruduct WithURL:(NSString *)url param:(NSMutableDictionary *)param
{
    [self PayForPruduct:pruduct WithURL:url param:param];
}

- (void)payForProductWithPruduct:(NSString *)pruduct WithURL:(NSString *)url param:(NSMutableDictionary *)param Button:(UIButton *)button
{
    

    self.product = pruduct;
    self.URL = url;
    self.param = param;
    self.rechargeButton = button;
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    if ([SKPaymentQueue canMakePayments]) {
        self.HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication]keyWindow] animated:YES];
        self.HUD.delegate = self;
        self.HUD.mode = MBProgressHUDModeIndeterminate;
        [self requestProductData:self.product];
    }
    else
    {
        NSLog(@"用户禁止应用内付费");
    }

}
/**
 *  请求商品
 *
 *  @param type 商品ID
 */
- (void)requestProductData:(NSString *)type
{
    NSArray *product = [[NSArray alloc]initWithObjects:type, nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
    
}
#pragma mark----内支付代理方法
/**
 *  收到产品返回信息
 *
 *  @param request  请求
 *  @param response 响应
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    if ([product count] == 0)  {
        [self showMessageWithMessage:@"无法获取商品信息,请重试"];
        return;
    }
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        if([pro.productIdentifier isEqualToString:self.product]){
            p = pro;
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
/**
 *  请求失败
 *
 *  @param request 请求
 *  @param error   错误
 */
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [self showMessageWithMessage:[error localizedDescription]];
    
    
}
- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"反馈信息结束");
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for(SKPaymentTransaction *tran in transactions){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                [self completeTransaction:tran];
                [self.rechargeButton setTitle:@"再次购买" forState:(UIControlStateNormal)];
                
                
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self.HUD removeFromSuperViewOnHide];
                [self.HUD hideAnimated:YES];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //交易结束
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"交易结束");
    
    //凭证发送给服务器
    NSString *receipt =  [transaction.transactionReceipt base64Encoding];
    [self sendReceiptToDomainWithReceipt:receipt];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"交易失败:%@",transaction.error);
    
    if(transaction.error.code != SKErrorPaymentCancelled) {
        [self showMessageWithMessage:@"交易失败"];
    } else {
        [self showMessageWithMessage:@"交易取消"];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
}


- (void)sendReceiptToDomainWithReceipt:(NSString *)receipt
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *URL = [[VipRechargeURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSLog(@"--------%@",URL);
    
    [self.param setObject:receipt forKey:@"backnumber"];

    [self.manager POST:self.URL parameters:self.param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic[@"status_code"]);
        
        if ([dic[@"status_code"] isEqualToString:@"200"]) {
            NSLog(@"发送成功");
            
        }
        else
        {
            [self saveReceiptWithReceipt:receipt];
        }
        NSLog(@"%@",dic[@"status_code"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
//        [self saveReceiptWithReceipt:receipt];
        //        [self sendReceiptToDomainWithReceipt:receipt];
    }];
}

//持久化存储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
-(void)saveReceiptWithReceipt:(NSString *)receipt{
    NSString *fileName = @"AppStorerRceipt";
    NSString *savedPath = [NSString stringWithFormat:@"%@%@.plist", AppStoreInfoLocalFilePath, fileName];
    
    NSLog(@"%@",savedPath);
    
    NSDictionary *dic =[ NSDictionary dictionaryWithObjectsAndKeys:
                        receipt,                           @"receipt",
                        self.amount,                   @"amount",
                        nil];
    [dic writeToFile:savedPath atomically:YES];
}

- (void)showMessageWithMessage:(NSString *)message
{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alertVC addAction:action];
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
//    [[[UIApplication sharedApplication]keyWindow] presentViewController:alertVC animated:YES completion:nil];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

@end
