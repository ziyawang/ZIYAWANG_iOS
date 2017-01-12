//
//  MessageListViewController.m
//  RongCloudDemo
//
//  Created by Mr.Xu on 16/7/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MessageListViewController.h"
#import "talkViewController.h"
#import "RCDCustomerServiceViewController.h"
#import "CustomerViewController.h"
#import "ZiyaServiceControllerViewController.h"
#import "LoginController.h"
//#import "RCDCustomServiceViewController.h"

@interface MessageListViewController ()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource>
@property (nonatomic,strong) talkViewController *talkVC;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) RCUserInfo *otherUserinfo;
@property (nonatomic,strong) UIView *view1;
@property (nonatomic,strong) UIView *view2;

@end

@implementation MessageListViewController
//会话类型
//不在初始化设置可能第一次进去是空的列表

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
//    
//    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
    UIColor *color = [UIColor blackColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.emptyConversationView removeFromSuperview];
    self.isShowNetworkIndicatorView=NO;
    
//    [[RCIM sharedRCIM]clearUserInfoCache];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
        [RCIM sharedRCIM].userInfoDataSource = self;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]==nil) {
        self.conversationListTableView.separatorStyle =NO;
    }
    else
    {
        self.conversationListTableView.separatorStyle =YES;

    }
    //         self.conversationListTableView.separatorStyle = NO;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]!=nil) {
        [self.conversationListTableView setFrame:CGRectMake(0, 123, self.view.bounds.size.width, self.view.bounds.size.height -120)];
        
        
        
         self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 61)];
        self.view1.backgroundColor = [UIColor colorWithHexString:@"#fffdf2"];
        
        self.view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 125, self.view.bounds.size.width, 61)];
        self.view2.backgroundColor = [UIColor colorWithHexString:@"#fffdf2"];
//        self.view1.backgroundColor = [UIColor whiteColor];
//        self.view2.backgroundColor = [UIColor whiteColor];
//        
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(11, 6.5, 47, 47)];
        
        imageView1.image = [UIImage imageNamed:@"xitongxiaoxi"];
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(11, 6.5, 47, 47 )];
        imageView2.image = [UIImage imageNamed:@"morentouxiang"];
        [self.view1 addSubview:imageView1];
        [self.view2 addSubview:imageView2];
        
        UILabel *label1= [[UILabel alloc]initWithFrame:CGRectMake(65, 15, 200, 25)];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(65, 15, 200, 25)];
        label1.text = @"系统消息";
        label2.text = @"资芽小助手";
        label1.textColor = [UIColor colorWithHexString:@"#ef8200"];
        label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        
        
        label1.font = [UIFont FontForBigLabel];
        label2.font = [UIFont FontForBigLabel];
        
        [self.view1 addSubview:label1];
        [self.view2 addSubview:label2];
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, 60, self.view1.bounds.size.width, 1)];
        lineView1.backgroundColor = [UIColor lightGrayColor];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, 60, self.view1.bounds.size.width, 1)];
        lineView1.alpha = 0.3;
        lineView2.alpha = 0.3;
        lineView2.backgroundColor = [UIColor lightGrayColor];
        [self.view1 addSubview:lineView1];
        [self.view2 addSubview:lineView2];
        
        //添加手势：
        UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstGestureAction:)];
        UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondGestureAction:)];
        [self.view1 addGestureRecognizer:gesture1];
        [self.view2 addGestureRecognizer:gesture2];
        
        [self.view addSubview:self.view1];
        [self.view addSubview:self.view2];
        
        
        
//        [self.emptyConversationView setFrame:CGRectMake(self.emptyConversationView.frame.origin.x, self.emptyConversationView.frame.origin.y+80, self.emptyConversationView.bounds.size.width, self.emptyConversationView.bounds.size.height)];
        
      
    }

   

//    [RCIM sharedRCIM].userInfoDataSource = self;
//    [self refreshConversationTableViewIfNeeded];
//    NSLog(@"%@", self.conversationListDataSource);

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view1 removeFromSuperview];
    [self.view2 removeFromSuperview];
    
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)notificationAction:(NSNotification *)sender
{
    self.talkVC = [[talkViewController alloc]init];
    self.talkVC.conversationType = ConversationType_PRIVATE;

//    self.talkVC.targetId = sender.userInfo[@"targetID"];//可以根据iD获取昵称的方法
//    self.talkVC.title = sender.userInfo[@"name"];
    [self.navigationController pushViewController:self.talkVC animated:YES];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.view setFrame:CGRectMake(0, 100, self.view.bounds.size, <#CGFloat height#>)

        
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
        
    }
    return self;
}

//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
//{
//    RCUserInfo *userinfo = [RCUserInfo new];
//    userinfo.userId = userId;
//    userinfo.name = userId;
//    if (completion) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(userinfo);
//        });
//    }
//}


//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
//{
//    NSLog(@"当前用户的userID：：：%@",userId);
//    if (userId == nil || [userId length] == 0 )
//        
//    {
//        
//        completion(nil);
//        
//        return ;
//        
//    }
//    else if([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId])
//    {
//        NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID"];
//        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
//        NSString *protrait = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserPicture"];
//        RCUserInfo *currentUser = [[RCUserInfo alloc]initWithUserId:userID name:userName portrait:[getImageURL stringByAppendingString:protrait]];
//        completion(currentUser);
//        
//    }
//    else
//    {
////        [self getUserInfoWithUserId:userId];
//        
//        self.manager = [AFHTTPSessionManager manager];
//        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        NSString *URL = @"https://apis.ziyawang.com/zll/app/uinfo?access_token=token";
//        NSMutableDictionary *dic = [NSMutableDictionary new];
//        //    NSString *URL = [[URL stringByAppendingString:@"&UserID="]stringByAppendingString:userID];
//        [dic setObject:userId forKey:@"UserID"];
//        [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSDictionary *userInfoDic = dic[@"data"];
//            if ([dic[@"status_code"] isEqualToString:@"200"]) {
//                NSLog(@"获取他人的信息成功");
//                NSLog(@"------------%@",dic);
//                RCUserInfo *otherUserInfo = [[RCUserInfo alloc]init];
//                otherUserInfo.userId = userId;
//                otherUserInfo.name = userInfoDic[@"UserName"];
//                if (userInfoDic[@"UserPicture"] != nil) {
//                    otherUserInfo.portraitUri = userInfoDic[@"UserPicture"];
//                }
//                
//                
//                //            RCUserInfo *otherUserInfo = [[RCUserInfo alloc]initWithUserId:userID name:userInfoDic[@"UserName"] portrait:[getImageURL stringByAppendingString:userInfoDic[@"UserPicture"]]];
//                
//                
////                self.otherUserinfo = otherUserInfo;
//                completion (otherUserInfo);
//                
//            }
//            else
//            {
//                NSLog(@"获取他人的信息失败");
//            }
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"获取他人的信息失败");
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }];
////        completion(self.otherUserinfo);
//        
//    }
//    
//}

- (void)getUserInfoWithUserId:(NSString *)userID
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URL = [getUserInfoWithUseridURL stringByAppendingString:@"?access_token=token"];
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
   
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求信息失败，请检查您的网络设置" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:action1];
        [self presentViewController:alertVC animated:YES completion:nil];
        
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        
//            [alert show];
        
    }];
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
        NSString *URL = [getUserInfoWithUseridURL stringByAppendingString:@"?access_token=token"];
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



- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    
//    RCConversationViewController * chatVC = [[RCConversationViewController alloc]init];
//    chatVC.conversationType =  model.conversationType;
//    chatVC.targetId = model.targetId;
//    chatVC.title = @"444";
//    [self.navigationController pushViewController:chatVC animated:YES];
    self.talkVC = [[talkViewController alloc]init];
    self.talkVC.conversationType = model.conversationType;
    model.targetId = [NSString stringWithFormat:@"%@",model.targetId];
    self.talkVC.targetId = model.targetId;//可以根据iD获取昵称的方法
    NSLog(@"!!!!!%@",model.targetId);
    self.talkVC.title = model.conversationTitle;
    NSLog(@"%@",model.conversationTitle);
    
    
    [self.navigationController pushViewController:self.talkVC animated:YES];
 }


- (void)didReceiveMessageNotification:(NSNotification *)notification;
{
    [super didReceiveMessageNotification:notification];
    NSLog(@"收到新的消息");
    [self refreshConversationTableViewIfNeeded];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";

    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"登录状态"];
    if (![str isEqualToString:@"已登录"]) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
          
        [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].userInfoDataSource = self;



    
}

- (void)firstGestureAction:(UITapGestureRecognizer *)gesture1
{
    ZiyaServiceControllerViewController *ziyaServiceVC = [[ZiyaServiceControllerViewController alloc]init];
    [self.navigationController pushViewController:ziyaServiceVC animated:YES];
    
    NSLog(@"跳转到系统消息页面");
}
- (void)secondGestureAction:(UITapGestureRecognizer *)gesture2
{
    NSLog(@"跳转到客服页面");
    
        CustomerViewController *chatService = [[CustomerViewController alloc] init];
    #define SERVICE_ID @"KEFU147175411050867"
        chatService.userName = @"客服";
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = SERVICE_ID;
        chatService.title = chatService.userName;
        [self.navigationController pushViewController :chatService animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName
{

    NSLog(@"%@",message);
    return YES;
}


-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

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
