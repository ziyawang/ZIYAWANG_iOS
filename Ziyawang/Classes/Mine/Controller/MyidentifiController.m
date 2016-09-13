//
//  MyidentifiController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/9.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MyidentifiController.h"
#import "SuPhotoPicker.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

#import "ChooseAreaController.h"
#import "CSChooseServiceArearController.h"
#import "CSChooseServiceTypeViewController.h"
#import "LoginController.h"
#import "UserInfoModel.h"
#import "MyUItextField.h"
@interface MyidentifiController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextView *comPanyDesTextView;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton1;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton2;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton3;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIView *companyLocationView;
@property (weak, nonatomic) IBOutlet UIView *companyServiceView;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *sentButtonBackView;
@property (weak, nonatomic) IBOutlet UIButton *sentMessageButton;
@property (weak, nonatomic) IBOutlet UIView *userIconBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageButtonLeftConstraint;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableArray *imagearray;

@property (nonatomic,strong)UIButton *deleteButton;

@property (nonatomic,assign) NSInteger x;
@property (nonatomic,strong) NSString *photostate;
@property (weak, nonatomic) IBOutlet UILabel *qiyesuozai;
@property (weak, nonatomic) IBOutlet UILabel *fuwudiqu;
@property (weak, nonatomic) IBOutlet UILabel *fuwuleixing;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (nonatomic,strong) UserInfoModel *model;
@property (nonatomic,strong) NSString *servicetypeID;
@property (nonatomic,assign) BOOL isPhoneNumber;






@end

@implementation MyidentifiController


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
//    [self getUserInfoFromDomin];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *userName = self.nameTextField.text;
//    NSString *phoneNumber = self.phoneNumTextField.text;
//    NSString *companyName = self.companyTextField.text;
//    NSString *companyDes = self.comPanyDesTextView.text;
    
    
    NSString *companyLocation = [defaults objectForKey:@"企业地区"];
    NSString *ServiceArea = [defaults objectForKey:@"服务地区"];
    NSString *ServiceType = [defaults objectForKey:@"服务的类型"];

    self.servicetypeID = ServiceType;
    
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!SERviceType%@",ServiceType);
    
    
    NSLog(@"~~~~~~~%@",self.ViewType);
    if ([self.ViewType isEqualToString:@"服务"]==NO) {
        self.qiyesuozai.text = companyLocation;
        self.fuwudiqu.text = ServiceArea;
        self.fuwuleixing.text = ServiceType;
    }
    self.ViewType = @"非服务";
    
//   self.ViewType = @"非服务";
    
    
//    else
//    {
//    
//        self.nameTextField.text = self.ConnectPerson;
//        self.phoneNumTextField.text = self.ConnectPhone;
//        self.companyTextField.text = self.ServiceName;
//        self.qiyesuozai.text = self.ServiceLocation;
//        self.fuwudiqu.text = self.ServiceArea;
//    }
  
}


- (void)showAlertViewWithString:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}

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

- (void)getUserInfoFromDomin
{
      NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *role = self.role;
    
    NSString *URL = [[getUserInfoURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"token" forKey:@"access_token"];
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        [self.model setValuesForKeysWithDictionary:dic[@"user"]];
//        [self.model setValuesForKeysWithDictionary:dic[@"service"]];
        self.nameTextField.text = @"";
        self.phoneNumTextField.text = @"";
        self.companyTextField.text = @"";
        self.comPanyDesTextView.text = @"";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"获取用户信息失败");
        
        //        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
        //        NSString *userPicture = [[NSUserDefaults standardUserDefaults]objectForKey:@""];
        //        NSString *
//        self.hasNet = NO;
        
    }];
}


- (void)layOutViewForRole1
{
//    @property (nonatomic,strong) NSString *phonenumber;
//    @property (nonatomic,strong) NSString *ServiceName;
//    @property (nonatomic,strong) NSString *ServiceLocation;
//    @property (nonatomic,strong) NSString *UserPicture;
//    @property (nonatomic,strong) NSString *ConnectPhone;
//    @property (nonatomic,strong) NSString *ConfirmationP1;
//    @property (nonatomic,strong) NSString *ConfirmationP2;
//    @property (nonatomic,strong) NSString *ConfirmationP3;
//    @property (nonatomic,strong) NSString *ConnectPerson;
//    @property (nonatomic,strong) NSString *ServiceIntroduction;
//    @property (nonatomic,strong) NSString *ServiceType;
    self.nameTextField.text = self.ConnectPerson;
    self.phoneNumTextField.text = self.ConnectPhone;
    self.companyTextField.text = self.ServiceName;
    self.qiyesuozai.text = self.ServiceLocation;
    self.fuwudiqu.text = self.ServiceArea;
    self.fuwuleixing.text = self.ServiceType;
    self.comPanyDesTextView.text = self.ServiceIntroduction;
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 90, 90)];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(90+20, 0, 90, 90)];
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(210, 0, 90, 90)];
    
    [self.imageBackView addSubview:imageView1];
    [self.imageBackView addSubview:imageView2];
    [self.imageBackView addSubview:imageView3];
    if ([self.ConfirmationP1 isEqualToString:@""]==NO) {
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.ConfirmationP1]]];
    }
    if ([self.ConfirmationP2 isEqualToString:@""]==NO) {
  [imageView2 sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.ConfirmationP2]]];    }
    
    if ([self.ConfirmationP3 isEqualToString:@""]==NO)
    {
  [imageView3 sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.ConfirmationP3]]];
    }
    [self.addImageButton setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self.sentMessageButton setHidden:YES];
    [self.sentButtonBackView setHidden:YES];
    
     //添加图片显示VIEW
}



- (void)layOutViewForRole2
{
    self.nameTextField.text = self.ConnectPerson;
    self.phoneNumTextField.text = self.ConnectPhone;
    self.companyTextField.text = self.ServiceName;
    self.qiyesuozai.text = self.ServiceLocation;
    self.fuwudiqu.text = self.ServiceArea;
    [self.comPanyDesTextView setText:self.ServiceIntroduction];
    NSLog(@"--------%@",self.comPanyDesTextView.text);
    self.fuwuleixing.text = self.ServiceType;
//    [self.qiyesuozai setText:self.ServiceLocation];
//    [self.fuwuleixing setText:self.ServiceType];
//    [self.comPanyDesTextView setText:self.ServiceIntroduction];
//    [self.fuwudiqu setText:self.ServiceArea];
    
//    self.qiyesuozai.text = self.ServiceLocation;
//    self.fuwudiqu.text = self.ServiceLocation;
//    self.fuwuleixing.text = self.ServiceType;
//    self.comPanyDesTextView.text = self.ServiceIntroduction;
//    [self.addImageButton setHidden:YES];
//    [self.deleteButton setHidden:YES];
    [self.sentMessageButton setTitle:@"重新提交" forState:(UIControlStateNormal)];
}







- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"服务方认证";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;
    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];

    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    
    self.ScrollView.delegate = self;
    [self.sentMessageButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    [defaults removeObjectForKey:@"企业地区"];
    [defaults removeObjectForKey:@"服务地区"];
    [defaults removeObjectForKey:@"服务类型"];
    [defaults removeObjectForKey:@"服务的类型"];
    
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    else
    {
        [self setSubViews];
        
    }
//    self.ViewType =@"非服务";
    
}


- (void)setSubViews
{
    self.imagearray = [NSMutableArray new];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.x = 0;
    [self.addImageButton addTarget:self action:@selector(didClickChooseImage:) forControlEvents:(UIControlEventTouchUpInside)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, self.addImageButton.bounds.size.width, 20)];
    label.text = @"添加图片";
    label.textColor = [UIColor colorWithHexString:@"fdd000"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11];
    [self.addImageButton addSubview:label];
    UIButton *deleteButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [deleteButton setFrame:CGRectMake(90 * 3 + 60, 30, 30, 30)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"chexiao"] forState:(UIControlStateNormal)];
//    [deleteButton setTitle:@"撤销" forState:(UIControlStateNormal)];
    [deleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.deleteButton = deleteButton;
    [self.imageBackView addSubview:self.deleteButton];
    self.userIconImageView.userInteractionEnabled = YES;
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.layer.cornerRadius = 15;
    self.comPanyDesTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 0, 10);
    
  
    self.comPanyDesTextView.text = self.ServiceIntroduction;
    
    self.comPanyDesTextView.text = @"企业简介";
    self.comPanyDesTextView.delegate = self;
    self.comPanyDesTextView.textColor = [UIColor grayColor];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [self.userIconBackView addGestureRecognizer:tapgesture];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseLoaction:)];
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseServiceArea:)];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseServiceType:)];
    [self.companyLocationView addGestureRecognizer:gesture1];
    [self.companyServiceView addGestureRecognizer:gesture2];
    [self.serviceView addGestureRecognizer:gesture3];
    
    NSString *role = self.role;
        if ([role isEqualToString:@"1"]) {
            [self layOutViewForRole1];
        }
        else if([role isEqualToString:@"2"])
        {
            [self layOutViewForRole2];
        }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"企业简介"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
//- (void)textViewDidChange:(UITextView *)textView
//{
//    textView.textColor = [UIColor blackColor];
//}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"企业简介";
    }
}


- (void)chooseLoaction:(UIGestureRecognizer *)gesture1
{
    [self.view endEditing:YES];
    ChooseAreaController *choosAreaVc = [[ChooseAreaController alloc]init];
    choosAreaVc.type = @"服务";
    
    [self.navigationController pushViewController:choosAreaVc animated:YES];
}
- (void)chooseServiceArea:(UIGestureRecognizer *)gesture2
{
    [self.view endEditing:YES];

    CSChooseServiceArearController *ServiceArea = [[CSChooseServiceArearController alloc]init];
    [self.navigationController pushViewController:ServiceArea animated:YES];
    
}
- (void)chooseServiceType:(UIGestureRecognizer *)gesture3
{
    [self.view endEditing:YES];

    CSChooseServiceTypeViewController *serviceType = [[CSChooseServiceTypeViewController alloc]init];
    [self.navigationController pushViewController:serviceType animated:YES];
    
}
- (IBAction)sentServiceUserInfoButton:(id)sender
{
    
     NSString *role = self.role;
    
    if ([role isEqualToString:@"0"])
    {
        [self checkMobilePhoneNumber:self.phoneNumTextField.text];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = self.nameTextField.text;
    NSString *phoneNumber = self.phoneNumTextField.text;
    NSString *companyName = self.companyTextField.text;
    NSString *companyDes = self.comPanyDesTextView.text;
    NSString *companyLocation = [defaults objectForKey:@"企业地区"];
    NSString *ServiceArea = [defaults objectForKey:@"服务地区"];
    NSString *ServiceType = [defaults objectForKey:@"服务类型"];
    NSString *headurl = getDataURL;
    NSString *footurl = @"/app/service/confirm";
   //    NSString *str = @"http://api.ziyawang.com/v1app/service/confirm";
    NSString *token1 = [defaults objectForKey:@"token"];

    NSString *token = [@"?token="stringByAppendingString:token1];
    
    NSString *URL = [[headurl stringByAppendingString:footurl]stringByAppendingString:token];
    NSLog(@"URL:::::%@",URL);
    
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    NSLog(@"token:::::%@",token);
    NSString *accesstoken = @"token";
//    [paraDic setObject:token forKey:@"token"];
    
    if (accesstoken == nil||userName == nil || phoneNumber ==nil ||companyName==nil||companyDes == nil || companyLocation ==nil ||ServiceArea ==nil || ServiceType ==nil||[companyDes isEqualToString:@"企业简介"]) {
        NSLog(@"信息不完整");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的认证信息不完整" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
    [paraDic setObject:accesstoken forKey:@"access_token"];
    [paraDic setObject:userName forKey:@"ConnectPerson"];
    [paraDic setObject:phoneNumber forKey:@"ConnectPhone"];
    [paraDic setObject:companyName forKey:@"ServiceName"];
    [paraDic setObject:companyDes forKey:@"ServiceIntroduction"];
    [paraDic setObject:companyLocation forKey:@"ServiceLocation"];
    [paraDic setObject:ServiceArea forKey:@"ServiceArea"];
    [paraDic setObject:ServiceType forKey:@"ServiceType"];
    
    [self.manager POST:URL parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传四张图片
        
        if (self.imagearray.count == 1) {
            NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
//            NSData *imageData4 = UIImageJPEGRepresentation(self.userIconImageView.image, 1.0f);
            [formData appendPartWithFileData:imageData1 name:@"ConfirmationP1"fileName:@"ConfirmationP1.png" mimeType:@"image/jpg/png/jpeg"];
//            [formData appendPartWithFileData:imageData4 name:@"UserPicture" fileName:@"bbb" mimeType:@"image/jpg/png/jpeg"];

        }
        else if(self.imagearray.count == 2)
        {
            NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
            NSData *imageData2 = UIImageJPEGRepresentation(self.imagearray[1], 1.0f);
//            NSData *imageData4 = UIImageJPEGRepresentation(self.userIconImageView.image, 1.0f);
            [formData appendPartWithFileData:imageData1 name:@"ConfirmationP1"fileName:@"ConfirmationP1.png" mimeType:@"image/jpg/png/jpeg"];
            [formData appendPartWithFileData:imageData2 name:@"ConfirmationP2" fileName:@"ConfirmationP2.png" mimeType:@"image/jpg/png/jpeg"];

//            [formData appendPartWithFileData:imageData4 name:@"UserPicture" fileName:@"UserPicture.png" mimeType:@"image/jpg/png/jpeg"];
        }
        else if(self.imagearray.count == 0)
        {
         
        }
        else
        {
            NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
            NSData *imageData2 = UIImageJPEGRepresentation(self.imagearray[1], 1.0f);
            NSData *imageData3 = UIImageJPEGRepresentation(self.imagearray[2], 1.0f);
//            NSData *imageData4 = UIImageJPEGRepresentation(self.userIconImageView.image, 1.0f);
            [formData appendPartWithFileData:imageData1 name:@"ConfirmationP1"fileName:@"ConfirmationP1.png" mimeType:@"image/jpg/png/jpeg"];
            [formData appendPartWithFileData:imageData2 name:@"ConfirmationP2" fileName:@"ConfirmationP2.png" mimeType:@"image/jpg/png/jpeg"];
            [formData appendPartWithFileData:imageData3 name:@"ConfirmationP3" fileName:@"ConfirmationP3.png" mimeType:@"image/jpg/png/jpeg"];
//            [formData appendPartWithFileData:imageData4 name:@"UserPicture" fileName:@"UserPicture.png" mimeType:@"image/jpg/png/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息已上传，等待审核" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"上传审核信息成功");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"审核信息上传失败，请重新上传" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"上传审核信息失败");
        NSLog(@"@@@@@@@@@@%@",error);
    }];
    }
    }
    
    
#pragma mark----未通过审核的服务方
    
    
    else if([role isEqualToString:@"2"])
    
    {
        if ([self.sentMessageButton.titleLabel.text isEqualToString:@"重新提交"]) {
            [self.sentMessageButton setTitle:@"提交" forState:(UIControlStateNormal)];
            self.nameTextField.text = @"";
            self.phoneNumTextField.text = @"";
            self.companyTextField.text = @"";
            self.qiyesuozai.text = @"";
            self.fuwudiqu.text = @"";
            self.fuwuleixing.text = @"";
            self.comPanyDesTextView.text = @"";
        }
        if ([self.sentMessageButton.titleLabel.text isEqualToString:@"提交"]) {
        [self checkMobilePhoneNumber:self.phoneNumTextField.text];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = self.nameTextField.text;
        NSString *phoneNumber = self.phoneNumTextField.text;
        NSString *companyName = self.companyTextField.text;
        NSString *companyDes = self.comPanyDesTextView.text;
        NSString *companyLocation = self.qiyesuozai.text;
        NSString *ServiceArea =  self.fuwudiqu.text;
        NSString *ServiceType = [[NSUserDefaults standardUserDefaults]objectForKey:@"服务类型"];
//        NSString *ServiceType = self.fuwuleixing.text;
            NSLog(@"-------------------%@",ServiceType);
            
        NSString *headurl = getDataURL;
        NSString *footurl = @"/app/service/reconfirm";
        //    NSString *str = @"http://api.ziyawang.com/v1app/service/confirm";
        NSString *token1 = [defaults objectForKey:@"token"];
        NSString *token = [@"?token="stringByAppendingString:token1];
        NSString *URL = [[headurl stringByAppendingString:footurl]stringByAppendingString:token];
        NSLog(@"URL:::::%@",URL);
        
        NSMutableDictionary *paraDic = [NSMutableDictionary new];
        NSLog(@"token:::::%@",token);
        NSString *accesstoken = @"token";
            if ([accesstoken isEqualToString:@""]||[userName isEqualToString:@""]|| [phoneNumber isEqualToString:@""]||[companyName isEqualToString:@""]||[companyDes isEqualToString:@""] || [companyLocation isEqualToString:@""]||[ServiceArea isEqualToString:@"" ]|| [ServiceType isEqualToString:@""]||[companyDes isEqualToString:@"企业简介"]||self.imagearray.count == 0) {
            NSLog(@"信息不完整");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的认证信息不完整" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            [paraDic setObject:accesstoken forKey:@"access_token"];
            [paraDic setObject:userName forKey:@"ConnectPerson"];
            [paraDic setObject:phoneNumber forKey:@"ConnectPhone"];
            [paraDic setObject:companyName forKey:@"ServiceName"];
            [paraDic setObject:companyDes forKey:@"ServiceIntroduction"];
            [paraDic setObject:companyLocation forKey:@"ServiceLocation"];
            [paraDic setObject:ServiceArea forKey:@"ServiceArea"];
            [paraDic setObject:ServiceType forKey:@"ServiceType"];
            
            NSLog(@"ServiceType::::::::::::::::::::%@",paraDic[@"ServiceType"]);
            
            
            
            [self.manager POST:URL parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                //上传四张图片
                
                if (self.imagearray.count == 1) {
                    NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
                    //            NSData *imageData4 = UIImageJPEGRepresentation(self.userIconImageView.image, 1.0f);
                    [formData appendPartWithFileData:imageData1 name:@"ConfirmationP1"fileName:@"ConfirmationP1.png" mimeType:@"image/jpg/png/jpeg"];
                    //            [formData appendPartWithFileData:imageData4 name:@"UserPicture" fileName:@"bbb" mimeType:@"image/jpg/png/jpeg"];
                    
                }
                else if(self.imagearray.count == 2)
                {
                    NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
                    NSData *imageData2 = UIImageJPEGRepresentation(self.imagearray[1], 1.0f);
                    //            NSData *imageData4 = UIImageJPEGRepresentation(self.userIconImageView.image, 1.0f);
                    [formData appendPartWithFileData:imageData1 name:@"ConfirmationP1"fileName:@"ConfirmationP1.png" mimeType:@"image/jpg/png/jpeg"];
                    [formData appendPartWithFileData:imageData2 name:@"ConfirmationP2" fileName:@"ConfirmationP2.png" mimeType:@"image/jpg/png/jpeg"];
                    
                    //            [formData appendPartWithFileData:imageData4 name:@"UserPicture" fileName:@"UserPicture.png" mimeType:@"image/jpg/png/jpeg"];
                }
                else if(self.imagearray.count == 0)
                {
                    
                }
                else
                {
                    NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
                    NSData *imageData2 = UIImageJPEGRepresentation(self.imagearray[1], 1.0f);
                    NSData *imageData3 = UIImageJPEGRepresentation(self.imagearray[2], 1.0f);
                    //            NSData *imageData4 = UIImageJPEGRepresentation(self.userIconImageView.image, 1.0f);
                    [formData appendPartWithFileData:imageData1 name:@"ConfirmationP1"fileName:@"ConfirmationP1.png" mimeType:@"image/jpg/png/jpeg"];
                    [formData appendPartWithFileData:imageData2 name:@"ConfirmationP2" fileName:@"ConfirmationP2.png" mimeType:@"image/jpg/png/jpeg"];
                    [formData appendPartWithFileData:imageData3 name:@"ConfirmationP3" fileName:@"ConfirmationP3.png" mimeType:@"image/jpg/png/jpeg"];
                    //            [formData appendPartWithFileData:imageData4 name:@"UserPicture" fileName:@"UserPicture.png" mimeType:@"image/jpg/png/jpeg"];
                }
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"%@",uploadProgress);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息已上传，等待审核" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
                NSLog(@"上传审核信息成功");
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"审核信息上传失败，请重新上传" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alert show];
                NSLog(@"上传审核信息失败");
                NSLog(@"@@@@@@@@@@%@",error);
            }];
        }
        }
    }
  
}

//UITextView代理方法
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    textView.text = @"";
//    textView.textColor = [UIColor blackColor];
//    textView.font = [UIFont systemFontOfSize:12];
//}

//- (void)didClickSentImageButton:(UIButton *)addimageButton
//{
//    __weak typeof(self) weakSelf = self;
//    SuPhotoPicker * picker = [[SuPhotoPicker alloc]init];
//    picker.selectedCount = 1;
//    picker.preViewCount = 5;
//    [picker showInSender:self handle:^(NSArray<UIImage *> *photos) {
//        [weakSelf showSelectedPhotos:photos];
//    }];
//}


- (void)didClickChooseImage:(UIButton *)button
{
    self.photostate = @"大";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
//PickerImage完成后的代理方法
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    //定义一个newPhoto，用来存放我们选择的图片。
//    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    //    self.usericonImageView.image = newPhoto;
//    
//  
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)showSelectedPhotos:(NSArray *)images
{
    self.x ++;
    NSLog(@"X的值未（（（（（（（（（（（%ld",self.x);
    [self.imagearray addObject:images.lastObject];
    if (self.x < 4) {
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(90 * (self.x - 1) + 10 * self.x, 0, 90, 90)];
        
        iv.image = images[0];
        iv.tag = self.x;
        [self.imageBackView addSubview:iv];
        if (self.x == 3) {
            //            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            //            button.backgroundColor = [UIColor whiteColor];
            //            [button setTitle:@"删除" forState:(UIControlStateNormal)];
            //            [button setFrame:CGRectMake(70, 5, 10, 10)];
            //            [iv addSubview:button];
            
            [self.addImageButton setHidden:YES];
            
        }
        if (self.x != 3) {
//            [self.addImageButton setFrame:CGRectMake(90 * self.x + 10 * self.x, 0, 90, 90)];
            self.addImageButtonLeftConstraint.constant = 90 * self.x + 10 * self.x;
        }
    }
}
- (void)didClickDeleteButton:(UIButton *)deleteButton
{
    NSMutableArray *a = [NSMutableArray array];
    for (UIView *view in self.imageBackView.subviews)
    {
        NSString *tag = [NSString stringWithFormat:@"%ld",view.tag];
        
        [a addObject:tag];
    }
    if (a.count == 5)
    {
        [[self.imageBackView viewWithTag:3]removeFromSuperview];
        self.x--;
        NSLog(@"X的值$$$$$$$$未%ld",self.x);
//        [self.addImageButton setFrame:CGRectMake(90 * 2 +10 *2, 0, 90, 90)];
        self.addImageButtonLeftConstraint.constant = 200;
        
        [self.imagearray removeObject:self.imagearray[2]];
        
        [self.addImageButton setHidden:NO];
    }
    else if(a.count == 4)
    {
        
        [[self.imageBackView viewWithTag:2]removeFromSuperview];
//        [self.addImageButton setFrame:CGRectMake(90+10, 0, 90, 90)];
        self.addImageButtonLeftConstraint.constant = 100;
        
        [self.imagearray removeObject:self.imagearray[1]];
        
        
        self.x--;
        NSLog(@"X的值@@@@@@@@@@未%ld",self.x);
        
    }
    else if(a.count == 3)
    {
        [[self.imageBackView viewWithTag:1]removeFromSuperview];
//        [self.addImageButton setFrame:CGRectMake(10 , 0, 90, 90)];
        self.addImageButtonLeftConstraint.constant = 10;
        [self.imagearray removeObject:self.imagearray[0]];
        self.x--;
        NSLog(@"X的值###########未%ld",self.x);
        
        
    }
    
    
    
}



- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    self.photostate = @"小";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if ([self.photostate isEqualToString:@"小"]) {
        self.userIconImageView.image = newPhoto;
    }
    else if([self.photostate isEqualToString:@"大"])
    {
        NSMutableArray *sentimage = [NSMutableArray new];
        [sentimage addObject:newPhoto];
        [self showSelectedPhotos:sentimage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
