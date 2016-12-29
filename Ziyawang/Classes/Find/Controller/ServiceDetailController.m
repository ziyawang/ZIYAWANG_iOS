//
//  ServiceDetailController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/4.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ServiceDetailController.h"
#import "FindServiceModel.h"
#import "AFNetWorking.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginController.h"
#import "talkViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "LookupMyRushController.h"

#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"
#import "KNToast.h"
#import "TipTableViewController.h"
#import "StarIdentiDetailController.h"
@interface ServiceDetailController ()<MBProgressHUDDelegate>
{
    BOOL     _ApplicationStatusIsHidden;
    
}
@property (weak, nonatomic) IBOutlet UIView *bringView;
@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *usericon;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *projectNumber;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyInfo;
@property (weak, nonatomic) IBOutlet UILabel *servicearea;
@property (weak, nonatomic) IBOutlet UILabel *serviceType;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *PublishTime;
@property (weak, nonatomic) IBOutlet UILabel *ViewCount;

@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) FindServiceModel *model;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) NSString *phoneNumber;

@property (nonatomic,strong) NSString *CollectFlag;
@property (nonatomic,assign) BOOL isCollected;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UILabel *serviceLocation;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic,strong) NSMutableArray *imageurlArray;
@property (nonatomic, strong) NSMutableArray *actionSheetArray; // 右上角弹出框的 选项 -->代理回调
@property (nonatomic, strong) KNPhotoBrower *photoBrower;

@property (weak, nonatomic) IBOutlet UIImageView *vipima1;
@property (weak, nonatomic) IBOutlet UIImageView *vipima2;
@property (weak, nonatomic) IBOutlet UIImageView *vipima3;
@property (weak, nonatomic) IBOutlet UIImageView *vipima4;
@property (weak, nonatomic) IBOutlet UIImageView *vipima5;
@property (weak, nonatomic) IBOutlet UIImageView *starima1;
@property (weak, nonatomic) IBOutlet UIImageView *starima2;
@property (weak, nonatomic) IBOutlet UIImageView *starima3;
@property (weak, nonatomic) IBOutlet UIImageView *starima4;
@property (weak, nonatomic) IBOutlet UIImageView *starima5;

@property (weak, nonatomic) IBOutlet UILabel *guimoLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhucezijinLabel;
@property (weak, nonatomic) IBOutlet UILabel *lianxirenLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@property (nonatomic,strong) NSArray *starszArr;
@property (nonatomic,strong) NSArray *starsdArr;
@property (nonatomic,strong) NSDictionary *showlevelDic;


@end

@implementation ServiceDetailController

- (IBAction)lookDetailButtonAction:(id)sender {
    StarIdentiDetailController *starDetailVC = [[StarIdentiDetailController alloc]init];
    starDetailVC.VideoURL = self.model.starvideo;
    starDetailVC.promiseBookURL = self.model.starcns;
    starDetailVC.threeBookArr = self.starszArr;
    starDetailVC.areaArr = self.starsdArr;
    starDetailVC.sholevelDic = self.showlevelDic;
    [self.navigationController pushViewController:starDetailVC animated:YES];
    
}

- (IBAction)didClickSaveButton:(id)sender {
    
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
      NSString *Token = @"?token=";
    NSString *url =getDataURL;
    NSString *url2 = @"/collect";
    NSString *access_token = @"token";
    
    NSString *URL = [[[url stringByAppendingString:url2]stringByAppendingString:Token]stringByAppendingString:token];
    
        
        //    NSString *getURL = @"http://api.ziyawang.com/v1/service/list?access_token=token";
    NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
    [postdic setObject:access_token forKey:@"access_token"];
//    [postdic setObject:token forKey:@"token"];
    [postdic setObject:self.ServiceID forKey:@"itemID"];
    [postdic setObject:@"4" forKey:@"type"];
    if (self.isCollected == NO)
    {
        
        NSLog(@"未收藏过,改变button的状态,调用收藏接口");
        [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
         {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"收藏成功");
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"服务收藏返回的信息：%@",dic);
            NSLog(@"%@",dic[@"msg"]);
            
            [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
            [self MBProgressWithString:@"收藏成功" timer:1 mode:MBProgressHUDModeText];


            //收藏按钮状态改变
//            self.saveButton.imageView.image = [UIImage imageNamed:<#(nonnull NSString *)#>]
            self.isCollected = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            [self MBProgressWithString:@"收藏失败" timer:1 mode:MBProgressHUDModeText];

            NSLog(@"收藏失败");
        }];
    }
    else
    {
        [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
         {
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"取消收藏成功");
             [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
             [self MBProgressWithString:@"已取消收藏" timer:1 mode:MBProgressHUDModeText];

             //收藏按钮状态改变
             //            self.saveButton.imageView.image = [UIImage imageNamed:<#(nonnull NSString *)#>]
             self.isCollected = NO;
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             [self MBProgressWithString:@"取消收藏失败" timer:1 mode:MBProgressHUDModeText];
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alert show];
             NSLog(@"取消收藏失败");
         }];
    }
    }
}


- (IBAction)didClickShareButton:(id)sender {
    
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    self.model.ServiceID = [NSString stringWithFormat:@"%@",self.model.ServiceID];
    NSString *URL = [@"http://ziyawang.com/service/" stringByAppendingString:self.model.ServiceID];
    NSString *shareURL1 = @"http://ziyawang.com/project/";
    NSString *shareURL = [shareURL1 stringByAppendingString:self.model.ServiceID];
    UIImage *image = [UIImage imageNamed:@"morentouxiang.png"];
    
    NSArray *imageArray = @[image];
    NSString *str1 = self.model.ServiceName;
    NSString *str2 = self.model.ServiceIntroduction;
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:str2
                                     images:imageArray
                                        url:[NSURL URLWithString:shareURL]
                                      title:str1
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeSinaWeibo)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state)
                   {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }];
    

    
    
    
}


- (void)rightBarbuttonAction:(UIBarButtonItem *)UIBarButton
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }
    else
    {
    TipTableViewController *tipVc = [[TipTableViewController alloc]init];
    tipVc.Type = @"2";
    self.model.ServiceID = [NSString stringWithFormat:@"%@",self.model.ServiceID];
    tipVc.ItemID = self.model.ServiceID;
    
    [self.navigationController pushViewController:tipVc animated:YES];
    }
    
    
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
- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    self.navigationItem.title = @"服务详情";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"举报" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarbuttonAction:)];
    

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    self.sourceArray = [NSMutableArray array];
    self.manager = [AFHTTPSessionManager manager];
    self.model = [[FindServiceModel alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.role = [defaults objectForKey:@"role"];
    [self findServicesDetail];
    
}

//进入的时候判断有没有收藏过
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)findServicesDetail
{
    
    
    if (self.sourceArray != nil)
    {
        [self.sourceArray removeAllObjects];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *url = ServiceDetailURL;
//    NSString *str = @"&token=";
    
    NSString *getURL = [url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ServiceID]];
    if(token == nil)
    {
    getURL = [url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ServiceID]];
    }
    else
    {
//        getURL = [[[[[url stringByAppendingString:@"?token="]stringByAppendingString:token]stringByAppendingString:@"&access_token="]stringByAppendingString:@"token"]stringByAppendingString:[NSString stringWithFormat:@"%@",self.ServiceID]];
        //
        getURL = [[[[[url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ServiceID]]stringByAppendingString:@"?token="]stringByAppendingString:token]stringByAppendingString:@"&access_token="]stringByAppendingString:@"token"];
        }
//    NSString *getURL = @"http://api.ziyawang.com/v1/service/list?access_token=token";
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      
        NSLog(@"%@",dic);
        
        [self.model setValuesForKeysWithDictionary:dic];
        self.starsdArr = dic[@"starsd"];
        self.starszArr = dic[@"starsz"];

        NSArray *rightArr = dic[@"showrightios"];
        switch (rightArr.count) {
            case 0:
                [self.noLabel setHidden:NO];
                break;
            case 1:
                [self.noLabel setHidden:YES];
                self.vipima1.image = [UIImage imageNamed:rightArr[0]];
                break;
            case 2:
                [self.noLabel setHidden:YES];
                self.vipima1.image = [UIImage imageNamed:rightArr[0]];
                self.vipima2.image = [UIImage imageNamed:rightArr[1]];
                break;
            case 3:
                [self.noLabel setHidden:YES];
                self.vipima1.image = [UIImage imageNamed:rightArr[0]];
                self.vipima2.image = [UIImage imageNamed:rightArr[1]];
                self.vipima3.image = [UIImage imageNamed:rightArr[2]];
                break;
            case 4:
                [self.noLabel setHidden:YES];
                self.vipima1.image = [UIImage imageNamed:rightArr[0]];
                self.vipima2.image = [UIImage imageNamed:rightArr[1]];
                self.vipima3.image = [UIImage imageNamed:rightArr[2]];
                self.vipima4.image = [UIImage imageNamed:rightArr[3]];
                break;
            case 5:
                [self.noLabel setHidden:YES];
                self.vipima1.image = [UIImage imageNamed:rightArr[0]];
                self.vipima2.image = [UIImage imageNamed:rightArr[1]];
                self.vipima3.image = [UIImage imageNamed:rightArr[2]];
                self.vipima4.image = [UIImage imageNamed:rightArr[3]];
                self.vipima5.image = [UIImage imageNamed:rightArr[4]];
                break;
            default:
                break;
        }
        
        NSDictionary *starDic = dic[@"showlevelarr"];
        NSLog(@"%@",starDic);
        
        
        self.showlevelDic = starDic;
        
        NSMutableDictionary *starArray = [NSMutableDictionary dictionaryWithDictionary:starDic];
        
        starArray[@"1"] = [NSString stringWithFormat:@"%@",starArray[@"1"]];
        starArray[@"2"] = [NSString stringWithFormat:@"%@",starArray[@"2"]];
        starArray[@"3"] = [NSString stringWithFormat:@"%@",starArray[@"3"]];
        starArray[@"4"] = [NSString stringWithFormat:@"%@",starArray[@"4"]];
        starArray[@"5"] = [NSString stringWithFormat:@"%@",starArray[@"5"]];
        
        
        if ([starArray[@"1"] isEqualToString:@"2"]) {
            self.starima1.image = [UIImage imageNamed:@"baozhengjin"];
        }
        if ([starArray[@"2"] isEqualToString:@"2"]) {
            self.starima2.image = [UIImage imageNamed:@"shi"];
        }
        
        if ([starArray[@"3"] isEqualToString:@"2"]) {
            self.starima3.image = [UIImage imageNamed:@"shipin"];
        }
        if ([starArray[@"4"] isEqualToString:@"2"]) {
            self.starima4.image = [UIImage imageNamed:@"nuo"];
        }
        if ([starArray[@"5"] isEqualToString:@"2"]) {
            self.starima5.image = [UIImage imageNamed:@"zheng"];
        }
        [self layoutView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}



//图片的点击放大事件
- (void)tapImagViewWithGesture:(UITapGestureRecognizer *)gesture
{
    
    self.backView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backView];
    
    UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    //////////////////////////////////////////////
    UIImageView *imageView = (UIImageView *)gesture.view;
    bigImageView.image = imageView.image;
    [self.backView addSubview:bigImageView];
    bigImageView.userInteractionEnabled = YES;
    [self.backView addSubview:bigImageView];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBackView:)];
    [bigImageView addGestureRecognizer:tapgesture];
    
}
- (void)closeBackView:(UITapGestureRecognizer *)tapgesture
{
    [self.backView removeFromSuperview];
}

#pragma mark----查看图片手势方法以及代理
- (void)imageTapGestureAction:(UITapGestureRecognizer *)imageTapGesture
{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = self.itemsArray;
    photoBrower.currentIndex = imageTapGesture.view.tag;
    // 如果设置了 photoBrower中的 actionSheetArr 属性. 那么 isNeedRightTopBtn 就应该是默认 YES, 如果设置成NO, 这个actionSheetArr 属性就没有意义了
    //    photoBrower.actionSheetArr = [self.actionSheetArray mutableCopy];
    
    [photoBrower present];
    
    _photoBrower = photoBrower;
    
    // 设置代理方法 --->可不写
    [photoBrower setDelegate:self];
    
    // 这里是 设置 状态栏的 隐藏 ---> 可不写
    _ApplicationStatusIsHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}
// 下面方法 是让 '状态栏' 在 PhotoBrower 显示的时候 消失, 消失的时候 显示 ---> 根据项目需求而定
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    if(_ApplicationStatusIsHidden){
        return YES;
    }
    return NO;
}

/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss{
    NSLog(@"Will Dismiss");
    _ApplicationStatusIsHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
}


- (void)tapgesture1:(UITapGestureRecognizer *)gesture1
{
    if (self.imageView1.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture1];
      }
    
}
- (void)tapgesture2:(UITapGestureRecognizer *)gesture2
{
    if (self.imageView2.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture2];
        
        
    }}
- (void)tapgesture3:(UITapGestureRecognizer *)gesture3
{
    if (self.imageView3.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture3];
        
        
    }
}
- (void)layoutView
{
    
    self.PublishTime.text = self.model.created_at;
    
    
    self.ViewCount.text = [@"浏览" stringByAppendingString:self.model.ViewCount];
    
    [self layoutBottomViewWithUserType:self.role UserID:self.model.UserID];
    NSString *url = getImageURL;
    NSString *usericonurl = self.model.UserPicture;
    self.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
     //设置收藏按钮的状态
    if ([self.CollectFlag isEqualToString:@"0"]) {
        NSLog(@"未收藏过");
        self.isCollected = NO;
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    }
    else
    {
        NSLog(@"收藏过");
        self.isCollected = YES;
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];

    }
    
    if (usericonurl == nil) {
        self.usericon.image = [UIImage imageNamed:@"morentouxiang"];
    }
    else
    {
        
    [self.usericon sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:usericonurl]]];
        [self.usericon setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.usericon.contentMode = UIViewContentModeScaleAspectFill;
        self.usericon.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.usericon.clipsToBounds = YES;
        self.usericon.layer.masksToBounds = YES;
        self.usericon.layer.cornerRadius = self.usericon.bounds.size.height/2;
    }
    
    
    self.phoneNumber = self.model.ConnectPhone;
    self.typeName.text = self.model.ServiceType;
    self.projectNumber.text = self.model.ServiceNumber;
//    self.starImage = [UIImage imageNamed:<#(nonnull NSString *)#>]
    self.companyName.text = self.model.ServiceName;
    self.companyInfo.text = self.model.ServiceIntroduction;
    self.servicearea.text = self.model.ServiceArea;
    self.serviceType.text = self.model.ServiceType;
    self.serviceLocation.text = self.model.ServiceLocation;
    
    self.model.Size = [NSString stringWithFormat:@"%@",self.model.Size];
    self.model.Founds = [NSString stringWithFormat:@"%@",self.model.Founds];
    
    self.guimoLabel.text = [self.model.Size stringByAppendingString:@"人"];
    self.zhucezijinLabel.text = [self.model.Founds stringByAppendingString:@"万"];
    self.lianxirenLabel.text = self.model.ConnectPerson;
    
    if ([self.model.Founds isEqualToString:@"0"]) {
        self.zhucezijinLabel.text = @"未填写";
    }
    if ([self.model.Size isEqualToString:@"0"]) {
        self.guimoLabel.text =@"未填写";
    }
    
    
    
    
    
    
    NSString *imageURL1 = @"1";
    NSString *imageURL2 = @"2";
    NSString *imageURL3 = @"3";
    
    self.itemsArray = [NSMutableArray new];
    KNPhotoItems *items1 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items2 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items3 = [[KNPhotoItems alloc] init];
    if ([self.model.ConfirmationP1 isEqualToString:@""])
    {
        
    }
    else if([self.model.ConfirmationP1 isEqualToString:@""]==NO&&[self.model.ConfirmationP2 isEqualToString:@""]==NO&&[self.model.ConfirmationP3 isEqualToString:@""])
    {
        imageURL1 = [url stringByAppendingString:self.model.ConfirmationP1];
        imageURL2 = [url stringByAppendingString:self.model.ConfirmationP2];
        
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP1]]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP2]]];
        [self.imageurlArray addObject:imageURL1];
        [self.imageurlArray addObject:imageURL2];
        items1.url = imageURL1;
        items2.url = imageURL2;
        items1.sourceView = self.imageView1;
        items2.sourceView = self.imageView2;
        [self.itemsArray addObject:items1];
        [self.itemsArray addObject:items2];
        [self.imageView3 setHidden:YES];

    }
    else if([self.model.ConfirmationP1 isEqualToString:@""]==NO && [self.model.ConfirmationP2 isEqualToString:@""]&&[self.model.ConfirmationP3 isEqualToString:@""])
    {
        imageURL1 = [url stringByAppendingString:self.model.ConfirmationP1];
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP1]]];
        items1.url = imageURL1;
        items1.sourceView = self.imageView1;
        [self.itemsArray addObject:items1];
        [self.imageView2 setHidden:YES];
        [self.imageView3 setHidden:YES];

    }
    else
    {
        imageURL1 = [url stringByAppendingString:self.model.ConfirmationP1];
        imageURL2 = [url stringByAppendingString:self.model.ConfirmationP2];
        imageURL3 = [url stringByAppendingString:self.model.ConfirmationP3];
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP1]]];
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP2]]];
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:self.model.ConfirmationP3]]];
        items1.url = imageURL1;
        items2.url = imageURL2;
        items3.url = imageURL3;
        items1.sourceView = self.imageView1;
        items2.sourceView = self.imageView2;
        items3.sourceView = self.imageView3;
        
        [self.itemsArray addObject:items1];
        [self.itemsArray addObject:items2];
        [self.itemsArray addObject:items3];
        
    }
    
    self.imageView1.userInteractionEnabled = YES;
    self.imageView2.userInteractionEnabled = YES;
    self.imageView3.userInteractionEnabled = YES;
    
    self.imageView1.tag = 0;
    self.imageView2.tag = 1;
    self.imageView3.tag = 2;
    
    //给每个图片添加手势，放大图片查看
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    [self.imageView1 addGestureRecognizer:gesture1];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    [self.imageView2 addGestureRecognizer:gesture2];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    [self.imageView3 addGestureRecognizer:gesture3];
}

//判断用户类型显示下方视图
- (void)layoutBottomViewWithUserType:(NSString *)role UserID:(NSString *)UserID
{
    //    NSString *role = [NSString stringWithFormat:@"%@",Role];
    
//    if (role == nil||[role isEqualToString:@"1"])
//    {
//        //认证过的服务方和游客
//        [self layoutView1];
//    }
//    else if([role isEqualToString:@"0"])
//    {
//        //没认证过的
//        NSLog(@"登录但是没认证过的");
//    }
    self.userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID"];

 
    if([self.userID isEqualToString:UserID]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] !=nil)
    {
        NSLog(@"我自己");
        [self layoutView2];
    }
    else
    {
        [self layoutView1];
        
    }
    
}
- (void)layoutView1
{
    UIView *SomeOneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    SomeOneView.backgroundColor = [UIColor whiteColor];
//    UIButton *connectButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/2, 50);
//    [connectButton setTitle:@"联系方式" forState:(UIControlStateNormal)];
//    [connectButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(connectButton.bounds.size.width/2-50, 17, 20, 20)];
//    imageview3.image = [UIImage imageNamed:@"lianxifangshi"];
//    [connectButton addSubview:imageview3];
    UIButton *connectButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [connectButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/3, 50);
    //        [connectButton setTitle:@"联系方式" forState:(UIControlStateNormal)];
    UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    imageview3.image = [UIImage imageNamed:@"wodeyuetan"];
    //        [connectButton addSubview:imageview3];
    
    UILabel *connectLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 20)];
    connectLabel.font = [UIFont systemFontOfSize:14];
    connectLabel.text = @"约谈";
    UIView *connectView = [[UIView alloc]initWithFrame:CGRectMake(0, 17, 130, 20)];
    connectView.centerX = connectButton.centerX;
    [connectView addSubview:connectLabel];
    [connectView addSubview:imageview3];
    connectView.userInteractionEnabled = NO;
    
    [connectButton addSubview:connectView];
    
    
    
    
    
//    UIButton *talkButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    talkButton.frame = CGRectMake(connectButton.bounds.size.width, 0, SomeOneView.bounds.size.width/2, 50);
//    [talkButton setTitle:@"私聊" forState:(UIControlStateNormal)];
//    [talkButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    
////    [talkButton setBackgroundImage:[UIImage imageNamed:@"siliao2"] forState:(UIControlStateNormal)];
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(talkButton.bounds.size.width/2-38, 17, 20, 20)];
//    imageView.image = [UIImage imageNamed:@"siliao3"];
//    
    UIButton *talkButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    talkButton.frame = CGRectMake(connectButton.bounds.size.width*2, 0, connectButton.bounds.size.width, 50);
    //    [talkButton setTitle:@"私聊" forState:(UIControlStateNormal)];
    [talkButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [talkButton setBackgroundColor:[UIColor colorWithHexString:@"#fdd000"]];
    
    UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(35, 0, 20, 20)];
    imageview2.image = [UIImage imageNamed:@"siliao3"];
    
    UILabel *talkLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 15, 100, 20)];
    talkLabel.font = [UIFont systemFontOfSize:14];
    talkLabel.text = @"私聊";
    
    
    UILabel *connectLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 100, 20)];
    connectLabel2.font = [UIFont systemFontOfSize:14];
    connectLabel2.text = @"私聊";
    
    UIView *connectView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 17, 130, 20)];
    connectView2.centerX = connectButton.centerX;
    [connectView2 addSubview:connectLabel2];
    [connectView2 addSubview:imageview2];
    connectView2.userInteractionEnabled = NO;
    
    [talkButton addSubview:connectView2];

    
    
    
    connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/2, 50);
    talkButton.frame = CGRectMake(connectButton.bounds.size.width, 0, connectButton.bounds.size.width, 50);
    [imageview3 setFrame:CGRectMake(50, 0, 20, 20)];
    [imageview2 setFrame:CGRectMake(70, 0, 20, 20)];
    
    [connectLabel setFrame:CGRectMake(85, 0, 130, 20)];
    [connectLabel2 setFrame:CGRectMake(100, 0, 130, 20)];
    
    
//    [talkButton addSubview:imageview2];
    [talkButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [SomeOneView addSubview:talkButton];
    [SomeOneView addSubview:connectButton];
    //给按钮添加点击事件
    [connectButton addTarget:self action:@selector(connectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [talkButton addTarget:self action:@selector(talkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bringView addSubview:SomeOneView];
    //.................
    [self.backGroundView bringSubviewToFront:self.bringView];
}
- (void)layoutView2
{
    [self.saveButton setHidden:YES];
    
    [self.saveLabel setHidden:YES];
    UIView *selfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    selfView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    UIButton *lookButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    lookButton.frame = CGRectMake(0, 0, selfView.bounds.size.width, 50);
    [lookButton setTitle:@"我的约谈" forState:(UIControlStateNormal)];
    [lookButton addTarget:self action:@selector(lookbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [lookButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [selfView addSubview:lookButton];
    [self.bringView addSubview:selfView];
    [self.backGroundView bringSubviewToFront:self.bringView];
    
}
- (void)connectButtonAction:(UIButton *)button
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"] ==nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];

    }
    else
    {
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        NSString *URL = [[ServiceConnectCountURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"token" forKey:@"access_token"];
        [dic setObject:@"IOS" forKey:@"Channel"];
        [dic setObject:self.model.ServiceID forKey:@"ServiceID"];
        [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
        self.model.insider = [NSString stringWithFormat:@"%@",self.model.insider];
        
        if ([self.model.insider isEqualToString:@"1"]) {
            NSLog(@"调用打电话");
            UIWebView *webView = [[UIWebView alloc]init];
            NSString *telString = [@"tel:"stringByAppendingString:self.phoneNumber];
            NSURL *url = [NSURL URLWithString:telString];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该服务方未办理会员，无法查看其联系方式" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
            }
    
}

- (void)talkButtonAction:(UIButton *)button
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"] ==nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        talkViewController *talkVc = [[talkViewController alloc]init];
        talkVc.title = self.model.ServiceName;
        talkVc.targetId = [NSString stringWithFormat:@"%@",self.userid];
        talkVc.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:talkVc animated:YES];
    }
}
- (void)lookbuttonAction:(UIButton *)button
{
    LookupMyRushController *myrushVC = [[LookupMyRushController alloc]init];
    [self.navigationController pushViewController:myrushVC animated:YES];
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
