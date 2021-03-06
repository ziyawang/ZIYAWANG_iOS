//
//  MySetController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MySetController.h"
#import "LoginController.h"
#import <RongIMKit/RongIMKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZiyaMainController.h"

#import "MineViewController.h"
#import "ZiyaRuleController.h"
@interface MySetController ()
@property (weak, nonatomic) IBOutlet UILabel *ziyashengming;
@property (weak, nonatomic) IBOutlet UILabel *tuijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *qingchuLabel;
@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UIView *ToFriendView;
@property (weak, nonatomic) IBOutlet UIView *clearSaveView;
@property (weak, nonatomic) IBOutlet UIView *ziyagongyueView;
@property (weak, nonatomic) IBOutlet UIView *outView;
@property (weak, nonatomic) IBOutlet UIView *versionView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;


@end

@implementation MySetController
- (IBAction)outButtonAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey:@"token"] == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还未登录，请先进行登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    else
    {
    UIAlertController *AlertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出登录吗" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"token" ]!= nil) {
//            [defaults removeObjectForKey:@"UserID"];
            //sdfiosdhishfihsdfhsidhf
            [[RCIM sharedRCIM]disconnect];
//            [[RCIM sharedRCIM]clearUserInfoCache];
            RCUserInfo *userinfo = [[RCUserInfo alloc]init];
            
//            [[RCIM sharedRCIM]refreshUserInfoCache:userinfo withUserId:[defaults objectForKey:@"UserID"]];
            [defaults removeObjectForKey:@"token"];
            [defaults removeObjectForKey:@"role"];
            [defaults removeObjectForKey:@"登录状态"];
            [defaults removeObjectForKey:@"UserPicture"];
            [defaults removeObjectForKey:@"UserName"];
            [defaults removeObjectForKey:@"rcToken"];
            [defaults removeObjectForKey:@"right"];
            [defaults removeObjectForKey:@"UserID"];
            [defaults synchronize];
            
//            [[SDImageCache sharedImageCache] clearDisk];  //清楚磁盘缓存
//            [[SDImageCache sharedImageCache] clearMemory];
//            ZiyaMainController *mainVC = [[ZiyaMainController alloc]init];
//            MineViewController *mineVC = [UIStoryboard storyboardWithName:@"Mine" bundle:nil].instantiateInitialViewController;
//            [self presentViewController:mainVC animated:YES completion:nil];
//            [self.navigationController pushViewController:mainVC animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
      LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }];
    [AlertC addAction:action1];
    [AlertC addAction:action2];
    [self presentViewController:AlertC animated:YES completion:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    if (token==nil) {
        [self.outButton setHidden:YES];
    }
  else
  {
      [self.outButton setHidden:NO];
  }
    self.automaticallyAdjustsScrollViewInsets = NO;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    title.textColor = [UIColor whiteColor];
//    title.backgroundColor = [UIColor clearColor];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.text = @"设置";
//    title.textColor = [UIColor blackColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"设置";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    //    [self setupTitle];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ziyaGestureAction:)];
    [self.ziyagongyueView addGestureRecognizer:gesture1];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toFriendAction:)];
    [self.ToFriendView addGestureRecognizer:gesture2];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearSaveAction:)];
    [self.clearSaveView addGestureRecognizer:gesture3];
    UITapGestureRecognizer *gesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(versionVieAction:)];
    [self.versionView addGestureRecognizer:gesture4];
    
//    self.ziyashengming.font = [UIFont FontForLabel];
//    self.tuijianLabel.font = [UIFont FontForLabel];
//    self.qingchuLabel.font = [UIFont FontForLabel];
    [self.outButton setBackgroundColor:[UIColor colorWithHexString:@"#e64840"]];
//    [self.outView setBackgroundColor:[UIColor colorWithHexString:@"#e64840"]];
    
}
- (void)versionVieAction:(UITapGestureRecognizer *)gesture4
{
    [self ifNeedUpdate];
}
- (void)ziyaGestureAction:(UITapGestureRecognizer *)gesture1
{
    ZiyaRuleController *ruleVC = [[ZiyaRuleController alloc]init];
    
    [self.navigationController pushViewController:ruleVC animated:YES];
    

}
- (void)toFriendAction:(UITapGestureRecognizer *)gesture2
{
    
    NSString *URL = @"http://ziyawang.com";
//    self.model.VideoID = [NSString stringWithFormat:@"%@",self.model.VideoID];
//    
//    NSString *URL = [url stringByAppendingString:self.model.VideoID];
    //    NSString *URL = [@"http://ziyawang.com/service/" stringByAppendingString:self.model.ServiceID];
    //    NSString *shareURL1 = @"http://ziyawang.com/project/";
    //    NSString *shareURL = [shareURL1 stringByAppendingString:self.model.ServiceID];
    UIImage *image = [UIImage imageNamed:@"morentouxiang.png"];
    NSArray *imageArray = @[image];
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"你还在等什么，赶快加入资芽吧！"
                                     images:imageArray
                                        url:[NSURL URLWithString:URL]
                                      title:@"你还在等什么，赶快加入资芽吧！"
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
- (void)clearSaveAction:(UITapGestureRecognizer *)gesture3
{
    UIAlertController *AlertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"缓存文件将被清理" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self clearCaches];
    }];
    [AlertC addAction:action1];
    [AlertC addAction:action2];
    [self presentViewController:AlertC animated:YES completion:nil];
    }



/**
 *  检查更新应用版本
 */
- (void)ifNeedUpdate
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *version = [[NSUserDefaults standardUserDefaults]objectForKey:@"Version"];
    NSString *URL = [ifNeedUpdateURL stringByAppendingString:@"?access_token=token"];
    
    //    NSString *URL = @"https://apis.ziyawang.com/zll/app/iosupdate?access_token=token";
    [self.manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *Array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = Array.lastObject;
        NSLog(@"----%@",dic);
        NSString *newVersion = dic[@"UpdateTitle"];
        NSLog(@"-------newVersion:%@",newVersion);
        if ([version isEqualToString:newVersion] == NO) {
            
            [self showAlertController];
        }
        else
        {
            UIAlertView *alertVC = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前版本：1.0.3，我们将尽我们最大的努力，提供给您最优质的体验。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertVC show];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)showAlertController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"资芽已有新版本，请您前往AppStore进行更新" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"前往更新" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/zi-ya/id1148016346?l=zh&ls=1&mt=8"]];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
}





- (NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *filePath = [cachesDir stringByAppendingPathComponent:@"myCache"];
    return filePath;
}
-(long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(float)getCacheSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize/(1024.0*1024.0);
}
-(void)clearCacheAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存已清除" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}
- (void)clearCaches
{
    
    [[SDImageCache sharedImageCache] clearDisk];  //清楚磁盘缓存
    
    [[SDImageCache sharedImageCache] clearMemory];    //清楚内存缓}
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存已清理" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
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
