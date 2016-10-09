//
//  ServiceMessageController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/20.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ServiceMessageController.h"

@interface ServiceMessageController ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xitongiCon;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ServiceMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息详情";

    NSArray *strArr =[self.Text componentsSeparatedByString:@"！"];
    self.messageLabel.text = [strArr[0]stringByAppendingString:@"！"];
    self.timeLabel.text =self.Time;
    self.xitongiCon.layer.masksToBounds = YES;
    self.xitongiCon.layer.cornerRadius = 25;
    self.xitongiCon.image = [UIImage imageNamed:@"morentouxiang"];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self PushSerViceData];
}


- (void)PushSerViceData
{
    NSString *url = [getDataURL stringByAppendingString:@"/readmessage"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"token" forKey:@"access_token"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[url stringByAppendingString:@"?token="]stringByAppendingString:token];
    [dic setObject:self.TextID forKey:@"TextID"];
    
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status_code"] isEqualToString:@"200"]) {
            NSLog(@"上传读取状态成功");
            
        }
        NSLog(@"------系统消息数据%@",dic);
        
        //    if(dic[@"statu"])
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求系统消息失败%@",error);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
