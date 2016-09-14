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

/**
 *  清单下载View
 */
@property (weak, nonatomic) IBOutlet UIView *qingdanDownLoadView;

@end

@implementation InfoDetailsController



#pragma mark----视图周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     *  iOS7之后导航栏问题
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    [self setController];

//    [self setController];
    /**
     *  初始化视图
     */
//    self.navigationItem.title = self.typeName;
    self.userModel = [[UserInfoModel alloc]init];
        [self getUserInfoFromDomin];

    
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
   self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(140, 17, 30, 9.5)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"信息详情";
    
    label.textColor = [UIColor blackColor];
    self.titleImageView.image = [UIImage imageNamed:@"vipziyuan"];
    [label addSubview:self.titleImageView];
    
    self.navigationItem.titleView = label;
//    [titleView addSubview:self.titleImageView];
//    [titleView addSubview:label];
//    self.navigationItem.titleView = titleView;
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    self.isPlaying = NO;
    self.playModel = [[PublishModel alloc]init];
    self.role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    if ([self.typeName isEqualToString:@"固产转让"]||[self.typeName isEqualToString:@"商业保理"]||[self.typeName isEqualToString:@"尽职调查"]||[self.typeName isEqualToString:@"法律服务"]||[self.typeName isEqualToString:@"悬赏信息"]) {
        self.areaBackViewHight.constant = 1;
//        self.areaAndFromBackView.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self ifHiddenQingdanView];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_left_jt"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor lightGrayColor];
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
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [weakSelf.model setValuesForKeysWithDictionary:dic];
        NSLog(@"%@",dic);
        
        //        weakSelf.role = dic[@"role"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            weakSelf.typeLable.text = weakSelf.model.TypeName;
            //            weakSelf.phoneNumber = weakSelf.model.PhoneNumber;
            //
            //            //        weakSelf.idNumLable.text = [NSString stringWithFormat:@"%@",weakSelf.model.ProjectID];
            //
            //            weakSelf.idNumLable.text = weakSelf.model.ProjectNumber;
            weakSelf.typeName = weakSelf.model.TypeName;
            weakSelf.VideoDes = weakSelf.model.VoiceDes;
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
    
    self.PublishtimeLabel.text = self.model.PublishTime;
//    self.ViewCount.text = [NSString stringWithFormat:@"%@",self.model.ViewCount];
    self.ViewCount.text = [@"浏览"stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.ViewCount]];
    
    if ([self.VideoDes isEqualToString:@""]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, 60, 20)];
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
    self.model.Member = [NSString stringWithFormat:@"%@",self.model.Member];
    if ([self.model.Member isEqualToString:@"1"]==NO) {
        [self.titleImageView setHidden:YES];
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
    
    self.typeLable.text = self.model.TypeName;
    self.idNumLable.text = self.model.ProjectNumber;
    NSLog(@"@@@@@@@@@@@@@@FBiD：%@",self.model.ProjectNumber);
    self.infoDescribLable.text = self.model.WordDes;
    
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
        self.label1.text = @"金额:";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        self.label3.text = @"佣金比例:";
        self.label4.text = self.model.Rate;
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        self.label7.text = @"状态:";
        self.label8.text = self.model.Status;
        self.label9.text = @"债务人所在地:";
        self.label10.text = self.model.ProArea;
        self.label11.text = @"类型:";
        self.label12.text = self.model.AssetType;
        
        
    }
    else if([self.typeName isEqualToString:@"债权转让"])
    {
        self.label1.text = @"金额:";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        self.label4.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        self.label7.text = @"类型:";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区:";
        self.label10.text = self.model.ProArea;
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
    }
    else if([self.typeName isEqualToString:@"固产转让"])
    {
        self.label1.text = @"转让价:";
        self.label2.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        self.label3.text = @"地区:";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型:";
        self.label12.text = self.model.AssetType;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
        
    }
    else if([self.typeName isEqualToString:@"商业保理"])
    {
        self.label1.text = @"合同金额:";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        self.label3.text = @"地区:";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"买方性质:";
        self.label12.text = self.model.BuyerNature;
        [self.label7 setHidden:YES];
        [self.label8 setHidden:YES];
        [self.label9 setHidden:YES];
        [self.label10 setHidden:YES];
        self.label11.text = @"买方性质:";
        [self.label11 setHidden:NO];
        [self.label12 setHidden:NO];
    }
    else if([self.typeName isEqualToString:@"典当担保"])
    {
        self.label1.text = @"金额:";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        self.label3.text = @"地区:";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型:";
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
        self.label1.text = @"金额:";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        self.label3.text = @"回报率:";
        self.label4.text = [self.model.Rate stringByAppendingString:@"%"];
        self.label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        
        self.label7.text = @"方式:";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区:";
        self.label10.text = self.model.ProArea;
        
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
    }
    else if([self.typeName isEqualToString:@"悬赏信息"])
    {
        self.label1.text = @"金额:";
        self.label2.text = [self.model.TotalMoney stringByAppendingString:@"元"];
        self.label2.textColor = [UIColor colorWithHexString:@"#ef8200"];
        
        self.label3.text = @"目标地区:";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型:";
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
        self.label1.text = @"被调查方:";
        self.label2.text = self.model.Informant;
        self.label3.text = @"地区:";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型:";
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
        self.label1.text = @"需求:";
        self.label2.text = self.model.Requirement;
        self.label3.text = @"地区:";
        self.label4.text = self.model.ProArea;
        self.label5.text = @"类型:";
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
        self.label1.text = @"求购方:";
        self.label2.text = self.model.Buyer;
        [self.label3 setHidden:YES];
        [self.label4 setHidden:YES];
        
        [self.label5 setHidden:YES];
        [self.label12 setHidden:YES];
        self.label7.text = @"类型:";
        self.label8.text = self.model.AssetType;
        self.label9.text = @"地区:";
        self.label10.text = self.model.ProArea;
        
        [self.label11 setHidden:YES];
        [self.label12 setHidden:YES];
    }
    else if([self.typeName isEqualToString:@"投资需求"])
    {
    self.label1.text = @"回报率:";
        self.label2.text = [self.model.Rate stringByAppendingString:@"%"];
        self.label3.text = @"投资期限:";
        self.label4.text = [self.model.Year stringByAppendingString:@"年"];
        self.label7.text = @"投资方式:";
        self.label8.text = self.model.investType;
        self.label11.text = @"投资类型:";
        self.label12.text = self.model.AssetType;
        [self.label5 setHidden:YES];
        [self.label6 setHidden:YES];
        [self.label9 setHidden:YES];
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
    
    if([self.userID isEqualToString:UserID])
    {
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
    if ([self.typeName isEqualToString:@"资产求购"]||[self.typeName isEqualToString:@"投资需求"])
    {
        self.isZichan = YES;
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
        connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/3, 50);
        [connectButton setTitle:@"联系方式" forState:(UIControlStateNormal)];
        UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(connectButton.bounds.size.width/2-50, 17, 20, 20)];
        imageview3.image = [UIImage imageNamed:@"lianxifangshi"];
        [connectButton addSubview:imageview3];
    /**
     *  申请抢单按钮
     *
     *  @param UIButtonTypeSystem UIButtonTypeSystem description
     *
     *  @return return value description
     */
    UIButton *applyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [applyButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    applyButton.frame = CGRectMake(connectButton.bounds.size.width, 0, SomeOneView.bounds.size.width/3, 50);
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(applyButton.bounds.size.width/2-50, 17, 20, 20)];
    imageview1.image = [UIImage imageNamed:@"shenqing"];
    [applyButton setBackgroundColor:[UIColor colorWithHexString:@"#ea6155"]];
    [applyButton addSubview:imageview1];
    
    if ([self.RushFlag isEqualToString:@"1"]) {
        [applyButton setTitle:@"已抢单" forState:(UIControlStateNormal)];
        [applyButton  setEnabled:NO];
    }
    else
    {
        [applyButton setTitle:@"申请抢单" forState:(UIControlStateNormal)];
        [applyButton setEnabled:YES];
        
    }
    /**
     *  私聊按钮
     *
     *  @param UIButtonTypeSystem UIButtonTypeSystem description
     *
     *  @return return value description
     */
    UIButton *talkButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    talkButton.frame = CGRectMake(applyButton.bounds.size.width*2, 0, applyButton.bounds.size.width, 50);
    [talkButton setTitle:@"私聊" forState:(UIControlStateNormal)];
    [talkButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [talkButton setBackgroundColor:[UIColor colorWithHexString:@"#fdd000"]];
    
      UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(talkButton.bounds.size.width/2-38, 17, 20, 20)];
    imageview2.image = [UIImage imageNamed:@"siliao3"];
    
    [talkButton addSubview:imageview2];
    
    if (self.isZichan == YES) {
        connectButton.frame = CGRectMake(0, 0, SomeOneView.bounds.size.width/2, 50);
        [applyButton setHidden:YES];
        
        talkButton.frame = CGRectMake(connectButton.bounds.size.width, 0, connectButton.bounds.size.width, 50);
        [imageview3 setFrame:CGRectMake(connectButton.bounds.size.width/2-50, 17, 20, 20)];
        [imageview2 setFrame:CGRectMake(connectButton.bounds.size.width/2-38, 17, 20, 20)];
    }
    [SomeOneView addSubview:connectButton];
    [SomeOneView addSubview:applyButton];
    [SomeOneView addSubview:talkButton];
    /**
     *  添加按钮点击事件
     *
     *  @param connectButtonAction: 按钮点击事件
     *
     *  @return return value description
     */
    [connectButton addTarget:self action:@selector(connectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [talkButton addTarget:self action:@selector(talkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.applyButton = applyButton;
    [self.bringView addSubview:SomeOneView];
    //.................
    [self.backGroundView bringSubviewToFront:self.bringView];
}
/**
 *  登录但是没有认证过的（发布方）
 */
- (void)layoutView2
{
    UIView *selfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    selfView.backgroundColor = [UIColor whiteColor];
    //    selfView.backgroundColor = [UIColor grayColor];
    UIButton *lookButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    lookButton.frame = CGRectMake(0, 0, selfView.bounds.size.width, 50);
    [lookButton setTitle:@"查看抢单人" forState:(UIControlStateNormal)];
    [lookButton addTarget:self action:@selector(lookbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    lookButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
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
    if (self.role == nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else if([self.role isEqualToString:@"1"])
    {
        UIWebView *webView = [[UIWebView alloc]init];
        NSString *telString = [@"tel:"stringByAppendingString:self.phoneNumber];
        NSURL *url = [NSURL URLWithString:telString];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
        NSLog(@"认证过的服务方，调用打电话");
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
    if (self.role == nil) {
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
    if (self.role ==nil) {
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
        talkVC.title = @"对话";//self.userid;
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

- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
    
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
    NSString *shareURL1 = @"http://ziyawang.com/project/";
    NSString *shareURL = [shareURL1 stringByAppendingString:self.model.ProjectID];
    [shareParams SSDKSetupShareParamsByText:@"资芽信息"
                                     images:imageArray
                                        url:[NSURL URLWithString:shareURL]
                                      title:@"资芽"
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
