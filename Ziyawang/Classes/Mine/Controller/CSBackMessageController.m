//
//  CSBackMessageController.m
//  Ziyawang
//
//  Created by 崔丰帅 on 16/8/9.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CSBackMessageController.h"
#import "CSTextView.h"
#import "UIView+Extension.h"
#import "CSCancelOperationController.h"
#import "LoginController.h"
#import <AVFoundation/AVFoundation.h>

#define kWidthScale ([UIScreen mainScreen].bounds.size.width/414)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/736)

@interface CSBackMessageController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) CSTextView  *textView;

@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UILabel *addImageLabel;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation CSBackMessageController

#pragma mark - 懒加载

#pragma mark - 系统方法

- (void)viewWillAppear:(BOOL)animated
{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    // 自定义控件初始化
    [self setupSubViews];
    
    // 初始化数据模型
    [self initData];
}

#pragma mark - 初始化方法
/**
 *  自定义控件初始化
 */
- (void)setupSubViews {
    
//    [self setupTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"意见反馈";
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
    [self setupTextView];
    
    [self setupAddImageView];
    
    [self setupUploadButton];
}
/**
 *  初始化数据模型
 */
- (void)initData
{
    
    
}

#pragma mark - 事件监听方法
- (void)backButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  添加图片手势监听事件
 */
- (void)tapImageViewAddAction {
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
        PickerImage.allowsEditing = NO;
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
        PickerImage.allowsEditing = NO;
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
/**
 *  提交按钮监听事件
 *
 */
- (void)uploadBtnClickAction:(UIButton *)sender {
    if ([self.textView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写反馈信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        [self uplodMessage];
    
    }
    NSLog(@"点击反馈按钮提交信息");
}

- (void)uplodMessage
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
 
        
        
        if (token == nil)
        {
            LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
            [self presentViewController:loginVC animated:YES completion:nil];
            
            
        }
    else
    {
  
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.mode = MBProgressHUDModeIndeterminate;

        NSString *url = [[CommentAdviceURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.textView.text forKey:@"Content"];
    NSData *imageData = UIImageJPEGRepresentation(self.addImageView.image, 1.0f);

[self.manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if (self.addImageView.image != nil) {
          [formData appendPartWithFileData:imageData name:@"Picture"fileName:@"adviceImage.png" mimeType:@"image/jpg/png/jpeg"];
    }
} progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的意见已提交" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    NSLog(@"反馈信息提交错误：：：%@",error);
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息提交失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}];
    }
}


#pragma mark - 实现代理方法
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    _addImageLabel.hidden = YES;
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _addImageView.image = newPhoto;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 其他方法

- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
//    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"意见反馈";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)setupTextView {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 150 * kHeightScale);
    [self.view addSubview:backView];
    
    _textView = [[CSTextView alloc] init];
    _textView.frame = CGRectMake(10 * kWidthScale, 0, self.view.bounds.size.width - 20 *kWidthScale, 150 * kHeightScale);
    _textView.font = [UIFont FontForLabel];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.placeholder = @"亲：您遇到什么系统问题啦？或有什么功能建议吗？欢迎提给我们，谢谢 文字输入，且不超过100个字";
    _textView.font = [UIFont systemFontOfSize:18];
    _textView.placeholerColor = [UIColor lightGrayColor];
    [backView addSubview:_textView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, _textView.bounds.size.height + 1, self.view.bounds.size.width, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:lineView];
    
}

- (void)setupAddImageView {
    
    UIView *addImageBackView = [[UIView alloc] init];
    addImageBackView.frame = CGRectMake(0, _textView.bounds.size.height + 2, self.view.bounds.size.width, 120 * kHeightScale);
    addImageBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addImageBackView];
    
    _addImageView = [[UIImageView alloc] init];
    _addImageView.image = [UIImage imageNamed:@"tianjia"];
    _addImageView.frame = CGRectMake(10 * kWidthScale, 10 * kHeightScale, 100 * kWidthScale, 100 * kHeightScale);
    _addImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImageViewAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAddAction)];
    [_addImageView addGestureRecognizer:tapImageViewAdd];
    _addImageView.contentMode = UIViewContentModeScaleAspectFill;
    _addImageView.clipsToBounds = YES;
    [addImageBackView addSubview:_addImageView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, addImageBackView.bounds.size.height, self.view.bounds.size.width, 0.7);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [addImageBackView addSubview:lineView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"上传图片";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:236.0 / 255.0 green:206.0 / 255.0 blue:73.0 / 255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(0, 70 * kHeightScale, 100 * kWidthScale, 20 * kHeightScale);
    _addImageLabel = label;
    [_addImageView addSubview:label];
    
}

- (void)setupUploadButton {
    
    UIButton *uploadBtn = [[UIButton alloc] init];
    uploadBtn.frame = CGRectMake(20 , 300 * kHeightScale, self.view.width   - 40, 50);
//    uploadBtn.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:206.0 / 255.0 blue:83.0 / 255.0 alpha:1.0];
    [uploadBtn setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [uploadBtn setTitle:@"提交" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];
}


@end
