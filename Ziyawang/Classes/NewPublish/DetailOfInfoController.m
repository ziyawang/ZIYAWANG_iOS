//
//  DetailOfInfoController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "DetailOfInfoController.h"
#import "PublishModel.h"

#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"


#import "LoginController.h"
#import "MyidentifiController.h"
#import "UserInfoModel.h"
#import "talkViewController.h"
#import "LookupRushPeopleController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <AVFoundation/AVFoundation.h>

#import "TipTableViewController.h"

#import "CLAmplifyView.h"
#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height

@interface DetailOfInfoController ()<KNPhotoBrowerDelegate>
{
    
    BOOL     _ApplicationStatusIsHidden;
    
}
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UIView *scrollView;
@property (nonatomic,strong) UIScrollView *scrollBackView;

@property (nonatomic,strong) UIView *imageBackView;
@property (nonatomic,strong) UIView *changeView;

@property (nonatomic,strong) UIView *ContentView;
@property (nonatomic,strong) PublishModel *model;

@property (nonatomic,strong) NSMutableArray *itemsArray;
@property (nonatomic,strong) NSMutableArray *itemsArray2;

@property (nonatomic, strong) KNPhotoBrower *photoBrower;

@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIImageView *imageView2;
@property (nonatomic,strong) UIImageView *imageView3;
@property (nonatomic,strong) UIView *imageViewb1;
@property (nonatomic,strong) UIView *imageViewb2;
@property (nonatomic,strong) UIView *imageViewb3;

@property (nonatomic,strong) UserInfoModel *userModel;
@property (nonatomic,strong) NSString *role;

@property (nonatomic,assign) BOOL isCollected;

@property (nonatomic,strong) UIButton *collectButton;
@property (nonatomic,strong) UIButton *shareButton;
@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) UIView *xiangmuView;
@property (nonatomic,strong) UIImageView *tapImageView;
@property (nonatomic,strong) UILabel *tapLabel;
@property (nonatomic,strong) UIView *audioView;
@property (nonatomic,strong) UILabel *xiangmuLabel;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,strong) UIImageView *ziyaIma;
@end

@implementation DetailOfInfoController
- (void)videoButtonAction:(UIButton *)button
{
    NSString *url = AudioURL;
    //    NSLog(@"333######################%@",self.VideoDes);
    if ([self.model.VoiceDes isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该条信息没有语音描述" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        NSString *playURL = [url stringByAppendingString:self.model.VoiceDes];
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.model = [[PublishModel alloc]init];
    self.itemsArray = [NSMutableArray new];
    self.itemsArray2 = [NSMutableArray new];
    self.photoBrower = [[KNPhotoBrower alloc]init];
    self.userModel = [[UserInfoModel alloc]init];
    [self getUserInfoFromDomin];
    [self getInfoData];
    self.role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataDic = [NSMutableDictionary new];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.typeName;
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
    UIButton *collectButton = [UIButton new];
    UIButton *shareButton = [UIButton new];
    
    [rightBarView addSubview:collectButton];
    [rightBarView addSubview:shareButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarView];
    
    [collectButton setBackgroundImage:[UIImage imageNamed:@"shoucangxin"] forState:(UIControlStateNormal)];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"fenxiang2"] forState:(UIControlStateNormal)];
    shareButton.sd_layout.rightSpaceToView(rightBarView,0)
    .centerYEqualToView(rightBarView)
    .heightIs(20)
    .widthIs(15);
    collectButton.sd_layout.rightSpaceToView(shareButton,15)
    .centerYEqualToView(rightBarView)
    .heightIs(20)
    .widthIs(25);
    
    [collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.collectButton = collectButton;
    self.shareButton = shareButton;
}
- (void)collectButtonAction:(UIButton *)button
{
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
        //    NSString *getURL = @"https://apis.ziyawang.com/zll/service/list?access_token=token";
        NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
        [postdic setObject:access_token forKey:@"access_token"];
        //    [postdic setObject:token forKey:@"token"];
        
        [postdic setObject:self.ProjectID forKey:@"itemID"];
        [postdic setObject:@"1" forKey:@"type"];
        if ([self.model.CollectFlag isEqualToString:@"0"])
        {
            NSLog(@"未收藏过,改变button的状态,调用收藏接口");
            [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
             {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"收藏成功");
                 //                 [self MBProgressWithString:@"收藏成功" timer:1 mode:MBProgressHUDModeText];
                 //                 收藏按钮状态改变
                 [button setBackgroundImage:[UIImage imageNamed:@"shouc"] forState:(UIControlStateNormal)];
                 self.model.CollectFlag = @"1";
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
                 [button setBackgroundImage:[UIImage imageNamed:@"shoucangxin"] forState:(UIControlStateNormal)];
                 
                 //                 [self MBProgressWithString:@"已取消收藏" timer:1 mode:MBProgressHUDModeText];
                 
                 //收藏按钮状态改变
                 //            self.saveButton.imageView.image = [UIImage imageNamed:<#(nonnull NSString *)#>]
                 self.model.CollectFlag = @"0";
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
                 //                 [self MBProgressWithString:@"取消收藏失败" timer:1 mode:MBProgressHUDModeText];
                 NSLog(@"取消收藏失败");
             }];
        }
    }
    
}
- (void)shareButtonAction:(UIButton *)button
{
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    //    NSString *url = @"http://ziyawang.com/project/";
    NSString *url = @"https://apis.ziyawang.com/zll/";
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

- (void)getInfoData
{
    //成功
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
    //    NSString *gfetURL = @"https://apis.ziyawang.com/zll/project/list/5?&access_token=token";
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
    //    [getdic setObject:token forKey:@"token"];
    
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        [self.model setValuesForKeysWithDictionary:dic];
        self.model.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
        if ([self.model.CollectFlag isEqualToString:@"1"]) {
            [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shouc"] forState:(UIControlStateNormal)];
            
        }
        else
        {
            [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucangxin"] forState:(UIControlStateNormal)];
        }
        
        NSLog(@"%@",dic);
        [self setViews];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        NSLog(@"请求失败：%@",error);
    }];
    
}


-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 10; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 10;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
//    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOriginattributes:dic context:nil].size;
    return size.height;
}- (void)setViews
{
    self.scrollView = [UIView new];
    self.scrollBackView = [UIScrollView new];
    
    self.ContentView = [UIView new];
    self.scrollBackView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.scrollBackView];
    [self.scrollBackView addSubview:self.scrollView];
    self.scrollBackView.showsVerticalScrollIndicator = FALSE;
    self.scrollBackView.showsHorizontalScrollIndicator = FALSE;
    
    
    //    [self.scrollView addSubview:self.ContentView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.scrollBackView.backgroundColor = [UIColor whiteColor];
    
    //    self.ScrollView.sd_layout.leftSpaceToView(self.view,0)
    //    .rightSpaceToView(self.view,0)
    //    .topSpaceToView(self.view,0)
    //    .bottomSpaceToView(self.view,0);
    //    self.scrollBackView.backgroundColor = [UIColor whiteColor];
    
    //    self.scrollBackView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    self.scrollView.sd_layout.topSpaceToView(self.scrollBackView,0)
    .leftSpaceToView(self.scrollBackView,0)
    .rightSpaceToView(self.scrollBackView,0);
    
    
    //    [self.scrollView setupAutoContentSizeWithRightView:self.imageBackView rightMargin:10];
    
    
    UIView *titleView = [UIView new];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"dfhiasuhfiuewhiugweuigweiugtiuewgt";
    
    titleLabel.text = self.model.Title;
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    
    
    [self.scrollView addSubview:titleView];
    [titleView addSubview:titleLabel];
    
    titleView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(self.scrollView,0);
    
    
    
    [titleView setupAutoHeightWithBottomView:titleLabel bottomMargin:15];
    titleLabel.sd_layout.leftSpaceToView(titleView,15)
    .rightSpaceToView(titleView,15)
    .heightIs(20)
    .topSpaceToView(titleView,20)
    .autoHeightRatio(0);
    
    
    UIView *infoView = [UIView new];
    infoView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview = [UIImageView new];
    UILabel *nameLabel = [UILabel new];
    UILabel *numberLabel = [UILabel new];
    UILabel *viewCountLabel = [UILabel new];
    UILabel *timeLabel = [UILabel new];
    UIButton *jubaoButton = [UIButton new];
    UIButton *jubaobutton2= [UIButton new];
    UIImageView *countIma = [UIImageView new];
    UIImageView *timeIma = [UIImageView new];
    
    [jubaobutton2 setBackgroundImage:[UIImage imageNamed:@"jubao"] forState:(UIControlStateNormal)];
    [jubaobutton2 addTarget:self action:@selector(jubaoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    countIma.image = [UIImage imageNamed:@"liulan"];
    timeIma.image = [UIImage imageNamed:@"shizhong"];
    
    
    numberLabel.textColor = [UIColor grayColor];
    viewCountLabel.textColor = [UIColor grayColor];
    timeLabel.textColor = [UIColor grayColor];
    
    
    
    [self.scrollView addSubview:infoView];
    [infoView addSubview:imageview];
    [infoView addSubview:nameLabel];
    [infoView addSubview:numberLabel];
    [infoView addSubview:viewCountLabel];
    [infoView addSubview:timeLabel];
    [infoView addSubview:jubaoButton];
    [infoView addSubview:jubaobutton2];
    [infoView addSubview:countIma];
    [infoView addSubview:timeIma];

    
    
    nameLabel.text = self.model.username;
    if (self.model.username == nil || [self.model.username isEqualToString:@""]) {
        nameLabel.text = [self.model.ConnectPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    numberLabel.text = self.model.ProjectNumber;
    
    numberLabel.font = [UIFont systemFontOfSize:14];
    viewCountLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    if (self.model.ViewCount != nil) {
        viewCountLabel.text = self.model.ViewCount;
    }
    
    NSArray *textarr = [self.model.PublishTime componentsSeparatedByString:@" "];
    timeLabel.text = textarr[0];
    
    
    if(self.model.UserPicture != nil)
    {
        [imageview sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.UserPicture]]];
    }
    [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageview.clipsToBounds = YES;
    
    imageview.layer.cornerRadius = 25;
    imageview.layer.masksToBounds = YES;
    
    
    
    infoView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(titleView,1)
    .heightIs(80);
    
    imageview.sd_layout.leftSpaceToView(infoView,15)
    .topSpaceToView(infoView,15)
    .widthIs(50)
    .heightIs(50);
    
    nameLabel.sd_layout.leftSpaceToView(imageview,10)
    .topSpaceToView(infoView,13)
    .heightIs(20);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    numberLabel.sd_layout.leftSpaceToView(imageview,10)
    .topSpaceToView(nameLabel,10)
    .heightIs(15);
    
    [numberLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    jubaoButton.sd_layout.centerYEqualToView(nameLabel)
    .rightSpaceToView(infoView,15)
    .heightIs(20)
    .widthIs(33);
    [jubaoButton setTitle:@"举报" forState:(UIControlStateNormal)];
    [jubaoButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    jubaoButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    [jubaoButton addTarget:self action:@selector(jubaoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    jubaobutton2.sd_layout.rightSpaceToView(jubaoButton,2)
    .topSpaceToView(infoView,15)
    .heightIs(15)
    .widthIs(20);
    
   
    timeLabel.sd_layout.rightEqualToView(jubaoButton)
    .centerYEqualToView(numberLabel)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];

    timeIma.sd_layout.rightSpaceToView(timeLabel,2)
    .centerYEqualToView(timeLabel)
    .heightIs(15)
    .widthIs(15);
    viewCountLabel.sd_layout.rightSpaceToView(timeIma,20)
    .centerYEqualToView(timeLabel)
    .heightIs(20);
    [viewCountLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    countIma.sd_layout.rightSpaceToView(viewCountLabel,2)
    .centerYEqualToView(viewCountLabel)
    .widthIs(22)
    .heightIs(13);
    
    
    
   
    
    
    self.changeView = [UIView new];
    self.changeView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *specialImageView = [UIImageView new];
    [self.changeView addSubview:specialImageView];
    [self.scrollView addSubview:self.changeView];
    
    self.changeView.sd_layout.topSpaceToView(infoView,1)
    .leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .heightIs(0);
    
    specialImageView.sd_layout.rightSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(65)
    .widthIs(80);
    
    
    
    
    self.model.Hide = [NSString stringWithFormat:@"%@",self.model.Hide];
    
    if ([self.model.CooperateState isEqualToString:@"0"]) {
        if ([self.model.Member isEqualToString:@"2"]) {
            specialImageView.image = [UIImage imageNamed:@"shoufeiyuan"];
        }
        if ([self.model.Member isEqualToString:@"1"] && [self.model.Hide isEqualToString:@"0"]) {
            specialImageView.image = [UIImage imageNamed:@"vipyuan"];
        }
        if ([self.model.Member isEqualToString:@"0"]) {
            specialImageView.image = [UIImage imageNamed:@"mianfeiyuan"];
        }
    }
    else
    {
        if ([self.model.CooperateState isEqualToString:@"1"]) {
            specialImageView.image = [UIImage imageNamed:@"hezuozhongd"];
        }
        if ([self.model.CooperateState isEqualToString:@"2"]) {
            if ([self.model.TypeName isEqualToString:@"融资信息"] || [self.model.TypeName isEqualToString:@"法拍资产"]) {
                specialImageView.image = [UIImage imageNamed:@"yiwanchengd"];

            }
            else
            {
                specialImageView.image = [UIImage imageNamed:@"chuzhichenggongd"];

            }
            
        }
    }
  
    
    
    UIView *wordDesView = [UIView new];
    UIView *wenziView = [UIView new];
    
    
    wordDesView.backgroundColor = [UIColor whiteColor];
    wenziView.backgroundColor = [UIColor whiteColor];
    
    UILabel *wenziLabel = [UILabel new];
    UILabel *desLabel = [UILabel new];
    [self.scrollView addSubview:wordDesView];
    [self.scrollView addSubview:wenziView];
    
    [wenziView addSubview:wenziLabel];
    [wordDesView addSubview:desLabel];
    
    
    
    wenziView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(self.changeView,10)
    .heightIs(50);
    
    
    wenziLabel.sd_layout.leftSpaceToView(wenziView,15)
    .centerYEqualToView(wenziView);
    [wenziLabel setSingleLineAutoResizeWithMaxWidth:200];
    wenziLabel.textAlignment = NSTextAlignmentCenter;
    
    wenziLabel.text = @"文字描述";
    wenziLabel.font = [UIFont boldSystemFontOfSize:17];
    
    wordDesView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(wenziView,1);
    
    
    [wordDesView setupAutoHeightWithBottomView:desLabel bottomMargin:15];
    NSString *text = self.model.WordDes;

    desLabel.numberOfLines = 0;
    [self setLabelSpace:desLabel withValue:text withFont:[UIFont systemFontOfSize:17]];

    CGFloat tableH = [self getSpaceLabelHeight:text withFont:[UIFont systemFontOfSize:17] withWidth:[UIScreen mainScreen].bounds.size.width - 20];
    
    desLabel.sd_layout.leftSpaceToView(wordDesView,15)
    .rightSpaceToView(wordDesView,15)
    .topSpaceToView(wordDesView,15)
    .heightIs(tableH + 35);


    
//    desLabel.text = self.model.WordDes;
//    [desLabel setNumberOfLines:0];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    
//    [paragraphStyle setLineSpacing:10];//调整行间距
//    
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, [text length])];
//    
//
//    desLabel.attributedText = attributedString;
//    [desLabel sizeToFit];
    
    
    self.audioView = [UIView new];
    self.audioView.backgroundColor = [UIColor whiteColor];
    
    UILabel *yuyinLabel = [UILabel new];
    UIButton *recordButton = [UIButton new];
    
    [self.scrollView addSubview:self.audioView];
    [self.audioView addSubview:yuyinLabel];
    [self.audioView addSubview:recordButton];
    
    self.audioView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(wordDesView,10)
    .heightIs(70);
    
    yuyinLabel.sd_layout.leftSpaceToView(self.audioView,15)
    .centerYEqualToView(self.audioView);
    [yuyinLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    yuyinLabel.text = @"语音描述";
    yuyinLabel.font = [UIFont boldSystemFontOfSize:17];
    
    recordButton.sd_layout.leftSpaceToView(yuyinLabel,10)
    .centerYEqualToView(yuyinLabel)
    .heightIs(30)
    .widthIs(120);
    
    [recordButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    if ([self.model.VoiceDes isEqualToString:@""]||self.model.VoiceDes == nil)
    {
        //        [recordButton setBackgroundImage:[UIImage new] forState:(UIControlStateNormal)];
        //        recordButton.backgroundColor = [UIColor redColor];
        [recordButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        
        [recordButton setTitle:@"无语音描述" forState:(UIControlStateNormal)];
    }
    else
    {
        [recordButton setBackgroundImage:[UIImage imageNamed:@"yuyin"] forState:(UIControlStateNormal)];
        
    }
    
    self.xiangmuLabel = [UILabel new];
    self.ziyaIma = [UIImageView new];
    self.xiangmuLabel.text = @"项目详情";
    self.xiangmuLabel.font = [UIFont boldSystemFontOfSize:17];

    self.xiangmuView = [UIView new];
    self.tapImageView = [UIImageView new];
    [self.scrollView addSubview:self.tapImageView];
    [self.scrollView addSubview:self.xiangmuView];
    [self.xiangmuView addSubview:self.xiangmuLabel];
    [self.xiangmuView addSubview:self.ziyaIma];
    
    self.xiangmuView.backgroundColor = [UIColor whiteColor];
    
    self.xiangmuView.sd_layout.leftEqualToView(self.audioView)
    .rightEqualToView(self.audioView)
    .heightIs(0)
    .topSpaceToView(self.audioView,0);
    self.tapImageView.sd_layout.leftEqualToView(self.xiangmuView)
    .rightEqualToView(self.xiangmuView)
    .heightIs(0)
    .topSpaceToView(self.xiangmuView,1);
//    self.tapImageView.backgroundColor = [UIColor redColor];
    self.xiangmuLabel.sd_layout.leftSpaceToView(self.xiangmuView,15)
    .centerYEqualToView(self.xiangmuView)
    .heightIs(20);
    [self.xiangmuLabel setSingleLineAutoResizeWithMaxWidth:200];

    self.ziyaIma.sd_layout.rightSpaceToView(self.xiangmuView,20)
    .centerYEqualToView(self.xiangmuView)
    .heightIs(30)
    .widthIs(75);
    self.ziyaIma.image = [UIImage imageNamed:@"ziyasmall"];
    
    self.tapLabel = [UILabel new];
    [self.tapImageView addSubview:self.tapLabel];
    self.tapLabel.sd_layout.centerXEqualToView(self.tapImageView)
    .bottomSpaceToView(self.tapImageView,25)
    .heightIs(30);
    [self.tapLabel setSingleLineAutoResizeWithMaxWidth:400];
    self.tapLabel.text = @"   点击查看大图   ";
    self.tapLabel.textColor = [UIColor whiteColor];
    self.tapLabel.backgroundColor = [UIColor colorWithHexString:@"#b2b2b2"];
    self.tapLabel.layer.masksToBounds = YES;
    self.tapLabel.layer.cornerRadius = 15;
    
    
    [self.xiangmuLabel setHidden:YES];
    [self.tapLabel setHidden:YES];
    [self.ziyaIma setHidden:YES];
    
    
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewAction:)];
    self.tapImageView.tag = 0;
    self.tapImageView.userInteractionEnabled = YES;

    self.tapImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.tapImageView addGestureRecognizer:tapG];
    KNPhotoItems *item = [[KNPhotoItems alloc] init];
    NSString *tapimageURL = @"1";
    if ([self.model.PictureDet isEqualToString:@""] == NO && self.model.PictureDet != nil) {
        [self.imageView1 setHidden:NO];
        tapimageURL = [getImageURL stringByAppendingString:self.model.PictureDet];
        [self.tapImageView sd_setImageWithURL:[NSURL URLWithString:tapimageURL]];
        item.url = tapimageURL;
        item.sourceView =self.tapImageView;
        [self.itemsArray2 addObject:item];
    }
    
    
    UIView *xiangguanView = [UIView new];
    xiangguanView.backgroundColor = [UIColor whiteColor];
    
    UILabel *xiangguanLabel = [UILabel new];
    [xiangguanView addSubview:xiangguanLabel];
    [self.scrollView addSubview:xiangguanView];
    
    
    self.imageBackView = [UIView new];
    self.imageBackView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImageView *imageView1 = [UIImageView new];
    UIImageView *imageView2 = [UIImageView new];
    UIImageView *imageView3 = [UIImageView new];
    
    self.imageViewb1 = [UIView new];
    self.imageViewb2 = [UIView new];
    self.imageViewb3 = [UIView new];
    
    
    [imageView1 setHidden:YES];
    [imageView2 setHidden:YES];
    [imageView3 setHidden:YES];
    
    [self.imageViewb1 setHidden:YES];
    [self.imageViewb2 setHidden:YES];
    [self.imageViewb3 setHidden:YES];

    self.imageView1 = imageView1;
    self.imageView2 = imageView2;
    self.imageView3 = imageView3;
    
    KNPhotoItems *items1 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items2 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items3 = [[KNPhotoItems alloc] init];
    
    
    NSString *imageURL1 = @"1";
    NSString *imageURL2 = @"2";
    NSString *imageURL3 = @"3";
    
    
    if ([self.model.PictureDes1 isEqualToString:@""] == NO && self.model.PictureDes1 != nil) {
        [self.imageView1 setHidden:NO];
        [self.imageViewb1 setHidden:NO];
        
        imageURL1 = [getImageURL stringByAppendingString:self.model.PictureDes1];
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:imageURL1]];
        items1.url = imageURL1;
        items1.sourceView =imageView1;
        [self.itemsArray addObject:items1];
    }
    
    if ([self.model.PictureDes2 isEqualToString:@""] == NO && self.model.PictureDes2 != nil) {
        imageURL2 = [getImageURL stringByAppendingString:self.model.PictureDes2];
        [imageView2 setHidden:NO];
        [self.imageViewb2 setHidden:NO];
        
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.PictureDes2]]];
        items2.url = imageURL2;
        items2.sourceView =imageView2;
        [self.itemsArray addObject:items2];
    }
    if ([self.model.PictureDes3 isEqualToString:@""] == NO && self.model.PictureDes3 != nil) {
        imageURL3 = [getImageURL stringByAppendingString:self.model.PictureDes3];
        
        [imageView3 setHidden:NO];
        [self.imageViewb3 setHidden:NO];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.PictureDes3]]];
        items3.url = imageURL3;
        items3.sourceView =imageView3;
        [self.itemsArray addObject:items3];
    }
    
    //    imageView1.backgroundColor = [UIColor redColor];
    //    imageView2.backgroundColor = [UIColor redColor];
    //    imageView3.backgroundColor = [UIColor redColor];
    
    imageView1.userInteractionEnabled = YES;
    imageView2.userInteractionEnabled = YES;
    imageView3.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *ImageTapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    UITapGestureRecognizer *ImageTapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    UITapGestureRecognizer *ImageTapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    
    imageView1.tag = 0;
    imageView2.tag = 1;
    imageView3.tag = 2;
    
    
    [imageView1 addGestureRecognizer:ImageTapGesture1];
    [imageView2 addGestureRecognizer:ImageTapGesture2];
    [imageView3 addGestureRecognizer:ImageTapGesture3];
    
    
    
    [self.scrollView addSubview:self.imageBackView];
    [self.imageBackView addSubview:self.imageViewb1];
    [self.imageBackView addSubview:self.imageViewb2];
    [self.imageBackView addSubview:self.imageViewb3];

    
    [self.imageViewb1 addSubview:imageView1];
    [self.imageViewb2 addSubview:imageView2];
    [self.imageViewb3 addSubview:imageView3];
    
//    self.imageViewb1.layer.masksToBounds = YES;
    
    self.imageViewb1.layer.borderWidth = 1;
    self.imageViewb1.layer.borderColor = [UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    
    self.imageViewb2.layer.borderWidth = 1;
    self.imageViewb2.layer.borderColor = [UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    self.imageViewb3.layer.borderWidth = 1;
    self.imageViewb3.layer.borderColor = [UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    
    self.imageViewb1.sd_layout.leftSpaceToView(self.imageBackView,10)
    .centerYEqualToView(self.imageBackView)
    .heightIs(110)
    .widthIs(110);
  
    self.imageViewb2.sd_layout.leftSpaceToView(self.imageViewb1,10)
    .centerYEqualToView(self.imageBackView)
    .heightIs(110)
    .widthIs(110);
    
    self.imageViewb3.sd_layout.leftSpaceToView(self.imageViewb2,10)
    .centerYEqualToView(self.imageBackView)
    .heightIs(110)
    .widthIs(110);
    
    imageView1.sd_layout.centerXEqualToView(self.imageViewb1)
    .centerYEqualToView(self.imageViewb1)
    .heightIs(90)
    .widthIs(90);
    
    imageView2.sd_layout.centerXEqualToView(self.imageViewb2)
    .centerYEqualToView(self.imageViewb2)
    .heightIs(90)
    .widthIs(90);
    
    imageView3.sd_layout.centerXEqualToView(self.imageViewb3)
    .centerYEqualToView(self.imageViewb3)
    .heightIs(90)
    .widthIs(90);
    
    xiangguanView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(self.tapImageView,10)
    .heightIs(50);
    
    xiangguanLabel.sd_layout.leftSpaceToView(xiangguanView,15)
    .centerYEqualToView(xiangguanView);
    [xiangguanLabel setSingleLineAutoResizeWithMaxWidth:200];
    xiangguanLabel.text = @"相关凭证";
    xiangguanLabel.font = [UIFont boldSystemFontOfSize:17];
    
    self.imageBackView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(xiangguanView,1)
    .heightIs(130);
    
    
    if ([self.model.Promise isEqualToString:@"承诺"]) {
        UIView *tishiView = [UIView new];
        UILabel *imporLabel = [UILabel new];
        UILabel *imporDes = [UILabel new];
        [tishiView addSubview:imporDes];
        [tishiView addSubview:imporLabel];
        
        [self.scrollView addSubview:tishiView];
        tishiView.sd_layout.leftSpaceToView(self.scrollView,0)
        .rightSpaceToView(self.scrollView,0)
        .topSpaceToView(self.imageBackView,10);
        tishiView.backgroundColor = [UIColor whiteColor];
        
        imporLabel.sd_layout.topSpaceToView(tishiView,15)
        .centerXEqualToView(tishiView)
        .heightIs(20);
        
        [imporLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        imporDes.sd_layout.leftSpaceToView(tishiView,0)
        .rightSpaceToView(tishiView,0)
        .topSpaceToView(imporLabel,10)
        .heightIs(20);
        
        imporLabel.text = @"重要提示";
        imporDes.text = @"发布方本人已对本条信息的真实性进行承诺";
        imporDes.textColor = [UIColor redColor];
        imporLabel.textColor = [UIColor redColor];
        
        imporLabel.textAlignment = NSTextAlignmentCenter;
        imporDes.textAlignment = NSTextAlignmentCenter;
        
        [tishiView setupAutoHeightWithBottomView:imporDes bottomMargin:15];
        [self.scrollView setupAutoHeightWithBottomView:tishiView bottomMargin:50];
        
        [self.scrollBackView setupAutoContentSizeWithBottomView:self.scrollView bottomMargin:50];
        [self.scrollBackView layoutSubviews];
        
    }
    
    
    else
        
    {
        [self.scrollView setupAutoHeightWithBottomView:self.imageBackView bottomMargin:50];
        
        [self.scrollBackView setupAutoContentSizeWithBottomView:self.scrollView bottomMargin:50];
        [self.scrollBackView layoutSubviews];
        
    }
    //判断是自己还是别人
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID"];
    
    if ([self.model.UserID isEqualToString:userID]) {
        [jubaoButton setHidden:YES];
        [self MySelfView];
    }
    else
    {
        if ([self.model.CooperateState isEqualToString:@"0"]) {
            [self otherView];
        }
        else
        {
        
        }
    }
    
    switch (self.model.TypeID.integerValue) {
        case 1:
            [self asetBackView];
            break;
            //融资信息股权
        case 6:
            [self finanCingGuquanView];
            break;
            //固定资产房产
        case 12:
            [self HouseProductionView];
            break;
            //固定资产土地
        case 16:
            [self landProductionView];
            break;
            //融资信息债权
        case 17:
            [self finaCingZhaiquanView];
            break;
            //企业商账
        case 18:
            [self businesssView];
            break;
            
            //个人债权
        case 19:
            [self personZhaiquanView];
            break;
            //法拍资产
        case 20:
            
            [self houseFapaiView];
            break;
        case 21:
            [self houseFapaiView];
            break;
        case 22:
            [self carFapaiView];
            break;
        default:
            break;
    }
    
}

- (void)otherView
{
    UIView *connectBackView = [UIView new];
    UIView *talkBackView = [UIView new];
    
    UIView *connectView = [UIView new];
    UIView *talkView = [UIView new];
    
    UIImageView *connectIma = [UIImageView new];
    UILabel *connectLabel = [UILabel new];
    
    UIImageView *talkIma = [UIImageView new];
    UILabel *talkLabel = [UILabel new];
    
    [self.view addSubview:connectBackView];
    [self.view addSubview:talkBackView];
    [connectBackView addSubview:connectView];
    [talkBackView addSubview:talkView];
    
    [connectView addSubview:connectIma];
    [connectView addSubview:connectLabel];
    
    [talkView addSubview:talkIma];
    [talkView addSubview:talkLabel];
    
    connectBackView.sd_layout.bottomSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .widthIs(self.view.bounds.size.width/2)
    .heightIs(50);
    
    connectBackView.backgroundColor = [UIColor whiteColor];
    talkBackView.sd_layout.bottomSpaceToView(self.view,0)
    .leftSpaceToView(connectBackView,0)
    .rightSpaceToView(self.view,0)
    .heightIs(50);
    talkBackView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
    connectView.sd_layout.centerXEqualToView(connectBackView)
    .centerYEqualToView(connectBackView)
    .heightIs(50);
    
    [connectView setupAutoWidthWithRightView:connectLabel rightMargin:0];
    
    
    talkView.sd_layout.centerYEqualToView(talkBackView)
    .centerXEqualToView(talkBackView)
    .heightIs(50);
    [talkView setupAutoWidthWithRightView:talkLabel rightMargin:0];
    
    connectIma.sd_layout.leftSpaceToView(connectView,0)
    .centerYEqualToView(connectView)
    .heightIs(20)
    .widthIs(20);
    connectLabel.sd_layout.leftSpaceToView(connectIma,10)
    .centerYEqualToView(connectView)
    .heightIs(20)
    .widthIs(40);
    
    talkIma.sd_layout.leftSpaceToView(talkView,0)
    .centerYEqualToView(connectView)
    .heightIs(20)
    .widthIs(20);
    talkLabel.sd_layout.leftSpaceToView(talkIma,10)
    .centerYEqualToView(talkView)
    .heightIs(20)
    .widthIs(40);
    
    connectIma.image = [UIImage imageNamed:@"wodeyuetan"];
    talkIma.image = [UIImage imageNamed:@"siliao3"];
    
    connectLabel.text = @"约谈";
    talkLabel.text = @"私聊";
    connectView.userInteractionEnabled = NO;
    talkView.userInteractionEnabled = NO;
    
    UIGestureRecognizer *connectGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(connectViewAction:)];
    
    UIGestureRecognizer *talkGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(talkViewAction:)];
    
    [connectBackView addGestureRecognizer:connectGesture];
    [talkBackView addGestureRecognizer:talkGesture];
    
}

- (void)MySelfView
{
    UIView *lookBackView = [UIView new];
    UIView *lookView = [UIView new];
    
    [self.view addSubview:lookBackView];
    [lookBackView addSubview:lookView];
    
    UIImageView *imv = [UIImageView new];
    UILabel *lookLabel = [UILabel new];
    
    [lookView addSubview:imv];
    [lookView addSubview:lookLabel];
    
    lookBackView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(50)
    .bottomSpaceToView(self.view,0);
    
    lookView.sd_layout.centerYEqualToView(lookBackView)
    .centerXEqualToView(lookBackView)
    .heightIs(50);
    [lookView setupAutoWidthWithRightView:lookLabel rightMargin:0];
    
    imv.sd_layout.leftSpaceToView(lookView,0)
    .centerYEqualToView(lookView)
    .heightIs(20)
    .widthIs(20);
    
    lookLabel.sd_layout.leftSpaceToView(imv,10)
    .centerYEqualToView(lookView)
    .heightIs(20);
    [lookLabel setSingleLineAutoResizeWithMaxWidth:200];
    lookLabel.text = @"查看约谈人";
    lookLabel.textColor = [UIColor whiteColor];
    
    imv.image = [UIImage imageNamed:@"fangdajing"];
    lookBackView.backgroundColor = [UIColor colorWithHexString:@"#ea6155"];
    
    lookView.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *lookGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookBackViewAction:)];
    [lookBackView addGestureRecognizer:lookGesture];
    
}

- (void)connectViewAction:(UITapGestureRecognizer *)gesture
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    if (token == nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else if([role isEqualToString:@"1"])
    {
        [self connectSomeOne];
    }
    else
    {
        [self ShowAlertViewController];
    }
    
}
- (void)connectSomeOne
{
    
    [self payForMessage];
    
}
- (void)payForMessage
{
  
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
             UIWebView *webView = [[UIWebView alloc]init];
             NSString *telString = [@"tel:"stringByAppendingString:self.model.ConnectPhone];
             NSURL *url = [NSURL URLWithString:telString];
             [webView loadRequest:[NSURLRequest requestWithURL:url]];
             [self.ContentView addSubview:webView];
             NSLog(@"认证过的服务方，调用打电话");
             NSLog(@"已支付");
         }
         else if ([status_code isEqualToString:@"416"])
         {
             UIWebView *webView = [[UIWebView alloc]init];
             NSString *telString = [@"tel:"stringByAppendingString:self.model.ConnectPhone];
             NSURL *url = [NSURL URLWithString:telString];
             [webView loadRequest:[NSURLRequest requestWithURL:url]];
             [self.ContentView addSubview:webView];
             NSLog(@"认证过的服务方，调用打电话");
             NSLog(@"非收费信息");
         }
         else if ([status_code isEqualToString:@"200"])
         {
             UIWebView *webView = [[UIWebView alloc]init];
             NSString *telString = [@"tel:"stringByAppendingString:self.model.ConnectPhone];
             NSURL *url = [NSURL URLWithString:telString];
             [webView loadRequest:[NSURLRequest requestWithURL:url]];
             
             [self.ContentView addSubview:webView];
             NSLog(@"认证过的服务方，调用打电话");
         }
      
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
     }];
}

- (void)talkViewAction:(UITapGestureRecognizer *)gesture
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    
    if (token == nil) {
        NSLog(@"未登录,提示登录");
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else if([role isEqualToString:@"1"])
    {
        talkViewController *talkVC = [[talkViewController alloc]init];
        talkVC.targetId = self.model.userid;
        NSLog(@"~~~~~~~~~~~~~~~~~TargetID%@",self.targetID);
        talkVC.title = @"私聊";//self.userid;
        talkVC.conversationType = ConversationType_PRIVATE;
        [self.navigationController pushViewController:talkVC animated:YES];
        NSLog(@"认证过的服务方，调用私聊界面");
        
    }
    else
    {
        [self ShowAlertViewController];
        
    }
    
}

- (void)lookBackViewAction:(UITapGestureRecognizer *)gesture
{
    NSLog(@"是自己，调用抢单人列表");
    
    LookupRushPeopleController *lookVC = [[LookupRushPeopleController alloc]init];
    lookVC.ProjectID = self.ProjectID;
    self.model.PublishState = [NSString stringWithFormat:@"%@",self.model.PublishState];
    lookVC.PublishState = self.model.PublishState;
    [self.navigationController pushViewController:lookVC animated:YES];
}
- (void)ShowAlertViewController
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"通过认证的服务方才可以进行约谈或私聊" preferredStyle:UIAlertControllerStyleAlert];
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
        identifiVC.RegTime = self.userModel.RegTime;
        identifiVC.Founds = self.userModel.Founds;
        identifiVC.Size = self.userModel.Size;
        
        [self.navigationController pushViewController:identifiVC animated:YES];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)carFapaiView
{
    
    
    //    addView = self.changeView;
    
    //    [self.scrollView addSubview:addView];
    
    UILabel *zichanLabel = [UILabel new];
    UILabel *zichanTypeLabel = [UILabel new];
    zichanLabel.textColor = [UIColor grayColor];
    
    
    UILabel *pinpaiLabel = [UILabel new];
    UILabel *pinpaiNumber = [UILabel new];
    pinpaiLabel.textColor = [UIColor grayColor];
    
    
    UILabel *qipaiLabel = [UILabel new];
    UILabel *qipaiMoney = [UILabel new];
    qipaiLabel.textColor = [UIColor grayColor];
    
    
    UILabel *didianLabel = [UILabel new];
    UILabel *areaLabel = [UILabel new];
    didianLabel.textColor = [UIColor grayColor];
    
    UILabel *shijianLabel = [UILabel new];
    UILabel *timeLabel = [UILabel new];
    shijianLabel.textColor = [UIColor grayColor];
    
    
    UILabel *paimaijieduan = [UILabel new];
    UILabel *jieduanLabel = [UILabel new];
    paimaijieduan.textColor = [UIColor grayColor];
    
    
    UILabel *chuzhidanwei = [UILabel new];
    UILabel *chuzhiLabel = [UILabel new];
    
    
    [self.changeView addSubview:zichanLabel];
    [self.changeView addSubview:zichanTypeLabel];
    [self.changeView addSubview:pinpaiLabel];
    [self.changeView addSubview:pinpaiNumber];
    [self.changeView addSubview:qipaiLabel];
    [self.changeView addSubview:qipaiMoney];
    [self.changeView addSubview:didianLabel];
    [self.changeView addSubview:areaLabel];
    [self.changeView addSubview:shijianLabel];
    [self.changeView addSubview:timeLabel];
    [self.changeView addSubview:paimaijieduan];
    [self.changeView addSubview:jieduanLabel];
    [self.changeView addSubview:chuzhidanwei];
    [self.changeView addSubview:chuzhiLabel];
    
    
    zichanTypeLabel.text = self.model.AssetType;
    pinpaiNumber.text = self.model.Brand;
    qipaiMoney.text = [self.model.Money stringByAppendingString:@"万"];
    qipaiMoney.textColor = [UIColor colorWithHexString:@"#ef8200"];
    qipaiMoney.font = [UIFont systemFontOfSize:20];
    areaLabel.text = self.model.ProArea;
    timeLabel.text = self.model.Year;
    jieduanLabel.text = self.model.State;
    chuzhiLabel.text = self.model.Court;
    
    
    zichanLabel.text = @"资产类型：";
    pinpaiLabel.text = @"品牌型号：";
    qipaiLabel.text = @"起拍价：";
    didianLabel.text = @"拍卖地点：";
    shijianLabel.text = @"拍卖时间：";
    paimaijieduan.text = @"拍卖阶段：";
    chuzhidanwei.text = @"处置单位：";
    
    chuzhidanwei.textColor = [UIColor grayColor];
    
    
    chuzhiLabel.textColor = [UIColor blackColor];
    
    zichanLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [zichanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    zichanTypeLabel.sd_layout.leftSpaceToView(zichanLabel,5)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [zichanTypeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    pinpaiLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(zichanLabel,15)
    .heightIs(20);
    [pinpaiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    pinpaiNumber.sd_layout.leftSpaceToView(pinpaiLabel,5)
    .topEqualToView(pinpaiLabel)
    .heightIs(20);
    [pinpaiNumber setSingleLineAutoResizeWithMaxWidth:200];
    
    qipaiLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(pinpaiLabel,15)
    .heightIs(20);
    [qipaiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    qipaiMoney.sd_layout.leftSpaceToView(qipaiLabel,5)
    .topEqualToView(qipaiLabel)
    .heightIs(20);
    [qipaiMoney setSingleLineAutoResizeWithMaxWidth:200];
    
    didianLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(qipaiLabel,15)
    .heightIs(20);
    [didianLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    areaLabel.sd_layout.leftSpaceToView(didianLabel,5)
    .topSpaceToView(qipaiMoney,15)
    .heightIs(20);
    [areaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    shijianLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(didianLabel,15)
    .heightIs(20);
    [shijianLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    timeLabel.sd_layout.leftSpaceToView(shijianLabel,5)
    .topEqualToView(shijianLabel)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    paimaijieduan.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(shijianLabel,15)
    .heightIs(20);
    [paimaijieduan setSingleLineAutoResizeWithMaxWidth:200];
    
    jieduanLabel.sd_layout.leftSpaceToView(paimaijieduan,5)
    .topEqualToView(paimaijieduan)
    .heightIs(20);
    [jieduanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    chuzhidanwei.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(paimaijieduan,15)
    .heightIs(20);
    [chuzhidanwei setSingleLineAutoResizeWithMaxWidth:200];
    
    chuzhiLabel.sd_layout.leftSpaceToView(chuzhidanwei,5)
    .topEqualToView(chuzhidanwei)
    .rightSpaceToView(self.changeView,15)
    .heightIs(20);
    
    [self.changeView setupAutoHeightWithBottomView:chuzhiLabel bottomMargin:35];
    
    //    self.changeView = addView;
    
    
}
- (void)houseFapaiView
{
    UILabel *zichanLabel = [UILabel new];
    UILabel *zichanTypeLabel = [UILabel new];
    zichanLabel.textColor = [UIColor grayColor];
    
    UILabel *mianjiLabel = [UILabel new];
    UILabel *mianjishuLabel = [UILabel new];
    mianjiLabel.textColor = [UIColor grayColor];
    
    UILabel *xingzhiLabel = [UILabel new];
    UILabel *xingzhiLabel2 = [UILabel new];
    xingzhiLabel.textColor = [UIColor grayColor];
    
    
    UILabel *qipaiLabel = [UILabel new];
    UILabel *qipaiMoney = [UILabel new];
    qipaiLabel.textColor = [UIColor grayColor];
    
    UILabel *didianLabel = [UILabel new];
    UILabel *areaLabel = [UILabel new];
    didianLabel.textColor = [UIColor grayColor];
    
    UILabel *shijianLabel = [UILabel new];
    UILabel *timeLabel = [UILabel new];
    shijianLabel.textColor = [UIColor grayColor];
    
    UILabel *paimaijieduan = [UILabel new];
    UILabel *jieduanLabel = [UILabel new];
    paimaijieduan.textColor = [UIColor grayColor];
    
    UILabel *chuzhidanwei = [UILabel new];
    UILabel *chuzhiLabel = [UILabel new];
    chuzhidanwei.textColor = [UIColor grayColor];
    
    
    [self.changeView addSubview:zichanLabel];
    [self.changeView addSubview:zichanTypeLabel];
    [self.changeView addSubview:mianjiLabel];
    [self.changeView addSubview:mianjishuLabel];
    
    [self.changeView addSubview:xingzhiLabel];
    [self.changeView addSubview:xingzhiLabel2];
    
    
    [self.changeView addSubview:qipaiLabel];
    [self.changeView addSubview:qipaiMoney];
    [self.changeView addSubview:didianLabel];
    [self.changeView addSubview:areaLabel];
    [self.changeView addSubview:shijianLabel];
    [self.changeView addSubview:timeLabel];
    [self.changeView addSubview:paimaijieduan];
    [self.changeView addSubview:jieduanLabel];
    [self.changeView addSubview:chuzhidanwei];
    [self.changeView addSubview:chuzhiLabel];
    zichanLabel.text = @"资产类型：";
    mianjiLabel.text = @"面积：";
    xingzhiLabel.text = @"性质：";
    qipaiLabel.text = @"起拍价：";
    didianLabel.text = @"拍卖地点：";
    shijianLabel.text = @"拍卖时间：";
    paimaijieduan.text = @"拍卖阶段：";
    chuzhidanwei.text = @"处置单位：";
    
    chuzhidanwei.textColor = [UIColor grayColor];
    
    zichanTypeLabel.text = self.model.AssetType;
    mianjishuLabel.text = [self.model.Area stringByAppendingString:@"平米"];
    xingzhiLabel2.text = self.model.Nature;
    qipaiMoney.text = [self.model.Money stringByAppendingString:@"万"];
    qipaiMoney.textColor = [UIColor colorWithHexString:@"#ef8200"];
    qipaiMoney.font = [UIFont systemFontOfSize:20];    areaLabel.text = self.model.ProArea;
    timeLabel.text = self.model.Year;
    jieduanLabel.text = self.model.State;
    chuzhiLabel.text = self.model.Court;
    chuzhiLabel.textColor = [UIColor blackColor];
    
    zichanLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [zichanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    zichanTypeLabel.sd_layout.leftSpaceToView(zichanLabel,5)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [zichanTypeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    mianjiLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(zichanLabel,15)
    .heightIs(20);
    [mianjiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    mianjishuLabel.sd_layout.leftSpaceToView(mianjiLabel,5)
    .topEqualToView(mianjiLabel)
    .heightIs(20);
    [mianjishuLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    xingzhiLabel.sd_layout.leftEqualToView(mianjiLabel)
    .topSpaceToView(mianjiLabel,15)
    .heightIs(20);
    [xingzhiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    xingzhiLabel2.sd_layout.leftSpaceToView(xingzhiLabel,0)
    .topEqualToView(xingzhiLabel)
    .heightIs(20);
    [xingzhiLabel2 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    qipaiLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(xingzhiLabel,15)
    .heightIs(20);
    [qipaiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    qipaiMoney.sd_layout.leftSpaceToView(qipaiLabel,5)
    .topEqualToView(qipaiLabel)
    .heightIs(20);
    [qipaiMoney setSingleLineAutoResizeWithMaxWidth:200];
    
    didianLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(qipaiLabel,15)
    .heightIs(20);
    [didianLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    areaLabel.sd_layout.leftSpaceToView(didianLabel,5)
    .topSpaceToView(qipaiMoney,15)
    .heightIs(20);
    [areaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    shijianLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(didianLabel,15)
    .heightIs(20);
    [shijianLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    timeLabel.sd_layout.leftSpaceToView(shijianLabel,5)
    .topEqualToView(shijianLabel)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    paimaijieduan.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(shijianLabel,15)
    .heightIs(20);
    [paimaijieduan setSingleLineAutoResizeWithMaxWidth:200];
    
    jieduanLabel.sd_layout.leftSpaceToView(paimaijieduan,5)
    .topEqualToView(paimaijieduan)
    .heightIs(20);
    [jieduanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    chuzhidanwei.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(paimaijieduan,15)
    .heightIs(20);
    [chuzhidanwei setSingleLineAutoResizeWithMaxWidth:200];
    
    chuzhiLabel.sd_layout.leftSpaceToView(chuzhidanwei,5)
    .topEqualToView(chuzhidanwei)
    .rightSpaceToView(self.changeView,15)
    .heightIs(20);
    //    [chuzhiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    [self.changeView setupAutoHeightWithBottomView:chuzhiLabel bottomMargin:35];
    
    
}
- (void)personZhaiquanView
{
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    UILabel *label13 = [UILabel new];
    UILabel *label14 = [UILabel new];
    UILabel *label15 = [UILabel new];
    
    label1.textColor = [UIColor grayColor];
    label3.textColor = [UIColor grayColor];
    label5.textColor = [UIColor grayColor];
    label7.textColor = [UIColor grayColor];
    
    label8.textColor = [UIColor grayColor];
    label10.textColor = [UIColor grayColor];
    label12.textColor = [UIColor grayColor];
    label14.textColor = [UIColor grayColor];
    
    
    
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    [self.changeView addSubview:label13];
    [self.changeView addSubview:label14];
    [self.changeView addSubview:label15];
    
    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label5,0)
    .heightIs(0);
    
    if (self.model.Law != nil || self.model.UnLaw != nil) {
        label8.sd_layout.leftEqualToView(label1)
        .topSpaceToView(label7,15)
        .heightIs(20);
        
        label9.sd_layout.leftSpaceToView(label8,0)
        .topEqualToView(label8)
        .heightIs(20);
        
        
        label10.sd_layout.leftEqualToView(label1)
        .topSpaceToView(label8,15)
        .heightIs(20);
        
        label11.sd_layout.leftSpaceToView(label10,0)
        .topEqualToView(label10)
        .heightIs(20);
        
    }
    if (self.model.Law != nil && self.model.UnLaw == nil) {
        label8.sd_layout.leftEqualToView(label1)
        .topSpaceToView(label7,15)
        .heightIs(20);
        
        label9.sd_layout.leftSpaceToView(label8,0)
        .topEqualToView(label8)
        .heightIs(20);
        
        
        label10.sd_layout.leftEqualToView(label1)
        .topSpaceToView(label8,0)
        .heightIs(0);
        
        label11.sd_layout.leftSpaceToView(label10,0)
        .topEqualToView(label10)
        .heightIs(0);
    }
    
    if (self.model.Law == nil && self.model.UnLaw != nil) {
        label8.sd_layout.leftEqualToView(label1)
        .topSpaceToView(label7,0)
        .heightIs(0);
        
        label9.sd_layout.leftSpaceToView(label8,0)
        .topEqualToView(label8)
        .heightIs(0);
        
        
        label10.sd_layout.leftEqualToView(label1)
        .topSpaceToView(label7,15)
        .heightIs(20);
        
        label11.sd_layout.leftSpaceToView(label10,0)
        .topEqualToView(label10)
        .heightIs(20);
        
    }
    
    
    
    label12.sd_layout.leftEqualToView(label1)
    .topSpaceToView(label10,15)
    .heightIs(20);
    
    label13.sd_layout.leftSpaceToView(label12,0)
    .topEqualToView(label12)
    .heightIs(20);
    
    
    label14.sd_layout.leftEqualToView(label1)
    .topSpaceToView(label12,15)
    .heightIs(20);
    
    label15.sd_layout.leftSpaceToView(label14,0)
    .topEqualToView(label14)
    .heightIs(20);
    
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    [label13 setSingleLineAutoResizeWithMaxWidth:200];
    [label14 setSingleLineAutoResizeWithMaxWidth:200];
    [label15 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label1.text = @"发布方身份：";
    label2.text = self.model.Identity;
    
    label3.text = @"总金额：";
    label4.text = [self.model.TotalMoney stringByAppendingString:@"万"];
    label4.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label4.font = [UIFont systemFontOfSize:20];
    
    
    label5.text = @"逾期时间：";
    label6.text = [self.model.Month stringByAppendingString:@"个月"];
    
    label7.text = @"处置方式";
    
    label8.text = @"诉讼佣金比例：";
    if (self.model.Law != nil) {
        label9.text = self.model.Law;
        
    }
    
    label10.text = @"非诉催收佣金比例：";
    if (self.model.UnLaw != nil) {
        label11.text = self.model.UnLaw;
        
        
    }
    
    label12.text = @"债权人所在地：";
    label13.text = self.model.DebteeLocation;
    
    label14.text = @"债务人所在地：";
    label15.text = self.model.ProArea;
    
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    //    line1.backgroundColor = [UIColor redColor];
    //    line2.backgroundColor = [UIColor blueColor];
    //    line3.backgroundColor = [UIColor blackColor];
    
    UIView *qitaView = [UIView new];
    UILabel *qitaLabel = [UILabel new];
    qitaLabel.text = @"其他信息";
    qitaLabel.font = [UIFont boldSystemFontOfSize:17];
    
    qitaView.backgroundColor = [UIColor whiteColor];
    
    UIView *qitaBottView = [UIView new];
    qitaBottView.backgroundColor = [UIColor whiteColor];
    
    UILabel *danbaoLabel = [UILabel new];
    UILabel *changhuanLabel = [UILabel new];
    UILabel *diyaLabel = [UILabel new];
    UILabel *pingzhenLabel = [UILabel new];
    UILabel *zhaiwurenLabel = [UILabel new];
    
    [qitaView addSubview:qitaLabel];
    
    [self.changeView addSubview:qitaView];
    [self.changeView addSubview:qitaBottView];
    
    [self.changeView addSubview:line1];
    [self.changeView addSubview:line2];
    [self.changeView addSubview:line3];
    
    [qitaBottView addSubview:danbaoLabel];
    [qitaBottView addSubview:changhuanLabel];
    [qitaBottView addSubview:diyaLabel];
    [qitaBottView addSubview:pingzhenLabel];
    [qitaBottView addSubview:zhaiwurenLabel];
    
    
    qitaBottView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(line2,0);
    [qitaBottView setupAutoHeightWithBottomView:zhaiwurenLabel bottomMargin:15];
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label14,15)
    .heightIs(10);
    
    qitaView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    qitaLabel.sd_layout.leftSpaceToView(qitaView,15)
    .centerYEqualToView(qitaView)
    .heightIs(20);
    [qitaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(qitaView,0)
    .heightIs(1);
    
    line3.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightIs(10)
    .topSpaceToView(qitaBottView,15);
    
    danbaoLabel.sd_layout.leftSpaceToView(qitaBottView,15)
    .topSpaceToView(qitaBottView,15)
    .heightIs(20);
    [danbaoLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    changhuanLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(danbaoLabel,15)
    .heightIs(20);
    [changhuanLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    diyaLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(changhuanLabel,15)
    .heightIs(20);
    [diyaLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    pingzhenLabel.sd_layout.leftEqualToView(diyaLabel)
    .topSpaceToView(diyaLabel,15)
    .heightIs(20);
    [pingzhenLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    zhaiwurenLabel.sd_layout.leftEqualToView(diyaLabel)
    .topSpaceToView(pingzhenLabel,15)
    .heightIs(20);
    [zhaiwurenLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    
    
    if ([self.model.Guaranty isEqualToString:@""]) {
        self.model.Guaranty = @"未填写";
    }
    if ([self.model.Pay isEqualToString:@""]) {
        self.model.Pay = @"未填写";
    }
    if ([self.model.Property isEqualToString:@""]) {
        self.model.Property = @"未填写";
    }
    if ([self.model.Credentials isEqualToString:@""]) {
        self.model.Credentials = @"未填写";
    }
    if ([self.model.Connect isEqualToString:@""]) {
        self.model.Connect = @"未填写";
    }
    
    //    NSString *text =[@"a" stringByAppendingString:self.model.Connect];
    danbaoLabel.text = [@"有无担保：" stringByAppendingString:self.model.Guaranty];
    changhuanLabel.text = [@"债务人有偿还能力："stringByAppendingString:self.model.Pay];
    diyaLabel.text = [@"有无抵押："stringByAppendingString:self.model.Property];
    pingzhenLabel.text = [@"相关凭证齐是否全："stringByAppendingString:self.model.Credentials];
    zhaiwurenLabel.text = [@"债务人是否失联："stringByAppendingString:self.model.Connect];
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UILabel *button3 = [UILabel new];
    UILabel *button4 = [UILabel new];
    
    UIView *line4 = [UIView new];
    
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    [liangdianBottomView addSubview:button3];
    [liangdianBottomView addSubview:button4];
    
    liangdianTopView.sd_layout.leftEqualToView(line3)
    .rightEqualToView(line3)
    .topSpaceToView(line3,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.leftSpaceToView(liangdianTopView,15)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    liandianLabel.font = [UIFont boldSystemFontOfSize:17];
    
    line4.sd_layout.leftEqualToView(liangdianTopView)
    .rightEqualToView(liangdianTopView)
    .heightIs(1)
    .topSpaceToView(liangdianTopView,0);
    
    line4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:35];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line4,0);
    
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    button3.sd_layout.leftSpaceToView(button2,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    
    [button3 setSingleLineAutoResizeWithMaxWidth:200];
    
    button4.sd_layout.topSpaceToView(button1,15)
    .leftEqualToView(button1)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    
    [button4 setSingleLineAutoResizeWithMaxWidth:200];
    
    NSArray *proArr = [self.model.ProLabel componentsSeparatedByString:@","];
    if (proArr.count == 0) {
        [button1 setHidden:YES];
        
//        button1.text = @"暂无项目亮点";
        [button2 setHidden:YES];
        line3.sd_layout.heightIs(0);
        [line4 setHidden:YES];
        liangdianTopView.sd_layout.heightIs(0);
        liangdianBottomView.sd_layout.heightIs(0);
        [self.changeView setupAutoHeightWithBottomView:qitaBottView bottomMargin:0];
        
    }
    else if(proArr.count == 1)
    {
        if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
            [button1 setHidden:YES];
            //line3.sd_layout.heightIs(0);
            [line4 setHidden:YES];
            liangdianTopView.sd_layout.heightIs(0);
            liangdianBottomView.sd_layout.heightIs(0);
            [self.changeView setupAutoHeightWithBottomView:qitaBottView bottomMargin:0];
            button1.text = @"暂无项目亮点";
        }
        else
        {
            button1.text = proArr[0];
            [button2 setHidden:YES];
        }
    }
    
    else if(proArr.count == 2)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        
    }
    else if(proArr.count == 3)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        button3.text = proArr[2];
        
    }
    else if(proArr.count == 4)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        button3.text = proArr[2];
        button4.text = proArr[3];
        
    }
    
    [self setliangdianLabel:button1];
    [self setliangdianLabel:button2];
    [self setliangdianLabel:button3];
    [self setliangdianLabel:button4];
    
}
- (void)HouseProductionView
{
    if (self.model.PictureDet == nil || [self.model.PictureDet isEqualToString:@""]) {
        
    }
    else
    {
        self.xiangmuView.sd_layout.leftEqualToView(self.audioView)
        .rightEqualToView(self.audioView)
        .heightIs(50)
        .topSpaceToView(self.audioView,10);
        
       
        
//        self.tapImageView.sd_layout.leftSpaceToView(self.scrollView,10)
//        .rightSpaceToView(self.scrollView,10)
//        .heightIs((self.scrollView.bounds.size.width -20)*self.tapImageView.image.size.height/self.tapImageView.image.size.width)
//        .topSpaceToView(self.xiangmuView,0);
        [self ifExistImage];
        
        
        [self.xiangmuLabel setHidden:NO];
        [self.tapLabel setHidden:NO];
        [self.ziyaIma setHidden:NO];
//        [self.tapImageView sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.PictureDet]]];

    }
    
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    UILabel *label13 = [UILabel new];
    UILabel *label14 = [UILabel new];
    UILabel *label15 = [UILabel new];
    UILabel *label16 = [UILabel new];
    UILabel *label17 = [UILabel new];
    UILabel *label18 = [UILabel new];
    UILabel *label19 = [UILabel new];
    UILabel *label20 = [UILabel new];
    
    UILabel *label21 = [UILabel new];
    UILabel *label22 = [UILabel new];
    UILabel *label23 = [UILabel new];
    UILabel *label24 = [UILabel new];
    UILabel *wan1 = [UILabel new];
    UILabel *wan2 = [UILabel new];
    
    
    UIImageView *ima1 = [UIImageView new];
    UIImageView *ima2 = [UIImageView new];

    
    label1.textColor = [UIColor grayColor];
    label3.textColor = [UIColor grayColor];
    label5.textColor = [UIColor grayColor];
    label7.textColor = [UIColor grayColor];
    label9.textColor = [UIColor grayColor];
    label11.textColor = [UIColor grayColor];
    label13.textColor = [UIColor grayColor];
    label15.textColor = [UIColor grayColor];
    label17.textColor = [UIColor grayColor];
    label19.textColor = [UIColor grayColor];
    
    label21.textColor = [UIColor grayColor];
    label23.textColor = [UIColor grayColor];
    
    
    
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    [self.changeView addSubview:label13];
    [self.changeView addSubview:label14];
    [self.changeView addSubview:label15];
    [self.changeView addSubview:label16];
    [self.changeView addSubview:label17];
    [self.changeView addSubview:label18];
    [self.changeView addSubview:label19];
    [self.changeView addSubview:label20];
    
    [self.changeView addSubview:label21];
    [self.changeView addSubview:label22];
    [self.changeView addSubview:label23];
    [self.changeView addSubview:label24];

    [self.changeView addSubview:ima1];
    [self.changeView addSubview:ima2];
    [self.changeView addSubview:wan1];
    [self.changeView addSubview:wan2];
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label6,15)
    .heightIs(20);
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label8.sd_layout.leftSpaceToView(label7,0)
    .topEqualToView(label7)
    .heightIs(20);
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    
    label9.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,15)
    .heightIs(20);
    
    label10.sd_layout.leftSpaceToView(label9,0)
    .topEqualToView(label9)
    .heightIs(20);
    
    

    
    label11.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(20);
 
    
    label12.sd_layout.leftSpaceToView(ima1,7.5)
    .centerYEqualToView(ima1)
    .heightIs(20);
    
    
    label13.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label11,15)
    .heightIs(20);
    
    
    
    label14.sd_layout.leftSpaceToView(ima2,7.5)
    .centerYEqualToView(ima2)
    .heightIs(20);
    
    label15.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label13,15)
    .heightIs(20);
    
    label16.sd_layout.leftSpaceToView(label15,0)
    .topEqualToView(label15)
    .heightIs(20);
    
    
    label17.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label15,15)
    .heightIs(20);
    
    label18.sd_layout.leftSpaceToView(label17,0)
    .topEqualToView(label17)
    .heightIs(20);
    
    ima1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(24)
    .widthIs(85);
    ima2.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label11,15)
    .heightIs(24)
    .widthIs(85);
    ima1.image = [UIImage imageNamed:@"shichangjia2"];
    ima2.image = [UIImage imageNamed:@"zhuangrangjia2"];
    
    wan1.sd_layout.leftSpaceToView(label12,0)
    .bottomEqualToView(ima1)
    .heightIs (22);
    wan1.text = @"万元";
    [wan1 setTextColor:[UIColor colorWithHexString:@"ef8200"]];
    
    [wan1 setSingleLineAutoResizeWithMaxWidth:100];
    
    
    wan2.sd_layout.leftSpaceToView(label14,0)
    .bottomEqualToView(ima2)
    .heightIs (22);
    wan2.text = @"万元";
    [wan2 setTextColor:[UIColor colorWithHexString:@"ef8200"]];
    [wan2 setSingleLineAutoResizeWithMaxWidth:100];

    label18.font = [UIFont systemFontOfSize:20];

//    label19.sd_layout.leftSpaceToView(self.changeView,15)
//    .topSpaceToView(label17,15)
//    .heightIs(20);
//    
//    label20.sd_layout.leftSpaceToView(label19,0)
//    .topEqualToView(label19)
//    .heightIs(20);
//    
//    label21.sd_layout.leftSpaceToView(self.changeView,15)
//    .topSpaceToView(label19,15)
//    .heightIs(20);
//    
//    label22.sd_layout.leftSpaceToView(label21,0)
//    .topEqualToView(label21)
//    .heightIs(20);
//    
//    label23.sd_layout.leftSpaceToView(self.changeView,15)
//    .topSpaceToView(label21,15)
//    .heightIs(20);
//    
//    label24.sd_layout.leftSpaceToView(label23,0)
//    .topEqualToView(label23)
//    .heightIs(20);
//    
    
    
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    [label13 setSingleLineAutoResizeWithMaxWidth:200];
    [label14 setSingleLineAutoResizeWithMaxWidth:200];
    [label15 setSingleLineAutoResizeWithMaxWidth:200];
    [label16 setSingleLineAutoResizeWithMaxWidth:200];
    [label17 setSingleLineAutoResizeWithMaxWidth:200];
    [label18 setSingleLineAutoResizeWithMaxWidth:200];
    [label19 setSingleLineAutoResizeWithMaxWidth:200];
    [label20 setSingleLineAutoResizeWithMaxWidth:200];
    
    [label21 setSingleLineAutoResizeWithMaxWidth:200];
    [label22 setSingleLineAutoResizeWithMaxWidth:200];
    [label23 setSingleLineAutoResizeWithMaxWidth:200];
    [label24 setSingleLineAutoResizeWithMaxWidth:200];

    
    label1.text = @"发布方身份：";
    label2.text = self.model.Identity;
    
    label3.text = @"标的物类型：";
    label4.text = self.model.AssetType;

    label5.text = @"地区：";
    label6.text =self.model.ProArea;
    
    label7.text = @"房产类型：";
    label8.text = self.model.Type;
    
//    label9.text = @"规划用途：";
//    label10.text = self.model.Usefor;
    
    label9.text = @"面积：";
    label10.text = [self.model.Area stringByAppendingString:@"平米"];
    
//    label13.text = @"剩余使用年限：";
//    label14.text = [self.model.Year stringByAppendingString:@"年"];
    
//    label15.text = @"转让方式：";
//    label16.text = self.model.TransferType;
    
//    label11.text = @"参考市价：";
//    label12.text = [self.model.MarketPrice stringByAppendingString:@"万"];
//    label12.textColor = [UIColor colorWithHexString:@"#ef8200"];
//    label12.font = [UIFont boldSystemFontOfSize:20];
//    label13.text = @"市场单价：";
//    label14.text = [[NSString stringWithFormat:@"%.2f",self.model.MarketPrice.floatValue/self.model.Area.floatValue]stringByAppendingString:@"万元/平米"];
//
//    label15.text = @"意向转让价：";
//
//    label16.text = [self.model.TransferMoney stringByAppendingString:@"万"];
//    label16.textColor = [UIColor colorWithHexString:@"#ef8200"];
//    label16.font = [UIFont systemFontOfSize:20];
//    
//    label17.text = @"意向转让单价：";
//    label18.text = [[NSString stringWithFormat:@"%.2f",self.model.TransferMoney.floatValue/self.model.Area.floatValue]stringByAppendingString:@"万元/平米"];
    
    
    label11.text = @"市场价格：";
    label12.text = self.model.MarketPrice;
    label12.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label12.font = [UIFont boldSystemFontOfSize:20];
    label13.text = @"转让价：";
    label14.text = self.model.TransferMoney;
    label14.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label14.font = [UIFont boldSystemFontOfSize:20];

    
    label15.text = @"市场单价：";
    
    label16.text =[[NSString stringWithFormat:@"%.2f",self.model.MarketPrice.floatValue/self.model.Area.floatValue]stringByAppendingString:@"万元/平米"];
    label16.font = [UIFont systemFontOfSize:20];
    
    label17.text = @"转让单价：";
    label18.text = [[NSString stringWithFormat:@"%.2f",self.model.TransferMoney.floatValue/self.model.Area.floatValue]stringByAppendingString:@"万元/平米"];
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    
    //    line1.backgroundColor = [UIColor redColor];
    //    line2.backgroundColor = [UIColor blueColor];
    //    line3.backgroundColor = [UIColor blackColor];
    UIView *qitaView = [UIView new];
    UILabel *qitaLabel = [UILabel new];
    qitaLabel.text = @"其他信息";
    qitaLabel.font = [UIFont boldSystemFontOfSize:17];
    
    qitaView.backgroundColor = [UIColor whiteColor];
    
    UIView *qitaBottView = [UIView new];
    qitaBottView.backgroundColor = [UIColor whiteColor];
    
    UILabel *danbaoLabel = [UILabel new];
    UILabel *changhuanLabel = [UILabel new];
    UILabel *diyaLabel = [UILabel new];
    UILabel *pingzhenLabel = [UILabel new];
    UILabel *zhaiwurenLabel = [UILabel new];
    
    [qitaView addSubview:qitaLabel];
    
//    [self.changeView addSubview:qitaView];
//    [self.changeView addSubview:qitaBottView];
//    
    [self.changeView addSubview:line1];
//    [self.changeView addSubview:line2];
//    [self.changeView addSubview:line3];
//    
    [qitaBottView addSubview:danbaoLabel];
    [qitaBottView addSubview:changhuanLabel];
    [qitaBottView addSubview:diyaLabel];
    [qitaBottView addSubview:pingzhenLabel];
    [qitaBottView addSubview:zhaiwurenLabel];
    
    
    qitaBottView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(line2,0);
    [qitaBottView setupAutoHeightWithBottomView:zhaiwurenLabel bottomMargin:15];
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label17,15)
    .heightIs(10);
    
    qitaView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    qitaLabel.sd_layout.leftSpaceToView(qitaView,15)
    .centerYEqualToView(qitaView)
    .heightIs(20);
    
    [qitaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(qitaView,0)
    .heightIs(1);
    
    line3.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightIs(10)
    .topSpaceToView(qitaBottView,15);
    
    danbaoLabel.sd_layout.leftSpaceToView(qitaBottView,15)
    .topSpaceToView(qitaBottView,15)
    .heightIs(20);
    [danbaoLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    changhuanLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(danbaoLabel,15)
    .heightIs(20);
    [changhuanLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    diyaLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(changhuanLabel,15)
    .heightIs(20);
    [diyaLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    pingzhenLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(diyaLabel,15)
    .heightIs(20);
    [pingzhenLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    zhaiwurenLabel.sd_layout.leftEqualToView(diyaLabel)
    .topSpaceToView(pingzhenLabel,15)
    .heightIs(20);
    [zhaiwurenLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    if ([self.model.Credentials isEqualToString:@""]) {
        self.model.Credentials = @"未填写";
    }
    if ([self.model.Guaranty isEqualToString:@""]) {
        self.model.Guaranty = @"未填写";
    }
    if ([self.model.Dispute isEqualToString:@""]) {
        self.model.Dispute = @"未填写";
    }
    if ([self.model.Property isEqualToString:@""]) {
        self.model.Property = @"未填写";
    }
    if ([self.model.Debt isEqualToString:@""]) {
        self.model.Debt = @"未填写";
    }
    
    //    NSString *teon = [@"aa" stringByAppendingString:self.model.Dispute];
    danbaoLabel.text = [@"有无相关证件："stringByAppendingString:self.model.Credentials];
    changhuanLabel.text = [@"有无担保抵押："stringByAppendingString:self.model.Guaranty];
    diyaLabel.text = [@"有无法律纠纷："stringByAppendingString:self.model.Dispute];
    pingzhenLabel.text = [@"是否拥有全部产权："stringByAppendingString:self.model.Property];
    zhaiwurenLabel.text = [@"有无负债："stringByAppendingString:self.model.Debt];
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UILabel *button3 = [UILabel new];
    UILabel *button4 = [UILabel new];
    
    UIView *line4 = [UIView new];
    
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    [liangdianBottomView addSubview:button3];
    [liangdianBottomView addSubview:button4];
    liangdianTopView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.leftSpaceToView(liangdianTopView,15)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    liandianLabel.font = [UIFont boldSystemFontOfSize:17];
    
    line4.sd_layout.leftEqualToView(liangdianTopView)
    .rightEqualToView(liangdianTopView)
    .heightIs(1)
    .topSpaceToView(liangdianTopView,0);
    
    line4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:10];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(80)
    .topSpaceToView(line4,0);
    

    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    button3.sd_layout.leftSpaceToView(button2,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button3 setSingleLineAutoResizeWithMaxWidth:200];
    
    button4.sd_layout.topSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .leftEqualToView(button1)
    .heightIs(20);
    [button4 setSingleLineAutoResizeWithMaxWidth:200];
    
    NSArray *proArr = [self.model.ProLabel componentsSeparatedByString:@","];
    NSLog(@"%ld",proArr.count);
    if (proArr.count == 0) {
        [button1 setHidden:YES];
        
//        button1.text = @"暂无项目亮点";
        [button2 setHidden:YES];
        [line1 setHidden:YES];
        [line2 setHidden:YES];
        [line4 setHidden:YES];
        [liandianLabel setHidden:YES];
        
        [liandianLabel setHidden:YES];
        liangdianTopView.sd_layout.leftEqualToView(line1)
        .rightEqualToView(line1)
        .topSpaceToView(line1,0)
        .heightIs(0);
        
        liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
        .rightSpaceToView(self.changeView,0)
        .heightIs(0)
        .topSpaceToView(line4,0);
        [self.changeView setupAutoHeightWithBottomView:label18 bottomMargin:20];
    }
    else if(proArr.count == 1)
    {
        if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
            [button1 setHidden:YES];
//            button1.text = @"暂无项目亮点";
            [line1 setHidden:YES];
            [line2 setHidden:YES];
            [line4 setHidden:YES];
            [liandianLabel setHidden:YES];
            
            [liandianLabel setHidden:YES];
            liangdianTopView.sd_layout.leftEqualToView(line1)
            .rightEqualToView(line1)
            .topSpaceToView(line1,0)
            .heightIs(0);
            
            liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
            .rightSpaceToView(self.changeView,0)
            .heightIs(0)
            .topSpaceToView(line4,0);
            [self.changeView setupAutoHeightWithBottomView:label18 bottomMargin:20];
        }
        else
        {
            button1.text = proArr[0];
            [button2 setHidden:YES];
        }
    }
    
    else if(proArr.count == 2)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        
        
    }
    else if(proArr.count == 3)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        button3.text = proArr[2];
    }
    
    else if(proArr.count == 4)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        button3.text = proArr[2];
        button4.text = proArr[3];
        
    }
    
    [self setliangdianLabel:button1];
    [self setliangdianLabel:button2];
    [self setliangdianLabel:button3];
    [self setliangdianLabel:button4];
    
    
}
- (void)landProductionView
{
    if (self.model.PictureDet == nil || [self.model.PictureDet isEqualToString:@""]) {
        
    }
    else
    {
        self.xiangmuView.sd_layout.leftEqualToView(self.audioView)
        .rightEqualToView(self.audioView)
        .heightIs(50)
        .topSpaceToView(self.audioView,10);
//        self.tapImageView.sd_layout.leftEqualToView(self.xiangmuView)
//        .rightEqualToView(self.xiangmuView)
//        .heightIs((self.scrollView.bounds.size.width -20)*self.tapImageView.image.size.height/self.tapImageView.image.size.width)
//        .topSpaceToView(self.xiangmuView,0);
        [self ifExistImage];
        [self.xiangmuLabel setHidden:NO];
        [self.tapLabel setHidden:NO];
        [self.ziyaIma setHidden:NO];
//        [self.tapImageView sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.PictureDet]]];

    }

    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    UILabel *label13 = [UILabel new];
    UILabel *label14 = [UILabel new];
    UILabel *label15 = [UILabel new];
    UILabel *label16 = [UILabel new];
    
    UILabel *label17 = [UILabel new];
    UILabel *label18 = [UILabel new];
    
    UIImageView *ima1 = [UIImageView new];
    ima1.image = [UIImage imageNamed:@"zhuangrangjia2"];
    UILabel *wan = [UILabel new];
    wan.text = @"万";
    
    label1.textColor = [UIColor grayColor];
    label3.textColor = [UIColor grayColor];
    label5.textColor = [UIColor grayColor];
    //    label6.textColor = [UIColor grayColor];
    label7.textColor = [UIColor grayColor];
    label9.textColor = [UIColor grayColor];
    label11.textColor = [UIColor grayColor];
    label13.textColor = [UIColor grayColor];
    label15.textColor = [UIColor grayColor];
    label17.textColor = [UIColor grayColor];
    
    
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    [self.changeView addSubview:label13];
    [self.changeView addSubview:label14];
    [self.changeView addSubview:label15];
    [self.changeView addSubview:label16];
    [self.changeView addSubview:label17];
    [self.changeView addSubview:label18];
    [self.changeView addSubview:ima1];
    [self.changeView addSubview:wan];
    
    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label6,15)
    .heightIs(20);
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label8.sd_layout.leftSpaceToView(label7,0)
    .topEqualToView(label7)
    .heightIs(20);
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    
    label9.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,15)
    .heightIs(20);
    
    label10.sd_layout.leftSpaceToView(label9,0)
    .topEqualToView(label9)
    .heightIs(20);
    
    label11.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(20);
    
    label12.sd_layout.leftSpaceToView(label11,0)
    .topEqualToView(label11)
    .heightIs(20);
    
    
    label13.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label11,15)
    .heightIs(20);
    
    label14.sd_layout.leftSpaceToView(label13,0)
    .topEqualToView(label13)
    .heightIs(20);
    
    ima1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label13,15)
    .heightIs(24)
    .widthIs(85);
    
    
    label15.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label13,15)
    .heightIs(20);
    
    label16.sd_layout.leftSpaceToView(ima1,7.5)
    .centerYEqualToView(ima1)
    .heightIs(20);
    
    wan.sd_layout.leftSpaceToView(label16,0)
    .bottomEqualToView(ima1)
    .heightIs(20);
    
    [wan setSingleLineAutoResizeWithMaxWidth:50];
    wan.textColor = [UIColor colorWithHexString:@"#ef8200"];
    
    
    label17.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label15,15)
    .heightIs(20);
    
    label18.sd_layout.leftSpaceToView(label17,0)
    .topEqualToView(label17)
    .heightIs(20);
    
    
    
    
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    [label13 setSingleLineAutoResizeWithMaxWidth:200];
    [label14 setSingleLineAutoResizeWithMaxWidth:200];
    [label15 setSingleLineAutoResizeWithMaxWidth:200];
    [label16 setSingleLineAutoResizeWithMaxWidth:200];
    
    [label17 setSingleLineAutoResizeWithMaxWidth:200];
    [label18 setSingleLineAutoResizeWithMaxWidth:200];
    label1.text = @"发布方身份：";
    label2.text = self.model.Identity;
    
    label3.text = @"标的物类型：";
    label4.text = self.model.AssetType;
    
    label5.text = @"地区：";
    label6.text = self.model.ProArea;
    

    
    label7.text = @"规划用途：";
    label8.text = self.model.Usefor;
    
    label9.text = @"土地面积：";
    label10.text = [self.model.Area stringByAppendingString:@"平米"];
    
    label11.text = @"建筑面积：";
    
    label13.text = @"容积率：";
    self.model.FloorRatio = [NSString stringWithFormat:@"%@",self.model.FloorRatio];
    if (self.model.BuildArea.floatValue == 0) {
    label12.text = @"";
    }
    else
    {
        label12.text = [self.model.BuildArea stringByAppendingString:@"平米"];
    }
    if (self.model.FloorRatio == nil || [self.model.FloorRatio isEqualToString:@""] || [self.model.FloorRatio isEqualToString:@"0.00"]) {
        label14.text = @"";
    }
    else
    {
        label14.text = self.model.FloorRatio;

    }
    
    label15.text = @"转让价：";
    label16.text = self.model.TransferMoney;
    label16.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label16.font = [UIFont boldSystemFontOfSize:20];
//    
//    label17.text = @"转让单价：";
//    label18.text = [[NSString stringWithFormat:@"%.2f",self.model.TransferMoney.floatValue/self.model.Area.floatValue]stringByAppendingString:@"万元/平米"];
    
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    
    //    line1.backgroundColor = [UIColor redColor];
    //    line2.backgroundColor = [UIColor blueColor];
    //    line3.backgroundColor = [UIColor blackColor];
    UIView *qitaView = [UIView new];
    UILabel *qitaLabel = [UILabel new];
    qitaLabel.text = @"其他信息";
    qitaLabel.font = [UIFont boldSystemFontOfSize:17];
    
    qitaView.backgroundColor = [UIColor whiteColor];
    
    UIView *qitaBottView = [UIView new];
    qitaBottView.backgroundColor = [UIColor whiteColor];
    
    UILabel *danbaoLabel = [UILabel new];
    UILabel *changhuanLabel = [UILabel new];
    UILabel *diyaLabel = [UILabel new];
    UILabel *pingzhenLabel = [UILabel new];
    UILabel *zhaiwurenLabel = [UILabel new];
    
    [qitaView addSubview:qitaLabel];
    
//    [self.changeView addSubview:qitaView];
//    [self.changeView addSubview:qitaBottView];
//    
    [self.changeView addSubview:line1];
//    [self.changeView addSubview:line2];
//    [self.changeView addSubview:line3];
    
    [qitaBottView addSubview:danbaoLabel];
    [qitaBottView addSubview:changhuanLabel];
    [qitaBottView addSubview:diyaLabel];
    [qitaBottView addSubview:pingzhenLabel];
    [qitaBottView addSubview:zhaiwurenLabel];
    
    
    
    qitaBottView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(line2,0);
    [qitaBottView setupAutoHeightWithBottomView:zhaiwurenLabel bottomMargin:15];
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label17,15)
    .heightIs(10);
    
    qitaView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    qitaLabel.sd_layout.leftSpaceToView(qitaView,15)
    .centerYEqualToView(qitaView)
    .heightIs(20);
    [qitaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(qitaView,0)
    .heightIs(1);
    
    line3.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightIs(10)
    .topSpaceToView(qitaBottView,15);
    
    
    
    danbaoLabel.sd_layout.leftSpaceToView(qitaBottView,15)
    .topSpaceToView(qitaBottView,15)
    .heightIs(20);
    [danbaoLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    //    changhuanLabel.sd_layout.rightSpaceToView(qitaBottView,15)
    //    .topEqualToView(danbaoLabel)
    //    .heightIs(20);
    changhuanLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(danbaoLabel,15)
    .heightIs(20);
    [changhuanLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    
    diyaLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(changhuanLabel,15)
    .heightIs(20);
    [diyaLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    //    pingzhenLabel.sd_layout.rightSpaceToView(qitaBottView,15)
    //    .topEqualToView(diyaLabel)
    //    .heightIs(20);
    pingzhenLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(diyaLabel,15)
    .heightIs(20);
    [pingzhenLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    zhaiwurenLabel.sd_layout.leftEqualToView(pingzhenLabel)
    .topSpaceToView(pingzhenLabel,15)
    .heightIs(20);
    [zhaiwurenLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    
    if ([self.model.Credentials isEqualToString:@""]) {
        self.model.Credentials = @"未填写";
    }
    if ([self.model.Guaranty isEqualToString:@""]) {
        self.model.Guaranty = @"未填写";
    }
    if ([self.model.Dispute isEqualToString:@""]) {
        self.model.Dispute = @"未填写";
    }
    if ([self.model.Property isEqualToString:@""]) {
        self.model.Property = @"未填写";
    }
    if ([self.model.Debt isEqualToString:@""]) {
        self.model.Debt = @"未填写";
    }
    
    danbaoLabel.text = [@"有无相关证件："stringByAppendingString:self.model.Credentials];
    changhuanLabel.text = [@"有无担保抵押："stringByAppendingString:self.model.Guaranty];
    diyaLabel.text = [@"有无法律纠纷："stringByAppendingString:self.model.Dispute];
    pingzhenLabel.text = [@"是否拥有全部产权："stringByAppendingString:self.model.Property];
    zhaiwurenLabel.text = [@"有无负债："stringByAppendingString:self.model.Debt];
    
    
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    
    UILabel *button3 = [UILabel new];
    UILabel *button4 = [UILabel new];
    
    UIView *line4 = [UIView new];
    
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    [liangdianBottomView addSubview:button3];
    [liangdianBottomView addSubview:button4];
    
    liangdianTopView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.leftSpaceToView(liangdianTopView,15)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    liandianLabel.font = [UIFont boldSystemFontOfSize:17];
    
    line4.sd_layout.leftEqualToView(liangdianTopView)
    .rightEqualToView(liangdianTopView)
    .heightIs(1)
    .topSpaceToView(liangdianTopView,0);
    
    line4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:10];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line4,0);
    
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .topSpaceToView(liangdianBottomView,15)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .topSpaceToView(liangdianBottomView,15)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    button3.sd_layout.leftSpaceToView(button2,15)
    .topSpaceToView(liangdianBottomView,15)
    .heightIs(20);
    [button3 setSingleLineAutoResizeWithMaxWidth:200];
    
    button4.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .topSpaceToView(button1,15)
    .heightIs(20);
    [button4 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    
    NSArray *proArr = [self.model.ProLabel componentsSeparatedByString:@","];
    NSLog(@"%ld",proArr.count);
    
    
    if (proArr.count == 0) {
        [button1 setHidden:YES];
        
//        button1.text = @"暂无项目亮点";
        //        [button2 setHidden:YES];
//        line1.sd_layout.leftSpaceToView(self.changeView,0)
//        .rightSpaceToView(self.changeView,0)
//        .topSpaceToView(label17,15)
//        .heightIs(0);
        [line1 setHidden:YES];
        [line2 setHidden:YES];
        [line4 setHidden:YES];
        [liandianLabel setHidden:YES];
        
        [liandianLabel setHidden:YES];
        liangdianTopView.sd_layout.leftEqualToView(line1)
        .rightEqualToView(line1)
        .topSpaceToView(line1,0)
        .heightIs(0);
        
        liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
        .rightSpaceToView(self.changeView,0)
        .heightIs(0)
        .topSpaceToView(line4,0);
        [self.changeView setupAutoHeightWithBottomView:ima1 bottomMargin:20];
    }
    else if(proArr.count == 1)
    {
        if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
            [button1 setHidden:YES];
//            button1.text = @"暂无项目亮点";
//            line1.sd_layout.leftSpaceToView(self.changeView,0)
//            .rightSpaceToView(self.changeView,0)
//            .topSpaceToView(label17,15)
//            .heightIs(0);
            [line1 setHidden:YES];
            [line2 setHidden:YES];
            [line4 setHidden:YES];

            [liandianLabel setHidden:YES];

            liangdianTopView.sd_layout.leftEqualToView(line1)
            .rightEqualToView(line1)
            .topSpaceToView(line1,0)
            .heightIs(0);
            
            liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
            .rightSpaceToView(self.changeView,0)
            .heightIs(0)
            .topSpaceToView(line4,0);
            [self.changeView setupAutoHeightWithBottomView:ima1 bottomMargin:20];

        }
        else
        {
            button1.text = proArr[0];
            [button2 setHidden:YES];
        }
    }
    
    else if(proArr.count == 2)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        
    }
    else if(proArr.count == 3)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        button3.text = proArr[2];
        
    }
    else if(proArr.count == 4)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        button3.text = proArr[2];
        button4.text = proArr[3];
        
    }
    
    [self setliangdianLabel:button1];
    [self setliangdianLabel:button2];
    [self setliangdianLabel:button3];
    [self setliangdianLabel:button4];
    
}
- (void)businesssView
{
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    UILabel *label13 = [UILabel new];
    UILabel *label14 = [UILabel new];
    UILabel *label15 = [UILabel new];
    
    UILabel *label16 = [UILabel new];
    UILabel *label17 = [UILabel new];
    UILabel *label18 = [UILabel new];
    UILabel *label19 = [UILabel new];
    
    label1.textColor = [UIColor grayColor];
    label3.textColor = [UIColor grayColor];
    label5.textColor = [UIColor grayColor];
    label7.textColor = [UIColor grayColor];
    
    label9.textColor = [UIColor grayColor];
    label10.textColor = [UIColor grayColor];
    label12.textColor = [UIColor grayColor];
    label14.textColor = [UIColor grayColor];
    label16.textColor = [UIColor grayColor];
    label18.textColor = [UIColor grayColor];
    
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    [self.changeView addSubview:label13];
    [self.changeView addSubview:label14];
    [self.changeView addSubview:label15];
    
    [self.changeView addSubview:label16];
    
    [self.changeView addSubview:label17];
    
    [self.changeView addSubview:label18];
    
    [self.changeView addSubview:label19];
    
    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label5,15)
    .heightIs(20);
    
    label8.sd_layout.leftSpaceToView(label7,0)
    .topEqualToView(label7)
    .heightIs(20);
    
    label9.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,0)
    .heightIs(0);
    
    if (self.model.Law != nil && self.model.UnLaw != nil) {
        label10.sd_layout.leftSpaceToView(self.changeView,15)
        .topSpaceToView(label9,15)
        .heightIs(20);
        
        label11.sd_layout.leftSpaceToView(label10,0)
        .topEqualToView(label10)
        .heightIs(20);
        
        label12.sd_layout.leftSpaceToView(self.changeView,15)
        .topSpaceToView(label10,15)
        .heightIs(20);
        
        label13.sd_layout.leftSpaceToView(label12,0)
        .topEqualToView(label12)
        .heightIs(20);
    }
    if (self.model.Law != nil && self.model.UnLaw == nil) {
        label10.sd_layout.leftSpaceToView(self.changeView,15)
        .topSpaceToView(label9,15)
        .heightIs(20);
        
        label11.sd_layout.leftSpaceToView(label10,0)
        .topEqualToView(label10)
        .heightIs(20);
        
        label12.sd_layout.leftSpaceToView(self.changeView,15)
        .topSpaceToView(label10,0)
        .heightIs(0);
        
        label13.sd_layout.leftSpaceToView(label12,0)
        .topEqualToView(label12)
        .heightIs(0);
    }
    if (self.model.Law == nil && self.model.UnLaw != nil) {
        label10.sd_layout.leftSpaceToView(self.changeView,15)
        .topSpaceToView(label9,0)
        .heightIs(0);
        
        label11.sd_layout.leftSpaceToView(label10,0)
        .topEqualToView(label10)
        .heightIs(0);
        
        label12.sd_layout.leftSpaceToView(self.changeView,15)
        .topSpaceToView(label10,15)
        .heightIs(20);
        
        label13.sd_layout.leftSpaceToView(label12,0)
        .topEqualToView(label12)
        .heightIs(20);
    }
    label14.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label12,15)
    .heightIs(20);
    
    label15.sd_layout.leftSpaceToView(label14,0)
    .topEqualToView(label14)
    .heightIs(20);
    
    label16.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label14,15)
    .heightIs(20);
    
    label17.sd_layout.leftSpaceToView(label16,0)
    .topEqualToView(label16)
    .heightIs(20);
    
    label18.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label16,15)
    .heightIs(20);
    
    label19.sd_layout.leftSpaceToView(label18,0)
    .topEqualToView(label18)
    .heightIs(20);
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    [label13 setSingleLineAutoResizeWithMaxWidth:200];
    [label14 setSingleLineAutoResizeWithMaxWidth:200];
    [label15 setSingleLineAutoResizeWithMaxWidth:200];
    [label16 setSingleLineAutoResizeWithMaxWidth:200];
    [label17 setSingleLineAutoResizeWithMaxWidth:200];
    [label18 setSingleLineAutoResizeWithMaxWidth:200];
    [label19 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label1.text = @"发布方身份：";
    label2.text = self.model.Identity;
    label3.text = @"商账类型：";
    label4.text = self.model.AssetType;
    label5.text = @"债权金额：";
    label6.text = [self.model.Money stringByAppendingString:@"万"];
    label6.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label6.font = [UIFont systemFontOfSize:20];
    label7.text = @"逾期时间：";
    label8.text = [self.model.Month stringByAppendingString:@"个月"];
    label9.text = @"处置方式";
    
    label10.text = @"诉讼佣金比例：";
    if (self.model.Law != nil) {
        label11.text = self.model.Law;
    }
    
    label12.text = @"非诉催收佣金比例：";
    if (self.model.UnLaw != nil) {
        label13.text = self.model.UnLaw;
        
    }
    label14.text = @"债务方地区：";
    label15.text = self.model.ProArea;
    label16.text = @"债务方企业性质：";
    label17.text = self.model.Nature;
    label18.text = @"债务方经营状况：";
    label19.text = self.dataDic[@"Status"];
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    UIView *qitaView = [UIView new];
    UILabel *qitaLabel = [UILabel new];
    qitaLabel.text = @"其他信息";
    qitaLabel.font = [UIFont boldSystemFontOfSize:17];
    
    qitaView.backgroundColor = [UIColor whiteColor];
    
    UIView *qitaBottView = [UIView new];
    qitaBottView.backgroundColor = [UIColor whiteColor];
    
    UILabel *pingzheng = [UILabel new];
    UILabel *hangyeLabel = [UILabel new];
    UILabel *shesuLabel = [UILabel new];
    //    UILabel *pingzhenLabel = [UILabel new];
    //    UILabel *zhaiwurenLabel = [UILabel new];
    
    [qitaView addSubview:qitaLabel];
    
    [self.changeView addSubview:qitaView];
    [self.changeView addSubview:qitaBottView];
    
    [self.changeView addSubview:line1];
    [self.changeView addSubview:line2];
    [self.changeView addSubview:line3];
    
    [qitaBottView addSubview:pingzheng];
    [qitaBottView addSubview:hangyeLabel];
    [qitaBottView addSubview:shesuLabel];
    
    
    qitaBottView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(line2,0);
    [qitaBottView setupAutoHeightWithBottomView:hangyeLabel bottomMargin:15];
    
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label18,15)
    .heightIs(10);
    
    qitaView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    qitaLabel.sd_layout.leftSpaceToView(qitaView,15)
    .centerYEqualToView(qitaView)
    .heightIs(20);
    
    
    [qitaLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(qitaView,0)
    .heightIs(1);
    
    line3.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightIs(10)
    .topSpaceToView(qitaBottView,15);
    
    pingzheng.sd_layout.leftSpaceToView(qitaBottView,15)
    .topSpaceToView(qitaBottView,15)
    .heightIs(20);
    [pingzheng setSingleLineAutoResizeWithMaxWidth:500];
    
    hangyeLabel.sd_layout.leftEqualToView(pingzheng)
    .topSpaceToView(shesuLabel,15)
    .heightIs(20)
    .rightSpaceToView(qitaBottView,15);
    
    
    //    [hangyeLabel setSingleLineAutoResizeWithMaxWidth:];
    
    shesuLabel.sd_layout.leftEqualToView(pingzheng)
    .topSpaceToView(pingzheng,15)
    .heightIs(20);
    [shesuLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    
    if ([self.model.Guaranty isEqualToString:@""]) {
        self.model.Guaranty = @"未填写";
        
    }
    if ([self.model.Industry isEqualToString:@""]) {
        self.model.Industry = @"未填写";
        
    }
    if ([self.model.State isEqualToString:@""]) {
        self.model.State = @"未填写";
        
    }
    pingzheng.text = [@"有无债权相关凭证：" stringByAppendingString:self.model.Guaranty];
    hangyeLabel.text = [@"债务方行业："stringByAppendingString:self.model.Industry];
    shesuLabel.text = [@"债权涉诉情况："stringByAppendingString:self.model.State];
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UIView *line4 = [UIView new];
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    
    liangdianTopView.sd_layout.leftEqualToView(line3)
    .rightEqualToView(line3)
    .topSpaceToView(line3,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.leftSpaceToView(liangdianTopView,15)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    liandianLabel.font = [UIFont boldSystemFontOfSize:17];
    
    line4.sd_layout.leftEqualToView(liangdianTopView)
    .rightEqualToView(liangdianTopView)
    .heightIs(1)
    .topSpaceToView(liangdianTopView,0);
    
    line4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:35];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line4,0);
    
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    NSArray *proArr = [self.model.ProLabel componentsSeparatedByString:@","];
    if (proArr.count == 0) {
        [button1 setHidden:YES];
        
//        button1.text = @"暂无项目亮点";
        [button2 setHidden:YES];
        
//        [line1 setHidden:YES];
//        [line2 setHidden:YES];
        line3.sd_layout.heightIs(0);
        [line4 setHidden:YES];
        [liandianLabel setHidden:YES];
        liangdianTopView.sd_layout.heightIs(0);
        liangdianBottomView.sd_layout.heightIs(0);
        [self.changeView setupAutoHeightWithBottomView:qitaBottView bottomMargin:0];
    }
    else if(proArr.count == 1)
    {
        if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
            [button1 setHidden:YES];
//            button1.text = @"暂无项目亮点";
//            [line1 setHidden:YES];
//            [line2 setHidden:YES];
            line3.sd_layout.heightIs(0);
            [line4 setHidden:YES];
            [liandianLabel setHidden:YES];
            liangdianTopView.sd_layout.heightIs(0);
            liangdianBottomView.sd_layout.heightIs(0);
            [self.changeView setupAutoHeightWithBottomView:qitaBottView bottomMargin:0];
        }
        else
        {
            button1.text = proArr[0];
            [button2 setHidden:YES];
        }
    }
    
    else if(proArr.count == 2)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
    }
    [self setliangdianLabel:button1];
    [self setliangdianLabel:button2];
    
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:15];
    
}

- (void)finanCingGuquanView
{
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    UILabel *label13 = [UILabel new];
    UILabel *label14 = [UILabel new];
    UILabel *label15 = [UILabel new];
    UILabel *label16 = [UILabel new];
    
    label1.textColor = [UIColor grayColor];
    label3.textColor = [UIColor grayColor];
    label5.textColor = [UIColor grayColor];
    label7.textColor = [UIColor grayColor];
    label9.textColor = [UIColor grayColor];
    label11.textColor = [UIColor grayColor];
    label13.textColor = [UIColor grayColor];
    label15.textColor = [UIColor grayColor];
    
    
    
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    
    [self.changeView addSubview:label13];
    [self.changeView addSubview:label14];
    [self.changeView addSubview:label15];
    [self.changeView addSubview:label16];
    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label6,15)
    .heightIs(20);
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label8.sd_layout.leftSpaceToView(label7,0)
    .topEqualToView(label7)
    .heightIs(20);
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    
    label9.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,15)
    .heightIs(20);
    
    label10.sd_layout.leftSpaceToView(label9,0)
    .topEqualToView(label9)
    .heightIs(20);
    
    label11.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(20);
    
    label12.sd_layout.leftSpaceToView(label11,0)
    .topEqualToView(label11)
    .heightIs(20);
    
    
    label13.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label11,15)
    .heightIs(20);
    
    label14.sd_layout.leftSpaceToView(label13,0)
    .topEqualToView(label13)
    .heightIs(20);
    
    label15.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label13,15)
    .heightIs(20);
    
    label16.sd_layout.leftSpaceToView(label15,0)
    .topEqualToView(label15)
    .heightIs(20);
    
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    
    [label13 setSingleLineAutoResizeWithMaxWidth:200];
    [label14 setSingleLineAutoResizeWithMaxWidth:200];
    [label15 setSingleLineAutoResizeWithMaxWidth:200];
    [label16 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label1.text = @"发布方身份：";
    label2.text = self.model.Identity;
    label3.text = @"项目所在地：";
    label4.text = self.model.ProArea;
    label5.text = @"融资方式：";
    label6.text = self.model.AssetType;
    label7.text = @"融资金额：";
    label8.text = [self.model.TotalMoney stringByAppendingString:@"万"];
    label8.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label8.font = [UIFont systemFontOfSize:20];
    label9.text = @"出让股权比例：";
    label10.text = [self.model.Rate stringByAppendingString:@"%"];
    label11.text = @"企业现状：";
    label12.text = self.dataDic[@"Status"];
    label13.text = @"所属行业：";
    label14.text = self.model.Belong;
    label15.text = @"资金用途：";
    label16.text = self.model.Usefor;
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    //    line1.backgroundColor = [UIColor redColor];
    //    line2.backgroundColor = [UIColor blueColor];
    //    line3.backgroundColor = [UIColor blackColor];
    
    
    [self.changeView addSubview:line1];
    [self.changeView addSubview:line2];
    [self.changeView addSubview:line3];
    
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label15,15)
    .heightIs(10);
    
    
    
    
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UILabel *button3 = [UILabel new];
    UIView *line4 = [UIView new];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(liangdianTopView,0)
    .heightIs(1);
    
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    [liangdianBottomView addSubview:button3];
    
    
    liangdianTopView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.leftSpaceToView(liangdianTopView,15)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    liandianLabel.font = [UIFont boldSystemFontOfSize:17];
    
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:35];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line2,0);
    
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    button3.sd_layout.leftSpaceToView(button2,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button3 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    
    
    NSArray *proArr = [self.model.ProLabel componentsSeparatedByString:@","];
    if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
        [button1 setHidden:YES];
//        button1.text = @"暂无项目亮点";
        line1.sd_layout.heightIs(0);
        [line2 setHidden:YES];
        [liandianLabel setHidden:YES];
        liangdianTopView.sd_layout.heightIs(0);
        liangdianBottomView.sd_layout.heightIs(0);
        [self.changeView setupAutoHeightWithBottomView:label16 bottomMargin:20];
        
    }
    
    if (proArr.count == 0) {
        [button1 setHidden:YES];
        
//        button1.text = @"暂无项目亮点";
        [button2 setHidden:YES];
        
        line1.sd_layout.heightIs(0);
        [line2 setHidden:YES];
        [liandianLabel setHidden:YES];
        liangdianTopView.sd_layout.heightIs(0);
        liangdianBottomView.sd_layout.heightIs(0);
        [self.changeView setupAutoHeightWithBottomView:label16 bottomMargin:20];
    }
    else if(proArr.count == 1)
    {
        if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
            [button1 setHidden:YES];
//            button1.text = @"暂无项目亮点";
            
        }
        else
        {
            button1.text = proArr[0];
            [button2 setHidden:YES];
        }
    }
    
    else if(proArr.count == 2)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        
    }
    else if(proArr.count == 3)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        button3.text = proArr[2];
    }
    [self setliangdianLabel:button1];
    [self setliangdianLabel:button2];
    [self setliangdianLabel:button3];
}
- (void)finaCingZhaiquanView
{
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    label1.textColor = [UIColor grayColor];
    label3.textColor = [UIColor grayColor];
    label5.textColor = [UIColor grayColor];
    label7.textColor = [UIColor grayColor];
    label9.textColor = [UIColor grayColor];
    label11.textColor = [UIColor grayColor];
    
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label6,15)
    .heightIs(20);
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label8.sd_layout.leftSpaceToView(label7,0)
    .topEqualToView(label7)
    .heightIs(20);
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    
    label9.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,15)
    .heightIs(20);
    
    label10.sd_layout.leftSpaceToView(label9,0)
    .topEqualToView(label9)
    .heightIs(20);
    
    label11.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(20);
    
    label12.sd_layout.leftSpaceToView(label11,0)
    .topEqualToView(label11)
    .heightIs(20);
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    
    label1.text = @"发布方身份：";
    label2.text = self.model.Identity;
    label3.text = @"项目所在地：";
    label4.text = self.model.ProArea;
    label5.text = @"融资方式：";
    label6.text = self.model.AssetType;
    label7.text = @"担保方式：";
    label8.text = self.model.Type;
    label9.text = @"融资金额：";
    label10.text = [self.model.Money stringByAppendingString:@"万"];
    label10.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label10.font = [UIFont systemFontOfSize:20];
    label11.text = @"使用期限：";
    label12.text = [self.model.Month stringByAppendingString:@"个月"];
    
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    //    line1.backgroundColor = [UIColor redColor];
    //    line2.backgroundColor = [UIColor blueColor];
    //    line3.backgroundColor = [UIColor blackColor];
    
    
    
    [self.changeView addSubview:line1];
    [self.changeView addSubview:line2];
    [self.changeView addSubview:line3];
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label11,15)
    .heightIs(10);
    
    
    
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UILabel *button3 = [UILabel new];
    UIView *line4 = [UIView new];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(liangdianTopView,0)
    .heightIs(1);
    
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    [liangdianBottomView addSubview:button3];
    
    
    liangdianTopView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.leftSpaceToView(liangdianTopView,15)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    liandianLabel.font = [UIFont boldSystemFontOfSize:17];
    
    
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:35];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line2,0);
    
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    NSArray *proArr = [self.model.ProLabel componentsSeparatedByString:@","];
    if (proArr.count == 0) {
        [button1 setHidden:YES];
        
//        button1.text = @"暂无项目亮点";
        [button2 setHidden:YES];
        line1.sd_layout.heightIs(0);
        [line2 setHidden:YES];

        [liandianLabel setHidden:YES];
        liangdianTopView.sd_layout.heightIs(0);
        liangdianBottomView.sd_layout.heightIs(0);
        [self.changeView setupAutoHeightWithBottomView:label12 bottomMargin:20];
    }
    else if(proArr.count == 1)
    {
        if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
            [button1 setHidden:YES];
//            button1.text = @"暂无项目亮点";
            line1.sd_layout.heightIs(0);
            [line2 setHidden:YES];
            [liandianLabel setHidden:YES];
            liangdianTopView.sd_layout.heightIs(0);
            liangdianBottomView.sd_layout.heightIs(0);
            [self.changeView setupAutoHeightWithBottomView:label12 bottomMargin:20];

        }
        else
        {
            button1.text = proArr[0];
            [button2 setHidden:YES];
        }
    }
    
    else if(proArr.count == 2)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
    }
    [self setliangdianLabel:button1];
    [self setliangdianLabel:button2];
    
    
    
}
- (void)asetBackView
{
    if (self.model.PictureDet == nil || [self.model.PictureDet isEqualToString:@""] ) {
        
    }
    else
    {
    self.xiangmuView.sd_layout.leftEqualToView(self.audioView)
    .rightEqualToView(self.audioView)
    .heightIs(50)
    .topSpaceToView(self.audioView,10);
//    self.tapImageView.sd_layout.leftEqualToView(self.xiangmuView)
//    .rightEqualToView(self.xiangmuView)
//    .heightIs((self.scrollView.bounds.size.width -20)*self.tapImageView.image.size.height/self.tapImageView.image.size.width)
//    .topSpaceToView(self.xiangmuView,0);
        [self ifExistImage];
        
       
    [self.xiangmuLabel setHidden:NO];
    [self.tapLabel setHidden:NO];
    [self.ziyaIma setHidden:NO];
//    [self.tapImageView sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.model.PictureDet]]];

    }
    
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    UILabel *label13 = [UILabel new];
    UILabel *label14 = [UILabel new];
    UILabel *label15 = [UILabel new];
    UILabel *label16 = [UILabel new];
    
    UILabel *wan1 = [UILabel new];
    UILabel *wan2 = [UILabel new];
    
    
    UIImageView *ima1 = [UIImageView new];
    UIImageView *ima2 = [UIImageView new];
    

    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    [self.changeView addSubview:label13];
    [self.changeView addSubview:label14];
    [self.changeView addSubview:label15];
    [self.changeView addSubview:label16];
    [self.changeView addSubview:ima1];
    [self.changeView addSubview:ima2];
    [self.changeView addSubview:wan1];
    [self.changeView addSubview:wan2];
    
    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label6,15)
    .heightIs(20);
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label8.sd_layout.leftSpaceToView(label7,0)
    .topEqualToView(label7)
    .heightIs(20);
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    
    label9.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,15)
    .heightIs(20);
    
    ima1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,15)
    .heightIs(24)
    .widthIs(85);
    
    
    label10.sd_layout.leftSpaceToView(ima1,7.5)
    .topEqualToView(ima1)
    .heightIs(24);
    wan1.sd_layout.leftSpaceToView(label10,0)
    .bottomEqualToView(label10)
    .heightIs (22);
    wan1.text = @"万元";
    [wan1 setTextColor:[UIColor colorWithHexString:@"ef8200"]];
    
    [wan1 setSingleLineAutoResizeWithMaxWidth:100];
    
    label11.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(20);
    ima2.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(24)
    .widthIs(85);
    
    
    
    ima1.image = [UIImage imageNamed:@"zongjine2"];
    ima2.image = [UIImage imageNamed:@"zhuangrangjia2"];
    label12.sd_layout.leftSpaceToView(ima2,7.5)
    .topEqualToView(ima2)
    .heightIs(24);
    wan2.sd_layout.leftSpaceToView(label12,0)
    .bottomEqualToView(label12)
    .heightIs (22);
    wan2.text = @"万元";
    [wan2 setTextColor:[UIColor colorWithHexString:@"ef8200"]];
    [wan2 setSingleLineAutoResizeWithMaxWidth:100];

    label13.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label11,15)
    .heightIs(20);
    
    label14.sd_layout.leftSpaceToView(label13,0)
    .topEqualToView(label13)
    .heightIs(20);
    
    label15.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label13,15)
    .heightIs(20);
    
    label16.sd_layout.leftSpaceToView(label15,0)
    .topEqualToView(label15)
    .heightIs(20);
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    [label13 setSingleLineAutoResizeWithMaxWidth:200];
    [label14 setSingleLineAutoResizeWithMaxWidth:200];
    [label15 setSingleLineAutoResizeWithMaxWidth:200];
    [label16 setSingleLineAutoResizeWithMaxWidth:200];

    
    label1.text = @"发布方身份：";
    label2.text = self.model.Identity;
    label3.text = @"卖家类型：";
    label4.text = self.model.FromWhere;
    label5.text = @"资产包类型：";
    label6.text = self.model.AssetType;
    label7.text = @"地区：";
    label8.text = self.model.ProArea;
    label9.text = @"总金额：";
    label10.text = self.model.TotalMoney;
    label10.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label10.font = [UIFont boldSystemFontOfSize:20];
    
    
    label11.text = @"转让价：";
    label12.text = self.model.TransferMoney;
    label12.font = [UIFont boldSystemFontOfSize:20];
    label12.textColor = [UIColor colorWithHexString:@"#ef8200"];


    label13.text = @"本金：";
    if ([self.model.Money isEqualToString:@"0.00"] == NO)
    {
        label14.text = [self.model.Money stringByAppendingString:@"万元"];
    }
    label14.font = [UIFont systemFontOfSize:20];
    label15.text = @"利息：";
    if ([self.model.Rate isEqualToString:@"0.00"] == NO)
    {
        label16.text = [self.model.Rate stringByAppendingString:@"万元"];
    }
//    label16.text =[[NSString stringWithFormat:@"%.2f",self.model.TotalMoney.floatValue - self.model.Money.floatValue]stringByAppendingString:@"万元"];
//    label16.text = [self.model.Rate stringByAppendingString:@"万元"];
//    label16.textColor = [UIColor colorWithHexString:@"#ef8200"];
    label16.font = [UIFont systemFontOfSize:20];
    label1.textColor = [UIColor grayColor];
    label3.textColor = [UIColor grayColor];
    label5.textColor = [UIColor grayColor];
    label7.textColor = [UIColor grayColor];
    label9.textColor = [UIColor grayColor];
    label11.textColor = [UIColor grayColor];
    label13.textColor = [UIColor grayColor];
    label15.textColor = [UIColor grayColor];

    
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    //    line1.backgroundColor = [UIColor redColor];
    //    line2.backgroundColor = [UIColor blueColor];
    //    line3.backgroundColor = [UIColor blackColor];
    
    UIView *qitaView = [UIView new];
    UILabel *qitaLabel = [UILabel new];
    qitaLabel.text = @"其他信息";
    qitaLabel.font = [UIFont boldSystemFontOfSize:17];
    
    qitaView.backgroundColor = [UIColor whiteColor];
    
    UIView *qitaBottView = [UIView new];
    qitaBottView.backgroundColor = [UIColor whiteColor];
    
    UILabel *danbaoLabel = [UILabel new];
    UILabel *changhuanLabel = [UILabel new];
    UILabel *diyaLabel = [UILabel new];
    UILabel *pingzhenLabel = [UILabel new];
    UILabel *zhaiwurenLabel = [UILabel new];
    UILabel *diyawuLeiXing = [UILabel new];
    
    
//    [qitaView addSubview:qitaLabel];
//    
//    [self.changeView addSubview:qitaView];
//    [self.changeView addSubview:qitaBottView];
//    
    [self.changeView addSubview:line1];
//    [self.changeView addSubview:line2];
//    [self.changeView addSubview:line3];
    
    [qitaBottView addSubview:danbaoLabel];
    [qitaBottView addSubview:changhuanLabel];
    [qitaBottView addSubview:diyaLabel];
    [qitaBottView addSubview:pingzhenLabel];
    [qitaBottView addSubview:zhaiwurenLabel];
    [qitaBottView addSubview:diyawuLeiXing];
    
    
    
    qitaBottView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(line2,0);
    [qitaBottView setupAutoHeightWithBottomView:diyawuLeiXing bottomMargin:15];
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label15,15)
    .heightIs(10);
    
    qitaView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    qitaLabel.sd_layout.leftSpaceToView(qitaView,15)
    .centerYEqualToView(qitaView)
    .heightIs(20);
    [qitaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(qitaView,0)
    .heightIs(1);
    
    line3.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightIs(10)
    .topSpaceToView(qitaBottView,15);
    
    danbaoLabel.sd_layout.leftSpaceToView(qitaBottView,15)
    .topSpaceToView(qitaBottView,15)
    .heightIs(20);
    [danbaoLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    changhuanLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(danbaoLabel,15)
    .heightIs(20);
    [changhuanLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    diyaLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(changhuanLabel,15)
    .heightIs(20);
    [diyaLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    pingzhenLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(diyaLabel,15)
    .heightIs(20);
    [pingzhenLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    zhaiwurenLabel.sd_layout.leftEqualToView(diyaLabel)
    .topSpaceToView(pingzhenLabel,15)
    .heightIs(20);
    [zhaiwurenLabel setSingleLineAutoResizeWithMaxWidth:500];
    
    diyawuLeiXing.sd_layout.leftEqualToView(diyaLabel)
    .topSpaceToView(zhaiwurenLabel,15)
    .heightIs(20);
    [diyawuLeiXing setSingleLineAutoResizeWithMaxWidth:500];
    
    if ([self.model.Money isEqualToString:@""]) {
        self.model.Money = @"未填写";
        
    }
    if ([self.model.Report isEqualToString:@""]) {
        self.model.Report = @"未填写";
        
    }
    if ([self.model.Rate isEqualToString:@""]) {
        self.model.Rate = @"未填写";
        
    }
    if ([self.model.Time isEqualToString:@""]) {
        self.model.Time = @"未填写";
        
    }
    if ([self.model.Pawn isEqualToString:@""]) {
        self.model.Pawn = @"未填写";
        
    }
    
    danbaoLabel.text = [[@"本金："stringByAppendingString:self.model.Money]stringByAppendingString:@"万"] ;
    //    danbaoLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    //    danbaoLabel.font = [UIFont systemFontOfSize:20];
    
    changhuanLabel.text = [@"是否有尽调报告："stringByAppendingString:self.model.Report];
    diyaLabel.text = [[@"利息："stringByAppendingString:self.model.Rate]stringByAppendingString:@"万"];
    //    diyaLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    //    diyaLabel.font = [UIFont systemFontOfSize:20];
    
    pingzhenLabel.text = [@"出表时间："stringByAppendingString:self.model.Time];
    zhaiwurenLabel.text = [@"户数："stringByAppendingString:self.model.Time];
    diyawuLeiXing.text = [@"抵押物类型："stringByAppendingString:self.model.Pawn];
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UILabel *button3 = [UILabel new];
    UIView *line4 = [UIView new];
    
//    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    [liangdianBottomView addSubview:button3];
    
    
    liangdianTopView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.leftSpaceToView(liangdianTopView,15)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    liandianLabel.font = [UIFont boldSystemFontOfSize:17];
    
    line4.sd_layout.leftEqualToView(liangdianTopView)
    .rightEqualToView(liangdianTopView)
    .heightIs(1)
    .topSpaceToView(liangdianTopView,0);
    
    line4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:20];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line4,0);
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    button3.sd_layout.leftSpaceToView(button2,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button3 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    
    NSArray *proArr = [self.model.ProLabel componentsSeparatedByString:@","];
    if (proArr.count == 0) {
        [button1 setHidden:YES];
//        button1.text = @"暂无项目亮点";
        [button2 setHidden:YES];
        line1.sd_layout.heightIs(0);
        [line2 setHidden:YES];
        [line4 setHidden:YES];
        
        liangdianTopView.sd_layout.heightIs(0);
        liangdianBottomView.sd_layout.heightIs(0);
        [self.changeView setupAutoHeightWithBottomView:label15 bottomMargin:20];
        
    }
    else if(proArr.count == 1)
    {
        if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
            [button1 setHidden:YES];
//            button1.text = @"暂无项目亮点";
            line1.sd_layout.heightIs(0);
            [line2 setHidden:YES];
            [line4 setHidden:YES];
            [liandianLabel setHidden:YES];
            liangdianTopView.sd_layout.heightIs(0);
            liangdianBottomView.sd_layout.heightIs(0);
            [self.changeView setupAutoHeightWithBottomView:label15 bottomMargin:20];

        }
        else
        {
            button1.text = proArr[0];
            [button2 setHidden:YES];
        }
    }
    
    else if(proArr.count == 2)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        
    }
    else if(proArr.count == 3)
    {
        button1.text = proArr[0];
        button2.text = proArr[1];
        button3.text = proArr[2];
        
    }
    [self setliangdianLabel:button1];
    [self setliangdianLabel:button2];
    [self setliangdianLabel:button3];
    
}
- (void)ifExistImage
{

        NSString *absoluteString = [getImageURL stringByAppendingString:self.model.PictureDet];
        if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
            
        {
            UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
            
            if(!image)
                
            {
                //            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:absoluteString];
                NSData* data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:absoluteString]];
                image = [UIImage imageWithData:data];
                self.imageSize = image.size;
                self.tapImageView.sd_layout.leftEqualToView(self.xiangmuView)
                .rightEqualToView(self.xiangmuView)
                .heightIs((self.scrollView.bounds.size.width -20)*self.imageSize.height/self.imageSize.width)
                .topSpaceToView(self.xiangmuView,1);
            }
            
            if(image)
                
            {
                NSLog(@"!!!!!!%f",image.size.height);
                self.imageSize = image.size;
                self.tapImageView.sd_layout.leftEqualToView(self.xiangmuView)
                .rightEqualToView(self.xiangmuView)
                .heightIs((self.scrollView.bounds.size.width)*self.imageSize.height/self.imageSize.width)
                .topSpaceToView(self.xiangmuView,1);
                
                
            }
            
        }
    else
    {
        NSData* data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:absoluteString]];
       UIImage *image = [UIImage imageWithData:data];
        self.imageSize = image.size;
        self.tapImageView.sd_layout.leftEqualToView(self.xiangmuView)
        .rightEqualToView(self.xiangmuView)
        .heightIs((self.scrollView.bounds.size.width)*self.imageSize.height/self.imageSize.width)
        .topSpaceToView(self.xiangmuView,1);
    
    }


}
- (void)setliangdianLabel:(UILabel *)label
{
    
    if (label.text != nil && [label.text isEqualToString:@""]==NO) {
        label.text = [[@" "stringByAppendingString:label.text]stringByAppendingString:@" "];
    }
    label.font = [UIFont systemFontOfSize:15];
    label.layer.borderWidth = 1;
    label.textColor = [UIColor colorWithHexString:@"fdd000"];
    label.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    label.layer.cornerRadius = 4;
    label.layer.masksToBounds = YES;
//    label.backgroundColor = [UIColor colorWithHexString:@"#fef8d3"];
}

- (void)jubaoButtonAction:(UIButton *)button
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        TipTableViewController *tipVc = [[TipTableViewController alloc]init];
        tipVc.Type = @"1";
        self.model.ProjectID = [NSString stringWithFormat:@"%@",self.model.ProjectID];
        tipVc.ItemID = self.model.ProjectID;
        [self.navigationController pushViewController:tipVc animated:YES];
    }
    
}
- (void)tapImageViewAction:(UITapGestureRecognizer *)gesture
{
//    CLAmplifyView *amplifyView = [[CLAmplifyView alloc] initWithFrame:self.view.bounds andGesture:gesture andSuperView:self.scrollView];
//    [[UIApplication sharedApplication].keyWindow addSubview:amplifyView];
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = self.itemsArray2;
    photoBrower.currentIndex = gesture.view.tag;
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
