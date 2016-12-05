//
//  RechargeController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/24.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "RechargeController.h"
#import <StoreKit/StoreKit.h>


#define AppStoreInfoLocalFilePath [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"EACEF35FE363A75A"]


@interface RechargeController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonSix;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeven;
@property (weak, nonatomic) IBOutlet UIButton *buttonEight;
@property (weak, nonatomic) IBOutlet UIButton *buttonNine;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsWidth;

@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

@property (weak, nonatomic) IBOutlet UIView *confirmRecharhe;

@property (nonatomic,strong) NSString *product;

@property (nonatomic,strong) UIImageView *selectedView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *realMoneyArray;
@property (nonatomic,strong) NSMutableArray *productsArray;
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSMutableArray *amountArray;


@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmViewAction:)];
    [self.confirmRecharhe addGestureRecognizer:tapGesture];
   
    
    self.navigationItem.title = @"充值";
    [self setButtonsView];
    [self setProductArray];
    [self setamountArray];
//    [self setupTitle];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    [self getYabiType];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setProductArray
{
    self.productsArray = [NSMutableArray new];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.10"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.120"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.500"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.1080"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.2880"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.5880"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.10980"];
    [self.productsArray addObject:@"i.e.com.ziyawang.Ziya.19980"];
    
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
    
    NSString *URL = [[RechargeSussceeURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSLog(@"--------%@",URL);
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.amount forKey:@"amount"];
    [dic setObject:receipt forKey:@"backnumber"];
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
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

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
    
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

- (void)getYabiType
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [self.manager GET:rechargeURL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.dataArray = [NSArray arrayWithArray:dataArray];
        NSMutableArray *RealMoneyArray = [[NSMutableArray alloc]init];
        for (NSDictionary *strDic in dataArray) {
            NSString *str = strDic[@"RealMoney"];
            
            NSString *Str = [NSString stringWithFormat:@"%ld",str.integerValue/100];
            [RealMoneyArray addObject:Str];
        }
        self.realMoneyArray = [NSMutableArray arrayWithArray:RealMoneyArray];
        
        
        
        [self addViewToButtonsWithButton:self.buttonOne labelText:RealMoneyArray[0] longLabelText:dataArray[0][@"YBCount"] defaultFlag:dataArray[0][@"selected"] add:dataArray[0][@"add"]];
        [self addViewToButtonsWithButton:self.buttonTwo labelText:RealMoneyArray[1]  longLabelText:dataArray[1][@"YBCount"] defaultFlag:dataArray[1][@"selected"] add:dataArray[1][@"add"]];
        [self addViewToButtonsWithButton:self.buttonThree labelText:RealMoneyArray[2]  longLabelText:dataArray[2][@"YBCount"] defaultFlag:dataArray[2][@"selected"] add:dataArray[2][@"add"]];
        [self addViewToButtonsWithButton:self.buttonFour labelText:RealMoneyArray[3]  longLabelText:dataArray[3][@"YBCount"] defaultFlag:dataArray[3][@"selected"] add:dataArray[3][@"add"]];
        [self addViewToButtonsWithButton:self.buttonFive labelText:RealMoneyArray[4]  longLabelText:dataArray[4][@"YBCount"] defaultFlag:dataArray[4][@"selected"] add:dataArray[4][@"add"]];
        [self addViewToButtonsWithButton:self.buttonSix labelText:RealMoneyArray[5]  longLabelText:dataArray[5][@"YBCount"] defaultFlag:dataArray[5][@"selected"] add:dataArray[5][@"add"]];
        
        [self addViewToButtonsWithButton:self.buttonSeven labelText:RealMoneyArray[6]  longLabelText:dataArray[6][@"YBCount"] defaultFlag:dataArray[6][@"selected"] add:dataArray[6][@"add"]];
        [self addViewToButtonsWithButton:self.buttonEight labelText:RealMoneyArray[7]  longLabelText:dataArray[7][@"YBCount"] defaultFlag:dataArray[7][@"selected"] add:dataArray[7][@"add"]];
//        [self addViewToButtonsWithButton:self.buttonNine labelText:RealMoneyArray[8]  longLabelText:dataArray[8][@"YBCount"] defaultFlag:dataArray[8][@"selected"]];
//
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        [self showMessageWithMessage:@"获取信息失败，请稍后再试"];
        
    }];
    

}
- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = @"充值";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;

    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)setButtonsView
{
    self.selectedView = [[UIImageView alloc]initWithFrame:CGRectMake([self widthForlabel] - [self widthForlabel]/4 +7, [self widthForlabel]/2 - [self widthForlabel]/4+7, [self widthForlabel]/4-10, [self widthForlabel]/4-10)];
    self.selectedView.image = [UIImage imageNamed:@"xuanzeqian"];
    self.buttonOne.tag = 0;
    self.buttonTwo.tag = 1;
    self.buttonThree.tag = 2;
    self.buttonFour.tag = 3;
    self.buttonFive.tag = 4;
    self.buttonSix.tag = 5;
    self.buttonSeven.tag = 6;
    self.buttonEight.tag = 7;
    self.buttonNine.tag = 8;
    
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
    [self.buttonOne addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonTwo addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonThree addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonFour addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonFive addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonSix addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonSeven addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonEight addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonNine addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)addViewToButtonsWithButton:(UIButton *)button labelText:(NSString *)text longLabelText:(NSString *)longText defaultFlag:(NSString *)defaultFlag add:(NSString *)add
{

    defaultFlag = [NSString stringWithFormat:@"%@",defaultFlag];
    if ([defaultFlag isEqualToString:@"1"]) {
        self.product = self.productsArray[button.tag];
        self.amount = self.amountArray[button.tag];
        [button addSubview:self.selectedView];
        self.buttonLabel.text = [@"¥"stringByAppendingString:text];
    }
    [button setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [button setBackgroundImage:[UIImage imageNamed:@"dahuangkuang"] forState:(UIControlStateNormal)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, [self constansForlabel], [self widthForlabel], 15)];
//    label.backgroundColor = [UIColor redColor];
//    UILabel *longLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [self constansForlabel2], [self widthForlabel], 11)];
    UILabel *label = [UILabel new];
    UILabel *longLabel = [UILabel new];
    UILabel *middleLabel = [UILabel new];
    
    
    [button addSubview:label];
    [button addSubview:longLabel];
    [button addSubview:middleLabel];

    
    if (button.tag != 0 && button.tag != 1) {

        label.sd_layout.bottomSpaceToView(middleLabel,5)
        .centerXEqualToView(button)
        .heightIs(15);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        middleLabel.sd_layout.centerYEqualToView(button)
        .centerXEqualToView(button)
        .heightIs(11);
        [middleLabel setSingleLineAutoResizeWithMaxWidth:300];
        
        longLabel.sd_layout.topSpaceToView(middleLabel,5)
        .centerXEqualToView(button)
        .heightIs(11);
        [longLabel setSingleLineAutoResizeWithMaxWidth:300];

    }
    else
    {
        label.sd_layout.bottomSpaceToView(middleLabel,3)
        .centerXEqualToView(button)
        .heightIs(15);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        middleLabel.sd_layout.centerYEqualToView(button)
        .centerXEqualToView(button)
        .heightIs(1);
        [middleLabel setSingleLineAutoResizeWithMaxWidth:300];

        
        longLabel.sd_layout.topSpaceToView(middleLabel,3)
        .centerXEqualToView(button)
        .heightIs(11);
        [longLabel setSingleLineAutoResizeWithMaxWidth:300];
        [middleLabel setHidden:YES];
        
    }
    
    
    
//    longLabel.backgroundColor = [UIColor blueColor];
//    label.centerX = button.centerX;
//    longLabel.centerX = button.centerX;
    
    label.textAlignment = NSTextAlignmentCenter;
    longLabel.textAlignment = NSTextAlignmentCenter;
    
    label.text = [longText stringByAppendingString:@"芽币"];
    longLabel.text = [[@"充值:"stringByAppendingString:text]stringByAppendingString:@"元"];
    label.font = [UIFont systemFontOfSize:15];
    longLabel.font = [UIFont systemFontOfSize:12];
    longLabel.textColor = [UIColor grayColor];
    
    middleLabel.font = [UIFont systemFontOfSize:12];
    middleLabel.textColor = [UIColor colorWithHexString:@"#ff2f2f"];
    middleLabel.text = [[[[@"("stringByAppendingString:@"赠送"]stringByAppendingString:add]stringByAppendingString:@"芽币"]stringByAppendingString:@")"];
    
    
    
    
    
    
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width, button.bounds.size.height - 5)];
//    imageview.image = [UIImage imageNamed:@"xiaobai"];
//    [button addSubview:imageview];
    
}
- (void)buttonsAction:(UIButton *)button
{
    NSLog(@"%ld",button.tag);
    self.buttonLabel.text =[@"¥"stringByAppendingString:self.realMoneyArray[button.tag]];
    self.product = self.productsArray[button.tag];
    self.amount = self.amountArray[button.tag];
    
    [button addSubview:self.selectedView];
}
- (CGFloat)widthForlabel
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 91.7;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 110;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 123;
        
    }
    
    return 123;
}

- (CGFloat)constansForlabel
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 7;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 13;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 14;
        
    }
    
    return 10;
}

- (CGFloat)constansForlabel2
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 27;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 33;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 35;
        
    }
    
    return 10;
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
