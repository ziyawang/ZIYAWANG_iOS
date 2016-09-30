//
//  ChageNickNameController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ChageNickNameController.h"

@interface ChageNickNameController ()
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UITextField *textField;
@end

@implementation ChageNickNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.navigationItem.title = @"修改昵称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickRightButton:)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 15, self.view.bounds.size.width, 50)];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 10, 50)];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    
    textField.placeholder = @"请输入您的新昵称";
    self.textField = textField;
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.textField];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width, 20)];
    
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    label.text = @"";
    //    label.font = [UIFont systemFontOfSize:12]
    [self.view addSubview:view];
}

- (void)showAlertViewWithString:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    return;
}

- (void)didClickRightButton:(UIBarButtonItem *)barbutton

{
    if (self.textField.text.length == 0) {
        [self showAlertViewWithString:@"请输入昵称"];
        return;
    }
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *url = changeNickNameURL;
    NSString *URL = [[[[url stringByAppendingString:@"?token="]stringByAppendingString:token]stringByAppendingString:@"&access_token="]stringByAppendingString:@"token"];
    
        //    if (self.textField.text.length<6||self.textField.text.length>16) {
    //
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的密码格式" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //        [alert show];
    //    }
    
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:self.textField.text forKey:@"username"];
        [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"status_code"] isEqualToString:@"200"]) {
                NSLog(@"修改昵称成功");
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络情况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        
        
        
    
    
    
    
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
