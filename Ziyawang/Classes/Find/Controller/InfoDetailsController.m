//
//  InfoDetailsController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/30.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "InfoDetailsController.h"
#import "AFNetWorking.h"
#import "PublishModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginController.h"
#import "LookupRushPeopleController.h"
#import "talkViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface InfoDetailsController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIView *bringView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIButton *usericon;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UILabel *idNumLable;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLable;
@property (weak, nonatomic) IBOutlet UILabel *transMoneyLable;
@property (weak, nonatomic) IBOutlet UILabel *whereLable;
@property (weak, nonatomic) IBOutlet UILabel *fromLable;
@property (weak, nonatomic) IBOutlet UILabel *smallTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *infoDescribLable;
@property (weak, nonatomic) IBOutlet UIButton *viedioButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageview1;
@property (weak, nonatomic) IBOutlet UIImageView *imageview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qingdanHight;

@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *label9;
@property (weak, nonatomic) IBOutlet UILabel *label10;
@property (weak, nonatomic) IBOutlet UILabel *label11;
@property (weak, nonatomic) IBOutlet UILabel *label12;

@property (nonatomic,strong) UIButton *applyButton;

@property (nonatomic,strong) NSString *userID;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic,assign) BOOL isCollected;
@property (nonatomic,strong) NSString *CollectFlag;
@property (nonatomic,strong) NSString *RushFlag;

@property (nonatomic,strong) NSMutableDictionary *sourceDic;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) PublishModel *model;

@property (nonatomic,strong) PublishModel *playModel;

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) NSString *VideoDes;

@property (weak, nonatomic) IBOutlet UIView *qingdanDownLoadView;

@end

@implementation InfoDetailsController




- (IBAction)videoButtonAction:(id)sender {
    
    NSString *url = @"http://files.ziyawang.com";
    
    
    NSLog(@"333######################%@",self.VideoDes);
    if ([self.VideoDes isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不存在音频文件" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
    NSString *playURL = [url stringByAppendingString:self.VideoDes];
    self.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:playURL]];
        [self.player play];

        
        
//    if (self.isPlaying == NO) {
//        [self.player play];
//        self.isPlaying =YES;
//    }
//    if (self.isPlaying == YES) {
//        [self.player pause];
//        self.isPlaying = NO;
//    }
        
        
        
       
//        
//        NSURL *url = [[NSURL alloc]initWithString:playURL];
//        NSData * audioData = [NSData dataWithContentsOfURL:url];
//        
//        //将数据保存到本地指定位置
//        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@.amr", docDirPath , @"temp"];
//        [audioData writeToFile:filePath atomically:YES];
//        //播放本地音乐
//        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//      AVAudioPlayer  *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//        [player play];
        
     }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.sourceDic = [NSMutableDictionary dictionary];
    self.manager = [AFHTTPSessionManager manager];
    self.model = [[PublishModel alloc]init];
    self.role = [defaults objectForKey:@"role"];
    self.userID = [defaults objectForKey:@"UserID"];
    [self getData];

    
    


}
- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    self.isPlaying = NO;
    self.playModel = [[PublishModel alloc]init];
    self.role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    
    
    
    if ([self.typeName isEqualToString:@"资产包转让"]) {
        [self.qingdanDownLoadView setHidden:NO];
        self.qingdanHight.constant = 50;
    }
    else
    {
        [self.qingdanDownLoadView setHidden:YES];
        
    }
    
    self.navigationItem.title = @"信息详情";
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_left_jt"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor lightGrayColor];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.role = [defaults objectForKey:@"role"];
//    self.userID = [defaults objectForKey:@"UserID"];
//    NSLog(@"---111--------1111%@",self.userID);
//    NSLog(@"用户的身份是：%@",self.role);
//    [self layoutBottomViewWithUserType:self.role UserID:self.userid];
//    [self getData];
}
//判断用户类型显示下方视图
- (void)layoutBottomViewWithUserType:(NSString *)role UserID:(NSString *)UserID
{
//    NSString *role = [NSString stringWithFormat:@"%@",Role];
 
    self.userID = [NSString stringWithFormat:@"%@",self.userID];
    
    if([self.userID isEqualToString:UserID])
    {
        NSLog(@"我自己");
        [self layoutView2];
        return;
        
    }
    if (role == nil||[role isEqualToString:@"1"])
    {
        //认证过的服务方和游客
        [self layoutView1];
    }
     if([role isEqualToString:@"0"])
    {
    //没认证过的
        NSLog(@"登录但是没认证过的");
    }
}
- (void)layoutView1
{
    UIView *SomeOneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    SomeOneView.backgroundColor = [UIColor whiteColor];
//    UIButton *connectButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/3, 50);
//    [connectButton setTitle:@"联系方式" forState:(UIControlStateNormal)];
    UIButton *applyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    applyButton.backgroundColor = [UIColor whiteColor];

[applyButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];     applyButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/2, 50);
//    [applyButton setBackgroundImage:[UIImage imageNamed:@"shenqingqiangdanren"] forState:(UIControlStateNormal)];
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(applyButton.bounds.size.width/2-50, 17, 20, 20)];

    imageview1.image = [UIImage imageNamed:@"shenqing"];
    [applyButton setBackgroundColor:[UIColor colorWithHexString:@"#ea6155"]];
    
    
    [applyButton addSubview:imageview1];
    
    if ([self.RushFlag isEqualToString:@"1"]) {
        [applyButton setTitle:@"已抢单" forState:(UIControlStateNormal)];
//        applyButton.backgroundColor = [UIColor redColor];

        [applyButton  setEnabled:NO];
    }
    else
    {
    [applyButton setTitle:@"申请抢单" forState:(UIControlStateNormal)];
        [applyButton setEnabled:YES];
    
    }
    UIButton *talkButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    talkButton.frame = CGRectMake(applyButton.bounds.size.width, 0, applyButton.bounds.size.width, 50);
    
    [talkButton setTitle:@"私聊" forState:(UIControlStateNormal)];
    [talkButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    talkButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
//    [talkButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    [talkButton setBackgroundImage:[UIImage imageNamed:@"siliao2"] forState:(UIControlStateNormal)];
    [talkButton setBackgroundColor:[UIColor colorWithHexString:@"#fdd000"]];

    
    UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(talkButton.bounds.size.width/2-38, 17, 20, 20 )];
    imageview2.image = [UIImage imageNamed:@"siliao3"];
    
    [talkButton addSubview:imageview2];
    
    [SomeOneView addSubview:applyButton];
    [SomeOneView addSubview:talkButton];
    //给按钮添加点击事件
//    [connectButton addTarget:self action:@selector(connectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [talkButton addTarget:self action:@selector(talkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.applyButton = applyButton;
    [self.bringView addSubview:SomeOneView];
    //.................
    [self.backGroundView bringSubviewToFront:self.bringView];
}
- (void)layoutView2
{
    UIView *selfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    selfView.backgroundColor = [UIColor whiteColor];
//    selfView.backgroundColor = [UIColor grayColor];
    UIButton *lookButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    lookButton.frame = CGRectMake(0, 0, selfView.bounds.size.width, 50);
    [lookButton setTitle:@"查看抢单人" forState:(UIControlStateNormal)];
    [lookButton addTarget:self action:@selector(lookbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    lookButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    [lookButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];     [selfView addSubview:lookButton];
    [self.bringView addSubview:selfView];
    [self.backGroundView bringSubviewToFront:self.bringView];
}
//打电话
- (void)connectButtonAction:(UIButton *)button
{
    if (self.role == nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
        

    }
    else if([self.role isEqualToString:@"1"])
    {
        UIWebView *webView = [[UIWebView alloc]init];
        NSURL *url = [NSURL URLWithString:self.phoneNumber];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        NSLog(@"认证过的服务方，调用打电话");
    }

}
//申请抢单
- (void)applyButtonAction:(UIButton *)button
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.role = [defaults objectForKey:@"role"];
    self.userID = [defaults objectForKey:@"UserID"];
    [self layoutBottomViewWithUserType:self.role UserID:self.userid];
    if (self.role == nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else if([self.role isEqualToString:@"1"])
    {
        NSLog(@"认证过的服务方，调用申请");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        NSString *headurl = @"http://api.ziyawang.com/v1";
        NSString *footurl = @"/project/rush";
            NSString *URL =[[[headurl stringByAppendingString:footurl]stringByAppendingString:@"?token="]stringByAppendingString:token];
        NSMutableDictionary *paraDic = [NSMutableDictionary new];
        NSString *accesstoken = @"token";
        NSString *ProjectID = self.ProjectID;
        [paraDic setObject:token forKey:@"token"];
        [paraDic setObject:accesstoken forKey:@"access_token"];
        [paraDic setObject:ProjectID forKey:@"ProjectID"];
        
        [self.manager POST:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"status_code"] isEqualToString:@"200"]) {
                NSLog(@"请求抢单成功");
                [self MBProgressWithString:@"抢单成功！" timer:1 mode:MBProgressHUDModeText];
                //抢单成功之后改变申请抢单按钮的状态
                [self.applyButton setTitle:@"已抢单" forState:(UIControlStateNormal)];
//                [self.applyButton setBackgroundColor:[UIColor redColor]];
                
                [self.applyButton setEnabled:NO];
                                }
            NSLog(@"申请接单返回的数据%@",dic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"申请请求失败！%@",error);
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            [self MBProgressWithString:@"抢单失败！" timer:1 mode:MBProgressHUDModeText];

        }];
        
    }
    
}
//私聊
- (void)talkButtonAction:(UIButton *)button
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.role = [defaults objectForKey:@"role"];
    self.userID = [defaults objectForKey:@"UserID"];
    NSString *userName = [defaults objectForKey:@"UserName"];
    [self layoutBottomViewWithUserType:self.role UserID:self.userid];
    if (self.role ==nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else if([self.role isEqualToString:@"1"])
    {
        
//        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//        userInfo[@"targetID"] = self.targetID;
//        userInfo[@"title"] = self.userid;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushTotalkControllerNotification" object:nil userInfo:userInfo];
        
        
        talkViewController *talkVC = [[talkViewController alloc]init];
        talkVC.targetId = self.targetID;
        NSLog(@"~~~~~~~~~~~~~~~~~TargetID%@",self.targetID);
        talkVC.title = @"对话";//self.userid;
        talkVC.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:talkVC animated:YES];
        NSLog(@"认证过的服务方，调用私聊界面");
        
    }
    
}
- (void)lookbuttonAction:(UIButton *)button
{
    NSLog(@"是自己，调用抢单人列表");
    
    LookupRushPeopleController *lookVC = [[LookupRushPeopleController alloc]init];
    lookVC.ProjectID = self.ProjectID;
    self.model.PublishState = [NSString stringWithFormat:@"%@",self.model.PublishState];
    lookVC.PublishState = self.model.PublishState;
     [self.navigationController pushViewController:lookVC animated:YES];
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
//点击收藏
- (IBAction)saveButtonAction:(id)sender {

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
        [postdic setObject:self.ProjectID forKey:@"itemID"];
        [postdic setObject:@"1" forKey:@"type"];
        if (self.isCollected == NO)
        {
            NSLog(@"未收藏过,改变button的状态,调用收藏接口");
            [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
             {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"收藏成功");
                 [self MBProgressWithString:@"收藏成功" timer:1 mode:MBProgressHUDModeText];
//                 收藏按钮状态改变
                 [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
                 
                 self.isCollected = YES;
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
//                 [self MBProgressWithString:@"收藏失败" timer:1 mode:MBProgressHUDModeText];
                 
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
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
//                 [self MBProgressWithString:@"取消收藏失败" timer:1 mode:MBProgressHUDModeText];
                 NSLog(@"取消收藏失败");
             }];
        }
    }
}

- (IBAction)shareButtonAction:(id)sender {
    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    
//    NSString *url = @"http://ziyawang.com/project/";
    NSString *url = @"http://api.ziyawang.com/v1/";
    self.model.ProjectID = [NSString stringWithFormat:@"%@",self.model.ProjectID];
    NSString *URL = [url stringByAppendingString:self.model.ProjectID];
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!%@",URL);
    UIImage *image = [UIImage imageNamed:@"morentouxiang"];
    
    NSArray *imageArray = @[image];
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
//    [shareParams SSDKSetupWeChatParamsByText:@"aaaaa"
//                                       title:@"wefwvw"
//                                         url:[NSURL URLWithString:@"http://www.baidu.com"]
//                                  thumbImage:imageArray//传一张小于32k 的图
//                                       image:[NSURL URLWithString:@"http://www.baidu.com"]
//                                musicFileURL:nil
//                                     extInfo:@"dwefwef"
//                                    fileData:nil
//                                emoticonData:nil
//                                        type:SSDKContentTypeAuto
//                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//    http://ziyawang.com/project/
    NSString *shareURL1 = @"http://ziyawang.com/project/";
    NSString *shareURL = [shareURL1 stringByAppendingString:self.model.ProjectID];
        [shareParams SSDKSetupShareParamsByText:@"资芽信息"
                                         images:imageArray
                                            url:[NSURL URLWithString:shareURL]
                                          title:@"资芽"
                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
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

- (void)getData
{
//http://api.ziyawang.com/v1/project/list/5?&access_token=token
    
   NSString *url = @"http://api.ziyawang.com/v1/project/list/";
//    NSString *accesstoken = @"?&access_token=token";
    NSLog(@"!!!!!!!!!!!!!!!!%@",self.ProjectID);
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ProjectID]]stringByAppendingString:@"?access_token=token"];
                     if(token == nil)
    {
         URL = [[url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ProjectID]]stringByAppendingString:@"?access_token=token"];
    }
    else{

    URL = [[[[url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ProjectID]]stringByAppendingString:@"?access_token=token"]stringByAppendingString:@"&token="]stringByAppendingString:token];
    }
    
    
    NSString *getURL = URL;
    
//    NSString *gfetURL = @"http://api.ziyawang.com/v1/project/list/5?&access_token=token";
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
//    [getdic setObject:token forKey:@"token"];
    
    __weak typeof(self) weakSelf = self;
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [weakSelf.model setValuesForKeysWithDictionary:dic];
        NSLog(@"%@",dic);
        
//        weakSelf.role = dic[@"role"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.typeLable.text = weakSelf.model.TypeName;
//            weakSelf.phoneNumber = weakSelf.model.PhoneNumber;
//            
//            //        weakSelf.idNumLable.text = [NSString stringWithFormat:@"%@",weakSelf.model.ProjectID];
//            
//            weakSelf.idNumLable.text = weakSelf.model.ProjectNumber;
            weakSelf.typeName = weakSelf.model.TypeName;
            weakSelf.VideoDes = weakSelf.model.VoiceDes;
//            if ([weakSelf.model.CollectFlag isEqualToString:@"0"]) {
//                [weakSelf.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
//            }
//            else
//            {
//            
//            }
            
            
            weakSelf.RushFlag =  [NSString stringWithFormat:@"%@",weakSelf.model.RushFlag];
            NSLog(@"!!!!!!!!!!!!!!!!!!!!!!%@",weakSelf.RushFlag);
//            self.model.ProArea = [self.model.ProArea substringToIndex:2];
            [weakSelf layoutSubview];
        });
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"请求失败：%@",error);
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
    if (self.imageview1.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture1];
        
    
    }

}
- (void)tapgesture2:(UITapGestureRecognizer *)gesture2
{
    if (self.imageview2.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture2];
        
        
    }}
- (void)tapgesture3:(UITapGestureRecognizer *)gesture3
{
    if (self.imageview3.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture3];
        
        
    }
}
- (void)layoutSubview
{
    
    
    [self layoutBottomViewWithUserType:self.role UserID:self.userid];

    self.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
    
    //设置收藏按钮的状态
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    
    /////////////////
    
    if ([self.CollectFlag isEqualToString:@"0"]) {
        NSLog(@"未收藏过");
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
        self.isCollected = NO;
        
    }
    else
    {
         [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang.png"] forState:(UIControlStateNormal)];
        NSLog(@"收藏过");
        self.isCollected = YES;
    }
    NSString *url = @"http://images.ziyawang.com";
    UIImageView *usericonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    usericonImage.layer.masksToBounds = YES;
    usericonImage.layer.cornerRadius = 30;
    if (self.model.UserPicture == nil) {
        NSLog(@"用户没有上传头像");
    }
    else
    {
        NSString *usericonurl = self.model.UserPicture;
    [self.usericon addSubview:usericonImage];
    [usericonImage sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:usericonurl]]];
    }
    self.userID = self.model.UserID;
    
    self.typeLable.text = self.model.TypeName;
    self.idNumLable.text = self.model.ProjectNumber;
    NSLog(@"@@@@@@@@@@@@@@FBiD：%@",self.model.ProjectNumber);
    self.infoDescribLable.text = self.model.WordDes;
    
    NSString *imageURL1 = @"1";
    NSString *imageURL2 = @"2";

    NSString *imageURL3 = @"3";

    self.phoneNumber = self.model.PhoneNumber;
    if (self.model.PictureDes1 ==nil)
    {
        
    }
    else if(self.model.PictureDes1!=nil&&self.model.PictureDes2 != nil&&self.model.PictureDes3 == nil)
    {
        imageURL1 = [url stringByAppendingString:self.model.PictureDes1];
       imageURL2 = [url stringByAppendingString:self.model.PictureDes2];
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:imageURL1]];
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:imageURL2]];
    }
    else if(self.model.PictureDes1 !=nil && self.model.PictureDes2 == nil&&self.model.PictureDes3 == nil)
    {
        imageURL1 = [url stringByAppendingString:self.model.PictureDes1];
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:imageURL1]];

    }
    else
    {
        imageURL1 = [url stringByAppendingString:self.model.PictureDes1];
        imageURL2 = [url stringByAppendingString:self.model.PictureDes2];
        imageURL3 = [url stringByAppendingString:self.model.PictureDes3];
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:imageURL1]];
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:imageURL2]];
        [self.imageview3 sd_setImageWithURL:[NSURL URLWithString:imageURL3]];
    }

    
    self.imageview1.userInteractionEnabled = YES;
    self.imageview2.userInteractionEnabled = YES;
    self.imageview3.userInteractionEnabled = YES;

    //给每个图片添加手势，放大图片查看
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture1:)];
    [self.imageview1 addGestureRecognizer:gesture1];
    
     UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture2:)];
    [self.imageview2 addGestureRecognizer:gesture2];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture3:)];
    [self.imageview3 addGestureRecognizer:gesture3];
    
    NSLog(@"________________图片%@",self.imageview1.image);
    self.model.TotalMoney = [NSString stringWithFormat:@"%@",self.model.TotalMoney];
    self.model.TransferMoney = [NSString stringWithFormat:@"%@",self.model.TransferMoney];
    if ([self.typeName isEqualToString:@"资产包转让"]) {
        self.label8.text = self.model.ProArea;
        self.label10.text = self.model.FromWhere;
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label4.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.label12.text = self.model.AssetType;
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        
    }
    else if([self.typeName isEqualToString:@"委外催收"])
    {
    self.label1.text = @"金额：";
    self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
    self.label3.text = @"佣金比例：";
        self.label4.text = self.model.Rate;
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        self.label7.text = @"状态：";
        self.label8.text = self.model.Status;
        self.label9.text = @"债务人所在地：";
        self.label10.text = self.model.ProArea;
        self.label11.text = @"类型：";
        self.label12.text = self.model.AssetType;
        
        
    }
    else if([self.typeName isEqualToString:@"债权转让"])
    {
    self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        self.label4.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        self.label7.text = @"类型：";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区：";
        self.label10.text = self.model.ProArea;
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
        }
    else if([self.typeName isEqualToString:@"固产转让"])
    {
      self.label1.text = @"转让价：";
        self.label2.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];

        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];

    }
    else if([self.typeName isEqualToString:@"商业保理"])
    {
        self.label1.text = @"合同金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];

        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"买方性质：";
        self.label12.text = self.model.BuyerNature;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        self.label11.text = @"买方性质：";
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"典当担保"])
    {
        self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
//    else if([self.typeName isEqualToString:@"担保信息"])
//    {
//        self.label1.text = @"金额：";
//        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
//        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
//        
//        self.label3.text = @"地区：";
//        self.label4.text = self.model.ProArea;
//        self.label5.text = @"类型：";
//        self.label12.text = self.model.AssetType;
//        [self.label7 setHidden:YES];
//        [self.label8 setHidden:YES];
//        [self.label9 setHidden:YES];
//        [self.label10 setHidden:YES];
//        [self.label11 setHidden:YES];
//        [self.label12 setHidden:YES];
//    }
    else if([self.typeName isEqualToString:@"融资需求"])
    {
        self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];

        self.label3.text = @"回报率：";
        self.label4.text = [self.model.Rate stringByAppendingString:@"%"];
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];

        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        
        self.label7.text = @"方式:";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区:";
        self.label10.text = self.model.ProArea;
        
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
    }
    else if([self.typeName isEqualToString:@"悬赏信息"])
    {
        self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"元"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];

        self.label3.text = @"目标地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"尽职调查"])
    {
        self.label1.text = @"被调查方：";
        self.label2.text = self.model.Informant;
        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"法律服务"])
    {
        self.label1.text = @"需求：";
        self.label2.text = self.model.Requirement;
        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"资产求购"])
    {
        self.label1.text = @"求购方:";
        self.label2.text = self.model.Buyer;
        [self.label3 setHidden:YES];
        [self.label4 setHidden:YES];

        [self.label5 setHidden:YES];
        [self.label12 setHidden:YES];
        self.label7.text = @"类型:";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区:";
        self.label10.text = self.model.ProArea;
        
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
    }
   
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
