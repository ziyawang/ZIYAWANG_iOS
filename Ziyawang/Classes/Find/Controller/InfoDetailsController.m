//
//  InfoDetailsController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/30.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "InfoDetailsController.h"
#import "AFNetWorking.h"
#import "PublishModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginController.h"
#import "LookupRushPeopleController.h"
#import "talkViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "MyidentifiController.h"


#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"

#import "KNToast.h"

#import "UserInfoModel.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#import "HcdPopMenu.h"
#import "MyYabiController.h"
#import "RechargeController.h"


#define kWidthScale ([UIScreen mainScreen].bounds.size.width/375)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/667)

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface InfoDetailsController ()<MBProgressHUDDelegate,KNPhotoBrowerDelegate>
{
    BOOL     _ApplicationStatusIsHidden;

}
/**
 *  storyboard属性
 */
@property (weak, nonatomic) IBOutlet UIView *bringView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIButton *usericon;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UILabel *idNumLable;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLable;
@property (weak, nonatomic) IBOutlet UILabel *transMoneyLable;
@property (weak, nonatomic) IBOutlet UILabel *whereLable;
@property (weak, nonatomic) IBOutlet UILabel *fromLable;
@property (weak, nonatomic) IBOutlet UILabel *smallTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *infoDescribLable;
@property (weak, nonatomic) IBOutlet UIButton *viedioButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageview1;
@property (weak, nonatomic) IBOutlet UIImageView *imageview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qingdanHight;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *areaAndFromBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaBackViewHight;
@property (weak, nonatomic) IBOutlet UILabel *PublishtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ViewCount;
@property (weak, nonatomic) IBOutlet UILabel *shoucangLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *beizhuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beizhuViewHight;
@property (weak, nonatomic) IBOutlet UIView *topToBeizhuVeiw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toptobeizhuView;
@property (weak, nonatomic) IBOutlet UIImageView *PublisherImage;

/**
 *  storyboard每一个label
 */
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *label9;
@property (weak, nonatomic) IBOutlet UILabel *label10;
@property (weak, nonatomic) IBOutlet UILabel *label11;
@property (weak, nonatomic) IBOutlet UILabel *label12;


/**
 *  自定义属性
 */
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *applyButton;

@property (nonatomic,strong) NSString *userID;


@property (nonatomic,assign) BOOL isCollected;
@property (nonatomic,strong) NSString *CollectFlag;
@property (nonatomic,strong) NSString *RushFlag;

@property (nonatomic,strong) NSMutableDictionary *sourceDic;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) PublishModel *model;

@property (nonatomic,strong) PublishModel *playModel;

@property (nonatomic,strong) UserInfoModel *userModel;


@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) NSString *VideoDes;
@property (nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic,assign) BOOL isZichan;

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic,strong) NSMutableArray *imageurlArray;
@property (nonatomic, strong) NSMutableArray *actionSheetArray; // 右上角弹出框的 选项 -->代理回调
@property (nonatomic, strong) KNPhotoBrower *photoBrower;
@property (nonatomic,strong) HcdPopMenuView *menu;
@property (nonatomic,strong) UIButton *connectButton;
@property (nonatomic,strong) UILabel *connectLabel;
@property (nonatomic,strong) UIImageView *imageView3;


/**
 *  清单下载View
 */
@property (weak, nonatomic) IBOutlet UIView *qingdanDownLoadView;

@property (nonatomic,strong) CTCallCenter *callcenter;


@property (nonatomic,strong) UIView *alertView1;
@property (nonatomic,strong) UIView *alertView2;
@property (nonatomic,strong) UIView *blackBackView1;
@property (nonatomic,strong) UIView *blackBackView2;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *AccountLabel1;
@property (nonatomic,strong) UILabel *AccountLabel2;
@property (nonatomic,strong) UILabel *buzuLabel;


@end

@implementation InfoDetailsController



#pragma mark----视图周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(145, 17, 40, 9.5)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.textAlignment = UITextAlignmentCenter;
    label.centerX = self.view.bounds.size.width/2;
    
    label.text = @"";
    label.textColor = [UIColor blackColor];
    self.titleImageView.image = [UIImage imageNamed:@"vipziyuan"];
    [label addSubview:self.titleImageView];
    self.label = label;
    [self.navigationController.navigationBar addSubview:self.label];
    
    
    self.navigationItem.title = self.typeName;
    
    
    /**
     *  iOS7之后导航栏问题
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]==nil) {
        [self.collectButton setHidden:NO];
        [self.shoucangLabel setHidden:NO];
    }
   else if ([self.role isEqualToString:@"0"]||[self.role isEqualToString:@"2"]) {
        [self.collectButton setHidden:YES];
        [self.shoucangLabel setHidden:YES];
       
    }
    
   
    [self setController];
   
   
    }


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
[self.label removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [self setController];
    
    
//    [self setController];
    /**
     *  初始化视图
     */
//    self.navigationItem.title = self.typeName;
    self.userModel = [[UserInfoModel alloc]init];
        [self getUserInfoFromDomin];

    
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
  
    
    
//    self.navigationItem.titleView = label;
//    [titleView addSubview:self.titleImageView];
//    [titleView addSubview:label];
//    self.navigationItem.titleView = titleView;
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    self.isPlaying = NO;
    self.playModel = [[PublishModel alloc]init];
    self.role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    if ([self.typeName isEqualToString:@"商业保理"]||[self.typeName isEqualToString:@"尽职调查"]||[self.typeName isEqualToString:@"法律服务"]||[self.typeName isEqualToString:@"悬赏信息"]) {
        self.areaBackViewHight.constant = 1;
//        self.areaAndFromBackView.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self ifHiddenQingdanView];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_left_jt"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor lightGrayColor];
    
    __weak typeof(self) weakSelf = self;
    
    self.callcenter = [[CTCallCenter alloc] init];
    self.callcenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"挂断了电话咯Call has been disconnected");
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"电话通了Call has just been connected");
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"来电话了Call is incoming");
            
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            NSLog(@"正在播出电话call is dialing");
//            [weakSelf payForMessage];
            }
        else
        {
            NSLog(@"嘛都没做Nothing is done");
        }
    };
    
}



#pragma mark----初始化
/**
 *  初始化请求，设置视图展示
 */
- (void)setController
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.sourceDic = [NSMutableDictionary dictionary];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.model = [[PublishModel alloc]init];
    self.role = [defaults objectForKey:@"role"];
    self.userID = [defaults objectForKey:@"UserID"];
    [self getData];
    
}



/**
 *  判断是否隐藏清单下载
 */
- (void)ifHiddenQingdanView
{
    if ([self.typeName isEqualToString:@"资产包转让"]) {
        [self.qingdanDownLoadView setHidden:NO];
        self.qingdanHight.constant = 50;
    }
    else
    {
        [self.qingdanDownLoadView setHidden:YES];
        
    }
}

#pragma mark----网络请求获取详情数据
/**
 *  网络请求获取详情数据
 */

- (void)getData
{
    //http://api.ziyawang.com/v1/project/list/5?&access_token=token
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    NSString *url = InformationDetailURL;
    //    NSString *accesstoken = @"?&access_token=token";
    NSLog(@"!!!!!!!!!!!!!!!!%@",self.ProjectID);
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ProjectID]]stringByAppendingString:@"?access_token=token"];
    if(token == nil)
    {
        URL = [[url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ProjectID]]stringByAppendingString:@"?access_token=token"];
    }
    else{
        URL = [[[[url stringByAppendingString:[NSString stringWithFormat:@"%@",self.ProjectID]]stringByAppendingString:@"?access_token=token"]stringByAppendingString:@"&token="]stringByAppendingString:token];
    }
    NSString *getURL = URL;
    //    NSString *gfetURL = @"http://api.ziyawang.com/v1/project/list/5?&access_token=token";
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
    //    [getdic setObject:token forKey:@"token"];
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self.model setValuesForKeysWithDictionary:dic];
        NSLog(@"%@",dic);
        
        //        weakSelf.role = dic[@"role"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            weakSelf.typeLable.text = weakSelf.model.TypeName;
            //            weakSelf.phoneNumber = weakSelf.model.PhoneNumber;
            //
            //            //        weakSelf.idNumLable.text = [NSString stringWithFormat:@"%@",weakSelf.model.ProjectID];
            //
            //            weakSelf.idNumLable.text = weakSelf.model.ProjectNumber;
            self.typeName = self.model.TypeName;
            self.VideoDes = self.model.VoiceDes;
            self.AccountLabel1.text = self.model.Account;
            self.AccountLabel2.text = self.model.Account;
            
            if (self.model.Account.integerValue > self.model.Price.integerValue || self.model.Account.integerValue == self.model.Price.integerValue) {
                self.buzuLabel.text = @"";
                
            }
            //            if ([weakSelf.model.CollectFlag isEqualToString:@"0"]) {
            //                [weakSelf.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
            //            }
            //            else
            //            {
            //
            //            }
            
            weakSelf.RushFlag =  [NSString stringWithFormat:@"%@",weakSelf.model.RushFlag];
            NSLog(@"!!!!!!!!!!!!!!!!!!!!!!%@",weakSelf.RushFlag);
            //            self.model.ProArea = [self.model.ProArea substringToIndex:2];
            [weakSelf layoutSubview];
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    
        NSLog(@"请求失败：%@",error);
    }];
    
    
}


#pragma mark----播放按钮点击事件
/**
 *  播放按钮点击事件
 *
 *  @param sender 播放按钮
 */

- (IBAction)videoButtonAction:(id)sender {
    
    NSString *url = AudioURL;
    NSLog(@"333######################%@",self.VideoDes);
    if ([self.VideoDes isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该条信息没有语音描述" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        NSString *playURL = [url stringByAppendingString:self.VideoDes];
        self.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:playURL]];
        [self.player play];
        
        /**
         *  判断是否正在播放，点击暂停
         *
         *  @param self.isPlaying YES正在播放
         *
         *  @return NO
         */
        //    if (self.isPlaying == NO) {
        //        [self.player play];
        //        self.isPlaying =YES;
        //    }
        //    if (self.isPlaying == YES) {
        //        [self.player pause];
        //        self.isPlaying = NO;
        //    }
        //
        //        NSURL *url = [[NSURL alloc]initWithString:playURL];
        //        NSData * audioData = [NSData dataWithContentsOfURL:url];
        //
        //        //将数据保存到本地指定位置
        //        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //        NSString *filePath = [NSString stringWithFormat:@"%@/%@.amr", docDirPath , @"temp"];
        //        [audioData writeToFile:filePath atomically:YES];
        //        //播放本地音乐
        //        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        //      AVAudioPlayer  *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        //        [player play];
        
    }
}

/**
 *  pop
 *
 *  @param barbutton leftBarbutton
 */
- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark----设置展示视图，根据不同用户类型设置需要展示的视图
/**
 *  设置所有视图
 */
- (void)layoutSubview
{
    self.PublishtimeLabel.font = [UIFont systemFontOfSize:10];
    self.ViewCount.font = [UIFont systemFontOfSize:10];
//    NSString *htmlString = self.model.CompanyDesPC;
//    NSAttributedString * attrStr =  [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    
//    self.companyInfoLabel.attributedText = attrStr;
    self.companyInfoLabel.text = self.model.CompanyDes;
    
    self.typeLable.text = self.model.TypeName;
    self.idNumLable.text = self.model.ProjectNumber;
    
    
    NSLog(@"@@@@@@@@@@@@@@FBiD：%@",self.model.ProjectNumber);
    self.infoDescribLable.text = self.model.WordDes;
    
    
    
    
    
    self.model.Publisher = [NSString stringWithFormat:@"%@",self.model.Publisher];
    
    if ([self.model.Publisher isEqualToString:@"0"])
    {
        [self.PublisherImage setHidden:YES];
        
    }
    
    if ([self.model.Member isEqualToString:@"2"] == NO) {
        self.beizhuViewHight.constant = 0;
        self.toptobeizhuView.constant = 0;
    }
    self.PublishtimeLabel.text = self.model.PublishTime;
//    self.ViewCount.text = [NSString stringWithFormat:@"%@",self.model.ViewCount];
    self.ViewCount.text = [@"浏览"stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.ViewCount]];
    
    if ([self.VideoDes isEqualToString:@""]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 20)];
        label.text = @"无语音";
        label.font = [UIFont FontForBigLabel];
        
        label.textColor = [UIColor lightGrayColor];
        [self.viedioButton addSubview:label];
        
//        [self.viedioButton setTitle:@"无语音" forState:(UIControlStateNormal)];
//        [self.viedioButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [self.viedioButton setBackgroundImage:[UIImage new] forState:(UIControlStateNormal)];
    }
    else
    {
//        [self.viedioButton setTitle:@"播放" forState:(UIControlStateNormal)];
//        [self.viedioButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    }
    /**
     *  会员，收费，普通image
     */
    self.model.Member = [NSString stringWithFormat:@"%@",self.model.Member];

    if ([self.model.Member isEqualToString:@"0"]) {
        [self.titleImageView setHidden:YES];
        
    }
    else if([self.model.Member isEqualToString:@"1"])
    {
        [self.titleImageView setHidden:NO];
        self.titleImageView.image = [UIImage imageNamed:@"vipziyuan"];
    }
    else if([self.model.Member isEqualToString:@"2"])
    {
         [self.titleImageView setHidden:NO];
        self.titleImageView.image = [UIImage imageNamed:@"shoufeiziyuan"];
        
    }
    
    
    
    [self layoutBottomViewWithUserType:self.role UserID:self.userid];
    
    self.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
    //设置收藏按钮的状态
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    
    /////////////////
    
    if ([self.CollectFlag isEqualToString:@"0"]) {
        NSLog(@"未收藏过");
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
        self.isCollected = NO;
        
    }
    else
    {
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang.png"] forState:(UIControlStateNormal)];
        NSLog(@"收藏过");
        self.isCollected = YES;
    }
    NSString *url = getImageURL;
    UIImageView *usericonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [usericonImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    usericonImage.contentMode = UIViewContentModeScaleAspectFill;
    usericonImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    usericonImage.clipsToBounds = YES;
    
    usericonImage.layer.masksToBounds = YES;
    usericonImage.layer.cornerRadius = 30;
    if (self.model.UserPicture == nil) {
        NSLog(@"用户没有上传头像");
    }
    else
    {
        NSString *usericonurl = self.model.UserPicture;
        [self.usericon addSubview:usericonImage];
        [usericonImage sd_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:usericonurl]]];
    }
    self.userID = self.model.UserID;
    
  
    
    NSString *imageURL1 = @"1";
    NSString *imageURL2 = @"2";
    NSString *imageURL3 = @"3";
    
    /**
     *  添加图片地址到数组中
     */
    self.imageurlArray = [NSMutableArray new];
    self.itemsArray = [NSMutableArray new];
//    [self.imageurlArray addObject:self.model.PictureDes1];
//    [self.imageurlArray addObject:self.model.PictureDes2];
//    [self.imageurlArray addObject:self.model.PictureDes3];
    
    
    self.phoneNumber = self.model.PhoneNumber;
    
    
    
    KNPhotoItems *items1 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items2 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items3 = [[KNPhotoItems alloc] init];

    if ([self.model.PictureDes1 isEqualToString:@""])
    {
        [self.imageview1 setHidden:YES];
        [self.imageview2 setHidden:YES];
        [self.imageview3 setHidden:YES];
    }
    else if([self.model.PictureDes1 isEqualToString:@""]==NO&&[self.model.PictureDes2 isEqualToString:@""]==NO&&[self.model.PictureDes3 isEqualToString:@""])
    {
        imageURL1 = [url stringByAppendingString:self.model.PictureDes1];
        imageURL2 = [url stringByAppendingString:self.model.PictureDes2];
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:imageURL1]];
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:imageURL2]];
        [self.imageurlArray addObject:imageURL1];
        [self.imageurlArray addObject:imageURL2];
        items1.url = imageURL1;
        items2.url = imageURL2;
        items1.sourceView = self.imageview1;
        items2.sourceView = self.imageview2;
        [self.itemsArray addObject:items1];
        [self.itemsArray addObject:items2];
        [self.imageview3 setHidden:YES];
        
        }
    else if([self.model.PictureDes1 isEqualToString:@""]==NO && [self.model.PictureDes2 isEqualToString:@""]&&[self.model.PictureDes3 isEqualToString:@""])
    {
        imageURL1 = [url stringByAppendingString:self.model.PictureDes1];
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:imageURL1]];
         [self.imageurlArray addObject:imageURL1];
        items1.url = imageURL1;
        items1.sourceView = self.imageview1;
        [self.itemsArray addObject:items1];
        [self.imageview2 setHidden:YES];
        [self.imageview3 setHidden:YES];
        
    }
    else
    {
        imageURL1 = [url stringByAppendingString:self.model.PictureDes1];
        imageURL2 = [url stringByAppendingString:self.model.PictureDes2];
        imageURL3 = [url stringByAppendingString:self.model.PictureDes3];
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:imageURL1]];
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:imageURL2]];
        [self.imageview3 sd_setImageWithURL:[NSURL URLWithString:imageURL3]];
        [self.imageurlArray addObject:imageURL1];
        [self.imageurlArray addObject:imageURL2];
        [self.imageurlArray addObject:imageURL3];
        items1.url = imageURL1;
        items2.url = imageURL2;
        items3.url = imageURL3;
        items1.sourceView = self.imageview1;
        items2.sourceView = self.imageview2;
        items3.sourceView = self.imageview3;
        
        [self.itemsArray addObject:items1];
        [self.itemsArray addObject:items2];
        [self.itemsArray addObject:items3];
        
    }
    
    
    self.imageview1.userInteractionEnabled = YES;
    self.imageview2.userInteractionEnabled = YES;
    self.imageview3.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *ImageTapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
     UITapGestureRecognizer *ImageTapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
     UITapGestureRecognizer *ImageTapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    self.imageview1.tag = 0;
    self.imageview2.tag = 1;
    self.imageview3.tag = 2;
    
    [self.imageview1 addGestureRecognizer:ImageTapGesture1];
    [self.imageview2 addGestureRecognizer:ImageTapGesture2];
    [self.imageview3 addGestureRecognizer:ImageTapGesture3];
//    [self.imageview2 addGestureRecognizer:ImageTapGesture];
//    [self.imageview3 addGestureRecognizer:ImageTapGesture];

    
    //给每个图片添加手势，放大图片查看
//    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture1:)];
//    [self.imageview1 addGestureRecognizer:gesture1];
//    
//    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture2:)];
//    [self.imageview2 addGestureRecognizer:gesture2];
//    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture3:)];
//    [self.imageview3 addGestureRecognizer:gesture3];
    
    NSLog(@"________________图片%@",self.imageview1.image);
    self.model.TotalMoney = [NSString stringWithFormat:@"%@",self.model.TotalMoney];
    self.model.TransferMoney = [NSString stringWithFormat:@"%@",self.model.TransferMoney];
    if ([self.typeName isEqualToString:@"资产包转让"]) {
        self.label8.text = self.model.ProArea;
        self.label10.text = self.model.FromWhere;
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label4.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.label12.text = self.model.AssetType;
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        
    }
    else if([self.typeName isEqualToString:@"委外催收"])
    {
        self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        self.label3.text = @"佣金比例：";
        self.label4.text = self.model.Rate;
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        self.label7.text = @"状态：";
        self.label8.text = self.model.Status;
        self.label9.text = @"债务人所在地：";
        self.label10.text = self.model.ProArea;
        self.label11.text = @"类型：";
        self.label12.text = self.model.AssetType;
        
        
    }
    else if([self.typeName isEqualToString:@"债权转让"])
    {
        self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        self.label4.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        self.label7.text = @"类型：";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区：";
        self.label10.text = self.model.ProArea;
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
    }
    else if([self.typeName isEqualToString:@"固产转让"])
    {
        self.label1.text = @"转让价：";
        self.label2.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        self.label7.text = @"标的物：";
        self.label8.text = self.model.Corpore;
        [self.label7 setHidden:NO];
        [self.label8 setHidden:NO];
        
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
        
    }
    else if([self.typeName isEqualToString:@"商业保理"])
    {
        self.label1.text = @"合同金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"买方性质：";
        self.label12.text = self.model.BuyerNature;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        self.label11.text = @"买方性质：";
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"典当担保"])
    {
        self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    //    else if([self.typeName isEqualToString:@"担保信息"])
    //    {
    //        self.label1.text = @"金额：";
    //        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
    //        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
    //
    //        self.label3.text = @"地区：";
    //        self.label4.text = self.model.ProArea;
    //        self.label5.text = @"类型：";
    //        self.label12.text = self.model.AssetType;
    //        [self.label7 setHidden:YES];
    //        [self.label8 setHidden:YES];
    //        [self.label9 setHidden:YES];
    //        [self.label10 setHidden:YES];
    //        [self.label11 setHidden:YES];
    //        [self.label12 setHidden:YES];
    //    }
    else if([self.typeName isEqualToString:@"融资需求"])
    {
        self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        self.label3.text = @"回报率：";
        self.label4.text = [self.model.Rate stringByAppendingString:@"%"];
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        
        self.label7.text = @"方式：";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区：";
        self.label10.text = self.model.ProArea;
        
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
    }
    else if([self.typeName isEqualToString:@"悬赏信息"])
    {
        self.label1.text = @"金额：";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"元"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        self.label3.text = @"目标地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"尽职调查"])
    {
        self.label1.text = @"被调查方：";
        self.label2.text = self.model.Informant;
        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"法律服务"])
    {
        self.label1.text = @"需求：";
        self.label2.text = self.model.Requirement;
        self.label3.text = @"地区：";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型：";
        self.label12.text = self.model.AssetType;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"资产求购"])
    {
        self.label1.text = @"求购方：";
        self.label2.text = self.model.Buyer;
        [self.label3 setHidden:YES];
        [self.label4 setHidden:YES];
        
        [self.label5 setHidden:YES];
        [self.label12 setHidden:YES];
        self.label7.text = @"类型：";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区：";
        self.label10.text = self.model.ProArea;
        
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
    }
    else if([self.typeName isEqualToString:@"投资需求"])
    {
    self.label1.text = @"回报率：";
        self.label2.text = [self.model.Rate stringByAppendingString:@"%"];
        self.label3.text = @"投资期限：";
        self.label4.text = [self.model.Year stringByAppendingString:@"年"];
        self.label7.text = @"投资方式：";
        self.label8.text = self.model.investType;
        self.label11.text = @"投资类型：";
        self.label12.text = self.model.AssetType;
        [self.label9 setHidden:NO];
        
        self.label9.text = @"投资地区：";
        self.label10.text = self.model.ProArea;
        
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
//        [self.label9 setHidden:YES];
    }
}

/**
 *  判断用户类型显示不同视图
 *
 *  @param role   用户类型
 *  @param UserID 用户UserID
 */
- (void)layoutBottomViewWithUserType:(NSString *)role UserID:(NSString *)UserID
{
    //    NSString *role = [NSString stringWithFormat:@"%@",Role];
    
    self.userID = [NSString stringWithFormat:@"%@",self.userID];
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"] ==nil) {
//        [self layoutView1];
//        
//    }
    
    if([self.userID isEqualToString:UserID]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] !=nil)
    {
        [self.collectButton setHidden:YES];
        [self.shoucangLabel setHidden:YES];
        
        NSLog(@"我自己");
        [self layoutView2];
        return;
    }
    else
    {
        //认证过的服务方和游客
        [self layoutView1];
    }
    
  }

/**
 *  认证过的服务方或游客视图
 */

- (void)layoutView1
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]==nil)
    {
        [self.collectButton setHidden:NO];
        [self.shoucangLabel setHidden:NO];
    }
    else if ([self.role isEqualToString:@"0"]||[self.role isEqualToString:@"2"])
    {
        [self.collectButton setHidden:YES];
        [self.shoucangLabel setHidden:YES];
    }
    
    if ([self.typeName isEqualToString:@"资产求购"]||[self.typeName isEqualToString:@"投资需求"])
    {
        self.isZichan = YES;
        [self.collectButton setHidden:NO];
    }
    
    /**
     初始化放两个按钮的View
     */
    UIView *SomeOneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    SomeOneView.backgroundColor = [UIColor whiteColor];
    
    /**
     *  联系方式按钮
     *
     *  @param UIButtonTypeSystem UIButtonTypeSystem description
     *
     *  @return return value description
     */
        UIButton *connectButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [connectButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/2, 50);
//        [connectButton setTitle:@"联系方式" forState:(UIControlStateNormal)];
        UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 20, 20)];
        imageview3.image = [UIImage imageNamed:@"wodeyuetan"];
    
//        [connectButton addSubview:imageview3];
    
    UILabel *connectLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, 20)];
     [imageview3 setFrame:CGRectMake(30, 0, 20, 20)];
     [connectLabel setFrame:CGRectMake(60, 0, 100, 20)];
    connectLabel.font = [UIFont systemFontOfSize:14];
  
    self.model.PayFlag = [NSString stringWithFormat:@"%@",self.model.PayFlag];
    
    if ([self.model.PayFlag isEqualToString:@"1"]) {
      connectLabel.text = @"已约谈";
        [connectLabel setFrame:CGRectMake(55, 0, 100, 20)];
        [imageview3 setFrame:CGRectMake(25, 0, 20, 20)];
        
    }
    else if([self.model.PayFlag isEqualToString:@"0"])
    {
    connectLabel.text = @"约谈";
        
    }
    if (self.isZichan == YES)
    {
        connectLabel.text = @"联系方式";
        [connectLabel setFrame:CGRectMake(50, 0, 100, 20)];
        [imageview3 setFrame:CGRectMake(20, 0, 20, 20)];
    }
    self.imageView3 = imageview3;
    self.connectLabel = connectLabel;
    
    UIView *connectView = [[UIView alloc]initWithFrame:CGRectMake(0, 17, 130, 20)];
    connectView.centerX = connectButton.centerX;
    [connectView addSubview:self.connectLabel];
    [connectView addSubview:self.imageView3];
    
    
    
    
    connectView.userInteractionEnabled = NO;
    
//    [connectButton addSubview:connectLabel];
//    [connectButton addSubview:imageview3];
    [connectButton addSubview:connectView];
    self.connectButton = connectButton;
  
    
    /**
     *  申请抢单按钮
     *
     *  @param UIButtonTypeSystem UIButtonTypeSystem description
     *
     *  @return return value description
     */
//    UIButton *applyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    [applyButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    applyButton.frame = CGRectMake(connectButton.bounds.size.width, 0, SomeOneView.bounds.size.width/3, 50);
//    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
//    imageview1.image = [UIImage imageNamed:@"shenqing_black"];
//    [applyButton setBackgroundColor:[UIColor colorWithHexString:@"#ea6155"]];
////    [applyButton addSubview:imageview1];
//    
//    UILabel *connectLabe = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 20)];
//    connectLabe.font = [UIFont systemFontOfSize:14];
//    connectLabe.text = @"申请抢单";
//    UIView *connectVie = [[UIView alloc]initWithFrame:CGRectMake(0, 17, 130, 20)];
//    connectVie.centerX = connectButton.centerX;
//    [connectVie addSubview:connectLabe];
//    [connectVie addSubview:imageview1];
//    //    [connectButton addSubview:connectLabel];
//    //    [connectButton addSubview:imageview3];
//    connectVie.userInteractionEnabled = NO;
//    
//    [applyButton addSubview:connectVie];
//    if ([self.RushFlag isEqualToString:@"1"]) {
//        [applyButton setTitle:@"已抢单" forState:(UIControlStateNormal)];
//        [applyButton  setEnabled:NO];
//    }
//    else
//    {
////        UILabel *rushLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, 100, 20)];
////        rushLabel.font = [UIFont systemFontOfSize:14];
////        rushLabel.text = @"申请抢单";
////        UIView *rushView = [[UIView alloc]initWithFrame:CGRectMake(0, 17, 130, 20)];
////        rushView.centerX = SomeOneView.centerX;
////        [rushView addSubview:rushLabel];
////        [rushView addSubview:imageview1];
////        
////        [applyButton addSubview:rushView];
//        
//     
////        [applyButton setTitle:@"申请抢单" forState:(UIControlStateNormal)];
//        [applyButton setEnabled:YES];
//    }

    /**
     *  私聊按钮
     *
     *  @param UIButtonTypeSystem UIButtonTypeSystem description
     *
     *  @return return value description
     */
    UIButton *talkButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    talkButton.frame = CGRectMake(SomeOneView.bounds.size.width/2, 0, connectButton.bounds.size.width, 50);
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
    connectView2.centerX = talkButton.frame.size.width/3;
    [connectView2 addSubview:connectLabel2];
    [connectView2 addSubview:imageview2];
    connectView2.userInteractionEnabled = NO;
    
    [talkButton addSubview:connectView2];
    

    
    
    //    [connectButton addSubview:connectLabel];
    //    [connectButton addSubview:imageview3];
//    //        [applyButton setTitle:@"申请抢单" forState:(UIControlStateNormal)];
//    [talkButton addSubview:talkLabel];
//    
//    [talkButton addSubview:imageview2];
    
    
    
//    if (self.isZichan == YES) {
        connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/2, 50);
//        [applyButton setHidden:YES];
        talkButton.frame = CGRectMake(connectButton.bounds.size.width, 0, connectButton.bounds.size.width, 50);
    
        [imageview2 setFrame:CGRectMake(70, 0, 20, 20)];
    
        [connectLabel2 setFrame:CGRectMake(100, 0, 130, 20)];
        
        
//    }
    [SomeOneView addSubview:connectButton];
//    [SomeOneView addSubview:applyButton];
    [SomeOneView addSubview:talkButton];
    /**
     *  添加按钮点击事件
     *
     *  @param connectButtonAction: 按钮点击事件
     *
     *  @return return value description
     */
    [connectButton addTarget:self action:@selector(connectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [talkButton addTarget:self action:@selector(talkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    self.applyButton = applyButton;
//    [self.applyButton isFirstResponder];
//    [connectButton isFirstResponder];
//    [talkButton isFirstResponder];
    [self.bringView addSubview:SomeOneView];
    
    
    
    
    //.................
    [self.backGroundView bringSubviewToFront:self.bringView];
    
}

/**
 *  登录但是没有认证过的（发布方）
 */
    
- (void)layoutView2
{
    
    [self.collectButton setHidden:YES];
    UIView *selfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    selfView.backgroundColor = [UIColor whiteColor];
    //    selfView.backgroundColor = [UIColor grayColor];
    UIButton *lookButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    lookButton.frame = CGRectMake(0, 0, selfView.bounds.size.width, 50);
    
//    [lookButton setTitle:@"查看约谈人" forState:(UIControlStateNormal)];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
    imageview.centerX = lookButton.bounds.size.width/2 - 45;
    imageview.image = [UIImage imageNamed:@"fangdajing"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 150, 20)];
    label.centerX = lookButton.bounds.size.width/2 +55;
    
    label.text = @"查看约谈人";
    label.textColor = [UIColor whiteColor];
    [lookButton addSubview:imageview];
    [lookButton addSubview:label];
    
    
    [lookButton addTarget:self action:@selector(lookbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    lookButton.backgroundColor = [UIColor colorWithHexString:@"#ea6155"];
    [lookButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];     [selfView addSubview:lookButton];
    [self.bringView addSubview:selfView];
    [self.backGroundView bringSubviewToFront:self.bringView];
}


#pragma mark----私聊、联系、申请抢单、查看抢单人、收藏、分享按钮点击事件

/**
 *  打电话
 *
 *  @param button 打电话按钮
 */
- (void)connectButtonAction:(UIButton *)button
{
    
  
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    if (token == nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else if([self.role isEqualToString:@"1"])
    {
      
        self.model.PayFlag = [NSString stringWithFormat:@"%@",self.model.PayFlag];
        
        if ([self.model.PayFlag isEqualToString:@"1"] || self.isZichan == YES) {
            UIWebView *webView = [[UIWebView alloc]init];
            NSString *telString = [@"tel:"stringByAppendingString:self.phoneNumber];
            NSURL *url = [NSURL URLWithString:telString];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];
            NSLog(@"认证过的服务方，调用打电话");
            
       
        }
       else
       {
           
           self.model.Member  = [NSString stringWithFormat:@"%@",self.model.Member];
           
           if ([self.model.Member isEqualToString:@"2"]) {
               
//               self.AccountLabel1.text = self.model.Account;
//               NSString *str = self.AccountLabel1.text;
//               
//               [self.alertView1 addSubview:self.AccountLabel1];
//               [self.view addSubview:self.blackBackView1];
//               [self.view addSubview:self.alertView1];
                [self createViewForLessMoney];
           }
           
          else
          {
//              self.AccountLabel2.text = self.model.Account;
//              [self.alertView2 addSubview:self.AccountLabel2];
//              [self.view addSubview:self.blackBackView2];
//              [self.view addSubview:self.alertView2];
           [self createViewForManyMoney];
          }
//           __weak typeof(self) weakSelf = self;
//           NSArray *array = @[@{kHcdPopMenuItemAttributeTitle : @"", kHcdPopMenuItemAttributeIconImageName : @"quedingjian"},
//                              @{kHcdPopMenuItemAttributeTitle : @"", kHcdPopMenuItemAttributeIconImageName : @"chongzhijian"}];
//           
           
           
//           [xiaohaoLabel setFrame:CGRectMake(20, 250, labelsize.width, labelsize.height)];
           
           
           
           
           
//           HcdPopMenuView *menu = [[HcdPopMenuView alloc]initWithItems:array View:view];
//           [menu setBgImageViewByUrlStr:@"http://img3.duitang.com/uploads/item/201411/17/20141117102333_rwHMH.thumb.700_0.jpeg"];
//           [menu setSelectCompletionBlock:^(NSInteger index) {
//               if(index == 0)
//               {
//                   [weakSelf payForMessage];
//               }
//               
//               if (index == 1) {
//                   MyYabiController *yabiVC = [[MyYabiController alloc]init];
//                   [self.navigationController pushViewController:yabiVC animated:YES];
//               }
//           }];
//           [menu setTipsLblByTipsStr:@""];
//           [menu setExitViewImage:@"cuowu"];
           //           [HcdPopMenuView createPopmenuItems:array closeImageName: @"cuowu" backgroundImageUrl:@"http://img3.duitang.com/uploads/item/201411/17/20141117102333_rwHMH.thumb.700_0.jpeg" tipStr:@"" completionBlock:^(NSInteger index) {
//           }];
//           [HcdPopMenuView createPopmenuItems:array closeImageName:@"cuowu" backgroundImageUrl:@"" tipStr:@"" completionBlock:^(NSInteger index) {
//      //           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的余额不足，请充值后再拨打" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
////               [alert show];
// 
//               NSLog(@"%ld",index);
//               
//           }];
           
          
//           [self showAlertControllerWithTitle:@"提示" message:@"该条信息是收费信息，若您想继续约谈，需要支付1元服务费用" cancelTitle:@"取消" otherTitle:@"付费约谈" actions:@selector(payForMessage)];
           
           
           
       }
    }
    else if([self.role isEqualToString:@"0"]||[self.role isEqualToString:@"2"])
    {
        if(self.isZichan == NO)
        {
        [self ShowAlertViewController];
        }
        else if(self.isZichan == YES)
        {
            UIWebView *webView = [[UIWebView alloc]init];
            NSString *telString = [@"tel:"stringByAppendingString:self.phoneNumber];
            NSURL *url = [NSURL URLWithString:telString];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];
        }
    }
}

- (void)createViewForLessMoney
{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 30, self.view.bounds.size.width - 40, 70)];
    view.backgroundColor = [UIColor whiteColor];

    
    
    UIView *blackBackview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [blackBackview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    UITapGestureRecognizer *blackBackViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackBackTapAction1:)];
    [blackBackview addGestureRecognizer:blackBackViewTapGesture];
    
    UIView *alertView  = [[UIView alloc]initWithFrame:CGRectMake(44 * kWidthScale, 69 * kHeightScale, 288 * kWidthScale , 400 * kHeightScale)];
    [alertView setBackgroundColor:[UIColor whiteColor]];
    

    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertView.bounds.size.width, alertView.bounds.size.height/2)];
    yellowView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    [alertView addSubview:yellowView];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(30, 24*kHeightScale, 98 * kWidthScale, 98 * kWidthScale)];
    CGRect frame = imageview.frame;
    frame.size = CGSizeMake(98 * kWidthScale, 98 * kWidthScale);
    imageview.frame = frame;
    CGPoint center = imageview.center;
    center.x = alertView.frame.size.width/2;
    imageview.center = center;
    
    //           imageview.centerX = self.view.bounds.size.width/2;
    imageview.image = [UIImage imageNamed:@"yuetan-popup-logo"];
    [yellowView addSubview:imageview];
    
    UILabel *resourceType = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*kHeightScale + 98 * kWidthScale + 20  *kHeightScale, alertView.bounds.size.width, 20)];
    resourceType.text = @"该信息为收费资源";
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*kHeightScale + 98 * kWidthScale + 20 *kHeightScale +25 * kHeightScale, alertView.bounds.size.width, 20)];
    textLabel.text = @"需消耗芽币即可查看对方联系方式";
    resourceType.font = [UIFont systemFontOfSize:20];
    textLabel.font = [UIFont systemFontOfSize:15];
    resourceType.textAlignment = NSTextAlignmentCenter;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [yellowView addSubview:resourceType];
    [yellowView addSubview:textLabel];
    
    CGFloat Height = yellowView.bounds.size.height;
    UIImageView *smallImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(30*kWidthScale, Height + 20*kHeightScale, 20, 20)];
    smallImage1.image = [UIImage imageNamed:@"yuetan-goldcoin"];
    
    UILabel *xiaohaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + 20, 150, 100, 20)];
    CGSize labelSize1 = [@"消耗：" sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    xiaohaoLabel.frame = CGRectMake(30*kWidthScale + 36*kWidthScale, Height + 20*kHeightScale, labelSize1.width,20);
    xiaohaoLabel.text = @"消耗：";
    
    CGSize labelSize2 = [self.model.Price sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width,Height + 20*kHeightScale,labelSize2.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label1.numberOfLines = 0;
    label1.text = self.model.Price;
    label1.font = [UIFont systemFontOfSize:20];
    label1.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    UILabel *yabiLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width + labelSize2.width, Height + 20*kHeightScale, 40, 20)];
    yabiLabel1.text = @"芽币";
    
    UIImageView *smallImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(30*kWidthScale, Height + 20*kHeightScale + 32 * kHeightScale, 20, 20)];
    smallImage2.image = [UIImage imageNamed:@"yuetan-goldcoin"];
    
    UILabel *xiaohaoLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + 20 , 150+32, 100, 20)];
    CGSize labelSize11 = [@"余额：" sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    
    xiaohaoLabel2.frame = CGRectMake(30*kWidthScale + 36*kWidthScale, Height + 20*kHeightScale + 32* kHeightScale, labelSize1.width,20);
    xiaohaoLabel2.text = @"余额：";
    CGSize labelSize22 = [self.model.Account sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width,Height + 20*kHeightScale + 32* kHeightScale,labelSize22.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label2.numberOfLines = 0;
    label2.text = self.model.Account;
    label2.font = [UIFont systemFontOfSize:20];
    
    label2.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
//   self.AccountLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width,Height + 20*kHeightScale + 32* kHeightScale,labelSize22.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
//    self.AccountLabel1.numberOfLines = 0;
//    self.AccountLabel1.text = self.model.Account;
//    self.AccountLabel1.font = [UIFont systemFontOfSize:20];
//    
//    self.AccountLabel1.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    
    UILabel *yabiLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width + labelSize22.width, Height + 20*kHeightScale+32* kHeightScale, 40, 20)];
    
    
    yabiLabel2.text = @"芽币";
    
    UILabel *buzuLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width + labelSize22.width + 40,  Height + 20*kHeightScale+32* kHeightScale, 100, 20)];
    if (self.model.Account.integerValue < self.model.Price.integerValue)
    {
    buzuLabel.text = @"(余额不足)";
    }
    buzuLabel.font = [UIFont systemFontOfSize:11];
    
    self.buzuLabel = buzuLabel;
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setFrame:CGRectMake(alertView.bounds.size.width - 30 * kWidthScale, 10 *kWidthScale, 20 * kWidthScale, 20 * kWidthScale)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    cancelButton.tag = 1;
    [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [sureButton setFrame:CGRectMake(26*kWidthScale, Height + 20*kHeightScale+32* kHeightScale + 20*kHeightScale + 20 * kHeightScale, alertView.bounds.size.width - 52 * kWidthScale, 40 * kHeightScale)];
    [sureButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    sureButton.tag = 3;
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *rechargeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rechargeButton setFrame:CGRectMake(26*kWidthScale, Height + 20*kHeightScale+32* kHeightScale + 20*kHeightScale+12*kHeightScale+40*kHeightScale+ 20 * kHeightScale, alertView.bounds.size.width - 52 * kWidthScale, 40 * kHeightScale)];
    [rechargeButton setBackgroundColor:[UIColor whiteColor]];
    [rechargeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [rechargeButton setTitle:@"充值" forState:(UIControlStateNormal)];
    
    rechargeButton.layer.borderWidth = 2.5;
    rechargeButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    [rechargeButton addTarget:self action:@selector(rechareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [alertView addSubview:smallImage1];
    [alertView addSubview:xiaohaoLabel];
    [alertView addSubview:label1];
    [alertView addSubview:yabiLabel1];
    [alertView addSubview:smallImage2];
    [alertView addSubview:xiaohaoLabel2];
    [alertView addSubview:label2];
    [alertView addSubview:yabiLabel2];
    [alertView addSubview:buzuLabel];
    [alertView addSubview:cancelButton];
    [alertView addSubview:sureButton];
    [alertView addSubview:rechargeButton];
    
    self.blackBackView1 = blackBackview;
    self.alertView1 = alertView;
    [self.view addSubview:self.blackBackView1];
    [self.view addSubview:self.alertView1];
    
  }
- (void)createViewForManyMoney
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 30, self.view.bounds.size.width - 40, 70)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *blackBackview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [blackBackview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    UIView *alertView  = [[UIView alloc]initWithFrame:CGRectMake(44 * kWidthScale, 69 * kHeightScale, 288 * kWidthScale , 370 * kHeightScale)];
    UITapGestureRecognizer *blackBackViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackBackTapAction2:)];
    [blackBackview addGestureRecognizer:blackBackViewTapGesture];
    

    [alertView setBackgroundColor:[UIColor whiteColor]];
    
 
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertView.bounds.size.width, alertView.bounds.size.height/2)];
    yellowView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    [alertView addSubview:yellowView];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(30, 24*kHeightScale, 98 * kWidthScale, 98 * kWidthScale)];
    CGRect frame = imageview.frame;
    frame.size = CGSizeMake(98 * kWidthScale, 98 * kWidthScale);
    imageview.frame = frame;
    CGPoint center = imageview.center;
    center.x = alertView.frame.size.width/2;
    imageview.center = center;
    //           imageview.centerX = self.view.bounds.size.width/2;
    imageview.image = [UIImage imageNamed:@"yuetan-popup-logo"];
    [yellowView addSubview:imageview];
    
    UILabel *resourceType = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*kHeightScale + 98 * kWidthScale + 20  *kHeightScale, alertView.bounds.size.width, 20)];
    resourceType.text = @"该信息为普通资源";
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*kHeightScale + 98 * kWidthScale + 20 *kHeightScale +25 * kHeightScale, alertView.bounds.size.width, 20)];
    textLabel.text = @"无需消耗芽币即可查看对方联系方式";
    resourceType.font = [UIFont systemFontOfSize:20];
    textLabel.font = [UIFont systemFontOfSize:15];
    resourceType.textAlignment = NSTextAlignmentCenter;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [yellowView addSubview:resourceType];
    [yellowView addSubview:textLabel];
    
    CGFloat Height = yellowView.bounds.size.height;
    UIImageView *smallImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(30*kWidthScale, Height + 20*kHeightScale, 20, 20)];
    smallImage1.image = [UIImage imageNamed:@"yuetan-goldcoin"];
    
    UILabel *xiaohaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + 20, 150, 100, 20)];
    CGSize labelSize1 = [@"余额：" sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    xiaohaoLabel.frame = CGRectMake(30*kWidthScale + 36*kWidthScale, Height + 20*kHeightScale, labelSize1.width,20);
    xiaohaoLabel.text = @"余额：";
    
    CGSize labelSize2 = [self.model.Account sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width,Height + 20*kHeightScale,labelSize2.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label1.numberOfLines = 0;
    label1.text = self.model.Account;
    label1.font = [UIFont systemFontOfSize:20];
    label1.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    self.AccountLabel2 = label1;
    UILabel *yabiLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width + labelSize2.width, Height + 20*kHeightScale, 40, 20)];
    yabiLabel1.text = @"芽币";
       UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setFrame:CGRectMake(alertView.bounds.size.width - 30 * kWidthScale, 10 *kWidthScale, 20 * kWidthScale, 20 * kWidthScale)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    cancelButton.tag = 2;
    
    [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [sureButton setFrame:CGRectMake(26*kWidthScale, Height + 60* kHeightScale , alertView.bounds.size.width - 52 * kWidthScale, 40 * kHeightScale)];
    [sureButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    sureButton.tag = 4;
    
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *rechargeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rechargeButton setFrame:CGRectMake(26*kWidthScale, Height + 12*kHeightScale+40*kHeightScale+ 60* kHeightScale, alertView.bounds.size.width - 52 * kWidthScale, 40 * kHeightScale)];
    [rechargeButton setBackgroundColor:[UIColor whiteColor]];
    [rechargeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [rechargeButton setTitle:@"充值" forState:(UIControlStateNormal)];
    
    rechargeButton.layer.borderWidth = 2.5;
    rechargeButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    [rechargeButton addTarget:self action:@selector(rechareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [alertView addSubview:smallImage1];
    [alertView addSubview:xiaohaoLabel];
    [alertView addSubview:self.AccountLabel2];
    [alertView addSubview:yabiLabel1];
 
    [alertView addSubview:cancelButton];
    [alertView addSubview:sureButton];
    [alertView addSubview:rechargeButton];
    
    
    self.blackBackView2 = blackBackview;
    self.alertView2 = alertView;
    
    [self.view addSubview:self.blackBackView2];
    [self.view addSubview:self.alertView2];
    
   
}


- (void)blackBackTapAction1:(UITapGestureRecognizer *)gesture
{
    [self.alertView1 removeFromSuperview];
    [self.blackBackView1 removeFromSuperview];
}
- (void)blackBackTapAction2:(UITapGestureRecognizer *)gesture
{
    [self.alertView2 removeFromSuperview];
    [self.blackBackView2 removeFromSuperview];
}
- (void)didClickCancelButton:(UIButton *)button
{
    if (button.tag == 1) {
        [self.alertView1 removeFromSuperview];
        [self.blackBackView1 removeFromSuperview];
    }
    else
    {
        [self.alertView2 removeFromSuperview];
        [self.blackBackView2 removeFromSuperview];
    }

}
- (void)sureButtonAction:(UIButton *)button
{
    if(self.model.Price.integerValue > self.model.Account.integerValue)
    {
    [self MBProgressWithString:@"余额不足，请充值！" timer:2 mode:MBProgressHUDModeText];
    }
    else
    {
        
    [self payForMessage];
    }
   
}
- (void)rechareButtonAction:(UIButton *)button
{
//    MyYabiController *yabiVC = [[MyYabiController alloc]init];
    RechargeController *rechargeVC = [[RechargeController alloc]init];
    
    [self.blackBackView1 removeFromSuperview];
    [self.alertView1 removeFromSuperview];
    [self.blackBackView2 removeFromSuperview];
    [self.alertView2 removeFromSuperview];
   [self.navigationController pushViewController:rechargeVC animated:YES];

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

- (void)createPopView
{

      __weak typeof(self) weakSelf = self;
    NSArray *array = @[@{kHcdPopMenuItemAttributeTitle : @"", kHcdPopMenuItemAttributeIconImageName : @"quedingjian"},
                       @{kHcdPopMenuItemAttributeTitle : @"", kHcdPopMenuItemAttributeIconImageName : @"chongzhijian"}];
    

//    self.menu = [[HcdPopMenuView alloc]initWithItems:array View:];
    
    [self.menu setBgImageViewByUrlStr:@"http://img3.duitang.com/uploads/item/201411/17/20141117102333_rwHMH.thumb.700_0.jpeg"];
    [self.menu setSelectCompletionBlock:^(NSInteger index) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SDG" message:@"DSFS" delegate:weakSelf cancelButtonTitle:@"AF" otherButtonTitles:@"DFSA", nil];
        [alert show];
    }];
    [self.menu setTipsLblByTipsStr:@"海量投单是所有人都可以看到的投单，定向投单则是针对有目的性的投单（如企业投单）"];
    [self.menu setExitViewImage:@"cuowu"];
}

- (void)confirmPayMessage
{
    NSLog(@"确认收费操作");

}
- (void)payForMessage
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    [dataDic setObject:@"token" forKey:@"access_token"];
    [dataDic setObject:self.model.ProjectID forKey:@"ProjectID"];
    NSString *URL = [[paidURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSLog(@"-----%@",URL);
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager POST:URL parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSString *status_code = dic[@"status_code"];
         if ([status_code isEqualToString:@"417"]) {
             NSLog(@"已支付");
         }
         else if ([status_code isEqualToString:@"418"])
         {
             NSLog(@"余额不足");
             [self MBProgressWithString:@"余额不足，请充值！" timer:2 mode:MBProgressHUDModeText];
         }
         else if ([status_code isEqualToString:@"416"])
         {
             NSLog(@"非收费信息");
         }
         else if ([status_code isEqualToString:@"200"])
         {
             [self.blackBackView1 removeFromSuperview];
             [self.alertView1 removeFromSuperview];
             [self.blackBackView2 removeFromSuperview];
             [self.alertView2 removeFromSuperview];
             NSLog(@"支付成功");
//             [self.connectButton setTitle:@"已约谈" forState:(UIControlStateNormal)];
             self.connectLabel.text = @"已约谈";
             self.model.PayFlag = @"1";
             [self.blackBackView2 removeFromSuperview];
             [self.alertView2 removeFromSuperview];
             UIWebView *webView = [[UIWebView alloc]init];
             NSString *telString = [@"tel:"stringByAppendingString:self.phoneNumber];
             NSURL *url = [NSURL URLWithString:telString];
             [webView loadRequest:[NSURLRequest requestWithURL:url]];
             [self.view addSubview:webView];
             
         }
         [self.HUD removeFromSuperViewOnHide];
         [self.HUD hideAnimated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         
     }];
  
}


- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)canceltitle otherTitle:(NSString *)othertitle actions:(SEL)actions
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:canceltitle style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:othertitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        /**
         *  收费操作
         */
        [self performSelector:actions];
        
          }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
    

}

- (void)ShowAlertViewController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"通过认证的服务方可以查看发布方的联系方式，申请抢单，私聊" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        MyidentifiController *identifiVC = [[MyidentifiController alloc]init];
        identifiVC.ConnectPhone = self.userModel.ConnectPhone;
        identifiVC.ServiceName = self.userModel.ServiceName;
        identifiVC.ServiceLocation = self.userModel.ServiceLocation;
        identifiVC.ServiceType = self.userModel.ServiceType;
        identifiVC.ServiceIntroduction = self.userModel.ServiceIntroduction;
        identifiVC.ConnectPerson = self.userModel.ConnectPerson;
        identifiVC.ServiceArea = self.userModel.ServiceArea;
        identifiVC.ConfirmationP1 = self.userModel.ConfirmationP1;
        identifiVC.ConfirmationP2 = self.userModel.ConfirmationP2;
        identifiVC.ConfirmationP3 = self.userModel.ConfirmationP3;
        identifiVC.ViewType = @"服务";
        identifiVC.role = self.role;
        [self.navigationController pushViewController:identifiVC animated:YES];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];

}


/**
 *  申请抢单
 *
 *  @param button 申请清单按钮
 */
- (void)applyButtonAction:(UIButton *)button
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.role = [defaults objectForKey:@"role"];
    self.userID = [defaults objectForKey:@"UserID"];
    [self layoutBottomViewWithUserType:self.role UserID:self.userid];
    if ([defaults objectForKey:@"token"] == nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else if([self.role isEqualToString:@"1"])
    {
        NSLog(@"认证过的服务方，调用申请");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        NSString *headurl = getDataURL;
        NSString *footurl = @"/project/rush";
        NSString *URL =[[[headurl stringByAppendingString:footurl]stringByAppendingString:@"?token="]stringByAppendingString:token];
        NSMutableDictionary *paraDic = [NSMutableDictionary new];
        NSString *accesstoken = @"token";
        NSString *ProjectID = self.ProjectID;
        [paraDic setObject:token forKey:@"token"];
        [paraDic setObject:accesstoken forKey:@"access_token"];
        [paraDic setObject:ProjectID forKey:@"ProjectID"];
        
        [self.manager POST:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"status_code"] isEqualToString:@"200"]) {
                NSLog(@"请求抢单成功");
                [self MBProgressWithString:@"抢单成功！" timer:1 mode:MBProgressHUDModeText];
                //抢单成功之后改变申请抢单按钮的状态
                [self.applyButton setTitle:@"已抢单" forState:(UIControlStateNormal)];
                //                [self.applyButton setBackgroundColor:[UIColor redColor]];
                [self.applyButton setEnabled:NO];
            }
            NSLog(@"申请接单返回的数据%@",dic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"申请请求失败！%@",error);
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
    }
    else
    {
        
        [self ShowAlertViewController];


    }
    
}




//私聊
/**
 *  私聊
 *
 *  @param button 私聊按钮
 */
- (void)talkButtonAction:(UIButton *)button
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.role = [defaults objectForKey:@"role"];
    self.userID = [defaults objectForKey:@"UserID"];
    NSString *userName = [defaults objectForKey:@"UserName"];
    [self layoutBottomViewWithUserType:self.role UserID:self.userid];
    if ([defaults objectForKey:@"token"] ==nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else if([self.role isEqualToString:@"1"])
    {
        
        //        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        //        userInfo[@"targetID"] = self.targetID;
        //        userInfo[@"title"] = self.userid;
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushTotalkControllerNotification" object:nil userInfo:userInfo];
        
        
        talkViewController *talkVC = [[talkViewController alloc]init];
        talkVC.targetId = self.targetID;
        NSLog(@"~~~~~~~~~~~~~~~~~TargetID%@",self.targetID);
        talkVC.title = @"私聊";//self.userid;
        talkVC.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:talkVC animated:YES];
        NSLog(@"认证过的服务方，调用私聊界面");
        
    }
    else
    {
        [self ShowAlertViewController];

        if(self.isZichan == YES)
        {
            
            //        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            //        userInfo[@"targetID"] = self.targetID;
            //        userInfo[@"title"] = self.userid;
            //        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushTotalkControllerNotification" object:nil userInfo:userInfo];
            talkViewController *talkVC = [[talkViewController alloc]init];
            talkVC.targetId = self.targetID;
            NSLog(@"~~~~~~~~~~~~~~~~~TargetID%@",self.targetID);
            talkVC.title = @"对话";//self.userid;
            talkVC.conversationType = ConversationType_PRIVATE;
            [self.navigationController pushViewController:talkVC animated:YES];
            NSLog(@"认证过的服务方，调用私聊界面");
            
        }

    }
    
}
/**
 *  我的抢单人列表
 *
 *  @param button 抢单人列表按钮
 */
- (void)lookbuttonAction:(UIButton *)button
{
    NSLog(@"是自己，调用抢单人列表");
    
    LookupRushPeopleController *lookVC = [[LookupRushPeopleController alloc]init];
    lookVC.ProjectID = self.ProjectID;
    self.model.PublishState = [NSString stringWithFormat:@"%@",self.model.PublishState];
    lookVC.PublishState = self.model.PublishState;
    [self.navigationController pushViewController:lookVC animated:YES];
}



/**
 *  收藏按钮点击
 *
 *  @param sender 收藏按钮
 */
- (IBAction)saveButtonAction:(id)sender {
  
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        NSString *Token = @"?token=";
        NSString *url = getDataURL;
        NSString *url2 = @"/collect";
        NSString *access_token = @"token";
        
        NSString *URL = [[[url stringByAppendingString:url2]stringByAppendingString:Token]stringByAppendingString:token];
        
        //    NSString *getURL = @"http://api.ziyawang.com/v1/service/list?access_token=token";
        NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
        [postdic setObject:access_token forKey:@"access_token"];
        //    [postdic setObject:token forKey:@"token"];
        [postdic setObject:self.ProjectID forKey:@"itemID"];
        [postdic setObject:@"1" forKey:@"type"];
        if (self.isCollected == NO)
        {
            NSLog(@"未收藏过,改变button的状态,调用收藏接口");
            [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
             {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"收藏成功");
                 [self MBProgressWithString:@"收藏成功" timer:1 mode:MBProgressHUDModeText];
                 //                 收藏按钮状态改变
                 [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
                 self.isCollected = YES;
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
                 //                 [self MBProgressWithString:@"收藏失败" timer:1 mode:MBProgressHUDModeText];
                 
                 NSLog(@"收藏失败");
             }];
        }
        else
        {
            [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
             {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"取消收藏成功");
                 [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
                 
                 [self MBProgressWithString:@"已取消收藏" timer:1 mode:MBProgressHUDModeText];
                 
                 //收藏按钮状态改变
                 //            self.saveButton.imageView.image = [UIImage imageNamed:<#(nonnull NSString *)#>]
                 self.isCollected = NO;
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
                 //                 [self MBProgressWithString:@"取消收藏失败" timer:1 mode:MBProgressHUDModeText];
                 NSLog(@"取消收藏失败");
             }];
        }
    }
}

/**
 *  分享按钮
 *
 *  @param sender 分享按钮
 */

- (IBAction)shareButtonAction:(id)sender {
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    
    //    NSString *url = @"http://ziyawang.com/project/";
    NSString *url = @"http://api.ziyawang.com/v1/";
    self.model.ProjectID = [NSString stringWithFormat:@"%@",self.model.ProjectID];
    NSString *URL = [url stringByAppendingString:self.model.ProjectID];
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!%@",URL);
    UIImage *image = [UIImage imageNamed:@"morentouxiang"];
    
    NSArray *imageArray = @[image];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    //    [shareParams SSDKSetupWeChatParamsByText:@"aaaaa"
    //                                       title:@"wefwvw"
    //                                         url:[NSURL URLWithString:@"http://www.baidu.com"]
    //                                  thumbImage:imageArray//传一张小于32k 的图
    //                                       image:[NSURL URLWithString:@"http://www.baidu.com"]
    //                                musicFileURL:nil
    //                                     extInfo:@"dwefwef"
    //                                    fileData:nil
    //                                emoticonData:nil
    //                                        type:SSDKContentTypeAuto
    //                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    //    http://ziyawang.com/project/
    NSString *str1 = self.model.WordDes;
    
//    if (self.model.WordDes.length < 40) {
//        str1 = self.model.WordDes;
//    }
//   else
//   {
//   str1 = [[self.model.WordDes substringToIndex:40]stringByAppendingString:@"..."];
//   }
    
 
    NSString *str2 = self.model.WordDes;
//    if (self.model.WordDes.length > 40) {
//        str2 = [[self.model.WordDes substringToIndex:40]stringByAppendingString:@"..."];
//    }
  
    NSString *shareURL1 = @"http://ziyawang.com/project/";
    NSString *shareURL = [shareURL1 stringByAppendingString:self.model.ProjectID];
    [shareParams SSDKSetupShareParamsByText:str2
                                     images:imageArray
                                        url:[NSURL URLWithString:shareURL]
                                      title:str1
                                       type:SSDKContentTypeAuto];
    //        //2、分享（可以弹出我们的分享菜单和编辑界面）
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






#pragma mark----图片的点击放大事件
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
    if (self.imageview1.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture1];
   
    }
    
}
- (void)tapgesture2:(UITapGestureRecognizer *)gesture2
{
    if (self.imageview2.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture2];
        
        
    }}
- (void)tapgesture3:(UITapGestureRecognizer *)gesture3
{
    if (self.imageview3.image == nil) {
        return;
    }
    else
    {
        [self tapImagViewWithGesture:gesture3];
        
        
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
            [self.userModel setValuesForKeysWithDictionary:dic[@"user"]];
            [self.userModel setValuesForKeysWithDictionary:dic[@"service"]];
            NSLog(@"%@",dic[@"role"]);
//            self.role =dic[@"role"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"获取用户信息失败");
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
