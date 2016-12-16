//
//  VipViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/14.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "VipViewController.h"
#import "VipRechargeController.h"
#import "VipRechargeLogController.h"
#import "UserInfoModel.h"
@interface VipViewController ()
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageview1;
@property (weak, nonatomic) IBOutlet UIImageView *imageview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UIImageView *imageview4;
@property (weak, nonatomic) IBOutlet UIImageView *imageview5;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UserInfoModel *model;
@end

@implementation VipViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getUserInfoFromDomin];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title = @"会员中心";
    [self.noLabel setHidden:YES];
    
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 17.5;
    
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.model = [[UserInfoModel alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.view6.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    UITapGestureRecognizer *gesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    UITapGestureRecognizer *gesture5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    UITapGestureRecognizer *gesture6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];

    [self.view1 addGestureRecognizer:gesture1];
    [self.view2 addGestureRecognizer:gesture2];
    [self.view3 addGestureRecognizer:gesture3];
    [self.view4 addGestureRecognizer:gesture4];
    [self.view5 addGestureRecognizer:gesture5];
    [self.view6 addGestureRecognizer:gesture6];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"充值记录" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
    
    
    // Do any additional setup after loading the view from its nib.
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
            NSLog(@"%@",dic[@"user"]);
            
            [self.model setValuesForKeysWithDictionary:dic[@"service"]];
            
            if (self.model.UserPicture != nil) {
                [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.UserPicture]]];
            }
            
            NSArray *rightArr = dic[@"user"][@"showrightios"];
            switch (rightArr.count) {
                case 0:
                    [self.noLabel setHidden:NO];
                    break;
                case 1:
                    self.imageview1.image = [UIImage imageNamed:rightArr[0]];
                    break;
                case 2:
                    self.imageview1.image = [UIImage imageNamed:rightArr[0]];
                    self.imageview2.image = [UIImage imageNamed:rightArr[1]];
                    
                    break;
                case 3:
                    self.imageview1.image = [UIImage imageNamed:rightArr[0]];
                    self.imageview2.image = [UIImage imageNamed:rightArr[1]];
                    self.imageview3.image = [UIImage imageNamed:rightArr[2]];

                    break;
                case 4:
                    self.imageview1.image = [UIImage imageNamed:rightArr[0]];
                    self.imageview2.image = [UIImage imageNamed:rightArr[1]];
                    self.imageview3.image = [UIImage imageNamed:rightArr[2]];
                    self.imageview4.image = [UIImage imageNamed:rightArr[3]];

                    break;
                case 5:
                    self.imageview1.image = [UIImage imageNamed:rightArr[0]];
                    self.imageview2.image = [UIImage imageNamed:rightArr[1]];
                    self.imageview3.image = [UIImage imageNamed:rightArr[2]];
                    self.imageview4.image = [UIImage imageNamed:rightArr[3]];
                    self.imageview5.image = [UIImage imageNamed:rightArr[4]];

                    break;
                default:
                    break;
            }
            
            
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

- (void)rightBarButtonItemAction:(UIBarButtonItem *)barbutton
{
    VipRechargeLogController *vipVC = [[VipRechargeLogController alloc]init];
    [self.navigationController pushViewController:vipVC animated:YES];
    
}
- (void)gestureAction:(UITapGestureRecognizer *)gesture
{
    VipRechargeController *viprechargeVC = [[VipRechargeController alloc]init];
    
    switch (gesture.view.tag) {
        case 1:
            viprechargeVC.vipType = @"1";
            break;
        case 2:
            viprechargeVC.vipType = @"2";

            break;
        case 3:
            viprechargeVC.vipType = @"3";

            break;
        case 4:
            viprechargeVC.vipType = @"4";

            break;
        case 5:
            viprechargeVC.vipType = @"5";

            break;
        case 6:
            viprechargeVC.vipType = @"6";

            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:viprechargeVC animated:YES];
    
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
