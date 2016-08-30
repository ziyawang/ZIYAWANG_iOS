//
//  ServiceDetailController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/4.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ServiceDetailController.h"
#import "FindServiceModel.h"
#import "AFNetWorking.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginController.h"
#import "talkViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ServiceDetailController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIView *bringView;
@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *usericon;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *projectNumber;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyInfo;
@property (weak, nonatomic) IBOutlet UILabel *servicearea;
@property (weak, nonatomic) IBOutlet UILabel *serviceType;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) FindServiceModel *model;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) NSString *phoneNumber;

@property (nonatomic,strong) NSString *CollectFlag;
@property (nonatomic,assign) BOOL isCollected;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UILabel *serviceLocation;



@end

@implementation ServiceDetailController


- (IBAction)didClickSaveButton:(id)sender {
    
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
      NSString *Token = @"?token=";
    NSString *url = @"http://api.ziyawang.com/v1";
    NSString *url2 = @"/collect";
    NSString *access_token = @"token";
    
    NSString *URL = [[[url stringByAppendingString:url2]stringByAppendingString:Token]stringByAppendingString:token];
    
        
        //    NSString *getURL = @"http://api.ziyawang.com/v1/service/list?access_token=token";
    NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
    [postdic setObject:access_token forKey:@"access_token"];
//    [postdic setObject:token forKey:@"token"];
    [postdic setObject:self.ServiceID forKey:@"itemID"];
    [postdic setObject:@"4" forKey:@"type"];
    if (self.isCollected == NO)
    {
        
        NSLog(@"未收藏过,改变button的状态,调用收藏接口");
        [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
         {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"收藏成功");
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"服务收藏返回的信息：%@",dic);
            NSLog(@"%@",dic[@"msg"]);
            
            [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
            [self MBProgressWithString:@"收藏成功" timer:1 mode:MBProgressHUDModeText];


            //收藏按钮状态改变
//            self.saveButton.imageView.image = [UIImage imageNamed:<#(nonnull NSString *)#>]
            self.isCollected = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            [self MBProgressWithString:@"收藏失败" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"收藏失败");
        }];
    }
    else
    {
        [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
         {
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"取消收藏成功");
             [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
             [self MBProgressWithString:@"已取消收藏" timer:1 mode:MBProgressHUDModeText];

             //收藏按钮状态改变
             //            self.saveButton.imageView.image = [UIImage imageNamed:<#(nonnull NSString *)#>]
             self.isCollected = NO;
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             [self MBProgressWithString:@"取消收藏失败" timer:1 mode:MBProgressHUDModeText];
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alert show];
             NSLog(@"取消收藏失败");
         }];
    }
    }
}


- (IBAction)didClickShareButton:(id)sender {
    
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    self.model.ServiceID = [NSString stringWithFormat:@"%@",self.model.ServiceID];
    NSString *URL = [@"http://ziyawang.com/service/" stringByAppendingString:self.model.ServiceID];
    NSString *shareURL1 = @"http://ziyawang.com/project/";
    NSString *shareURL = [shareURL1 stringByAppendingString:self.model.ServiceID];
    UIImage *image = [UIImage imageNamed:@"morentouxiang.png"];
    
    NSArray *imageArray = @[image];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"服务信息"
                                     images:imageArray
                                        url:[NSURL URLWithString:shareURL]
                                      title:@"资芽"
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeSinaWeibo)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state)
                   {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }];
    

    
    
    
}


- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
    
}
- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];


    
    self.sourceArray = [NSMutableArray array];
    self.manager = [AFHTTPSessionManager manager];
    self.model = [[FindServiceModel alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.role = [defaults objectForKey:@"role"];
    [self layoutBottomViewWithUserType:self.role UserID:self.userid];
    [self findServicesDetail];
    
}

//进入的时候判断有没有收藏过
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)findServicesDetail
{
    
    
    if (self.sourceArray != nil)
    {
        [self.sourceArray removeAllObjects];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *url = @"http://api.ziyawang.com/v1/service/list/";
//    NSString *str = @"&token=";
    
    NSString *getURL = [url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ServiceID]];
    if(token == nil)
    {
    getURL = [url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ServiceID]];
    }
    else
    {
//        getURL = [[[[[url stringByAppendingString:@"?token="]stringByAppendingString:token]stringByAppendingString:@"&access_token="]stringByAppendingString:@"token"]stringByAppendingString:[NSString stringWithFormat:@"%@",self.ServiceID]];
        //
        getURL = [[[[[url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ServiceID]]stringByAppendingString:@"?token="]stringByAppendingString:token]stringByAppendingString:@"&access_token="]stringByAppendingString:@"token"];
        }
//    NSString *getURL = @"http://api.ziyawang.com/v1/service/list?access_token=token";
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      
            [self.model setValuesForKeysWithDictionary:dic];
        [self layoutView];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}



//图片的点击放大事件
- (void)tapImagViewWithGesture:(UITapGestureRecognizer *)gesture
{
    
    self.backView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backView];
    
    UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    //////////////////////////////////////////////
    UIImageView *imageView = (UIImageView *)gesture.view;
    bigImageView.image = imageView.image;
    [self.backView addSubview:bigImageView];
    bigImageView.userInteractionEnabled = YES;
    [self.backView addSubview:bigImageView];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBackView:)];
    [bigImageView addGestureRecognizer:tapgesture];
    
}
- (void)closeBackView:(UITapGestureRecognizer *)tapgesture
{
    [self.backView removeFromSuperview];
}

- (void)tapgesture1:(UITapGestureRecognizer *)gesture1
{
    if (self.imageView1.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture1];
      }
    
}
- (void)tapgesture2:(UITapGestureRecognizer *)gesture2
{
    if (self.imageView2.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture2];
        
        
    }}
- (void)tapgesture3:(UITapGestureRecognizer *)gesture3
{
    if (self.imageView3.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture3];
        
        
    }
}
- (void)layoutView
{
    NSString *url = @"http://images.ziyawang.com";
    NSString *usericonurl = self.model.UserPicture;
    self.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
     //设置收藏按钮的状态
    if ([self.CollectFlag isEqualToString:@"0"]) {
        NSLog(@"未收藏过");
        self.isCollected = NO;
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    }
    else
    {
        NSLog(@"收藏过");
        self.isCollected = YES;
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];

    }
    
    if (usericonurl == nil) {
        self.usericon.image = [UIImage imageNamed:@"morentouxiang"];
    }
    else
    {
    [self.usericon sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:usericonurl]]];
    }
    
    self.phoneNumber = self.model.ConnectPhone;
    self.typeName.text = self.model.ServiceType;
    self.projectNumber.text = self.model.ServiceNumber;
//    self.starImage = [UIImage imageNamed:<#(nonnull NSString *)#>]
    self.companyName.text = self.model.ServiceName;
    self.companyInfo.text = self.model.ServiceIntroduction;
    self.servicearea.text = self.model.ServiceArea;
    self.serviceType.text = self.model.ServiceType;
    self.serviceLocation.text = self.model.ServiceLocation;
    
    if (self.model.ConfirmationP1 ==nil)
    {
        
    }
    else if(self.model.ConfirmationP1!=nil&&self.model.ConfirmationP2 != nil&&self.model.ConfirmationP3 == nil)
    {
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP1]]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP2]]];

    }
    else if(self.model.ConfirmationP1 !=nil && self.model.ConfirmationP2 == nil&&self.model.ConfirmationP3 == nil)
    {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP1]]];
    }
    else
    {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP1]]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP2]]];
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP3]]];
    }
    
    self.imageView1.userInteractionEnabled = YES;
    self.imageView2.userInteractionEnabled = YES;
    self.imageView3.userInteractionEnabled = YES;
    
    //给每个图片添加手势，放大图片查看
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture1:)];
    [self.imageView1 addGestureRecognizer:gesture1];
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture2:)];
    [self.imageView2 addGestureRecognizer:gesture2];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture3:)];
    [self.imageView3 addGestureRecognizer:gesture3];
    
}

//判断用户类型显示下方视图
- (void)layoutBottomViewWithUserType:(NSString *)role UserID:(NSString *)UserID
{
    //    NSString *role = [NSString stringWithFormat:@"%@",Role];
    
//    if (role == nil||[role isEqualToString:@"1"])
//    {
//        //认证过的服务方和游客
//        [self layoutView1];
//    }
//    else if([role isEqualToString:@"0"])
//    {
//        //没认证过的
//        NSLog(@"登录但是没认证过的");
//    }
    if([self.userID isEqualToString:UserID])
    {
        NSLog(@"我自己");
        [self layoutView2];
        
    }
    else
    {
        [self layoutView1];
        
    }
    
}
- (void)layoutView1
{
    UIView *SomeOneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    SomeOneView.backgroundColor = [UIColor redColor];
    UIButton *connectButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/2, 50);
    [connectButton setTitle:@"联系方式" forState:(UIControlStateNormal)];
  
    UIButton *talkButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    talkButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width, 50);
    [talkButton setTitle:@"私聊" forState:(UIControlStateNormal)];
    [talkButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    [talkButton setBackgroundImage:[UIImage imageNamed:@"siliao2"] forState:(UIControlStateNormal)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SomeOneView.bounds.size.width/2-45, 15, 25, 25)];
    imageView.image = [UIImage imageNamed:@"siliao3"];
    [talkButton addSubview:imageView];
    [talkButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [SomeOneView addSubview:talkButton];
    
    //给按钮添加点击事件
    [connectButton addTarget:self action:@selector(connectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [talkButton addTarget:self action:@selector(talkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bringView addSubview:SomeOneView];
    //.................
    [self.backGroundView bringSubviewToFront:self.bringView];
}
- (void)layoutView2
{
    UIView *selfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    selfView.backgroundColor = [UIColor grayColor];
    UIButton *lookButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    lookButton.frame = CGRectMake(0, 0, selfView.bounds.size.width, 50);
    [lookButton setTitle:@"我的抢单" forState:(UIControlStateNormal)];
    [lookButton addTarget:self action:@selector(lookbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [selfView addSubview:lookButton];
    [self.bringView addSubview:selfView];
    [self.backGroundView bringSubviewToFront:self.bringView];
    
}
- (void)connectButtonAction:(UIButton *)button
{
    if (self.role == nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];

    }
    else
    {
        
        NSLog(@"调用打电话");
        UIWebView *webView = [[UIWebView alloc]init];
        [self.backView addSubview:webView];
        
        NSURL *url = [NSURL URLWithString:self.phoneNumber];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        
    }
    
}

- (void)talkButtonAction:(UIButton *)button
{
    if (self.role ==nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        talkViewController *talkVc = [[talkViewController alloc]init];
        talkVc.title = self.model.ServiceName;
        talkVc.targetId = [NSString stringWithFormat:@"%@",self.userID];
        talkVc.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:talkVc animated:YES];
        
    }
    
}
- (void)lookbuttonAction:(UIButton *)button
{
    
    
    
    
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
