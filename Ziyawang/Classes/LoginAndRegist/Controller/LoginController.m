//
//  LoginController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "LoginController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "RegistController.h"
#import "FindwordController.h"
#import "SDVersion.h"
#import "SDiOSVersion.h"
#import "LoginModel.h"
#import <UMMobClick/MobClick.h>

@interface LoginController ()<MBProgressHUDDelegate,UITextFieldDelegate,RCIMUserInfoDataSource,RCIMReceiveMessageDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *userNnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetwordButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSUserDefaults *userDefault;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) MBProgressHUD *HUD2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftButton;

@property (nonatomic,assign) CGFloat lableSize;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) LoginModel *model;
@property (nonatomic,strong) NSString *UserPictuerURl;

@property (nonatomic,strong) NSArray *otherUserInfo;

@property (nonatomic,assign) BOOL isPhoneNumber;
@end

@implementation LoginController


- (IBAction)leftButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)showAlertViewWithString:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
  }
 //正则判断
- (void)checkMobilePhoneNumber:(NSString *)mobile{
    if (mobile.length < 11)
    {
        [self showAlertViewWithString:@"请输入正确的手机号"];
        _isPhoneNumber = NO;
        return;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (!(isMatch1 || isMatch2 || isMatch3)) {
            _isPhoneNumber = NO;
            [self showAlertViewWithString:@"请输入正确的手机号"];
            return;
            
        } else {
            _isPhoneNumber = YES;
        }
    }
}
- (IBAction)didClickLogin:(id)sender {
    
    [self.passWordTextField resignFirstResponder];
    [self.userNnameTextField resignFirstResponder];
    
//    if (self.userNnameTextField.text.length !=11) {
//        [self MBProgressWithString:@"号码不存在" timer:1 mode:MBProgressHUDModeText];
//        NSLog(@"号码不存在");
//        return;
//    }
    if ([self.userNnameTextField.text isEqualToString:@""]&&[self.passWordTextField.text isEqualToString:@""]) {
        [self showAlertViewWithString:@"请输入正确的手机号"];
        return;
    }
    [self checkMobilePhoneNumber:self.userNnameTextField.text];
    
    
    if ([self.userNnameTextField.text isEqualToString:@""]||[self.passWordTextField.text isEqualToString:@""]) {
      if([self.passWordTextField.text isEqualToString:@""])
        {
            [self showAlertViewWithString:@"请输入密码"];
            return;
        }

    }
    
    else
    {
        [self checkNetWorkStatus];
        [self loginFromDomin];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)didClickRegist:(id)sender {
    UIViewController *registVC = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil] instantiateViewControllerWithIdentifier:@"Regist"];
    [self presentViewController:registVC animated:YES completion:nil];
    
}
- (IBAction)didClickForget:(id)sender {
    UIViewController *findVC = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil]instantiateViewControllerWithIdentifier:@"Findword"];
    [self presentViewController:findVC animated:YES completion:nil];
  }


- (void )getCurrentDeviceModelAndSetTextSize
{
//    self.messageLable.text = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSString *version = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSLog(@"%@",version);
    NSLog(@"!!!!!!%@",DeviceVersionNames[[SDiOSVersion deviceVersion]]);
    if ([SDiOSVersion deviceVersion] == iPhone4)
    {
        self.messageLable.font = [UIFont fontWithName:@"ArialMT" size:11];
        
    }
    else if([SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        self.messageLable.font = [UIFont fontWithName:@"ArialMT" size:13];
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 || [SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        self.messageLable.font = [UIFont fontWithName:@"ArialMT" size:15];

    }
    
}

- (CGFloat )leftimageHeight
{
    //    self.messageLable.text = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSString *version = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSLog(@"%@",version);
    NSLog(@"!!!!!!%@",DeviceVersionNames[[SDiOSVersion deviceVersion]]);
    
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 0;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 9;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 14;
        
    }
    
    return 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
//    //    让黑线消失的方法
//    self.navigationBar.shadowImage=[UIImage new];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.title = @"登录";
    self.model = [[LoginModel alloc]init];
//    [self.navigationController setTitle:@"登录"];
    
//    UIColor *placeHoderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
//        [self.userNnameTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
//    [self.passWordTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    
//    self.userNnameTextField.layer.masksToBounds = YES;
//    
//    self.userNnameTextField.layer.borderWidth = 1.0f;
//    self.userNnameTextField.borderStyle = UITextBorderStyleRoundedRect;
//    self.userNnameTextField.layer.cornerRadius = self.userNnameTextField.bounds.size.height/2 +5;
//    self.userNnameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
////self.userNnameTextField.placeholder = @"请输入用户名";
//    
//    self.passWordTextField.layer.masksToBounds = YES;
//    self.passWordTextField.layer.cornerRadius = self.passWordTextField.bounds.size.height/2+5;
//    self.passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
//    self.passWordTextField.layer.borderWidth = 1.0f;
//    self.passWordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
//self.passWordTextField.placeholder = @"请输入密码";
    
    self.passWordTextField.secureTextEntry = YES;
    self.userNnameTextField.keyboardType = UIKeyboardTypePhonePad;
    self.passWordTextField.keyboardType = UIKeyboardTypeDefault;
    self.userDefault = [NSUserDefaults standardUserDefaults];
    
    self.userNnameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passWordTextField.leftViewMode = UITextFieldViewModeAlways;
//    CGFloat B = 30/self.passWordTextField.bounds.size.height +1;
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.userNnameTextField.bounds.size.height +[self leftimageHeight], self.userNnameTextField.bounds.size.height+[self leftimageHeight])];
    imageView1.image = [UIImage imageNamed:@"shoujihao"];
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.userNnameTextField.bounds.size.height+[self leftimageHeight], self.userNnameTextField.bounds.size.height + [self leftimageHeight])];
    
    
    imageView2.image = [UIImage imageNamed:@"mima"];
    
    UIView *View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.userNnameTextField.bounds.size.height+[self leftimageHeight]+10, self.userNnameTextField.bounds.size.height + [self leftimageHeight])];
     UIView *View2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.userNnameTextField.bounds.size.height+[self leftimageHeight]+10, self.userNnameTextField.bounds.size.height + [self leftimageHeight])];
    
    [View1 addSubview:imageView1];
    [View2 addSubview:imageView2];
    
    [View1 addSubview:imageView1];
    [View2 addSubview:imageView2];
    
//    self.userNnameTextField.leftView = imageView1;
//    self.passWordTextField.leftView = imageView2;
    self.userNnameTextField.leftView = View1;
    self.passWordTextField.leftView = View2;
    
       //初始化属性
    self.manager = [AFHTTPSessionManager manager];
    //导航栏变为透明
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    让黑线消失的方法
    self.navigationBar.shadowImage=[UIImage new];
//    [self.backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu"]]];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationBar setTitleTextAttributes:dic];
    
//    CGFloat size = 0;
    [self getCurrentDeviceModelAndSetTextSize];
    
//    if (condition) {
//        statements
//    }
//    self.messageLable.font = [UIFont fontWithName:@"ArialMT" size:11];
    self.userNnameTextField.delegate = self;
    self.passWordTextField.delegate = self;
    }


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 100;
    int movenment = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.50];
    self.view.frame = CGRectOffset(self.view.frame, 0, movenment);
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.userNnameTextField) {
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    else if(textField == self.passWordTextField)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
        
    }
 
    return YES;
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


- (void)checkNetWorkStatus
{
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未知");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你正在使用未知网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有网络");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
            {
                NSLog(@"没有网络");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前使用3G/4G访问网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WiFi");
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前使用WiFi访问网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
            default:
                break;
        }
    }];

}
//登录
- (void)loginFromDomin
{
    
    
    
    
    
    if (_isPhoneNumber == YES) {
        
    

//    [RCIM sharedRCIM].userInfoDataSource = self;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSString *UserID = self.userNnameTextField.text;
    NSString *phonenumer = self.userNnameTextField.text;
    NSString *password = self.passWordTextField.text;
    NSString *access_token = @"token";
//    NSString *loginurl = @"http://api.ziyawang.com/v1/auth/login";
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:phonenumer forKey:@"phonenumber"];
    [postDic setObject:password forKey:@"password"];
    [postDic setObject:access_token forKey:@"access_token"];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager POST:loginURL parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
      #warning 这个地方有问题，不需要解析就出现了结果，生成字典内容 加上上面的话就好了
//     NSDictionary *dic = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *userid = [NSString stringWithFormat:@"%@",dic[@"UserID"]];
        
         NSString *code = dic[@"status_code"];
           if ([code isEqualToString:@"200"]) {
            
            NSString *token = dic[@"token"];
            NSString *role = [NSString stringWithFormat:@"%@",dic[@"role"]];
            self.UserPictuerURl = dic[@"UserPicture"];
            [self.userDefault setObject:token forKey:@"token"];
            [self.userDefault setObject:@"已登录" forKey:@"登录状态"];
            [self.userDefault setObject:userid forKey:@"UserID"];
            NSLog(@"#############USERID%@",UserID);
            [self.userDefault setObject:role forKey:@"role"];
            [self.userDefault setObject:self.UserPictuerURl forKey:@"UserPicture"];
            [self.userDefault setObject:dic[@"UserName"] forKey:@"UserName"];
            [MobClick profileSignInWithPUID:self.userNnameTextField.text];
            
            NSLog(@"-----------------------------%@",dic[@"UserName"]);
            
            NSLog(@"------------------------------%@",dic[@"UserID"]);
            
            NSLog(@"-----------------------------%@",dic[@"UserPicture"]);
           
            //缓存名字
            //缓存userpicture
            //初始化融云
//               [RCIM sharedRCIM].userInfoDataSource = self;
               
            [self getRongCloudToken];
//               UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//               [alert show];
               NSLog(@"请求失败");
               self.HUD = [MBProgressHUD showHUDAddedTo:[self window]animated:YES];
               self.HUD.delegate = self;
               self.HUD.mode = MBProgressHUDModeText;
               self.HUD.labelText = @"登录成功";
               self.HUD.removeFromSuperViewOnHide = YES;
               [self.HUD hideAnimated:YES afterDelay:2];
               
//           [self MBProgressWithString:@"登录成功" timer:2 mode:MBProgressHUDModeText];
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"登录成功");
               
                }
        else if([code isEqualToString:@"404"])
        {
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
//            [self MBProgressWithString:@"密码错误" timer:1 mode:MBProgressHUDModeText];
            [self showAlertViewWithString:@"用户名或密码错误"];
        }
        else if ([code isEqualToString:@"406"])
        { [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            [self MBProgressWithString:@"该手机号未注册" timer:1 mode:MBProgressHUDModeText];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            NSLog(@"登录失败");
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"请求失败");
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            [self MBProgressWithString:@"登录失败" timer:1 mode:MBProgressHUDModeText];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    }
}

- (UIWindow *)window
{
    return [UIApplication sharedApplication].keyWindow;
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
        NSString *URL =[getUserInfoWithUseridURL stringByAppendingString:@"?access_token=token"];
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




- (void)getRongCloudToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *URL = [[getRongCloudTokenURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSString *accesstoken = @"token";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:accesstoken forKey:@"access_token"];
    
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *rcToken = dic[@"rcToken"];
        self.userID = dic[@"UserID"];
        NSLog(@"!!!!!!!!!!!!!!!!!!RcTOken:%@",rcToken);
        [self.userDefault setObject:rcToken forKey:@"rcToken"];
        [self connectRongCloudWithtoken:rcToken];
        NSLog(@"获取融云token成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

- (void)connectRongCloudWithtoken:(NSString *)token
{
    //设置代理
//    [RCIM sharedRCIM].receiveMessageDelegate=self;
    [RCIM sharedRCIM].enableReadReceipt = YES;
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        
        NSLog(@"融云登陆成功。当前登录的用户ID：%@", userId);
        //        //设置当前用户的信息
        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
        NSString *userPortrait = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserPicture"];
        NSLog(@"----------%@",userPortrait);
        [self setCurrentUserWithUserID:userId Name:userName Portrait:[getImageURL stringByAppendingString:userPortrait]];
            
            
        
            
            
            
            
                   dispatch_async(dispatch_get_main_queue(), ^{
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            [self MBProgressWithString:@"登录成功" timer:1 mode:MBProgressHUDModeText];
        });
       } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.HUD removeFromSuperViewOnHide];
               [self.HUD hideAnimated:YES];
               [self MBProgressWithString:@"登录失败" timer:1 mode:MBProgressHUDModeText];
           });
           }
                         tokenIncorrect:^{
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self MBProgressWithString:@"验证已过期请重新登录" timer:1 mode:MBProgressHUDModeText];
                             });
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
}




- (void)setCurrentUserWithUserID:(NSString *)userID Name:(NSString *)userName Portrait:(NSString *)portrait
{
    RCUserInfo *_currentUser = [[RCUserInfo alloc]initWithUserId:userID name:userName portrait:portrait];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
             [[RCIM sharedRCIM]refreshUserInfoCache:_currentUser withUserId:[defaults objectForKey:@"UserID"]];
    [RCIM sharedRCIM].currentUserInfo = _currentUser;

    
    
    //登录之后更新用户的数据
    //业务服务器获取用户的信息本地化 病给到融云
//    [RCDHTTPTOOL getUserInfoByUserID:userId
//                          completion:^(RCUserInfo* user) {
//                              [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:userId];
//                              [DEFAULTS setObject:user.portraitUri forKey:@"userPortraitUri"];
//                              [DEFAULTS setObject:user.name forKey:@"userNickName"];
//                              [DEFAULTS synchronize];
//                          }];
//
}






//
//
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
//{
//    //        [[RCIM sharedRCIM]clearUserInfoCache];
//    
//    NSLog(@"当前用户的userID：：：%@",userId);
//    if (userId == nil || [userId length] == 0 )
//        
//    {
//        completion(nil);
//        return ;
//    }
//    
//    else if([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId])
//    {
//        
//        //        NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID"];
//        NSLog(@"!!!!!%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"]);
//        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
//        NSString *protrait = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserPicture"];
//        //        RCUserInfo *currentUser = [[RCUserInfo alloc]initWithUserId:userID name:userName portrait:[getImageURL stringByAppendingString:protrait]];
//        //        completion(currentUser);
//        
//        RCUserInfo *currentUser = [[RCUserInfo alloc]init];
//        currentUser.userId = userId;
//        currentUser.name = userName;
//        if(userName == nil)
//        {
//            currentUser.name = @"资芽用户";
//        }
//        
//        if ([protrait isEqualToString:@""]==NO) {
//            currentUser.portraitUri = [getImageURL stringByAppendingString:protrait];
//        }
//    }
//    
//    else{
//        //    else if([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]!=nil)
//        //    {
//        //        [self getUserInfoWithUserId:userId];
//        //        completion(self.otherUserinfo);
//        self.manager = [AFHTTPSessionManager manager];
//        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        NSString *URL = @"http://api.ziyawang.com/v1/app/uinfo?access_token=token";
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
//                if(userInfoDic[@"UserName"] == nil)
//                {
//                    otherUserInfo.name = @"资芽用户";
//                }
//                if (userInfoDic[@"UserPicture"] != nil)
//                {
//                    otherUserInfo.portraitUri = [getImageURL stringByAppendingString:userInfoDic[@"UserPicture"]];
//                    
//                }
//                
//                
//                //            RCUserInfo *otherUserInfo = [[RCUserInfo alloc]initWithUserId:userID name:userInfoDic[@"UserName"] portrait:[getImageURL stringByAppendingString:userInfoDic[@"UserPicture"]]];
//                
//                completion(otherUserInfo);
//                //                self.otherUserinfo = otherUserInfo;
//            }
//            else
//            {
//                NSLog(@"获取他人的信息失败");
//            }
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"获取他人的信息失败");
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            });
//            
//        }];
//    }
//}


//- (void)getUserInfoWithUserId:(NSString *)userID
//{
//    self.manager = [AFHTTPSessionManager manager];
//    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString *URL = @"http://api.ziyawang.com/v1/app/uinfo?access_token=token";
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    //    NSString *URL = [[URL stringByAppendingString:@"&UserID="]stringByAppendingString:userID];
//    [dic setObject:userID forKey:@"UserID"];
//    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSDictionary *userInfoDic = dic[@"data"];
//        if ([dic[@"status_code"] isEqualToString:@"200"]) {
//            NSLog(@"获取他人的信息成功");
//            NSLog(@"------------%@",dic);
//            RCUserInfo *otherUserInfo = [[RCUserInfo alloc]init];
//            otherUserInfo.userId = userID;
//            otherUserInfo.name = userInfoDic[@"UserName"];
//            if (userInfoDic[@"UserPicture"] != nil) {
//                otherUserInfo.portraitUri = userInfoDic[@"UserPicture"];
//            }
//            
//            
//            //            RCUserInfo *otherUserInfo = [[RCUserInfo alloc]initWithUserId:userID name:userInfoDic[@"UserName"] portrait:[getImageURL stringByAppendingString:userInfoDic[@"UserPicture"]]];
//            
//            
//            self.otherUserinfo = otherUserInfo;
//        }
//        else
//        {
//            NSLog(@"获取他人的信息失败");
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"获取他人的信息失败");
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
//}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    

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
