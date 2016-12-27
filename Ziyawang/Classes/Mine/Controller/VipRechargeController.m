//
//  VipRechargeController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/14.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "VipRechargeController.h"
#import "KnowVipController.h"
#import <StoreKit/StoreKit.h>

#define AppStoreInfoLocalFilePath [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"EACEF35FE363A75A"]

@interface VipRechargeController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *knowLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *monthImageview;
@property (weak, nonatomic) IBOutlet UIImageView *yearImageview;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UIView *yearView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *typeDesLabel;


@property (nonatomic,strong) NSArray *imageNameArray;
@property (nonatomic,strong) NSMutableArray *productsArray;
@property (nonatomic,strong) NSMutableArray *amountArray;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) NSString *product;
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *payid;
@property (nonatomic,strong) NSString *payname;
@end

@implementation VipRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员充值";
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.sureButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    
    self.imageNameArray = @[@"superbao",@"superqi",@"supergu",@"superrong",@"superge",@"superSvip"];
    self.monthImageview.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];
    self.yearImageview.image = [UIImage imageNamed:@"leixingxuanzhong"];
    [self setamountArray];
    [self setproductArray];
    
    switch (self.vipType.integerValue) {
            //资产包
        case 1:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[0]];
            [self.yearView setHidden:YES];
            self.backViewHeight.constant = 52;
            self.topLabel.text = @"月度会员";
            self.monthMoneyLabel.text = @"¥6498";
            self.payname = @"资产包";
            self.payid = @"7";
            self.product = self.productsArray[0];
            self.monthImageview.image = [UIImage imageNamed:@"leixingxuanzhong"];
            self.typeDesLabel.text = @"开通资产包VIP享受精彩特权";
            break;
            //企业商账
        case 2:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[1]];
            self.monthMoneyLabel.text = @"¥1498";
            self.yearMoneyLabel.text = @"¥4998";
            
            self.payid = @"10";
            self.product = self.productsArray[2];
            self.payname = @"企业商账";
            self.typeDesLabel.text = @"开通企业商账VIP享受精彩特权";

            break;
            //固定资产
        case 3:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[2]];
            [self.yearView setHidden:YES];
            self.backViewHeight.constant = 52;
            self.monthMoneyLabel.text = @"¥3998";
            
            self.payid = @"5";
            self.product = self.productsArray[3];
            self.payname = @"固定资产";
            self.monthImageview.image = [UIImage imageNamed:@"leixingxuanzhong"];
            self.typeDesLabel.text = @"开通固定资产VIP享受精彩特权";

            break;
            //融资信息
        case 4:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[3]];
            self.monthMoneyLabel.text = @"¥998";
            self.yearMoneyLabel.text = @"¥2998";
            self.payid = @"4";
            self.product = self.productsArray[5];
            self.payname = @"融资信息";
            self.typeDesLabel.text = @"开通融资信息VIP享受精彩特权";

            break;
            //个人债权
        case 5:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[4]];
            self.monthMoneyLabel.text = @"¥998";
            self.yearMoneyLabel.text = @"¥2998";
            self.payid = @"2";
            self.product = self.productsArray[7];
            self.payname = @"个人债权";
            self.typeDesLabel.text = @"开通个人债权VIP享受精彩特权";

            break;
           
//        case 6:
//            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[5]];
//            break;
        default:
            break;
    }
    self.monthView.tag = 1;
    self.yearView.tag = 2;
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    [self.monthView addGestureRecognizer:gesture1];
    [self.yearView addGestureRecognizer:gesture2];
    
    UITapGestureRecognizer *knowLabelGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(knowLabelGestureAction:)];
    self.knowLabel.userInteractionEnabled = YES;
    [self.knowLabel addGestureRecognizer:knowLabelGesture];
    
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    
}
- (void)setproductArray
{
    self.productsArray = [NSMutableArray new];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.zichanbaoyuedu2"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.qiyejidu2"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.qiyenianduhuiyuan2"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.guchanjidu2"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.rongzijidu2"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.rongziniandu2"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.gerenjidu2"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.gerenniandu2"];
}

- (void)setamountArray
{
    self.amountArray = [NSMutableArray new];
    [self.amountArray addObject:@"100"];
    [self.amountArray addObject:@"1200"];
    [self.amountArray addObject:@"5000"];
    [self.amountArray addObject:@"10800"];
    [self.amountArray addObject:@"28800"];
    [self.amountArray addObject:@"58800"];
    [self.amountArray addObject:@"109800"];
    [self.amountArray addObject:@"199800"];
    
}
- (void)gestureAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.view.tag == 1) {
        self.monthImageview.image = [UIImage imageNamed:@"leixingxuanzhong"];
        self.yearImageview.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];
        switch (self.vipType.integerValue) {
                //资产包
            case 1:
                self.payid = @"7";
                self.product = self.productsArray[0];
                break;
                //企业商账
            case 2:
                self.payid = @"9";
                self.product = self.productsArray[1];
                break;
                //固定资产
            case 3:
                self.payid = @"5";
                self.product = self.productsArray[3];
                break;
                //融资信息
            case 4:
                self.payid = @"3";
                self.product = self.productsArray[4];
                break;
                //个人债权
            case 5:
                self.payid = @"1";
                self.product = self.productsArray[6];
                break;
            default:
                break;
        }
    }
    else
    {
        self.monthImageview.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];
        self.yearImageview.image = [UIImage imageNamed:@"leixingxuanzhong"];
        switch (self.vipType.integerValue) {
                //资产包
            case 1:
                self.payid = @"7";
                self.product = self.productsArray[0];
                break;
                //企业商账
            case 2:
                self.payid = @"10";
                self.product = self.productsArray[2];
                break;
                //固定资产
            case 3:
                self.payid = @"5";
                self.product = self.productsArray[3];
                break;
                //融资信息
            case 4:
                self.payid = @"4";
                self.product = self.productsArray[5];
                break;
                //个人债权
            case 5:
                self.payid = @"2";
                self.product = self.productsArray[7];
                break;
            default:
                break;
        }
        

    }
    
    
    
}
- (void)knowLabelGestureAction:(UITapGestureRecognizer *)gesture
{
    KnowVipController *knowVipVC = [[KnowVipController alloc]init];
    knowVipVC.vipType = self.vipType;
    
    [self.navigationController pushViewController:knowVipVC animated:YES];
    
}
- (IBAction)sureButtonAction:(id)sender {
    
    if ([SKPaymentQueue canMakePayments]) {
        
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.mode = MBProgressHUDModeIndeterminate;
        [self requestProductData:self.product];
    }
    else
    {
        NSLog(@"用户禁止应用内付费");
    }
}
- (void)confirmViewAction:(UITapGestureRecognizer *)gesture
{
    if ([SKPaymentQueue canMakePayments]) {
        
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.payname forKey:@"payname"];
    [dic setObject:self.payid forKey:@"payid"];
    [dic setObject:@"member" forKey:@"paytype"];
    [dic setObject:receipt forKey:@"backnumber"];
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
        
        [self saveReceiptWithReceipt:receipt];
        
        
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
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //    [alert show];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action];
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
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
