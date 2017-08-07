//
//  RegistController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/22.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "RegistController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "PassWordCheck.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface RegistController ()<MBProgressHUDDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextfield;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getsmsCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *YesButton;

@property (weak, nonatomic) IBOutlet UILabel *xiyeLabel;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSUserDefaults *userDefault;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) MBProgressHUD *HUD2;

@property (nonatomic,assign) BOOL agree;

@property (nonatomic,strong) UITapGestureRecognizer *tapgesture;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (nonatomic,strong) UIButton *getSmsButton;

@property (nonatomic,assign) BOOL isPhoneNumber;

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIView *topView;

@end

@implementation RegistController

- (IBAction)leftButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didClickgetCode:(id)sender
{
    
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
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTextfield) {
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
- (IBAction)didClickRegistButton:(id)sender {
    
    [self checkMobilePhoneNumber:self.phoneNumTextfield.text];
    //判断输入
//    if (self.phoneNumTextfield.text.length !=11) {
//        [self MBProgressWithString:@"号码不存在" timer:1 mode:MBProgressHUDModeText];
//        
//        NSLog(@"号码不存在");
//        return;
//    }
    if ([self.smsCodeTextField.text isEqualToString:@""]||[self.passwordTextField.text isEqualToString:@""]||[self.repasswordTextField.text isEqualToString:@""]) {
        if ([self.smsCodeTextField.text isEqualToString:@""]) {
            [self showAlertViewWithString:@"请输入验证码"];
            return;
        }
        if ([self.passwordTextField.text isEqualToString:@""]) {
            [self showAlertViewWithString:@"请输入密码"];
            return;
        }
        if ([self.passwordTextField.text isEqualToString:@""]) {
            [self showAlertViewWithString:@"请再次输入密码"];
            return;
        }
        NSLog(@"您输入的信息不完整");
        return;
    }
    if(self.passwordTextField.text.length<6||self.passwordTextField.text.length>16)
    {
        if(self.passwordTextField.text.length < 6)
        {
         [self showAlertViewWithString:@"请输入不少于6位密码"];
            return;
        }
        if (self.passwordTextField.text.length > 16) {
            [self showAlertViewWithString:@"输入密码不能多于16位"];
        }
        return;
        
    }
    
    //判断同意条款
//    if (self.agree == YES) {
//        [self.registButton setUserInteractionEnabled:YES];
        [self RegistFromDomin];
    
//    }
//    else
//    {
//        [self.registButton setUserInteractionEnabled:NO];
//        
//    }
    
    
}
- (IBAction)didClickYesButton:(id)sender {
    
    if (self.agree == YES) {
        [self.YesButton setBackgroundImage:[UIImage imageNamed:@"tiaoli"] forState:(UIControlStateNormal)];
        self.agree = NO;
    }
    else if (self.agree == NO) {
        [self.YesButton setBackgroundImage:[UIImage imageNamed:@"tiaolixuanzhong"] forState:(UIControlStateNormal)];
        self.agree = YES;
    }
    
//    if (self.YesButton.selected == YES)
//    {
//    self.YesButton.selected = NO;
//        
//    }
//    if(self.YesButton.selected == NO)
//    {
//    self.YesButton.selected = YES;
//        self.agree = YES;
//        self.tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
//        [self.YesButton addGestureRecognizer:self.tapgesture];
//        
//    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 140;
    int movenment = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.50];
    self.view.frame = CGRectOffset(self.view.frame, 0, movenment);
    [UIView commitAnimations];
    
}
// 给同意按钮添加手势方法
- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    self.YesButton.selected = NO;
    self.agree = NO;
    [self.YesButton removeGestureRecognizer:self.tapgesture];
}
- (void)xiyeLabelGesture:(UITapGestureRecognizer *)gesture
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView = webView;
    NSString *URL = [AudioURL stringByAppendingString:@"/law.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
   
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 25, 150, 20)];
    titleLabel.text = @"资芽网注册协议";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.centerX = view.centerX;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:titleLabel];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 25, 10, 18)];
    imageview.image = [UIImage imageNamed:@"back3"];
    
    [view addSubview:imageview];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button setFrame:CGRectMake(20, 20, 40, 30)];
    [button setTitle:@"返回" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [button addTarget:self action:@selector(didClickWebViewButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [view addSubview:button];
    self.topView = view;
       [self.view addSubview:self.topView];
    [self.view addSubview:self.webView];
}
- (void)didClickWebViewButton
{
    [self.webView removeFromSuperview];
    [self.topView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
self.title = @"aaa";
    self.navigationController.navigationBar.topItem.title = @"aaa";
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xiyeLabelGesture:)];
    
    [self.xiyeLabel addGestureRecognizer:gesture];
    self.xiyeLabel.userInteractionEnabled = YES;
    
    [self setColorForTextPlaceHoder];
    [self initPravite];
    [self.YesButton setBackgroundImage:[UIImage imageNamed:@"tiaolixuanzhong"] forState:UIControlStateNormal];
    self.agree = YES;
    [self setAgreeButtonState];
    //设置注册按钮不可点击
     //    [self.registButton setUserInteractionEnabled:NO];
    //    导航栏变为透明
    [self.navigationbar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    让黑线消失的方法
    self.navigationbar.shadowImage=[UIImage new];
//    self.leftBarButton.image = [UIImage imageNamed:@"icon_left_jt"];

      }
- (void)setAgreeButtonState
{
    
    
//    [self.YesButton setBackgroundImage:[UIImage imageNamed:@"tiaolixuanzhong"] forState:UIControlStateHighlighted];
//    [self.YesButton setBackgroundImage:[UIImage imageNamed:@"tiaolixuanzhong"] forState:UIControlStateSelected];
//    [self.YesButton setBackgroundImage:[UIImage imageNamed:@"tiaolixuanzhong"] forState:UIControlStateSelected | UIControlStateHighlighted];
//    self.YesButton.selected = NO;
  
    
}

- (void)initPravite
{
    self.manager = [AFHTTPSessionManager manager];
    self.userDefault = [NSUserDefaults standardUserDefaults];
}



- (void)setColorForTextPlaceHoder
{
    UIColor *placeHoderColor = [UIColor lightGrayColor];
    
    [self.phoneNumTextfield setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.smsCodeTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];

    [self.passwordTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];

    [self.repasswordTextField setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    
    self.phoneNumTextfield.keyboardType = UIKeyboardTypePhonePad;
    self.smsCodeTextField.keyboardType = UIKeyboardTypePhonePad;
    
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    self.repasswordTextField.keyboardType = UIKeyboardTypeDefault;

    self.phoneNumTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.smsCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.smsCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.repasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTextfield.delegate = self;
    self.smsCodeTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.repasswordTextField.delegate = self;
    
//    self.phoneNumTextfield.layer.borderWidth = 1.0f;
//    self.smsCodeTextField.layer.borderWidth = 1.0f;
//    self.passwordTextField.layer.borderWidth = 1.0f;
//    self.repasswordTextField.layer.borderWidth = 1.0f;


    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight] )];
    
    imageView1.image = [UIImage imageNamed:@"shoujihao"];
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight] )];
    imageView2.image = [UIImage imageNamed:@"yanzhengma"];
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight] )];
    imageView3.image = [UIImage imageNamed:@"mima"];
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight])];
    imageView4.image = [UIImage imageNamed:@"mimaqueren"];
    UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight],[self leftimageHeight] )];
    imageView5.image = [UIImage imageNamed:@"shoujihao"];
    
    UIView *View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight]+10, [self leftimageHeight])];
    UIView *View2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight]+10, [self leftimageHeight])];
    
     UIView *View3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight]+10,[self leftimageHeight])];
     UIView *View4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self leftimageHeight]+10, [self leftimageHeight])];
    
    [View1 addSubview:imageView1];
    [View2 addSubview:imageView2];
    [View3 addSubview:imageView3];
    [View4 addSubview:imageView4];
    
    
    self.phoneNumTextfield.leftView = View1;
    self.smsCodeTextField.leftView = View2;
    self.passwordTextField.leftView = View3;
    self.repasswordTextField.leftView = View4;
    
    UIButton *getcodeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [getcodeButton setFrame:CGRectMake(self.phoneNumTextfield.bounds.size.width * 0.75, 0, self.phoneNumTextfield.bounds.size.width * 0.25, self.phoneNumTextfield.bounds.size.height)];
    [getcodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    getcodeButton.titleLabel.font = [UIFont FontForLabel];
    [getcodeButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
//    [getcodeButton.titleLabel setTextColor:[UIColor lightGrayColor]];
    
    
    
    self.smsCodeTextField.rightView = getcodeButton;
    
    [getcodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengmaB"] forState:(UIControlStateNormal)];
        [getcodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengmaB"] forState:(UIControlStateHighlighted)];
    [getcodeButton addTarget:self action:@selector(getsmscode) forControlEvents:(UIControlEventTouchUpInside)];
    self.getSmsButton = getcodeButton;
    
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return self.phoneNumTextfield.bounds.size.height-7;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return self.phoneNumTextfield.bounds.size.height;
        
    }
    
    return 0;
    
}

//注册获取验证码

- (void)getsmscode
{
    
    
     [self checkMobilePhoneNumber:self.phoneNumTextfield.text];
    if (self.isPhoneNumber == YES) {
      
    NSString *access_token = @"token";
    NSString *phonenumber = self.phoneNumTextfield.text;
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
    [self.manager POST:getsmscodeURL parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
            
            [self startTime];
//            [self MBProgressWithString:@"发送成功" timer:1 mode:MBProgressHUDModeText];
            [self showAlertViewWithString:@"验证码发送成功,60s后可重新获取"];
            
            NSLog(@"验证码发送成功");
            
        }
        else if([code isEqualToString:@"405"])
            
        {
            [self showAlertViewWithString:@"该账号已注册，请直接登录"];
//            [self MBProgressWithString:@"手机号已注册" timer:1 mode:MBProgressHUDModeText];

        }
        else
        {
            [self showAlertViewWithString:@"服务器异常，请稍后重试"];
            
//            [self MBProgressWithString:@"发送失败" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"验证码发送失败");
        }
        
        NSLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 [self showAlertViewWithString:@"验证码发送失败,请检查您的网络设置"];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
    }];
        
    }
}



//注册
- (void)RegistFromDomin
{
    if ([self.smsCodeTextField.text isEqualToString:@""]||[self.passwordTextField.text isEqualToString:@""]||[self.repasswordTextField.text isEqualToString:@""]) {
        if ([self.smsCodeTextField.text isEqualToString:@""]) {
            [self showAlertViewWithString:@"请输入验证码"];
            return;
            
        }
        if ([self.passwordTextField.text isEqualToString:@""]) {
            [self showAlertViewWithString:@"请输入的密码"];
            return;
            
        }
        if ([self.repasswordTextField.text isEqualToString:@""]) {
            [self showAlertViewWithString:@"请再次输入密码"];
            return;
            
        }

    }
    
    if ([self.passwordTextField.text isEqualToString:self.repasswordTextField.text]==NO) {
        [self showAlertViewWithString:@"两次输入密码不一致"];
        return;
    }
  
//    BOOL pass =  [PassWordCheck judgePassWordLegal:self.passwordTextField.text];
//    if (pass == NO) {
//        [self showAlertViewWithString:@"请输入6-16位字母与数字组合"];
//        return;
//    }
//    if (self.agree == NO) {
//        [self showAlertViewWithString:@"您还未阅读并同意《资芽网注册协议》"];
//        return;
//    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSString *phoneNum = self.phoneNumTextfield.text;
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
    [postDic setObject:@"IOS" forKey:@"Channel"];
    
    
    [manager POST:registURL parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
//            [self MBProgressWithString:@"注册成功" timer:1 mode:MBProgressHUDModeText];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功，请用新账号登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            NSLog(@"请求失败");
//            self.HUD = [MBProgressHUD showHUDAddedTo:[self window]animated:YES];
//            self.HUD.delegate = self;
//            self.HUD.mode = MBProgressHUDModeText;
//            self.HUD.labelText = @"注册成功";
//            self.HUD.removeFromSuperViewOnHide = YES;
//            [self.HUD hideAnimated:YES afterDelay:2];
            [self showAlertViewWithString:@"注册成功"];
            NSLog(@"注册成功");
            NSString *token = dic[@"token"];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:token forKey:@"token"];
            NSLog(@"%@",token);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if([code isEqualToString:@"405"])
        {
            [self showAlertViewWithString:@"该账号已注册"];
//            [self MBProgressWithString:@"账号已注册" timer:1 mode:MBProgressHUDModeText];
        }
        else if([code isEqualToString:@"402"])
        {
            [self showAlertViewWithString:@"验证码不正确"];
//            [self MBProgressWithString:@"验证码不正确" timer:1 mode:MBProgressHUDModeText];
        }
        else
        {
            [self showAlertViewWithString:@"服务器异常，请稍后重试"];
//            [self MBProgressWithString:@"服务器异常，注册失败" timer:1 mode:MBProgressHUDModeText];
            NSLog(@"注册失败");
        }
        NSLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"请求失败");
        
    }];
    
    
}

- (UIWindow *)window
{
    return [UIApplication sharedApplication].keyWindow;
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
