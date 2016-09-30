//
//  ViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/19.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIkit+AFNetworking.h"


@interface ViewController ()<MBProgressHUDDelegate>
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *loginNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginpasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *registNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSmscodeButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UITextField *registPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsloginNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginsmscodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *smsLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *smsLoginGetsmsButton;
@property (nonatomic,strong) NSUserDefaults *userDefault;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) MBProgressHUD *HUD2;
@end

@implementation ViewController
- (IBAction)tiaozhuan:(id)sender {
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil]instantiateInitialViewController];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginButtonClick:(id)sender {
    [self loginFromDomin];
}
- (IBAction)getsmsButtonDidClick:(id)sender {
    [self getsmscode];
}
- (IBAction)registButtonClick:(id)sender {
    [self RegistFromDomin];
}
- (IBAction)smsLoginGetsms:(id)sender {
    [self getsmscodeinLogin];
    
}
- (IBAction)smsLoginButton:(id)sender {
    [self loginWithsmsCode];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"lll" ofType:@"wav"];
    NSLog(@"%@",filePath);
    
    
    self.manager = [AFHTTPSessionManager manager];
    self.userDefault = [NSUserDefaults standardUserDefaults];
//    self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
    
   
    
    
 }



//显示菊花
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
    
}
//菊花出现
- (void)showJuhuaWithHUDWithView:(UIView *)view HUD:(MBProgressHUD *)HUD
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
}
//菊花消失
- (void)dismissJuhuaWithHUD:(MBProgressHUD *)HUD
{
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hideAnimated:YES];
}
//注册获取验证码

- (void)getsmscode
{
    
    NSString *postUrl = @"http://api.ziyawang.com/v1/auth/getsmscode";
    NSString *access_token = @"token";
    NSString *phonenumber = self.registNumberTextField.text;
    NSString *act = @"register";
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:access_token forKey:@"access_token"];
    [postDic setObject:phonenumber forKey:@"phonenumber"];
    [postDic setObject:act forKey:@"action"];

//    [self showJuhuaWithHUDWithView:self.view HUD:self.HUD2];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.manager POST:postUrl parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"连接成功");
        NSLog(@"获得的数据%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *code = dic[@"status_code"];
//        [self dismissJuhuaWithHUD:self.HUD2];
        
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        if([code isEqualToString:@"200"])
        {
            
            [self MBProgressWithString:@"发送成功" timer:1 mode:MBProgressHUDModeText];
            
            NSLog(@"验证码发送成功");
            
        }
        else if([code isEqualToString:@"405"])
            
        {
            [self MBProgressWithString:@"手机号已注册" timer:1 mode:MBProgressHUDModeText];

        }
        else
        {
            [self MBProgressWithString:@"发送失败" timer:1 mode:MBProgressHUDModeText];
            NSLog(@"验证码发送失败");
        }
      
        NSLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"连接失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}
//注册
- (void)RegistFromDomin
{
    NSString *phoneNum = self.registNumberTextField.text;
    NSString *password = self.registPasswordTextField.text;
    NSString *smscode = self.smsCodeTextField.text;
    NSString *postUrl = @"http://api.ziyawang.com/v1/auth/register";
    NSString *access_token = @"token";
    
    
    AFHTTPSessionManager *manager = self.manager;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:phoneNum forKey:@"phonenumber"];
    [postDic setObject:password  forKey:@"password"];
    [postDic setObject:access_token forKey:@"access_token"];
    [postDic setObject:smscode forKey:@"smscode"];
    
    
    [manager POST:postUrl parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"请求成功");
        NSLog(@"返回的数据＝＝＝＝%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *code = dic[@"status_code"];
        
        NSLog(@"---------------%@",code);
        if ([code isEqualToString:@"200"])
        {
            [self MBProgressWithString:@"注册成功" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"注册成功");
            NSString *token = dic[@"token"];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:token forKey:@"token"];
            NSLog(@"%@",token);
        }
        else if([code isEqualToString:@"405"])
        {
            [self MBProgressWithString:@"账号已注册" timer:1 mode:MBProgressHUDModeText];
        
        }
        else
        {
            [self MBProgressWithString:@"注册失败" timer:1 mode:MBProgressHUDModeText];
            NSLog(@"注册失败");
        }
        NSLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
    
    
 }
//登录
- (void)loginFromDomin
{

    
    
    NSString *phonenumer = self.loginNumberTextField.text;
    NSString *password = self.loginpasswordTextField.text;
    NSString *access_token = @"token";
    NSString *posturl = @"http://api.ziyawang.com/v1/auth/login";
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:phonenumer forKey:@"phonenumber"];
    [postDic setObject:password forKey:@"password"];
    [postDic setObject:access_token forKey:@"access_token"];
    
    [self.manager POST:posturl parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSLog(@"----%@",responseObject);
        
        NSDictionary *dic = responseObject;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"字典信息----%@",dic);
        
        NSString *code = dic[@"status_code"];
        
        if ([code isEqualToString:@"200"]) {
            [self MBProgressWithString:@"登录成功" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"登录成功");
            NSString *token = dic[@"token"];
            [self.userDefault setObject:token forKey:@"token"];
            
        }
        else
        {
            [self MBProgressWithString:@"登录成功" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"登录失败");
            
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
    

}
//登录获取验证码
- (void)getsmscodeinLogin
{
    NSString *postUrl = @"http://api.ziyawang.com/v1/auth/getsmscode";
    NSString *access_token = @"token";
    NSString *phonenumber = self.smsloginNumTextField.text;
    NSString *action = @"login";
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:access_token forKey:@"access_token"];
    [postDic setObject:phonenumber forKey:@"phonenumber"];
    [postDic setObject:action forKey:@"action"];
    
    
    [self.manager POST:postUrl parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"连接成功");
        NSLog(@"获得的数据%@",responseObject);
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"字典信息%@",dic);
        NSString *code = dic[@"status_code"];
        
        if([code isEqualToString:@"200"])
        {
            [self MBProgressWithString:@"已发送" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"验证码发送成功");
            
        }
        else
        {
            [self MBProgressWithString:@"发送失败" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"验证码发送失败");
            
        }
        
        NSLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"连接失败:%@",error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}
//验证码登录
- (void)loginWithsmsCode
{
    NSString *phonenumber = self.smsloginNumTextField.text;
    NSString *accesstoken = @"token";
    NSString *smscode = self.loginsmscodeTextField.text;
    NSString *postUrl = @"http://api.ziyawang.com/v1/auth/smslogin";
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:phonenumber forKey:@"phonenumber"];
    [postDic setObject:accesstoken forKey:@"access_token"];
    [postDic setObject:smscode forKey:@"smscode"];
    
    
    [self.manager POST:postUrl parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *code = dic[@"status_code"];
        if ([code isEqualToString:@"200"]) {
            [self MBProgressWithString:@"登录成功" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"登录成功");
            NSString *token = dic[@"token"];
            [self.userDefault setObject:token forKey:@"token"];
        }
        else
        {
            [self MBProgressWithString:@"登录失败" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"登录失败");
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
}




//——————————————————————————————————上传音频————————————————————————————————————
-(void)uloadImageWithAudioPath:(NSString *)audioPath
{
    NSString *postUrl = @"url";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *dic = @{@"username":@"aaa"};
    
    [manager POST:postUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"lll" ofType:@"wav"];
        NSLog(@"%@",filePath);
        NSData *audioData = [NSData dataWithContentsOfFile:filePath];
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.wav",str];
        [formData appendPartWithFileData:audioData name:@"file" fileName:fileName mimeType:@"audio/wav"];
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        /上传进度
//        // @property int64_t totalUnitCount;     需要下载文件的总大小
//        // @property int64_t completedUnitCount; 当前已经下载的大小
//        //
//        // 给Progress添加监听 KVO
//        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//        // 回到主队列刷新UI,用户自定义的进度条
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.progressView.progress = 1.0 *
//            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

    }];
    
}

//————————————————————————————————————————上传图片————————————————————————————
-(void)AFNupload
{
    NSString *posturl = @"111";
    NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
[self.manager POST:posturl parameters:postdic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData *data = [NSData data];
    
    //formData:需要上传的数据
    //name:服务器那边接收文件用的参数名
    //fileName:告诉服务器所上传文件的文件名
    //mimeType：所上传文件的文件类型
    [formData appendPartWithFileData:data name:@"file" fileName:@"haha.png" mimeType:@"image/png"];
    //服务器的file写成数组，或者file1 file2
    
    
} progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


























@end
