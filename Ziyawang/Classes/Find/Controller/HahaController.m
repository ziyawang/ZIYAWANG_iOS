//
//  HahaController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/10.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "HahaController.h"
#import "VideosViewCell.h"
#import "AFNetWorking.h"
#import "VideosModel.h"
#import "ZXVideo.h"
#import "VideoPlayViewController.h"

#import "VideosModel.h"
#import "LoginController.h"
#import "RechargeController.h"
#import "PublishModel.h"
#define kWidthScale ([UIScreen mainScreen].bounds.size.width/375)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/667)
@interface HahaController ()<UITableViewDelegate,UITableViewDataSource,playDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,assign) NSInteger startPage;
@property (nonatomic,strong) ZXVideo *zvideo;

@property (nonatomic,strong) NSString *videoURL;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) UIView *alertView1;
@property (nonatomic,strong) UIView *alertView2;
@property (nonatomic,strong) UIView *blackBackView1;
@property (nonatomic,strong) UIView *blackBackView2;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *AccountLabel1;
@property (nonatomic,strong) UILabel *AccountLabel2;
@property (nonatomic,strong) UILabel *buzuLabel;
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) NSString *USERID;
@property (nonatomic,strong) VideosModel *pubModel;
@property (nonatomic,assign) NSInteger row;
@end

@implementation HahaController

- (void)pushToControllerWithZXVideo:(ZXVideo *)zvideo model:(VideosModel *)model
{
    self.account = [[NSUserDefaults standardUserDefaults]objectForKey:@"account"];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    userInfo[@"zvideoModel"] = zvideo;
    userInfo[@"model"] = model;
    self.pubModel = model;
    if ([model.Member isEqualToString:@"0"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
    }
    else
    {
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"] == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentToLoginControllerNotification" object:nil userInfo:userInfo];
        }
        
        
        else
        {
            self.pubModel.PayFlag = [NSString stringWithFormat:@"%@",self.pubModel.PayFlag];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"right"] isEqualToString:@""]==NO || [self.pubModel.PayFlag isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
            }
            else
            {
                [self createViewForLessMoney];
            }
        }
    }
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserInfoFromDomin];
    [self getNewVideosList];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.zvideo = [[ZXVideo alloc]init];
    self.pubModel = [[VideosModel alloc]init];

    self.sourceArray = [NSMutableArray new];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VideosViewCell" bundle:nil] forCellReuseIdentifier:@"VideosViewCell"];

    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self getUserInfoFromDomin];

     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

}
- (void)getUserInfoFromDomin
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    //    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    if (token != nil) {
        NSString *URL = [[getUserInfoURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"token" forKey:@"access_token"];
        [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.account = dic[@"user"][@"Account"];
            self.role = dic[@"role"];
            self.USERID = dic[@"user"][@"userid"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"user"][@"Account"] forKey:@"account"];

            [[NSUserDefaults standardUserDefaults] setObject:dic[@"user"][@"right"] forKey:@"right"];
            
            //            [self.userModel setValuesForKeysWithDictionary:dic[@"user"]];
            //            [self.userModel setValuesForKeysWithDictionary:dic[@"service"]];
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
    }
    
}

- (void)loadMoreData
{
//    NSString *headurl = @"https://apis.ziyawang.com/zll";
//    NSString *footurl = @"/video/list";
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *URL = getVideoListURL;
    if (token != nil) {
        URL =[[getVideoListURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    NSString *accesstoken = @"token";
    NSString *VideoLabel = @"zyhhh";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:accesstoken forKey:@"access_token"];
    //    [dic setObject:pagecount forKey:@"pagecount"];
    [dic setObject:VideoLabel forKey:@"VideoLabel"];
    [dic setObject:[NSString stringWithFormat:@"%ld",self.startPage] forKey:@"startpage"];
    
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取信息成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *dataArray = dic[@"data"];
        NSMutableArray *addArray = [NSMutableArray new];
        
        
        for (NSDictionary *dic in dataArray) {
            
            VideosModel *model = [[VideosModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [addArray addObject:model];
        }
        self.startPage ++;
        if (addArray.count == 0) {
            //            [self.tableView.mj_footer resetNoMoreData];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];

        }
        else
        {
        [self.sourceArray addObjectsFromArray:addArray];
        NSLog(@"%@",self.sourceArray);
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取信息失败");
        NSLog(@"%@",error);
        [self.tableView.mj_footer endRefreshing];

        [self showAlertWithMessage:@"信息获取失败，请检查您的网络状态"];
        
    }];
}


- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}
//
- (void)getNewVideosList
{
    [self.sourceArray removeAllObjects];
    
    self.startPage = 1;
//    NSString *headurl = @"https://apis.ziyawang.com/zll";
//    NSString *footurl = @"/video/list";
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *URL = getVideoListURL;
    if (token != nil) {
        URL =[[getVideoListURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    NSString *accesstoken = @"token";
    NSString *VideoLabel = @"zyhhh";
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:accesstoken forKey:@"access_token"];
    
    //    [dic setObject:pagecount forKey:@"pagecount"];
    [dic setObject:VideoLabel forKey:@"VideoLabel"];
    
    
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取信息成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *dataArray = dic[@"data"];
        
      
            for (NSDictionary *dic in dataArray) {
                VideosModel *model = [[VideosModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.sourceArray addObject:model];
            }
            self.startPage ++;
            NSLog(@"%@",self.sourceArray);
            [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取信息失败");
        NSLog(@"%@",error);
        [self showAlertWithMessage:@"获取信息失败，请检查您的网络状况"];
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 230;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 250;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 270;
        
    }
    return 270;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideosViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideosViewCell" forIndexPath:indexPath];
    cell.model = self.sourceArray[indexPath.row];
    cell.zvideo = self.zvideo;
    cell.Mydelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.account = [[NSUserDefaults standardUserDefaults]objectForKey:@"account"];
    VideosModel *model = [[VideosModel alloc]init];
    model = self.sourceArray[indexPath.row];
    self.pubModel = model;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    self.row = indexPath.row;
    userInfo[@"zvideoModel"] = _zvideo;
    userInfo[@"model"] = model;
    
    if ([model.Member isEqualToString:@"0"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"] == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentToLoginControllerNotification" object:nil userInfo:userInfo];
        }
        
        
        else
        {
            self.pubModel.PayFlag = [NSString stringWithFormat:@"%@",self.pubModel.PayFlag];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"right"] isEqualToString:@""]==NO || [self.pubModel.PayFlag isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
            }
            else
            {
                [self createViewForLessMoney];
            }
        }
    }
}
- (void)payForMessage
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    [dataDic setObject:@"token" forKey:@"access_token"];
    [dataDic setObject:self.pubModel.VideoID forKey:@"VideoID"];
    NSString *URL = [[paidVideoURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSLog(@"-----%@",URL);
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager POST:URL parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSString *status_code = dic[@"status_code"];
         if ([status_code isEqualToString:@"417"]) {
             NSLog(@"已支付");
         }
         else if ([status_code isEqualToString:@"418"])
         {
             NSLog(@"余额不足");
             [self MBProgressWithString:@"余额不足，请充值！" timer:2 mode:MBProgressHUDModeText];
         }
         else if ([status_code isEqualToString:@"416"])
         {
             NSLog(@"非收费信息");
         }
         else if ([status_code isEqualToString:@"200"])
         {
             [self.blackBackView1 removeFromSuperview];
             [self.alertView1 removeFromSuperview];
             [self.blackBackView2 removeFromSuperview];
             [self.alertView2 removeFromSuperview];
             
             NSLog(@"支付成功");
             self.pubModel.PayFlag = @"1";
             
             VideosModel *model = [[VideosModel alloc]init];
             model = self.sourceArray[self.row];
             NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
             
             userInfo[@"zvideoModel"] = self.zvideo;
             userInfo[@"model"] = model;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
             
             //             [self.connectButton setTitle:@"已约谈" forState:(UIControlStateNormal)];
             [self.blackBackView2 removeFromSuperview];
             [self.alertView2 removeFromSuperview];
         }
         [self.HUD removeFromSuperViewOnHide];
         [self.HUD hideAnimated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         
     }];
    
}



- (void)createViewForLessMoney
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 30, self.view.bounds.size.width - 40, 70)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIView *blackBackview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [blackBackview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    UITapGestureRecognizer *blackBackViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackBackTapAction1:)];
    [blackBackview addGestureRecognizer:blackBackViewTapGesture];
    
    UIView *alertView  = [[UIView alloc]initWithFrame:CGRectMake(44 * kWidthScale, 69 * kHeightScale, 288 * kWidthScale , 400 * kHeightScale)];
    [alertView setBackgroundColor:[UIColor whiteColor]];
    
    
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertView.bounds.size.width, alertView.bounds.size.height/2)];
    yellowView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    [alertView addSubview:yellowView];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(30, 24*kHeightScale, 98 * kWidthScale, 98 * kWidthScale)];
    CGRect frame = imageview.frame;
    frame.size = CGSizeMake(98 * kWidthScale, 98 * kWidthScale);
    imageview.frame = frame;
    CGPoint center = imageview.center;
    center.x = alertView.frame.size.width/2;
    imageview.center = center;
    
    //           imageview.centerX = self.view.bounds.size.width/2;
    imageview.image = [UIImage imageNamed:@"yuetan-popup-logo"];
    [yellowView addSubview:imageview];
    
    UILabel *resourceType = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*kHeightScale + 98 * kWidthScale + 20  *kHeightScale, alertView.bounds.size.width, 20)];
    resourceType.text = @"该视频为付费视频";
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*kHeightScale + 98 * kWidthScale + 20 *kHeightScale +25 * kHeightScale, alertView.bounds.size.width, 20)];
    textLabel.text = @"消耗芽币可观看视频";
    resourceType.font = [UIFont systemFontOfSize:20];
    textLabel.font = [UIFont systemFontOfSize:15];
    resourceType.textAlignment = NSTextAlignmentCenter;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [yellowView addSubview:resourceType];
    [yellowView addSubview:textLabel];
    
    CGFloat Height = yellowView.bounds.size.height;
    UIImageView *smallImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(30*kWidthScale, Height + 20*kHeightScale, 20, 20)];
    smallImage1.image = [UIImage imageNamed:@"yuetan-goldcoin"];
    
    UILabel *xiaohaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + 20, 150, 100, 20)];
    CGSize labelSize1 = [@"消耗：" sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    xiaohaoLabel.frame = CGRectMake(30*kWidthScale + 36*kWidthScale, Height + 20*kHeightScale, labelSize1.width,20);
    xiaohaoLabel.text = @"消耗：";
    
    CGSize labelSize2 = [self.pubModel.Price sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width,Height + 20*kHeightScale,labelSize2.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label1.numberOfLines = 0;
    label1.text = self.pubModel.Price;
    label1.font = [UIFont systemFontOfSize:20];
    label1.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    UILabel *yabiLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width + labelSize2.width, Height + 20*kHeightScale, 40, 20)];
    yabiLabel1.text = @"芽币";
    
    UIImageView *smallImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(30*kWidthScale, Height + 20*kHeightScale + 32 * kHeightScale, 20, 20)];
    smallImage2.image = [UIImage imageNamed:@"yuetan-goldcoin"];
    
    UILabel *xiaohaoLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + 20 , 150+32, 100, 20)];
    CGSize labelSize11 = [@"余额：" sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    
    xiaohaoLabel2.frame = CGRectMake(30*kWidthScale + 36*kWidthScale, Height + 20*kHeightScale + 32* kHeightScale, labelSize1.width,20);
    xiaohaoLabel2.text = @"余额：";
    CGSize labelSize22 = [self.account sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width,Height + 20*kHeightScale + 32* kHeightScale,labelSize22.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label2.numberOfLines = 0;
    label2.text = self.account;
    label2.font = [UIFont systemFontOfSize:20];
    
    label2.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    //   self.AccountLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width,Height + 20*kHeightScale + 32* kHeightScale,labelSize22.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    //    self.AccountLabel1.numberOfLines = 0;
    //    self.AccountLabel1.text = self.model.Account;
    //    self.AccountLabel1.font = [UIFont systemFontOfSize:20];
    //
    //    self.AccountLabel1.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    
    UILabel *yabiLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width + labelSize22.width, Height + 20*kHeightScale+32* kHeightScale, 40, 20)];
    
    
    yabiLabel2.text = @"芽币";
    
    UILabel *buzuLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width + labelSize22.width + 40,  Height + 20*kHeightScale+32* kHeightScale, 100, 20)];
    if (self.account.integerValue < self.pubModel.Price.integerValue)
    {
        buzuLabel.text = @"(余额不足)";
    }
    buzuLabel.font = [UIFont systemFontOfSize:11];
    
    self.buzuLabel = buzuLabel;
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setFrame:CGRectMake(alertView.bounds.size.width - 30 * kWidthScale, 10 *kWidthScale, 20 * kWidthScale, 20 * kWidthScale)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    cancelButton.tag = 1;
    [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [sureButton setFrame:CGRectMake(26*kWidthScale, Height + 20*kHeightScale+32* kHeightScale + 20*kHeightScale + 20 * kHeightScale, alertView.bounds.size.width - 52 * kWidthScale, 40 * kHeightScale)];
    [sureButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    sureButton.tag = 3;
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *rechargeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rechargeButton setFrame:CGRectMake(26*kWidthScale, Height + 20*kHeightScale+32* kHeightScale + 20*kHeightScale+12*kHeightScale+40*kHeightScale+ 20 * kHeightScale, alertView.bounds.size.width - 52 * kWidthScale, 40 * kHeightScale)];
    [rechargeButton setBackgroundColor:[UIColor whiteColor]];
    [rechargeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [rechargeButton setTitle:@"充值" forState:(UIControlStateNormal)];
    
    rechargeButton.layer.borderWidth = 2.5;
    rechargeButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    [rechargeButton addTarget:self action:@selector(rechareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [alertView addSubview:smallImage1];
    [alertView addSubview:xiaohaoLabel];
    [alertView addSubview:label1];
    [alertView addSubview:yabiLabel1];
    [alertView addSubview:smallImage2];
    [alertView addSubview:xiaohaoLabel2];
    [alertView addSubview:label2];
    [alertView addSubview:yabiLabel2];
    [alertView addSubview:buzuLabel];
    [alertView addSubview:cancelButton];
    [alertView addSubview:sureButton];
    [alertView addSubview:rechargeButton];
    
    self.blackBackView1 = blackBackview;
    self.alertView1 = alertView;
    self.alertView1 = alertView;
    [self.view addSubview:self.blackBackView1];
    [self.view addSubview:self.alertView1];
    
}
- (void)blackBackTapAction1:(UITapGestureRecognizer *)gesture
{
    [self.alertView1 removeFromSuperview];
    [self.blackBackView1 removeFromSuperview];
}
- (void)blackBackTapAction2:(UITapGestureRecognizer *)gesture
{
    [self.alertView2 removeFromSuperview];
    [self.blackBackView2 removeFromSuperview];
}
- (void)didClickCancelButton:(UIButton *)button
{
    if (button.tag == 1) {
        [self.alertView1 removeFromSuperview];
        [self.blackBackView1 removeFromSuperview];
    }
    else
    {
        [self.alertView2 removeFromSuperview];
        [self.blackBackView2 removeFromSuperview];
    }
    
}
- (void)sureButtonAction:(UIButton *)button
{
    if(self.pubModel.Price.integerValue > self.account.integerValue)
    {
        [self MBProgressWithString:@"余额不足，请充值！" timer:2 mode:MBProgressHUDModeText];
    }
    else
    {
        
        [self payForMessage];
    }
    
}
- (void)rechareButtonAction:(UIButton *)button
{
    //    MyYabiController *yabiVC = [[MyYabiController alloc]init];
    
    [self.blackBackView1 removeFromSuperview];
    [self.alertView1 removeFromSuperview];
    [self.blackBackView2 removeFromSuperview];
    [self.alertView2 removeFromSuperview];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToReacharControllerNotifi" object:nil userInfo:userInfo];
}
//显示菊花
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
}




@end
