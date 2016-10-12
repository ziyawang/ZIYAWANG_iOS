//
//  UserInfoController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "UserInfoController.h"
#import "FindwordController.h"
#import "LoginController.h"
#import "ChangeWordViewController.h"
#import "PassWordCheck.h"
#import "ChageNickNameController.h"
#import "UserInfoModel.h"
#import <AVFoundation/AVFoundation.h>

@interface UserInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *usericonImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *changePasswordView;
@property (weak, nonatomic) IBOutlet UIView *changeIconView;
@property (weak, nonatomic) IBOutlet UIView *nickNameView;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UILabel *touxiang;
@property (weak, nonatomic) IBOutlet UILabel *connectPhone;
@property (weak, nonatomic) IBOutlet UILabel *xiugaimima;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UserInfoModel *model;

@end

@implementation UserInfoController

- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"个人信息";
    title.textColor = [UIColor blackColor];
    
    self.navigationItem.titleView = title;
    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.model = [[UserInfoModel alloc]init];
    [self getUserInfoFromDomin];
}
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupTitle];
//    self.touxiang.font = [UIFont FontForLabel];
//    self.connectPhone.font = [UIFont FontForLabel];
//    self.xiugaimima.font = [UIFont FontForLabel];
    self.navigationItem.title = @"个人信息";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    //    [self setupTitle];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    
    
    self.navigationController.navigationBar.titleTextAttributes = dict;

    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    else
    {
[self setSubViews];
    }
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
            [self.model setValuesForKeysWithDictionary:dic[@"service"]];
            self.nickNameLabel.text = self.model.username;
            

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



- (void)setSubViews
{
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeicon:)];
    
    self.usericonImageView.userInteractionEnabled = YES;
    self.usericonImageView.layer.masksToBounds = YES;
    self.usericonImageView.layer.cornerRadius = self.usericonImageView.bounds.size.width/2;
    
    [self.usericonImageView addGestureRecognizer:gesture1];
    [self.changeIconView addGestureRecognizer:gesture1];
    self.usericonImageView.image = [UIImage imageWithData:self.imageData];
    self.phoneNumberLabel.text = self.phoneNumber;
//    self.nickNameLabel.text = self.nickNme;
    
    
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePassword:)];
    [self.changePasswordView addGestureRecognizer:gesture2];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNickName:)];
    [self.nickNameView addGestureRecognizer:gesture3];
    
}

- (void)changeNickName:(UITapGestureRecognizer *)gesture
{
    ChageNickNameController *changeVC = [[ChageNickNameController alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
    

}
- (void)changeicon:(UITapGestureRecognizer *)gesture
{
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
        
        
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"应用相机权限受限,请在设置中启用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            return;
        }
        else
        {
            [self presentViewController:PickerImage animated:YES completion:nil];
        }
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)changeUserPictuer
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *url1= getDataURL;
    NSString *url2 = @"/upload";
    NSString *URL = [[[[[url1 stringByAppendingString:url2]stringByAppendingString:@"?token="]stringByAppendingString:token]stringByAppendingString:@"&access_token="]stringByAppendingString:@"token"];
    NSLog(@"%@",URL);
    

    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:@"token" forKey:@"access_token"];
    NSData *imageData = UIImageJPEGRepresentation(self.usericonImageView.image, 1.0f);
 [self.manager POST:URL parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     [formData appendPartWithFileData:imageData name:@"UserPicture"fileName:@"image1.png" mimeType:@"image/jpg/png/jpeg"];
 } progress:^(NSProgress * _Nonnull uploadProgress) {
     
 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSLog(@"上传头像成功");
//     [NSUserDefaults standardUserDefaults] setObject:<#(nullable id)#> forKey:(nonnull NSString *)
     [self MBProgressWithString:@"修改成功" timer:1 mode:MBProgressHUDModeText];

} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    NSLog(@"上传头像失败");
//    [self MBProgressWithString:@"修改失败" timer:1 mode:MBProgressHUDModeText];

    NSLog(@"%@",error);
 }];
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.usericonImageView.image = newPhoto;
    
    self.usericonImageView.image = [newPhoto imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    [self changeUserPictuer];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)changePassword:(UITapGestureRecognizer *)gesture
{
    ChangeWordViewController *changeVC = [[ChangeWordViewController alloc]init];
//    FindwordController *findPasswordVC = [[UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil]instantiateViewControllerWithIdentifier:@"Findword"];
    [self.navigationController pushViewController:changeVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
