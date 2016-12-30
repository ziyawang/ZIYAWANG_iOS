//
//  UserCenterController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "UserCenterController.h"
#import "UserInfoModel.h"
#import "LoginController.h"
#import "MyPushController.h"
#import "MyTogetherController.h"
#import "MyCollectController.h"
#import "MyidentifiController.h"
#import "HelpViewController.h"
#import "MyrobListController.h"
#import "UserInfoController.h"
#import "LookupMyRushController.h"
#import "CSBackMessageController.h"
#import "UserInfoModel.h"

#import "MySetController.h"
#import "MyYabiController.h"
#import "MessageListViewController.h"
#import "VipViewController.h"
#import "StaridentiController.h"

#import "UITabBar+CustomBadge.h"

#import "AppDelegate.h"

#import <RongIMKit/RongIMKit.h>

@interface UserCenterController ()<UITableViewDelegate,UITableViewDataSource,RCIMReceiveMessageDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *myPushView;
@property (weak, nonatomic) IBOutlet UIView *myOperationView;
@property (weak, nonatomic) IBOutlet UIView *myCollectView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImage;
@property (weak, nonatomic) IBOutlet UILabel *MyproCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *MycooCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *MyColCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *redRechageLabel;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) UserInfoModel *model;
@property (nonatomic,strong) NSString *role;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic,strong) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;


@end

@implementation UserCenterController


- (void)tabBarBadgeValueNotiFication:(NSNotification *)sender
{
    NSString *value = sender.userInfo[@"BadgeValue"];
    NSLog(@"%@",value);
    UITabBarItem * item=[self.navigationController.tabBarController.tabBar.items objectAtIndex:3];
    [item setValue:value forKeyPath:@"badgeValue"];
    //    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    view.backgroundColor = [UIColor redColor];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    //    label.text = @"12";
    //    label.textColor = [UIColor whiteColor];
    //    label.font = [UIFont systemFontOfSize:10];
    //
    //    [self.tabBarController.tabBar addSubview:view];
    //    [self.tabBarController.tabBar addSubview:label];
    
    
    //    item.badgeValue = value;
    //    item.badgeValue = @"2";
    
    //    item.badgeColor = [UIColor redColor];
    
    
    NSLog(@"%@",sender.userInfo[@"BadgeValue"]);
    
    //    [self.tabBarItem setBadgeValue:@"2"];
    
}




- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    // NSInteger unreadcount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    //    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",unreadcount]];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    
    NSInteger unreadcount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    NSString *unreadStr = [NSString stringWithFormat:@"%ld",unreadcount];
    if (unreadcount == 99 || unreadcount>99) {
        unreadStr = @"99+";
    }
    if (unreadcount == 0 || unreadcount < 0) {
        unreadStr = nil;
    }
    [[[[[self tabBarController]tabBar]items]objectAtIndex:3]setBadgeValue:unreadStr];
    //    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    delegate.tabarBageValue = [UIApplication sharedApplication].applicationIconBadgeNumber;
    //    NSString *value = delegate.tabarBageValue;
    
    //
    //    NSInteger value = [UIApplication sharedApplication].applicationIconBadgeNumber;
    //
    //    NSString *valueStr = [NSString stringWithFormat:@"%ld",value];
    //    if (value == 0) {
    //     valueStr = @"";
    //
    //        [self.tabBarItem setBadgeColor:[UIColor clearColor]];
    //
    //    }
    //    [self.tabBarItem setBadgeValue:valueStr];
    
    
    //    [self.tabBarItem setBadgeValue:@"2"];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarBadgeValueNotiFication:) name:@"tabBarBadgeValueNotifi" object:nil];
    
    
    
    self.navigationItem.title = @"我的";
    UIColor *color = [UIColor clearColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    UIButton *rightbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"modify"] forState:(UIControlStateNormal)];
    [rightbutton setFrame:CGRectMake(0, 0, 20, 25)];
    [rightbutton addTarget:self action:@selector(rightBarbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    [[self navigationItem]setRightBarButtonItem:rightButtonItem];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token == nil) {
        [self.redRechageLabel setHidden:NO];
    }
    [self.redRechageLabel setTitleColor:[UIColor colorWithHexString:@"ee5a50"] forState:(UIControlStateNormal)];
    self.redRechageLabel.layer.borderColor = [UIColor colorWithHexString:@"ee5a50"].CGColor;
    
    
    //    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"modify"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarbuttonAction:)];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.manager = [AFHTTPSessionManager manager];
    
    
    self.role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sourceArray  = [NSMutableArray new];
    self.model = [[UserInfoModel alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self setViewGesture];
    [self setTableViewHight];
    //    [self setViews];
    [self getUserInfoFromDomin];
    
    //    [self setViews];
}
//- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
//{
////    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",left]];
//    [[[[[self tabBarController]tabBar]items]objectAtIndex:3]setBadgeValue:[NSString stringWithFormat:@"%d",left]];
//
////    [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%d",left];
//
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    
    NSInteger unreadcount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",unreadcount]];
    
    
    //    NSInteger value = [UIApplication sharedApplication].applicationIconBadgeNumber;
    //
    //    NSString *valueStr = [NSString stringWithFormat:@"%ld",value];
    //    if (value == 0) {
    //        valueStr = @"";
    //
    //        [self.tabBarItem setBadgeColor:[UIColor clearColor]];
    //    }
    //    [self.tabBarItem setBadgeValue:valueStr];
    //     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarBadgeValueNotiFication:) name:@"tabBarBadgeValueNotifi" object:nil];
    //    [self.tabBarItem setBadgeValue:@"3"];
    
    //    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"modify"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarbuttonAction:)];
    self.userIconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *userIconGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userIconGestureAction:)];
    [self.userIconImage addGestureRecognizer:userIconGesture];
    
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.manager = [AFHTTPSessionManager manager];
    self.role = [self.defaults objectForKey:@"role"];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sourceArray  = [NSMutableArray new];
    self.model = [[UserInfoModel alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self setViewGesture];
    [self setTableViewHight];
    if ([self.defaults objectForKey:@"token"]!=nil) {
        [self getUserInfoFromDomin];
    }
    else
    {
        [self setViews];
        
    }
    //
    // Do any additional setup after loading the view from its nib.
}

- (void)UsericonAndRightButtonAction
{
    if ([self ifNeedLogin] == YES) {
        LoginController *loginVC = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil]instantiateInitialViewController];
        //        LoginController *loginVC = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil]instantiateViewControllerWithIdentifier:@"Login"];
        
        //        [self.navigationController pushViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        //        NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
        NSString *role = self.role;
        
        if ([role isEqualToString:@"0"])
        {
            NSData *imageData = UIImagePNGRepresentation(self.userIconImage.image);
            UserInfoController *userinfoVC = [[UserInfoController alloc]init];
            userinfoVC.imageData = imageData;
            userinfoVC.phoneNumber = self.model.phonenumber;
            userinfoVC.nickNme = self.model.username;
            [self.navigationController pushViewController:userinfoVC animated:YES];
            
        }
        
        else
        {
            NSData *imageData = UIImagePNGRepresentation(self.userIconImage.image);
            UserInfoController *userinfoVC = [[UserInfoController alloc]init];
            userinfoVC.imageData = imageData;
            userinfoVC.phoneNumber = self.model.phonenumber;
            userinfoVC.nickNme = self.model.username;
            
            [self.navigationController pushViewController:userinfoVC animated:YES];
        }
    }
}

- (void)userIconGestureAction:(UITapGestureRecognizer *)userIconGesture
{
    [self UsericonAndRightButtonAction];
}

- (void)rightBarbuttonAction:(UIButton *)rightButtonItem
{
    [self UsericonAndRightButtonAction];
}
- (void)setViews
{
    self.userIconImage.layer.masksToBounds = YES;
    self.userIconImage.userInteractionEnabled = YES;
    self.userIconImage.layer.cornerRadius = self.userIconImage.bounds.size.height/2;
    
    NSString *token = [self.defaults objectForKey:@"token"];
    if (token == nil) {
        [self.loginButton setHidden:NO];
        [self.nameLabel setHidden:YES];
        [self.areaLabel setHidden:YES];
        [self.companyNameLabel setHidden:YES];
        self.MyColCountLabel.text = @"0";
        self.MycooCountLabel.text = @"0";
        self.MyproCountLabel.text = @"0";
        self.userIconImage.image = [UIImage imageNamed:@"user2"];
    }
    else
    {
        [self.loginButton setHidden:YES];
        if ([self.role isEqualToString:@"0"])
        {
            [self.nameLabel setHidden:NO];
            [self.areaLabel setHidden:YES];
            [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.UserPicture]]];
            [self.companyNameLabel setHidden:YES];
            if ([self.model.username isEqualToString:@""]) {
                self.nameLabel.text = self.model.phonenumber;
            }
            else
            {
                self.nameLabel.text = self.model.username;
            }
        }
        else
        {
            [self.nameLabel setHidden:NO];
            [self.areaLabel setHidden:NO];
            [self.companyNameLabel setHidden:NO];
            
            if ([self.model.username isEqualToString:@""]) {
                self.nameLabel.text = self.model.phonenumber;
            }
            else
            {
                self.nameLabel.text = self.model.username;
            }
            self.areaLabel.text = self.model.ServiceLocation;
            self.companyNameLabel.text = self.model.ServiceName;
            [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.UserPicture]]];
        }
    }
}
- (IBAction)loginButtonAction:(id)sender {
    LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
    //        [self.navigationController pushViewController:loginVC animated:YES];
    [self presentViewController:loginVC animated:YES completion:nil];
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
            NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",dic);
            [self.model setValuesForKeysWithDictionary:dic[@"user"]];
            [self.model setValuesForKeysWithDictionary:dic[@"service"]];
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            dataDic[@"MyProCount"] = [NSString stringWithFormat:@"%@",dic[@"MyProCount"]];
            dataDic[@"MyColCount"] = [NSString stringWithFormat:@"%@",dic[@"MyColCount"]];
            dataDic[@"MyCooCount"] = [NSString stringWithFormat:@"%@",dic[@"MyCooCount"]];
            //            self.MyproCountLabel.text = dataDic[@"MyProCount"];
            self.MyColCountLabel.text = dataDic[@"MyColCount"];
            self.MycooCountLabel.text = dataDic[@"MyProCount"];
            self.MyproCountLabel.text = dataDic[@"user"][@"Account"];
            if (self.MyproCountLabel.text.integerValue < 10)
            {
                [self.redRechageLabel setHidden:NO];
            }
            else
            {
                [self.redRechageLabel setHidden:YES];
            }
            
            NSLog(@"%@",dic[@"role"]);
            self.role =dic[@"role"];
            //        NSString *role = self.role;
            [[NSUserDefaults standardUserDefaults]setObject:self.role forKey:@"role"];
            if ([self.role isEqualToString:@"0"])
            {
                NSLog(@"第一种视图");
                //            [self layoutViewNormalUsersView];
                [self setTableViewHight];
                [self setViews];
                
                [self.tableView reloadData];
            }
            else if([self.role isEqualToString:@"1"]||[self.role isEqualToString:@"2"])
            {
                NSLog(@"第二种视图");
                //            [self layoutViewServiceUsersView];
                [self setTableViewHight];
                [self setViews];
                [self.tableView reloadData];
            }
            NSLog(@"获取用户信息成功");
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"获取用户信息失败");
            //        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
            //        NSString *userPicture = [[NSUserDefaults standardUserDefaults]objectForKey:@""];
            //        NSString *
        }];
        
        
    }
    else
    {
        [self setViews];
        
    }
}

- (void)setTableViewHight
{
    if ([self.role isEqualToString:@"1"]) {
        self.tableViewHeight.constant = 308;
        self.contentViewHeight.constant = 533;
        
        [self.tableView reloadData];
        
    }
    else
    {
        self.tableViewHeight.constant = 176;
        self.contentViewHeight.constant = 401;

        [self.tableView reloadData];
        
    }
    
}

- (void)setViewGesture
{
    
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction1:)];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction2:)];
    
    [self.myPushView addGestureRecognizer:gesture2];
    [self.myOperationView addGestureRecognizer:gesture1];
    
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction3:)];
    [self.myCollectView addGestureRecognizer:gesture3];
    
}
- (void)gestureAction1:(UITapGestureRecognizer *)gesture1
{
    if ([self ifNeedLogin] == YES) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        //        [self.navigationController pushViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        MyPushController *pushVc = [[MyPushController alloc]init];
        [self.navigationController pushViewController:pushVc animated:YES];
    }
    
}

- (void)gestureAction2:(UITapGestureRecognizer *)gesture2
{
    if ([self ifNeedLogin] == YES) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        //        [self.navigationController pushViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        MyYabiController *YabiVC = [[MyYabiController alloc]init];
        YabiVC.Account = self.MyproCountLabel.text;
        
        [self.navigationController pushViewController:YabiVC animated:YES];
        
    }
}
- (void)gestureAction3:(UITapGestureRecognizer *)gesture3
{
    if ([self ifNeedLogin] == YES) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        //        [self.navigationController pushViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        MyCollectController *collectVC = [[MyCollectController alloc]init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
}

- (BOOL)ifNeedLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token == nil) {
        return YES;
    }
    else
        return NO;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSString *role = self.role;
    
    
    if ([role isEqualToString:@"1"]) {
        return 7;
    }
    
    
    else
    {
        return 4;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
//    {
//        
//        return 30;
//    }
//    
//    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
//    {
//        return 44;
//    }
//    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
//    {
//        return 44;
//    }
    return 44;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *role = self.role;
    if ([role isEqualToString:@"1"]) {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"Serviceidentification"];
                cell.textLabel.text = @"服务方认证";
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //    NSString *userName = self.nameTextField.text;
                //    NSString *phoneNumber = self.phoneNumTextField.text;
                //    NSString *companyName = self.companyTextField.text;
                //    NSString *companyDes = self.comPanyDesTextView.text;
                //                NSString *companyLocation = [defaults objectForKey:@"企业地区"];
                //                NSString *ServiceArea = [defaults objectForKey:@"服务地区"];
                //                NSString *ServiceType = [defaults objectForKey:@"服务类型"];
                //                [defaults removeObjectForKey:@"企业地区"];
                //                [defaults removeObjectForKey:@"服务地区"];
                //                [defaults removeObjectForKey:@"服务类型"];
                //                [defaults removeObjectForKey:@"服务的类型"];
                
            }
                
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"vipCenter"];
                cell.textLabel.text = @"会员中心";
                
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"xingjirenzheng"];
                cell.textLabel.text = @"星级认证";
                break;

                
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"gerenwodeyuetan"];
                cell.textLabel.text = @"我的约谈";
                
                break;
            case 4:
                cell.imageView.image = [UIImage imageNamed:@"xiaoxizhongxin"];
                cell.textLabel.text = @"消息中心";
                
                
                break;
            case 5:
                
                cell.imageView.image = [UIImage imageNamed:@"help"];
                cell.textLabel.text = @"帮助与反馈";
                
                break;
            case 6:
                
                cell.imageView.image = [UIImage imageNamed:@"set"];
                cell.textLabel.text = @"设置";
                
                break;
            default:
                break;
        }
        
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"Serviceidentification"];
                cell.textLabel.text = @"服务方认证";
                
                break;
//            case 1:
//                cell.imageView.image = [UIImage imageNamed:@"vipCenter"];
//                cell.textLabel.text = @"会员中心";
//                
//                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"xiaoxizhongxin"];
                cell.textLabel.text = @"消息中心";
                
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"help"];
                cell.textLabel.text = @"帮助与反馈";
                
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"set"];
                cell.textLabel.text = @"设置";
                
                break;
            default:
                break;
        }
        
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //#import "MySettingController.h"
    //#import "MyPushController.h"
    //#import "MyTogetherController.h"
    //#import "MyCollectController.h"
    //#import "MyidentifiController.h"
    //#import "HelpViewController.h"
    //#import "MyrobListController.h"
    NSString *role = self.role;
    
    //    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    if ([role isEqualToString:@"1"]) {
        
        switch (indexPath.row) {
            case 0:
            {
                if ([self ifNeedLogin] == YES) {
                    LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                    //        [self.navigationController pushViewController:loginVC animated:YES];
                    [self presentViewController:loginVC animated:YES completion:nil];
                }
                else
                {
                    MyidentifiController *identifiVC = [[MyidentifiController alloc]init];
                    //                @property (nonatomic,strong) NSString *phonenumber;
                    //                @property (nonatomic,strong) NSString *ServiceName;
                    //                @property (nonatomic,strong) NSString *ServiceLocation;
                    //                @property (nonatomic,strong) NSString *UserPicture;
                    //                @property (nonatomic,strong) NSString *ConnectPhone;
                    
                    identifiVC.ConnectPhone = self.model.ConnectPhone;
                    identifiVC.ServiceName = self.model.ServiceName;
                    identifiVC.ServiceLocation = self.model.ServiceLocation;
                    identifiVC.ServiceType = self.model.ServiceType;
                    identifiVC.ServiceIntroduction = self.model.ServiceIntroduction;
                    identifiVC.ConnectPerson = self.model.ConnectPerson;
                    identifiVC.ServiceArea = self.model.ServiceArea;
                    identifiVC.ConfirmationP1 = self.model.ConfirmationP1;
                    identifiVC.ConfirmationP2 = self.model.ConfirmationP2;
                    identifiVC.ConfirmationP3 = self.model.ConfirmationP3;
                    identifiVC.ViewType = @"服务";
                    identifiVC.role = self.role;
                    identifiVC.RegTime = self.model.RegTime;
                    identifiVC.Founds = self.model.Founds;
                    identifiVC.Size = self.model.Size;
                    
                    
                    [self.navigationController pushViewController:identifiVC animated:YES];
                }
            }
                break;
            case 1:
            {
                
                
                if ([self ifNeedLogin] == YES) {
                    LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                    //        [self.navigationController pushViewController:loginVC animated:YES];
                    [self presentViewController:loginVC animated:YES completion:nil];
                }
                else
                {
                    VipViewController *VipVC = [[VipViewController alloc]init];
                    
                    [self.navigationController pushViewController:VipVC animated:YES];
                    
                    
                }
            }
                break;
                
            case 2:
            {
                    if ([self ifNeedLogin] == YES) {
                    LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                    //        [self.navigationController pushViewController:loginVC animated:YES];
                    [self presentViewController:loginVC animated:YES completion:nil];
                }
                else
                {
                    StaridentiController *roblistVC = [[StaridentiController alloc]init];
                    
                    [self.navigationController pushViewController:roblistVC animated:YES];
                }
                
            }
                break;
            case 3:
            {
          
                
                
                if ([self ifNeedLogin] == YES) {
                    LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                    //        [self.navigationController pushViewController:loginVC animated:YES];
                    [self presentViewController:loginVC animated:YES completion:nil];
                }
                else
                {
                    LookupMyRushController *roblistVC = [[LookupMyRushController alloc]init];
                    
                    [self.navigationController pushViewController:roblistVC animated:YES];
                    
                    
                }

            }
                break;
                
           
            case 4:
            {
                
                
                
                MessageListViewController *messageVC = [[MessageListViewController alloc]init];
                
                
                [self.navigationController pushViewController:messageVC animated:YES];
            }
                break;
            case 5:
            {
                
                CSBackMessageController *helpVC = [[CSBackMessageController alloc]init];
                
                
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            case 6:
            {
                MySetController *setVc = [[MySetController alloc]initWithNibName:@"MySetController" bundle:nil];
                [self.navigationController pushViewController:setVc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        
        switch (indexPath.row) {
            case 0:
            {
                if ([self ifNeedLogin] == YES) {
                    LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                    //        [self.navigationController pushViewController:loginVC animated:YES];
                    [self presentViewController:loginVC animated:YES completion:nil];
                }
                else
                {
                    MyidentifiController *identifiVC = [[MyidentifiController alloc]init];
                    identifiVC.ConnectPhone = self.model.ConnectPhone;
                    identifiVC.ServiceName = self.model.ServiceName;
                    identifiVC.ServiceLocation = self.model.ServiceLocation;
                    identifiVC.ServiceType = self.model.ServiceType;
                    identifiVC.ServiceIntroduction = self.model.ServiceIntroduction;
                    identifiVC.ConnectPerson = self.model.ConnectPerson;
                    identifiVC.ServiceArea = self.model.ServiceArea;
                    identifiVC.ConfirmationP1 = self.model.ConfirmationP1;
                    identifiVC.ConfirmationP2 = self.model.ConfirmationP2;
                    identifiVC.ConfirmationP3 = self.model.ConfirmationP3;
                    identifiVC.ViewType = @"服务";
                    identifiVC.role = self.role;
                    
                    [self.navigationController pushViewController:identifiVC animated:YES];
                    
                }
            }
                break;
//            case 1:
//            {
//                if ([self ifNeedLogin] == YES) {
//                    LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
//                    //        [self.navigationController pushViewController:loginVC animated:YES];
//                    [self presentViewController:loginVC animated:YES completion:nil];
//                }
//                else
//                {
//                    VipViewController *VipVC = [[VipViewController alloc]init];
//                    [self.navigationController pushViewController:VipVC animated:YES];
//                }
//            }
//                break;
//                
            case 1:
            {
                if ([self ifNeedLogin] == YES) {
                    LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                    //        [self.navigationController pushViewController:loginVC animated:YES];
                    [self presentViewController:loginVC animated:YES completion:nil];
                }
                else
                {
                    MessageListViewController *helpVC = [[MessageListViewController alloc]init];
                    [self.navigationController pushViewController:helpVC animated:YES];
                }
            }
                break;
            case 2:
            {
                CSBackMessageController *messageVC = [[CSBackMessageController alloc]init];
                [self.navigationController pushViewController:messageVC animated:YES];
            }
                break;
            case 3:
            {
                MySetController *setVc = [[MySetController alloc]initWithNibName:@"MySetController" bundle:nil];
                [self.navigationController pushViewController:setVc animated:YES];
            }
                break;
                
            default:
                break;
        }
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
