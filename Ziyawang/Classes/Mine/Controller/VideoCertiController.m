//
//  VideoCertiController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/23.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "VideoCertiController.h"
#import "PayManager.h"
@interface VideoCertiController ()
@property (nonatomic,strong) NSString *product;
@property (nonatomic,strong) NSString *payid;
@property (nonatomic,strong) NSString *payname;
@end

@implementation VideoCertiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频认证";
    
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.payid = @"3";
    self.payname = @"视频认证";
    self.product = @"i.e.com.ziyawang.Ziya.shipin";
    


}
- (IBAction)rechargeButtonAction:(id)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *URL = [[VipRechargeURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSLog(@"--------%@",URL);
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.payname forKey:@"payname"];
    [dic setObject:self.payid forKey:@"payid"];
    [dic setObject:@"star" forKey:@"paytype"];
    
    
    [[PayManager payManager]payForProductWithPruduct:self.product WithURL:URL param:dic];
    

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
