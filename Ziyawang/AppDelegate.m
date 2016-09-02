//
//  AppDelegate.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/19.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//



#import "AppDelegate.h"
#import "ViewController.h"
#import "InfoDetailsController.h"
#import "LinkpageController.h"
#import "ZiyaMainController.h"


#import <UMMobClick/MobClick.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import <RongIMKit/RongIMKit.h>

#import <AudioToolbox/AudioToolbox.h>


#import "PushController.h"
#import "PushViewController.h"
#import "FindController.h"

#import "talkViewController.h"
#import "MessageListViewController.h"
#import "MineViewController.h"
#import "LBTabBarController.h"
#import "LoginController.h"
@interface AppDelegate ()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,RCIMConnectionStatusDelegate,UITabBarControllerDelegate>

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) RCUserInfo *otherUserinfo;
@end

@implementation AppDelegate


//是否允许支持横竖屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    //   NSLog(@"方向  =============   %ld", _allowRotate);
    if (_allowRotate == 1) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}


// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (_allowRotate == 1) {
        return YES;
    }
    return NO;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    //更新版本
     [[NSUserDefaults standardUserDefaults]setObject:@"Version1.0.1" forKey:@"Version"];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self ifNeedUpdate];
    //初始化融云
    [[RCIM sharedRCIM]initWithAppKey:@"25wehl3uww96w"];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [self getUserInfoFromDomin];
    //初始化Tabbar
    [self initTabbar];
    //初始化shareSDK
    [self setShareSDK];
    
    //状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   
    //推送通知
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }

    
    //rcToken判断
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"rcToken"] == nil) {
        
    }
    else
    {
        NSLog(@"有rcToken，链接融云");
        [[RCIM sharedRCIM]connectWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"rcToken"] success:^(NSString *userId) {
            NSLog(@"链接成功");
        } error:^(RCConnectErrorCode status) {
            NSLog(@"链接失败");
        } tokenIncorrect:^{
            NSLog(@"token过期");
        }];
        
    }

    
    //设置融云代理
//    [RCIM sharedRCIM].receiveMessageDelegate=self;
//    [RCIM sharedRCIM].enableReadReceipt = YES;
    [RCIM sharedRCIM].userInfoDataSource = self;

    
    // 友盟统计
    [self UmobClick];
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
//    
//    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
//    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    //远程推送的内容
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@">>>>>>>>>>>>>>>>>%@",remoteNotificationUserInfo);
     return YES;
}
#pragma mark---更新用户信息
- (void)getUserInfoFromDomin
{
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    //    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    NSString *URL = @"aa";
    if (token!=nil) {
        URL = [[getUserInfoURL stringByAppendingString:@"?token="]stringByAppendingString:token];
       
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"token" forKey:@"access_token"];
        
        
        
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *code = dic[@"status_code"];
//        if ([code isEqualToString:@"200"]) {
        
        NSLog(@"%@",dic[@"role"]);
        
        NSString *role =dic[@"role"];
            
        [[NSUserDefaults standardUserDefaults]setObject:role forKey:@"role"];
       
        NSLog(@"获取用户信息成功");
            
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"获取用户信息失败");
        //        NSString *userName = [[NSUserDefaults
    }];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"role"];
        
    }
}


#pragma mark----检查更新
- (void)ifNeedUpdate
{
    NSString *version = [[NSUserDefaults standardUserDefaults]objectForKey:@"Version"];
    NSString *URL = @"http://api.ziyawang.com/v1/app/iosupdate?access_token=token";
    
    [self.manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *Array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSDictionary *dic = Array.lastObject;
        NSString *newVersion = dic[@"UpdateTitle"];
        NSLog(@"-------newVersion:%@",newVersion);
        if ([version isEqualToString:newVersion] == NO) {
          
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"资芽已有新版本，请您前往AppStore搜索并下载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSLog(@"%@",error);
        
    }];
  }

- (void)updateVersion
{
    NSString *VerSionURL = @"";
    
[self.manager GET:VerSionURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSString *version = dic[@"Version"];
    NSString *lastVersion =  [[NSUserDefaults standardUserDefaults]objectForKey:@"Version"];
    if (![version isEqualToString:lastVersion]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"资芽已有新版本，请您前往AppStore搜索并下载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    
}];
 }

- (void)UmobClick {
    // 开启debug模式  正式上线时删除
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"57b7c912e0f55adc8b000c33";
    UMConfigInstance.channelId = @"App Store";
    //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    UMConfigInstance.ePolicy = BATCH;
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    
//     获取测试设备的oid
//        Class cls = NSClassFromString(@"UMANUtil");
//        SEL deviceIDSelector = @selector(openUDIDString);
//        NSString *deviceID = nil;
//        if(cls && [cls respondsToSelector:deviceIDSelector]){
//            deviceID = [cls performSelector:deviceIDSelector];
//        }
//        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                           options:NSJSONWritingPrettyPrinted
//                                                             error:nil];
//    
//        NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}


#pragma mark----融云数据源提供者
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
//        [[RCIM sharedRCIM]clearUserInfoCache];
    NSLog(@"当前用户的userID：：：%@",userId);
    if (userId == nil || [userId length] == 0 )
        
    {
        completion(nil);
        return ;
    }
    else if([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId])
    {
        
//        NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID"];
        NSLog(@"!!!!!%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"]);
            NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
        NSString *protrait = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserPicture"];
        
        
//        RCUserInfo *currentUser = [[RCUserInfo alloc]initWithUserId:userID name:userName portrait:[getImageURL stringByAppendingString:protrait]];
//        completion(currentUser);
        
        RCUserInfo *currentUser = [[RCUserInfo alloc]init];
        currentUser.userId = userId;
        currentUser.name = userName;
        if(userName == nil)
        {
            currentUser.name = @"资芽用户";
        }
        if ([protrait isEqualToString:@""]==NO) {
            currentUser.portraitUri = [getImageURL stringByAppendingString:protrait];
        }
        completion(currentUser);
    }
    
    
    else{
//    else if([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]!=nil)
//    {
//        [self getUserInfoWithUserId:userId];
//        completion(self.otherUserinfo);
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *URL = @"http://api.ziyawang.com/v1/app/uinfo?access_token=token";
        NSMutableDictionary *dic = [NSMutableDictionary new];
        //    NSString *URL = [[URL stringByAppendingString:@"&UserID="]stringByAppendingString:userID];
        [dic setObject:userId forKey:@"UserID"];
        
        [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *userInfoDic = dic[@"data"];
            
                NSLog(@"获取他人的信息成功");
                NSLog(@"------------%@",dic);
                RCUserInfo *otherUserInfo = [[RCUserInfo alloc]init];
            
                NSLog(@"别人的userID为：%@",userId);
                otherUserInfo.userId = userId;
                otherUserInfo.name = userInfoDic[@"UserName"];
                if(userInfoDic[@"UserName"] == nil)
                    
                {
                otherUserInfo.name = @"资芽用户";
                }
                if (![userInfoDic[@"UserPicture"] isKindOfClass:[NSNull class]])
                {
                    otherUserInfo.portraitUri = [getImageURL stringByAppendingString:userInfoDic[@"UserPicture"]];
                    
                }
            
                //            RCUserInfo *otherUserInfo = [[RCUserInfo alloc]initWithUserId:userID name:userInfoDic[@"UserName"] portrait:[getImageURL stringByAppendingString:userInfoDic[@"UserPicture"]]];
                
                completion(otherUserInfo);
//                self.otherUserinfo = otherUserInfo;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"获取他人的信息失败");
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
            });
 
        }];
    }
    }


- (void)getUserInfoWithUserId:(NSString *)userID
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URL = @"http://api.ziyawang.com/v1/app/uinfo?access_token=token";
    NSMutableDictionary *dic = [NSMutableDictionary new];
//    NSString *URL = [[URL stringByAppendingString:@"&UserID="]stringByAppendingString:userID];
    [dic setObject:userID forKey:@"UserID"];
      [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *userInfoDic = dic[@"data"];
        if ([dic[@"status_code"] isEqualToString:@"200"]) {
            NSLog(@"获取他人的信息成功");
            NSLog(@"------------%@",dic);
            RCUserInfo *otherUserInfo = [[RCUserInfo alloc]init];
            otherUserInfo.userId = userID;
            otherUserInfo.name = userInfoDic[@"UserName"];
            if (userInfoDic[@"UserPicture"] != nil) {
                otherUserInfo.portraitUri = userInfoDic[@"UserPicture"];
            }
//            RCUserInfo *otherUserInfo = [[RCUserInfo alloc]initWithUserId:userID name:userInfoDic[@"UserName"] portrait:[getImageURL stringByAppendingString:userInfoDic[@"UserPicture"]]];
            self.otherUserinfo = otherUserInfo;
        }
        else
        {
            NSLog(@"获取他人的信息失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取他人的信息失败");
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
    }];
}

//收到消息代理方法
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{


}


- (void)setRongCloud
{

}

- (void)setShareSDK
{
    [ShareSDK registerApp:@"152eaa6443bdc"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeRenren),
                            @(SSDKPlatformTypeGooglePlus)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
       
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1195328523"
                                           appSecret:@"1b0d0960683212ea2376635872ad5978"
                                         redirectUri:@"http://www.ziyawang.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxcc011e353bdc805b"
                                       appSecret:@"4913f06aac8d419c5ba0d971d529cdb3"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105620476"
                                      appKey:@"BV8MIfaahLfMt1NI"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
}




- (void)initTabbar
{
    
    
    
//    UIViewController *mainVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    
//    UIViewController *findVC = [UIStoryboard storyboardWithName:@"Find" bundle:nil].instantiateInitialViewController;
    FindController *findVC = [[FindController alloc]init];
    
//    UIViewController *messageVC = [UIStoryboard storyboardWithName:@"Message" bundle:nil].instantiateInitialViewController;
    MessageListViewController *messageVC = [[MessageListViewController alloc]init];

//    
//    UIViewController *mineVC = [UIStoryboard storyboardWithName:@"Mine" bundle:nil].instantiateInitialViewController;
    MineViewController *mineVC = [UIStoryboard storyboardWithName:@"Mine" bundle:nil].instantiateInitialViewController;
    
    UIViewController *publishVC = [UIStoryboard storyboardWithName:@"Publish" bundle:nil].instantiateInitialViewController;
    
//    UINavigationController *pushVC = [[UINavigationController alloc]initWithRootViewController:pushvc];
    //    UIViewController *publishVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil]instantiateViewControllerWithIdentifier:@"PublishController"];
    
    //    UIViewController *registVC = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil]instantiateViewControllerWithIdentifier:@"Regist"];
    
    UIViewController *testVC = [UIStoryboard storyboardWithName:@"testData" bundle:nil].instantiateInitialViewController;
    UIViewController *infoDetailVc = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
    
    
//    UIViewController *ZiyaVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    ZiyaMainController *ZiyaVC = [[ZiyaMainController alloc]init];
    UITabBarController *tabVC = [[UITabBarController alloc]init];
    //    NSLog(@"%@",loginAndRegistVC);
    ZiyaVC.tabBarItem.title = @"首页";
    ZiyaVC.tabBarItem.image = [[UIImage imageNamed:@"tabshouye"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZiyaVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"dshouye"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [ZiyaVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    
//    [ZiyaVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"dshouye"]];
    
    findVC.tabBarItem.title = @"查询";
    findVC.tabBarItem.image = [[UIImage imageNamed:@"sousuo"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    findVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"dsousuo"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  [findVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    messageVC.tabBarItem.title = @"消息";
    messageVC.tabBarItem.image = [UIImage imageNamed:@"tabxiaoxi"];
    
    messageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"dxiaoxi"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [messageVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    mineVC.tabBarItem.title = @"个人中心";
    mineVC.tabBarItem.image = [UIImage imageNamed:@"wode"];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"dwode"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];

    LBTabBarController *tabBarVC = [[LBTabBarController alloc]init];
    
    tabBarVC.delegate = self;
    
    CATransition *amin = [[CATransition alloc]init];
    amin.type = @"rippleEffect";
    amin.duration = 1.0;
    [self.window.layer addAnimation:amin forKey:nil];
    
    //————————————————————————————————————————引导图————————————————————————————————————————————————
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    
    if ([currentVersion isEqualToString:lastVersion]==NO) {
        NSLog(@"第一次启动");
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
        LinkpageController *linkVC = [[LinkpageController alloc]init];
        linkVC.controller = tabBarVC;
        self.window.rootViewController = linkVC;
    }
    else
    {
        self.window.rootViewController =tabBarVC;
    
    }
   }

//tabBar代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController.tabBarItem.title isEqualToString:@"消息"])
    {
        
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        if (token)
    {
            return YES;
    }
        else
        {
            LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
            //        loginVC.hidesBottomBarWhenPushed = YES;
            [tabBarController.selectedViewController presentViewController:loginVC animated:YES completion:nil];
            return NO;
        }
    }
 

       return YES;
        
}
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    NSLog(@"!!!!!!!!!!!!!!!!!!%@",token);
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"-----------------%@",userInfo);
    // userInfo为远程推送的内容
}


////////////////////////////////////////获取Token情况////////////////////////////////////////////////////////


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#if TARGET_IPHONE_SIMULATOR
    // 模拟器不能使用远程推送
#else
    // 请检查App的APNs的权限设置，更多内容可以参考文档 http://www.rongcloud.cn/docs/ios_push.html。
    NSLog(@"获取DeviceToken失败！！！");
    NSLog(@"ERROR：%@", error);
#endif
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

////////////////////////////////////////获取本地通知后震动/////////////////////////////////////////////

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    
    //
    ////    [self getUserInfoWithUserId:@"444" completion:^(RCUserInfo *userInfo) {
    //        NSLog(@"---------------000000000%@",userInfo);
    //
    //    }];
    
}
- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName
{
    return NO;
    
    
}


///////////**********************************貌似是app的右上角＋1*＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    RCMessage *message = notification.object;
    if (message.messageDirection == MessageDirection_RECEIVE) {
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    }
    
}
//**********************************    检测网络状态           ***************************************
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        //        RCDLoginViewController *loginVC = [[RCDLoginViewController alloc] init];
        //        // [loginVC defaultLogin];
        //        // RCDLoginViewController* loginVC = [storyboard
        //        // instantiateViewControllerWithIdentifier:@"loginVC"];
        //        UINavigationController *_navi =
        //        [[UINavigationController alloc] initWithRootViewController:loginVC];
        //        self.window.rootViewController = _navi;
        //    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            RCDLoginViewController *loginVC =
        //            [[RCDLoginViewController alloc] init];
        //            UINavigationController *_navi = [[UINavigationController alloc]
        //                                             initWithRootViewController:loginVC];
        //            self.window.rootViewController = _navi;
        //            UIAlertView *alertView =
        //            [[UIAlertView alloc] initWithTitle:nil
        //                                       message:@"Token已过期，请重新登录"
        //                                      delegate:nil
        //                             cancelButtonTitle:@"确定"
        //                             otherButtonTitles:nil, nil];
        //            [alertView show];
        //        });
    }
}
//*******************************************收到消息后的操作＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊

//-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
//{
//    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
//        RCInformationNotificationMessage *msg=(RCInformationNotificationMessage *)message.content;
//        //NSString *str = [NSString stringWithFormat:@"%@",msg.message];
//        if ([msg.message rangeOfString:@"你已添加了"].location!=NSNotFound) {
//            [RCDDataSource syncFriendList:^(NSMutableArray *friends) {
//            }];
//        }
//    }
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:RCKitDispatchMessageNotification
     object:nil];
}

@end
