//
//  ChuzhiDetailController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/1.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ChuzhiDetailController.h"
#import "NewsModel.h"
#import "LoginController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface ChuzhiDetailController ()<UIWebViewDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NewsModel *model;
@property (nonatomic,assign) BOOL isCollected;
@property (nonatomic,strong) UIButton *collectButton;
@property (nonatomic,strong) UIButton *shareButton;

@end

@implementation ChuzhiDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    

    self.navigationItem.title = @"处置公告";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [shareButton addTarget:self action:@selector(didClickShareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.collectButton = collectButton;
    self.shareButton = shareButton;
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self getDetailData];
    
    }
- (void)setViews
{
    _scrollView = [UIScrollView new];
    _webView = [UIWebView new];
    UILabel *titleLabel = [UILabel new];
    UIView *laiyuanView = [UIView new];
    UILabel *laiyuanyuLabel = [UILabel new];
    UILabel *timeLabel = [UILabel new];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_webView];
    [_scrollView addSubview:titleLabel];
    [_scrollView addSubview:laiyuanView];
    [laiyuanView addSubview:laiyuanyuLabel];
    [laiyuanView addSubview:timeLabel];
    
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
//    _scrollView.sd_layout.leftSpaceToView(_scrollView,0)
//    .rightSpaceToView(_scrollView,0)
//    .topSpaceToView(laiyuanView,15);
    
    _webView.sd_layout.leftSpaceToView(_scrollView,15)
    .rightSpaceToView(_scrollView,15)
    .topSpaceToView(laiyuanView,15);
    
    
    
    
    titleLabel.sd_layout.topSpaceToView(_scrollView,30)
    .leftSpaceToView(_scrollView,15)
    .rightSpaceToView(_scrollView,15)
    .autoHeightRatio(0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.model.NewsTitle;
    titleLabel.font = [UIFont systemFontOfSize:21];
    
    laiyuanView.sd_layout.centerXEqualToView(_scrollView)
    .topSpaceToView(titleLabel,15)
    .heightIs(15);
    
    
    [laiyuanView setupAutoWidthWithRightView:timeLabel rightMargin:0];
    laiyuanyuLabel.sd_layout.leftSpaceToView(laiyuanView,0)
    .topSpaceToView(laiyuanView,0)
    .heightIs(15);
    [laiyuanyuLabel setSingleLineAutoResizeWithMaxWidth:300];
    laiyuanyuLabel.text = [@"来源于："stringByAppendingString:self.model.NewsAuthor];
    
    
    laiyuanyuLabel.font = [UIFont systemFontOfSize:14];
    
    timeLabel.sd_layout.leftSpaceToView(laiyuanyuLabel,25)
    .topEqualToView(laiyuanyuLabel)
    .heightIs(15);
    NSArray *textarr = [self.model.PublishTime componentsSeparatedByString:@" "];
    timeLabel.text = textarr[0];
    
    [timeLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    laiyuanyuLabel.textColor = [UIColor grayColor];
    
    timeLabel.textColor = [UIColor grayColor];
    
    NSString *htmlString = self.model.NewsContent;
    
    NSLog(@"%@",htmlString);
    
    NSString *html = [[[@"<head><style>img{max-width:375px !important;height:auto!important;margin:0 auto;width:100%!important;display:block;}</style></head>" stringByAppendingString:@"<body>"]stringByAppendingString:htmlString]stringByAppendingString:@"</body>"];
    
    _webView.delegate = self;
    _webView.scalesPageToFit = NO;
    _webView.scrollView.scrollEnabled = NO;
    [_webView loadHTMLString:html baseURL:nil];

}
- (void)getDetailData
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [NewsDetailURL stringByAppendingString:self.NewsID];
    if (token != nil) {
        URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.model = [[NewsModel alloc]init];
        NSDictionary *dic = [NSDictionary new];
        NSDictionary *dataDic = [NSDictionary new];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        dataDic = dic[@"data"];
        [self.model setValuesForKeysWithDictionary:dataDic];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        self.model.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
        if ([self.model.CollectFlag isEqualToString:@"1"]) {
            [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shouc"] forState:(UIControlStateNormal)];
            
        }
        else
        {
            [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucangxin"] forState:(UIControlStateNormal)];
        }

        [self setViews];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
    }];
    
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
        //    NSString *getURL = @"http://api.ziyawang.com/v1/service/list?access_token=token";
        NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
        [postdic setObject:access_token forKey:@"access_token"];
        //    [postdic setObject:token forKey:@"token"];
        
        [postdic setObject:self.NewsID forKey:@"itemID"];
        [postdic setObject:@"3" forKey:@"type"];
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

- (void)didClickShareButtonAction:(UIButton *)button
{
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    
    //    NSString *url = @"http://ziyawang.com/project/";
    NSString *url = @"http://api.ziyawang.com/v1/";
    self.NewsID = [NSString stringWithFormat:@"%@",self.NewsID];
    NSString *URL = [url stringByAppendingString:self.NewsID];
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
    NSString *str1 = self.model.NewsTitle;
    
    //    if (self.model.WordDes.length < 40) {
    //        str1 = self.model.WordDes;
    //    }
    //   else
    //   {
    //   str1 = [[self.model.WordDes substringToIndex:40]stringByAppendingString:@"..."];
    //   }
    
    
    NSString *str2 = self.model.Brief;
    //    if (self.model.WordDes.length > 40) {
    //        str2 = [[self.model.WordDes substringToIndex:40]stringByAppendingString:@"..."];
    //    }
    
    NSString *shareURL1 = @"http://ziyawang.com/project/";
    NSString *shareURL = [shareURL1 stringByAppendingString:self.NewsID];
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

#pragma mark----webview代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGRect frame = self.webView.frame;
    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    self.webView.frame = frame;
    [_scrollView setupAutoContentSizeWithBottomView:_webView bottomMargin:30];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
      
        //        [self.navigationController pushViewController:WebVC animated:YES];
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
        
    }
    
    
    return YES;
    
    
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
