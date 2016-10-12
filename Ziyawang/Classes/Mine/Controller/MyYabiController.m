//
//  MyYabiController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/24.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MyYabiController.h"
#import "RechargeController.h"
#import "CostController.h"
#import "YabiRuleController.h"
@interface MyYabiController ()
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation MyYabiController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self getUserAccountInfoFromDomin];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的芽币";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    //    [self setupTitle];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];

    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:(UIBarButtonItemStylePlain) target:self action:@selector(RightBarbuttonAction:)];
    
    [self.rechargeButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    self.accountLabel.text = self.Account;
//    [self setupTitle];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)getUserAccountInfoFromDomin
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
            
            self.accountLabel.text = dic[@"user"][@"Account"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"获取用户信息失败");
            //        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
            //        NSString *userPicture = [[NSUserDefaults standardUserDefaults]objectForKey:@""];
            //        NSString *
            
        }];
        
    }

}

- (void)RightBarbuttonAction:(UIBarButtonItem *)barbuttonItem
{
    CostController *CostVc = [[CostController alloc]init];
    [self.navigationController pushViewController:CostVc animated:YES];
}
- (IBAction)rechargeButtonAction:(id)sender {
    RechargeController *recharVC = [[RechargeController alloc]init];
    [self.navigationController pushViewController:recharVC animated:YES];
}
- (IBAction)xiyiButtonAction:(id)sender {
    YabiRuleController *ruleVc = [[YabiRuleController alloc]init];
    [self.navigationController pushViewController:ruleVc animated:YES];
}
- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"我的芽币";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
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
