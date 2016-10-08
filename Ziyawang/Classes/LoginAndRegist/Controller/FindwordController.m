//
//  FindwordController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/22.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FindwordController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "LoginController.h"
#import "PassWordCheck.h"
#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface FindwordController ()<MBProgressHUDDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSUserDefaults *userDefault;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) MBProgressHUD *HUD2;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationbar;
@property (nonatomic,assign) BOOL isPhoneNumber;

@property (nonatomic,strong) UIButton *getSmsButton;

@end

@implementation FindwordController
- (IBAction)leftButtonAction:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didClickGetsmsButton:(id)sender {
    
    [self getsmscode];
}

//正则判断
- (void)checkMobilePhoneNumber:(NSString *)mobile{
    if (mobile.length < 11)
    {
        [self showAlertViewWithString:@"请输入正确的手机号"];
        _isPhoneNumber = NO;
        
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
- (void)showAlertViewWithString:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    return;
}


#pragma 正则匹配用户密码 6 - 18 位数字和字母组合
//+ (BOOL)checkPassword:(NSString *) password
//{
//    NSString *pattern = @^(?![ 0 - 9 ]+$)(?![a-zA-Z]+$)[a-zA-Z0- 9 ]{ 6 , 18 };
//    
//    
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat: @SELF MATCHES %@, pattern];
//    BOOL isMatch = [pred evaluateWithObject:password];
//    return isMatch;
//    
//}
- (IBAction)didClickAgreeButton:(id)sender {
    
    
    
    
    
//    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
//    s = [s invertedSet];
//    NSRange r = [string rangeOfCharacterFromSet:s];
//    if (r.location !=NSNotFound) { NSLog(@"the string contains illegal characters");}
//    
    
    
    
    
    
    //判断输入
    
//    if (self.phoneNumTextField.text.length !=11) {
//        [self MBProgressWithString:@"号码不存在" timer:1 mode:MBProgressHUDModeText];
//        NSLog(@"号码不存在");
//        return;
//    }
    if (self.phoneNumTextField.text == nil||self.smsCodeTextField.text == nil||self.passwordTextField.text == nil||self.repasswordTextField.text == nil) {
//        [self MBProgressWithString:@"您输入的信息不完整" timer:1 mode:MBProgressHUDModeText];
        
        if (self.phoneNumTextField.text == nil) {
            
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写完整信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        NSLog(@"您输入的信息不完整");
        return;
        
    }
    
    else
    {
    [self checkMobilePhoneNumber:self.phoneNumTextField.text];
        [self changePassWord];
    }
    
  }
- (void)shoAlertWithString:(NSString *)String
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:String delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
    NSLog(@"您输入的信息不完整");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setColorForTextPlaceHoder];
    [self initPravite];
    
    //    导航栏变为透明
    [self.navigationbar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    让黑线消失的方法
    self.navigationbar.shadowImage=[UIImage new];
//    UIImage *image = [UIImage imageNamed:@"Bar"];
//
//    [self.navigationbar setBackgroundImage:image forBarMetrics:UIBarMetricsCompact];
//    
//    [self.navigationbar setShadowImage:image];
    
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
    
    
    const int movementDistance = 120;
    int movenment = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.50];
    self.view.frame = CGRectOffset(self.view.frame, 0, movenment);
    [UIView commitAnimations];
    
}





- (CGFloat )leftimageHeight
{
    //    self.messageLable.text = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSString *version = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSLog(@"%@",version);
    NSLog(@"!!!!!!%@",DeviceVersionNames[[SDiOSVersion deviceVersion]]);
    
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 28;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return self.phoneNumTextField.bounds.size.height-7;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return self.phoneNumTextField.bounds.size.height;
        
    }
    
    return self.phoneNumTextField.bounds.size.height;;
    
}

- (void)setColorForTextPlaceHoder
{
//    UIColor *placeHoderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
//    
//    [self.phoneNumTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
//    [self.smsCodeTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
//    [self.passwordTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
//    [self.repasswordTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
    self.smsCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.smsCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.repasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //    self.phoneNumTextfield.layer.borderWidth = 1.0f;
    //    self.smsCodeTextField.layer.borderWidth = 1.0f;
    //    self.passwordTextField.layer.borderWidth = 1.0f;
    //    self.repasswordTextField.layer.borderWidth = 1.0f;
    
    
//    
//    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.phoneNumTextField.bounds.size.height +[self leftimageHeight], self.phoneNumTextField.bounds.size.height+[self leftimageHeight] )];
//    imageView1.image = [UIImage imageNamed:@"shoujihao"];
//    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.phoneNumTextField.bounds.size.height+[self leftimageHeight], self.phoneNumTextField.bounds.size.height+[self leftimageHeight])];
//    imageView2.image = [UIImage imageNamed:@"yanzhengma"];
//    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.phoneNumTextField.bounds.size.height +[self leftimageHeight], self.phoneNumTextField.bounds.size.height+[self leftimageHeight] )];
//    imageView3.image = [UIImage imageNamed:@"mima"];
//    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.phoneNumTextField.bounds.size.height +[self leftimageHeight], self.phoneNumTextField.bounds.size.height+[self leftimageHeight] )];
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight] )];
    
    imageView1.image = [UIImage imageNamed:@"shoujihao"];
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight] )];
    imageView2.image = [UIImage imageNamed:@"yanzhengma"];
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight] )];
    imageView3.image = [UIImage imageNamed:@"mima"];
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight])];
    imageView4.image = [UIImage imageNamed:@"mimaqueren"];//    UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.phoneNumTextField.bounds.size.height +[self leftimageHeight], self.phoneNumTextField.bounds.size.height+[self leftimageHeight] )];
//    imageView5.image = [UIImage imageNamed:@"yanzhengmaB"];
    
    UIView *View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight]+10,  [self leftimageHeight])];
    UIView *View2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[self leftimageHeight]+10, [self leftimageHeight])];
    
    UIView *View3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight]+10,  [self leftimageHeight])];
    UIView *View4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight]+10, [self leftimageHeight])];
    
    [View1 addSubview:imageView1];
    [View2 addSubview:imageView2];
    [View3 addSubview:imageView3];
    [View4 addSubview:imageView4];
    
    self.phoneNumTextField.leftView = View1;
    self.smsCodeTextField.leftView = View2;
    self.passwordTextField.leftView = View3;
    self.repasswordTextField.leftView = View4;
//    self.smsCodeTextField.rightView = imageView5;
    
    
    
    
    self.phoneNumTextField.delegate = self;
    self.smsCodeTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.repasswordTextField.delegate = self;
    
    UIButton *getcodeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [getcodeButton setFrame:CGRectMake(self.passwordTextField.bounds.size.width * 0.75-2, 0, self.passwordTextField.bounds.size.width * 0.25, self.passwordTextField.bounds.size.height)];
    getcodeButton.layer.masksToBounds = YES;
    [getcodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    getcodeButton.titleLabel.font = [UIFont FontForLabel];
    [getcodeButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [getcodeButton.titleLabel setTextColor:[UIColor lightGrayColor]];
    self.getSmsButton = getcodeButton;
    self.smsCodeTextField.rightView = self.getSmsButton;
    
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.passwordTextField.bounds.size.width * 0.75-1, 0,self.passwordTextField.bounds.size.width * 0.25, self.passwordTextField.bounds.size.height)];
//    [view addSubview:getcodeButton];
//    self.smsCodeTextField.rightView = view;
//    [getcodeButton setFrame:CGRectMake(self.passwordTextField.bounds.size.width * 0.75-1, 0, self.passwordTextField.bounds.size.width * 0.25, self.passwordTextField.bounds.size.height)];
//    getcodeButton.layer.cornerRadius = self.smsCodeTextField.rightView.bounds.size.height/2;

    [getcodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengmaB"] forState:(UIControlStateNormal)];
//    [getcodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengmaB"] forState:(UIControlStateHighlighted)];
//    [getcodeButton setImage:[UIImage imageNamed:@"yanzhengmaB"] forState:(UIControlStateNormal)];
//    [getcodeButton setBackgroundColor:[UIColor colorWithHexString:@"#fdd000"]];
    
      
    [getcodeButton addTarget:self action:@selector(getsmscode) forControlEvents:(UIControlEventTouchUpInside)];

    
}


- (void)initPravite
{
    self.manager = [AFHTTPSessionManager manager];
    self.userDefault = [NSUserDefaults standardUserDefaults];
}
//显示菊花
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
//    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.HUD.delegate = self;
//    self.HUD.mode = mode;
//    self.HUD.labelText = lableText;
//    self.HUD.removeFromSuperViewOnHide = YES;
//    [self.HUD hideAnimated:YES afterDelay:timer];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTextField) {
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    else if(textField == self.smsCodeTextField)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
        
    }
    else if(textField == self.passwordTextField || textField == self.repasswordTextField)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
        
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)startTime{
    __block int timeout= 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getSmsButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getSmsButton.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.getSmsButton setTitle:[NSString stringWithFormat:@"%zd秒",timeout] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.getSmsButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)getsmscode
{
    [self checkMobilePhoneNumber:self.phoneNumTextField.text];
    if (self.isPhoneNumber == YES) {
        NSString *access_token = @"token";
        NSString *phonenumber = self.phoneNumTextField.text;
        NSString *act = @"login";
        
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        
        [postDic setObject:access_token forKey:@"access_token"];
        [postDic setObject:phonenumber forKey:@"phonenumber"];
        [postDic setObject:act forKey:@"action"];
        
        
        //    [self showJuhuaWithHUDWithView:self.view HUD:self.HUD2];
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.mode = MBProgressHUDModeIndeterminate;
        [self.manager POST:getsmscodeURL parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"连接成功");
            NSLog(@"获得的数据%@",responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *code = dic[@"status_code"];
            NSLog(@"111111111111111111111111111111%@",code);
            //        [self dismissJuhuaWithHUD:self.HUD2];
            
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            if([code isEqualToString:@"200"])
            {
                [self startTime];
//                [self MBProgressWithString:@"发送成功" timer:1 mode:MBProgressHUDModeText];
                [self showAlertViewWithString:@"验证码发送成功,60s后可重新获取"];
                NSLog(@"验证码发送成功");
                
            }
            else if([code isEqualToString:@"405"])
                
            {
                [self showAlertViewWithString:@"该手机号已注册"];
//                [self MBProgressWithString:@"该手机号已注册" timer:1 mode:MBProgressHUDModeText];
                
            }
            else if([code isEqualToString:@"406"])
            {
                [self showAlertViewWithString:@"该手机号未注册"];
//                [self MBProgressWithString:@"该手机号未注册" timer:1 mode:MBProgressHUDModeText];
                
                NSLog(@"手机未注册验证码发送失败");
            }
            else if([code isEqualToString:@"503"])
            {
                [self showAlertViewWithString:@"操作过于频繁，请稍后再试"];
                
            }
            
            NSLog(@"%@",dic);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"连接失败");
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            [self showAlertViewWithString:@"获取验证码失败"];
        }];

        
    }
    }




//注册
- (void)changePassWord
{
    
    if (self.isPhoneNumber == YES)
    {
    
        if ([self.smsCodeTextField.text isEqualToString:@""]||[self.passwordTextField.text isEqualToString:@""]||[self.repasswordTextField.text isEqualToString:@""]) {
            if ([self.smsCodeTextField.text isEqualToString:@""]) {
                [self showAlertViewWithString:@"请输入您的验证码"];
                return;
            }
            if ([self.passwordTextField.text isEqualToString:@""]) {
                [self showAlertViewWithString:@"请输入您的密码"];
                return;
            }
            if ([self.passwordTextField.text isEqualToString:@""]) {
                [self showAlertViewWithString:@"请再次输入密码"];
                return;
            }
       
  
        }
        
        if ([self.passwordTextField.text isEqualToString:self.repasswordTextField.text]==NO) {
            [self showAlertViewWithString:@"两次输入的密码不一致"];
            return;
        }
//        BOOL pass =  [PassWordCheck judgePassWordLegal:self.passwordTextField.text];
//        if (pass == NO) {
//            [self showAlertViewWithString:@"请输入6-16位字母与数字组合"];
//        }
        
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSString *URL = changePaswordURL ;
    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *smscode = self.smsCodeTextField.text;
    NSString *access_token = @"token";
    AFHTTPSessionManager *manager = self.manager;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:phoneNum forKey:@"phonenumber"];
    [postDic setObject:password  forKey:@"password"];
    [postDic setObject:access_token forKey:@"access_token"];
    [postDic setObject:smscode forKey:@"smscode"];
        
        [manager POST:URL  parameters:postDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"请求成功");
            NSLog(@"返回的数据＝＝＝＝%@",responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSString *code = dic[@"status_code"];
            NSLog(@"---------------%@",code);
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            if ([code isEqualToString:@"200"])
            {
//                [self MBProgressWithString:@"密码修改成功" timer:1 mode:MBProgressHUDModeText];
                [self showAlertViewWithString:@"修改密码成功，请重新登录"];
                NSLog(@"修改成功");
                //跳出自己页面，调到登录页面
                [self dismissViewControllerAnimated:YES completion:nil];
                
//                LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
//                [self presentViewController:loginVC animated:YES completion:nil];
                
                NSString *token = dic[@"token"];
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:token forKey:@"token"];
                NSLog(@"%@",token);
            }
            //        else if([code isEqualToString:@"405"])
            //        {
            //            [self MBProgressWithString:@"账号已注册" timer:1 mode:MBProgressHUDModeText];
            //
            //        }
            else if([code isEqualToString:@"402"])
            {
                [self.HUD removeFromSuperViewOnHide];
                [self.HUD hideAnimated:YES];
                [self MBProgressWithString:@"验证码不正确" timer:1 mode:MBProgressHUDModeText];
                
            }
            
            else if([code isEqualToString:@"406"])
            {
                [self.HUD removeFromSuperViewOnHide];
                [self.HUD hideAnimated:YES];
                [self MBProgressWithString:@"该手机号未注册" timer:1 mode:MBProgressHUDModeText];
                NSLog(@"注册失败");
            }
            NSLog(@"%@",dic);
            

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败");
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            [self showAlertViewWithString:@"网络异常，请检查您的网络状况"];
            NSLog(@"%@",error);

        }];
        
        

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
