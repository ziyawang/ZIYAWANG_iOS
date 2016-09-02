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
@interface RegistController ()<MBProgressHUDDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextfield;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getsmsCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *YesButton;


@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSUserDefaults *userDefault;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) MBProgressHUD *HUD2;

@property (nonatomic,assign) BOOL agree;

@property (nonatomic,strong) UITapGestureRecognizer *tapgesture;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (nonatomic,assign) BOOL isPhoneNumber;


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
        [self showAlertViewWithString:@"手机格式不正确"];
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
            [self showAlertViewWithString:@"手机格式不正确"];
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
- (IBAction)didClickRegistButton:(id)sender {
    
    [self checkMobilePhoneNumber:self.phoneNumTextfield.text];
    //判断输入
    if (self.phoneNumTextfield.text.length !=11) {
        [self MBProgressWithString:@"号码不存在" timer:1 mode:MBProgressHUDModeText];
        
        NSLog(@"号码不存在");
        return;
    }
    if ([self.phoneNumTextfield.text isEqualToString:@""]||[self.smsCodeTextField.text isEqualToString:@""]||[self.passwordTextField.text isEqualToString:@""]||[self.repasswordTextField.text isEqualToString:@""]) {
        [self showAlertViewWithString:@"请填写完整信息"];
        
        NSLog(@"您输入的信息不完整");
        return;
    }
    if(self.passwordTextField.text.length<6||self.passwordTextField.text.length>16)
    {
        [self showAlertViewWithString:@"密码格式不正确"];
        return;
        
    }
    
    //判断同意条款
//    if (self.agree == YES) {
//        [self.registButton setUserInteractionEnabled:YES];
        [self RegistFromDomin];
        [self dismissViewControllerAnimated:YES completion:nil];
        
//    }
//    else
//    {
//        [self.registButton setUserInteractionEnabled:NO];
//        
//    }
    
    
}
- (IBAction)didClickYesButton:(id)sender {
    
//    if (self.YesButton.selected == YES)
//    {
//    self.YesButton.selected = NO;
//    }
//    if(self.YesButton.selected == NO)
//    {
//    self.YesButton.selected = YES;
//        self.agree = YES;
//        self.tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
//        [self.YesButton addGestureRecognizer:self.tapgesture];
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
//- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
//{
//    
//    self.YesButton.selected = NO;
//    self.agree = NO;
//    [self.YesButton removeGestureRecognizer:self.tapgesture];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
self.title = @"aaa";
    self.navigationController.navigationBar.topItem.title = @"aaa";
    
    [self setColorForTextPlaceHoder];
    [self initPravite];
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
    [self.YesButton setBackgroundImage:[UIImage imageNamed:@"tiaolixuanzhong"] forState:UIControlStateNormal];
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
    
    self.phoneNumTextfield.leftView = imageView1;
    self.smsCodeTextField.leftView = imageView2;
    self.passwordTextField.leftView = imageView3;
    self.repasswordTextField.leftView = imageView4;
    
    UIButton *getcodeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [getcodeButton setFrame:CGRectMake(self.phoneNumTextfield.bounds.size.width * 0.75, 0, self.phoneNumTextfield.bounds.size.width * 0.25, self.phoneNumTextfield.bounds.size.height)];
    [getcodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    getcodeButton.titleLabel.font = [UIFont FontForLabel];
    [getcodeButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
//    [getcodeButton.titleLabel setTextColor:[UIColor lightGrayColor]];
    
    self.smsCodeTextField.rightView = getcodeButton;
    
    [getcodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengmaB"] forState:(UIControlStateNormal)];
        [getcodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengmaB"] forState:(UIControlStateHighlighted)];
    [getcodeButton addTarget:self action:@selector(getsmscode) forControlEvents:(UIControlEventTouchUpInside)];
    
    
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
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return self.phoneNumTextfield.bounds.size.height-7;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
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
            
//            [self MBProgressWithString:@"发送成功" timer:1 mode:MBProgressHUDModeText];
            [self showAlertViewWithString:@"验证码发送成功,您可于60s后可重新获取"];
            
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
 [self showAlertViewWithString:@"验证码发送失败,请检查您的网络设置"];    }];
        
    }
}



//注册
- (void)RegistFromDomin
{
    
    
    if ([self.phoneNumTextfield.text isEqualToString:@""]||[self.smsCodeTextField.text isEqualToString:@""]||[self.passwordTextField.text isEqualToString:@""]||[self.repasswordTextField.text isEqualToString:@""]) {
        [self showAlertViewWithString:@"请填写完整信息"];
        
        NSLog(@"您输入的信息不完整");
        return;
    }
    
    if ([self.passwordTextField.text isEqualToString:self.repasswordTextField.text]==NO) {
        [self showAlertViewWithString:@"您输入的两次密码不一致，请重新输入"];
        return;
    }
    
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功，请用新账号登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"请求失败");
            
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
        else if([code isEqualToString:@"402"])
        {
            [self MBProgressWithString:@"验证码不正确" timer:1 mode:MBProgressHUDModeText];
            
        }
       
        else
        {
            [self MBProgressWithString:@"服务器异常，注册失败" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"注册失败");
        }
        NSLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"请求失败");
        
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
