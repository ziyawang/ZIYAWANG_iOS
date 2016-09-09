//
//  MineViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MineViewController.h"
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
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageview;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *AreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *comanyName;
@property (weak, nonatomic) IBOutlet UIButton *myPushButton;
@property (weak, nonatomic) IBOutlet UIButton *myOperationButton;
@property (weak, nonatomic) IBOutlet UIButton *myCollectionButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UILabel *wodefabu;
@property (weak, nonatomic) IBOutlet UILabel *wodehezuo;
@property (weak, nonatomic) IBOutlet UILabel *wodeshoucang;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) UserInfoModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UserViewheight;
@property (weak, nonatomic) IBOutlet UIImageView *normalUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *normalUserLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHigh;

@property (nonatomic,assign) BOOL hasNet;
@property (weak, nonatomic) IBOutlet UIView *myPushView;
@property (weak, nonatomic) IBOutlet UIView *myOperationView;
@property (weak, nonatomic) IBOutlet UIView *myCollectView;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) NSString *role2;
@end

@implementation MineViewController


- (void)setViewGesture
{
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction1:)];
    
    [self.myPushView addGestureRecognizer:gesture1];
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction2:)];
    [self.myOperationView addGestureRecognizer:gesture2];
    
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
        MyTogetherController *togetVC = [[MyTogetherController alloc]init];
        
        [self.navigationController pushViewController:togetVC animated:YES];
        
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
    
    UIColor *color = [UIColor blackColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.role2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    self.role2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    //    NSString *role = self.role;
    

    
//    self.navigationItem.titleTextAttributes = dict;
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sourceArray  = [NSMutableArray new];
    self.model = [[UserInfoModel alloc]init];
    self.normalUserLabel.font = [UIFont FontForLabel];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token==nil)
    {
        self.tableViewHigh.constant = 132;
        
        [self.userIconImageview setHidden:YES];
        [self.AreaLabel setHidden:YES];
        [self.userNameLabel setHidden:YES];
        [self.comanyName setHidden:YES];
        
        [self.normalUserLabel setHidden:NO];
        [self.normalUserImageView setHidden:NO];
        self.normalUserLabel.textColor = [UIColor lightGrayColor];
        self.normalUserLabel.font = [UIFont FontForBigLabel];
        self.normalUserLabel.text = @"未登录";
        self.normalUserImageView.image = [UIImage imageNamed:@"morentouxiang"];
        NSLog(@"未登录");
        self.normalUserImageView.layer.masksToBounds = YES;
        self.normalUserImageView.layer.cornerRadius = self.normalUserImageView.bounds.size.height/2;
        
//        self.AreaLabel.text = @"未登录";
//        self.AreaLabel.textColor = [UIColor grayColor];
//        self.userNameLabel.hidden =YES;
//        self.comanyName.hidden = YES;
    }
    else
    {
        [self getUserInfoFromDomin];

//       NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
        NSString *role = self.role;
        if ([self.role isEqualToString:@"1"]) {
            self.tableViewHigh.constant = 176;
            
        }
        else
        {
            self.tableViewHigh.constant = 132;
        }
        
        NSLog(@"已登录");
        
        
        if ([role isEqualToString:@"0"]) {
            [self.userIconImageview setHidden:YES];
            [self.AreaLabel setHidden:YES];
            [self.userNameLabel setHidden:YES];
            [self.comanyName setHidden:YES];
            [self.normalUserLabel setHidden:NO];
            [self.normalUserImageView setHidden:NO];
            self.normalUserImageView.layer.masksToBounds = YES;
            self.normalUserImageView.layer.cornerRadius = self.normalUserImageView.bounds.size.height/2;
            self.normalUserImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(normalImageTapGestureAction:)];
            [self.normalUserImageView addGestureRecognizer:gesture];
        }
        else
        {
            [self.userIconImageview setHidden:NO];
            [self.AreaLabel setHidden:NO];
            [self.userNameLabel setHidden:NO];
            [self.comanyName setHidden:NO];
            [self.normalUserLabel setHidden:YES];
            [self.normalUserImageView setHidden:YES];
            self.UserViewheight.constant = 90;
              
        }
    
//        self.userNameLabel.hidden =NO;
//        self.comanyName.hidden = NO;
//        self.AreaLabel.textColor = [UIColor blackColor];
    }
  
}

- (void)normalImageTapGestureAction:(UITapGestureRecognizer *)gesture
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
            NSData *imageData = UIImagePNGRepresentation(self.normalUserImageView.image);
            
            UserInfoController *userinfoVC = [[UserInfoController alloc]init];
            userinfoVC.imageData = imageData;
            userinfoVC.phoneNumber = self.normalUserLabel.text;
            [self.navigationController pushViewController:userinfoVC animated:YES];

        }
        
        else
        {
            NSData *imageData = UIImagePNGRepresentation(self.userIconImageview.image);
            UserInfoController *userinfoVC = [[UserInfoController alloc]init];
            userinfoVC.imageData = imageData;
            userinfoVC.phoneNumber = self.userNameLabel.text;
            [self.navigationController pushViewController:userinfoVC animated:YES];
        }
    }
    

}
- (void)getUserInfoFromDomin
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
//    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    NSString *URL = [[getUserInfoURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"token" forKey:@"access_token"];
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",dic);
        
        
        [self.model setValuesForKeysWithDictionary:dic[@"user"]];
        [self.model setValuesForKeysWithDictionary:dic[@"service"]];
        
        NSLog(@"%@",dic[@"role"]);
        
         self.role =dic[@"role"];
        NSString *role = self.role;
        
        [[NSUserDefaults standardUserDefaults]setObject:role forKey:@"role"];
        
        if ([role isEqualToString:@"0"])
        {
            NSLog(@"第一种视图");
            [self layoutViewNormalUsersView];
            [self.tableView reloadData];
        }
        else if([role isEqualToString:@"1"]||[role isEqualToString:@"2"])
        {
            NSLog(@"第二种视图");
            [self layoutViewServiceUsersView];
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
        self.hasNet = NO;
        
    }];
}

- (void)layoutViewNormalUsersView
{
    

   //缓存数据用于展示
    
//    if (self.hasNet == NO) {
//        NSString *userpic = [[NSUserDefaults standardUserDefaults]objectForKey:@"MineUserPicture"];
//        NSString *userphone = [[NSUserDefaults standardUserDefaults]objectForKey:@"MineUSerNumber"];
//      
////        [self.userIconImageview sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:userpic]]];
//        self.AreaLabel.text =  userphone;
//        self.userNameLabel.hidden = YES;
//        self.comanyName.hidden = YES;
//    }
    
//   else
//   {
//        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]!=nil) {
////            NSString *headURL = @"http://images.ziyawang.com";
//            
//            
//        [self.normalUserImageView sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.UserPicture]]];
//        }
    
//        self.userNameLabel.hidden = YES;
//        self.comanyName.hidden = YES;
    
    [self.userIconImageview setHidden:YES];
    [self.normalUserImageView setHidden:NO];
    [self.comanyName setHidden:YES];
    [self.userNameLabel setHidden:YES];
    [self.AreaLabel setHidden:YES];
    
    
    
    if (!self.model.UserPicture) {
        self.normalUserImageView.image = [UIImage imageNamed:@"morentouxiang"];
        
    }
    else
    {
    [self.normalUserImageView sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.UserPicture]]];
    }
    self.normalUserImageView.layer.masksToBounds = YES;
    self.normalUserImageView.layer.cornerRadius = self.normalUserImageView.bounds.size.height/2;
    
    [self.normalUserLabel setHidden:NO];
    self.normalUserLabel.text = self.model.phonenumber;
    
    
    
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        [userDefault setObject:self.model.UserPicture forKey:@"MineUserPicture"];
//        [userDefault setObject:self.model.phonenumber forKey:@"MineUSerNumber"];
    
//    }
    
}

- (void)layoutViewServiceUsersView
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//
//    NSString *servicePic = [userDefault objectForKey:@"MineServerPicture"];
//    NSString *ServiceName = [userDefault objectForKey:@"MineSerVerName"];
//    NSString *ServiceLocation = [userDefault objectForKey:@"MineSerVerLocation"];
//    if (self.hasNet == NO&&servicePic!=nil&&ServiceName!=nil&&ServiceLocation!=nil) {
//      
//        self.comanyName.text = ServiceName;
//        self.AreaLabel.text = ServiceLocation;
//        [self.userIconImageview sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:servicePic]]];
//    }
    
//    [self.userIconImageview setHidden:NO];
//    [self.normalUserImageView setHidden:YES];
    NSString *headURL = getImageURL;
    
    
    
    [self.AreaLabel setHidden:NO];
    [self.userNameLabel setHidden:NO];
    [self.comanyName setHidden:NO];
    [self.userIconImageview setHidden:NO];
    [self.normalUserLabel setHidden:YES];
    [self.normalUserImageView setHidden:YES];
//    self.UserViewheight.constant = 80;
    
    
    self.userNameLabel.text = self.model.phonenumber;
    NSLog(@"33333333333333333333%@",self.model.UserPicture);
    if (!self.model.UserPicture)
    {
        NSLog(@"用户没有头像");
    }
    else
    {
        NSLog(@"-------------用户的头像%@",self.model.UserPicture);
    [self.userIconImageview sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.UserPicture]]];
    }
    
    self.comanyName.text = self.model.ServiceName;
    self.AreaLabel.text = self.model.ServiceLocation;
    
    
//    [userDefault setObject:self.model.UserPicture forKey:@"MineServerPicture"];
//    [userDefault setObject:self.model.ServiceName forKey:@"MineSerVerName"];
//    [userDefault setObject:self.model.ServiceLocation forKey:@"MineSerVerLocation"];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    [button setTitle:@"登录" forState:(UIControlStateNormal)];
//    button.frame = CGRectMake(100, 100, 100, 100);
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:button];
  
    
    
    
    [self setViewGesture];
self.navigationItem.title = @"个人中心";

    self.userNameLabel.font = [UIFont FontForLabel];
    self.AreaLabel.font = [UIFont FontForLabel];
    self.comanyName.font = [UIFont FontForLabel];
    self.wodefabu.font = [UIFont FontForLabel];
    self.wodehezuo.font = [UIFont FontForLabel];
    self.wodeshoucang.font = [UIFont FontForLabel];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.scrollEnabled = NO;
 
    
    self.userIconImageview.image = [UIImage imageNamed:@"morentouxiang"];
    
//    self.usericonButton.selected = YES;
    self.userIconImageview.layer.masksToBounds = YES;
    self.userIconImageview.layer.cornerRadius = 30;
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoViewgesture:)];
    [self.userInfoView addGestureRecognizer:tapgesture];
    
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sourceArray  = [NSMutableArray new];
    self.model = [[UserInfoModel alloc]init];
    self.normalUserLabel.font = [UIFont FontForLabel];
    
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token==nil)
    {
        [self.userIconImageview setHidden:YES];
        [self.AreaLabel setHidden:YES];
        [self.userNameLabel setHidden:YES];
        [self.comanyName setHidden:YES];
        
        [self.normalUserLabel setHidden:NO];
        [self.normalUserImageView setHidden:NO];
        self.normalUserLabel.textColor = [UIColor lightGrayColor];
        self.normalUserLabel.font = [UIFont FontForBigLabel];
        self.normalUserLabel.text = @"未登录";
        self.normalUserImageView.image = [UIImage imageNamed:@"morentouxiang"];
        NSLog(@"未登录");
        self.normalUserImageView.layer.masksToBounds = YES;
        self.normalUserImageView.layer.cornerRadius = self.normalUserImageView.bounds.size.height/2;
        
        //        self.AreaLabel.text = @"未登录";
        //        self.AreaLabel.textColor = [UIColor grayColor];
        //        self.userNameLabel.hidden =YES;
        //        self.comanyName.hidden = YES;
    }
    else
    {
        [self getUserInfoFromDomin];
        
        //       NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
        NSString *role = self.role;
        if ([self.role isEqualToString:@"1"]) {
            self.tableViewHigh.constant = 176;
            
        }
        else
        {
            self.tableViewHigh.constant = 132;
            
        }
        
        NSLog(@"已登录");
        
        
        if ([role isEqualToString:@"0"]) {
            [self.userIconImageview setHidden:YES];
            [self.AreaLabel setHidden:YES];
            [self.userNameLabel setHidden:YES];
            [self.comanyName setHidden:YES];
            [self.normalUserLabel setHidden:NO];
            [self.normalUserImageView setHidden:NO];
            self.normalUserImageView.layer.masksToBounds = YES;
            self.normalUserImageView.layer.cornerRadius = self.normalUserImageView.bounds.size.height/2;
            self.normalUserImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(normalImageTapGestureAction:)];
            [self.normalUserImageView addGestureRecognizer:gesture];
        }
        else
        {
            [self.userIconImageview setHidden:NO];
            [self.AreaLabel setHidden:NO];
            [self.userNameLabel setHidden:NO];
            [self.comanyName setHidden:NO];
            [self.normalUserLabel setHidden:YES];
            [self.normalUserImageView setHidden:YES];
            self.UserViewheight.constant = 90;
            
            
        }
        
        //        self.userNameLabel.hidden =NO;
        //        self.comanyName.hidden = NO;
        //        self.AreaLabel.textColor = [UIColor blackColor];
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

- (void)userInfoViewgesture:(UITapGestureRecognizer *)gesture
{
    if ([self ifNeedLogin] == YES) {
        LoginController *loginVC = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil]instantiateInitialViewController];
//        LoginController *loginVC = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil]instantiateViewControllerWithIdentifier:@"Login"];

       
        //        [self.navigationController pushViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        NSString *role = self.role;
        if ([role isEqualToString:@"0"])
        {
            NSData *imageData = UIImagePNGRepresentation(self.normalUserImageView.image);
            
            UserInfoController *userinfoVC = [[UserInfoController alloc]init];
            userinfoVC.imageData = imageData;
            userinfoVC.phoneNumber = self.normalUserLabel.text;
            [self.navigationController pushViewController:userinfoVC animated:YES];

        }
        
        else
        {
        NSData *imageData = UIImagePNGRepresentation(self.userIconImageview.image);
        UserInfoController *userinfoVC = [[UserInfoController alloc]init];
        userinfoVC.imageData = imageData;
        userinfoVC.phoneNumber = self.userNameLabel.text;
    [self.navigationController pushViewController:userinfoVC animated:YES];
        }
    }
    
}
- (IBAction)rightButtonAction:(id)sender {
    if ([self ifNeedLogin] == YES) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        //        [self.navigationController pushViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        UserInfoController *userinfoVC = [[UserInfoController alloc]init];
        [self.navigationController pushViewController:userinfoVC animated:YES];
    }

}
- (IBAction)usericonAction:(id)sender {
    
    if ([self ifNeedLogin] == YES) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        //        [self.navigationController pushViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        UserInfoController *userinfoVC = [[UserInfoController alloc]init];
        [self.navigationController pushViewController:userinfoVC animated:YES];
    }
    

}
- (IBAction)pushButtonAction:(id)sender {
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
- (IBAction)operationButtonAction:(id)sender {

    if ([self ifNeedLogin] == YES) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        //        [self.navigationController pushViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        MyTogetherController *togetVC = [[MyTogetherController alloc]init];
        
        [self.navigationController pushViewController:togetVC animated:YES];
        
    }
    }
- (IBAction)collectionButton:(id)sender {
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


- (void)getUserData
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSString *role = self.role;
    
    
    if ([role isEqualToString:@"1"]) {
         return 4;
    }
    
    
   else
   {
       return 3;
   }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                cell.imageView.image = [UIImage imageNamed:@"fuwufangrezheng"];
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
                
                cell.imageView.image = [UIImage imageNamed:@"wodeqiangdan"];
                cell.textLabel.text = @"我的抢单";
                
                
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"bangzhu"];
                cell.textLabel.text = @"反馈意见";
                
                
                break;
            case 3:
                
                cell.imageView.image = [UIImage imageNamed:@"shezhi"];
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
                
                cell.imageView.image = [UIImage imageNamed:@"fuwufangrezheng"];
                cell.textLabel.text = @"服务方认证";
                
                
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"bangzhu"];
                cell.textLabel.text = @"反馈意见";
                
                
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"shezhi"];
                cell.textLabel.text = @"设置";
                
                break;
            default:
                break;
        }
    
    }
    
    
       cell.textLabel.font = [UIFont FontForLabel];

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
                LookupMyRushController *roblistVC = [[LookupMyRushController alloc]init];
                
                [self.navigationController pushViewController:roblistVC animated:YES];
                
                
            }
                   }
            break;
        case 2:
        {
            
    CSBackMessageController *helpVC = [[CSBackMessageController alloc]init];
         
            
            [self.navigationController pushViewController:helpVC animated:YES];
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
            
            case 1:
            {
                
                CSBackMessageController *helpVC = [[CSBackMessageController alloc]init];
                
                
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            case 2:
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
