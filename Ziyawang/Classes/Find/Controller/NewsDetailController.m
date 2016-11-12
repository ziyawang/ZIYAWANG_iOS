//
//  NewsDetailController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/1.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "NewsDetailController.h"
#import "UIView+SDAutoLayout.h"
#import "NewsModel.h"
#import "CommentModel.h"
#import "CommentsCell.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


#import "NSString+ZZAttributedMarkup.h"
#import "ZZAttributedMarkupActionLabel.h"
#import "NewWebViewController.h"

#import <WebKit/WebKit.h>
@interface NewsDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MBProgressHUDDelegate,UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,strong) NewsModel *model;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger startpage;
@property (nonatomic,strong) UIView *commentBackView;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,strong) UIView *mengban;

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UILabel *remenLabel;

@property (nonatomic,strong) UIView *HeadView;




@end

@implementation NewsDetailController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资讯";
    self.view.backgroundColor = [UIColor whiteColor];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self registerForKeyboardNotifications];

//    UIButton *rightBarButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [rightBarButton setFrame:CGRectMake(0,0 , 25, 25)];
//    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
//    [rightBarButton addTarget:self action:@selector(didClickShareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
    [self getDetailData];
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
        [self setHeadView];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
    }];
    
}
- (void)setHeadView
{
    self.HeadView = [UIView new];
    UIView *lineView = [UIView new];
    
    UILabel *TitleLabel = [UILabel new];
    TitleLabel.font = [UIFont systemFontOfSize:20];
    UILabel *fromLabel = [UILabel new];
    
    UILabel *timeLabel = [UILabel new];
    UILabel *zhaiyao = [UILabel new];
    
    UILabel *briefLabel = [UILabel new];
    self.remenLabel = [UILabel new];
    
    UIButton *shareButton = [UIButton new];
    UILabel *shareLabel = [UILabel new];
    
//   self.webView = [UIWebView new];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,100)];
//s
    
//    self.webView.sd_layout.leftSpaceToView(view,20)
//    .rightSpaceToView(view,20)
//    .topSpaceToView(lineView,20)
//    .heightIs(0);
    
 
    
    self.HeadView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
    self.tableView = [UITableView new];
    self.textView.delegate = self;
    self.textView.textColor = [UIColor darkGrayColor];
    self.textView.text = @"请输入评论内容";
    [self.tableView registerClass:[CommentsCell class] forCellReuseIdentifier:@"CommentsCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    
    [self.HeadView addSubview:lineView];
    [self.HeadView addSubview:TitleLabel];
    [self.HeadView addSubview:fromLabel];
    [self.HeadView addSubview:timeLabel];
//    [view addSubview:zhaiyao];
//    [view addSubview:briefLabel];
    [self.HeadView addSubview:self.webView];
    [self.view addSubview:self.tableView];
    

    
    [self.HeadView addSubview:self.remenLabel];
    [self.HeadView addSubview:shareButton];
    [self.HeadView addSubview:shareLabel];
    
    
    
    
    //    [briefLabel addSubview:zhaiyao];
    
    self.HeadView.backgroundColor = [UIColor whiteColor];
    TitleLabel.text = self.model.NewsTitle;
    NSLog(@"%@",TitleLabel.text);
    fromLabel.text = @"来源:资芽网";
    fromLabel.textColor = [UIColor grayColor];
    
    timeLabel.text = self.NewsTime;
    timeLabel.textColor = [UIColor grayColor];
    zhaiyao.text = @"摘要：";
    zhaiyao.textColor = [UIColor redColor];
    
    NSString *htmlString = self.model.NewsContent;

    NSString *html = [[[@"<head><style>img{max-width:375px !important;height:auto!important;margin:0 auto;width:100%!important;display:block;}</style></head>" stringByAppendingString:@"<body>"]stringByAppendingString:htmlString]stringByAppendingString:@"</body>"];

    
    
//    webView.dataDetectorTypes = UIDataDetectorTypeAddress;
    
    

    NSMutableAttributedString * attrStr =  [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSInteger lengt = attrStr.length;
    NSLog(@"%@",attrStr);
    
    NSMutableDictionary *setAttrdic = [NSMutableDictionary new];
    [setAttrdic setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
//    [setAttrdic setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [attrStr addAttributes:setAttrdic range:NSMakeRange(0, lengt)];
    
//
    
//    [attrStr addAttributes:setAttrdic range:NSMakeRange(0, lengt)];
//    NSDictionary* style1 = @{
//                             @"body":@[[UIFont systemFontOfSize:18],[UIColor grayColor]],
//                             @"bold":[UIFont boldSystemFontOfSize:24],
//                             @"red": [UIColor redColor]
//                             };
    
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineHeightMultiple = 1.5;//行间距是多少倍
     [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, lengt)];
//    briefLabel.text = text;
    
    briefLabel.attributedText =  attrStr;

    
    //    setAttrdic setObject:[UIFont systemFontOfSize:14] forKey:<#(nonnull id<NSCopying>)#>
//    briefLabel.attributedText =  [htmlString attributedStringWithStyleBook:style1];
;
    
    fromLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.font = [UIFont systemFontOfSize:14];
    self.remenLabel.text = @"热门评论";
    self.remenLabel.textColor = [UIColor redColor];
    
    

//    [self.mengban setHidden:YES];
    
    self.HeadView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0);
    
  
    
    TitleLabel.sd_layout.leftSpaceToView(self.HeadView,20)
    .rightSpaceToView(self.HeadView,20)
    .topSpaceToView(self.HeadView,20)
    .heightIs(20)
    .autoHeightRatio(0);
    
    shareButton.sd_layout.rightSpaceToView(self.HeadView,20)
    .topSpaceToView(self.HeadView,50)
    .widthIs(25)
    .heightIs(25);
    
    shareLabel.sd_layout.topSpaceToView(shareButton,0)
    .centerXEqualToView(shareButton)
    .widthIs(30)
    .heightIs(15);
    shareLabel.font = [UIFont systemFontOfSize:11];
    shareLabel.textColor = [UIColor grayColor];
    shareLabel.text = @"分享";
    shareLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    [shareButton addTarget:self action:@selector(didClickShareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [shareButton setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    
    

    fromLabel.sd_layout.leftSpaceToView(self.HeadView,20)
    .topSpaceToView(TitleLabel,20)
    .heightIs(14);
    [fromLabel setSingleLineAutoResizeWithMaxWidth:100];

    timeLabel.sd_layout.topSpaceToView(TitleLabel,20)
    .leftSpaceToView(fromLabel,10)
    .heightIs(14);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    lineView.sd_layout.topSpaceToView(fromLabel,20)
    .leftSpaceToView(self.HeadView,20)
    .heightIs(1)
    .widthIs(self.view.bounds.size.width - 40);
    
    lineView.backgroundColor = [UIColor lightGrayColor];
  
    
    briefLabel.numberOfLines = 0;
    briefLabel.sd_layout.topSpaceToView(lineView,20)
    .leftSpaceToView(self.HeadView,20)
    .rightSpaceToView(self.HeadView,20)
    .autoHeightRatio(0);
    

    /**
     attributedContent才能准确识别，不设置会出现显示不全的状况
     */
    briefLabel.isAttributedContent = YES;
    
    
    
    zhaiyao.sd_layout.topEqualToView(briefLabel)
    .leftSpaceToView(briefLabel,0)
    .heightIs(20);
    [zhaiyao setSingleLineAutoResizeWithMaxWidth:100];
    
//    remenLabel.sd_layout.topSpaceToView(briefLabel,0)
//    .leftSpaceToView(view,20)
//    .heightIs(20);
//    [remenLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    
    
    self.remenLabel.sd_layout.topSpaceToView(self.webView,0)
    .leftSpaceToView(self.HeadView,20)
    .heightIs(20);
    
    [self.remenLabel setSingleLineAutoResizeWithMaxWidth:100];

    
    
    
    
    
    [self.HeadView setupAutoHeightWithBottomView:self.remenLabel bottomMargin:5];
    
    

    
    
    
    self.mengban = [UIView new];
    [self.view addSubview:self.mengban];
    self.mengban.backgroundColor = [UIColor blackColor];
    self.mengban.alpha = 0.5;
    [self.mengban setHidden:YES];

    
    
    self.mengban.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(700);
    
    
    self.tableView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    
    
    
    
    
    self.commentBackView = [UIView new];
    self.commentBackView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    self.textView = [UITextView new];
    self.textView.delegate = self;
    UIButton *sendButton = [UIButton new];
    [sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
    [sendButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    
    [sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.commentBackView addSubview:sendButton];
    [self.commentBackView addSubview:self.textView];
    [self.view addSubview:self.commentBackView];
    
    
    
    
    UIButton *commentButton = [UIButton new];
    UIView *pinglun = [UIView new];
    UIImageView *image = [UIImageView new];
    UILabel *label = [UILabel new];
    
    label.text = @"评论";
    label.font = [UIFont systemFontOfSize:14];
    image.image = [UIImage imageNamed:@"pen"];
    pinglun.userInteractionEnabled = NO;
    
    [commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [pinglun addSubview:image];
    [pinglun addSubview:label];
    
    
    commentButton.backgroundColor = [UIColor whiteColor];
    commentButton.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;

    [commentButton addSubview:pinglun];
    
//    [self.view addSubview:commentButton];
    
    
    
    commentButton.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(60);
    
    pinglun.sd_layout.centerXEqualToView(commentButton)
    .centerYEqualToView(commentButton)
    .heightIs(20)
    .widthIs(50);
    
    
    image.sd_layout.leftSpaceToView(pinglun,0)
    .topSpaceToView(pinglun,0)
    .heightIs(20)
    .widthIs(17)
    .centerYEqualToView(pinglun);
    
    label.sd_layout.leftSpaceToView(image,5)
    .topEqualToView(image)
    .heightIs(20)
    .widthIs(30)
    .centerYEqualToView(pinglun);
    
    self.commentBackView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(60);
    
    
    sendButton.sd_layout.rightSpaceToView(self.commentBackView,10)
    .centerYEqualToView(self.commentBackView)
    .widthIs(40)
    .heightIs(30);
    
    self.textView.sd_layout.leftSpaceToView(self.commentBackView,10)
    .centerYEqualToView(self.commentBackView)
    .rightSpaceToView(sendButton,10)
    .heightIs(40);
    
  
    self.textView.textColor = [UIColor darkGrayColor];
    self.textView.text = @"请输入评论内容";
    self.textView.font = [UIFont systemFontOfSize:17];

    
  
    
    
    
    
    self.webView.sd_layout.topSpaceToView(lineView,20)
    .leftSpaceToView(self.HeadView,15)
    .rightSpaceToView(self.HeadView,15);
    self.webView.delegate = self;
    self.webView.scalesPageToFit = NO;
    self.webView.scrollView.scrollEnabled = NO;
    
       [self.webView loadHTMLString:html baseURL:nil];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getComments)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreContentData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    [self.tableView setTableHeaderView:self.HeadView];
    [self getComments];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGRect frame = self.webView.frame;
    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    self.webView.frame = frame;
    
    self.remenLabel.sd_layout.topSpaceToView(self.webView,0)
    .leftSpaceToView(self.HeadView,20)
    .heightIs(20);
    [self.remenLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self getComments];
    [self.tableView setTableHeaderView:self.HeadView];

    
//    CGSize
//
//    actualSize
//    =
//    [webView
//     
//     sizeThatFits:CGSizeZero];
//    
//    
//    CGRect
//    
//    newFrame
//    =
//    webView.frame;
//    
//    
//    
//    newFrame.size.height
//    
//    = 
//    actualSize.height;
//    
//    
//    webView.frame
//    
//    = 
//    newFrame;
//    
//    CGRect frame = webView.frame;
//    
//    NSLog(@"%f",frame.size.height);
   
    
    
    
  
 


}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NewWebViewController *WebVC = [[NewWebViewController alloc]init];
        WebVC.request = request;
//        [self.navigationController pushViewController:WebVC animated:YES];
        [[UIApplication sharedApplication] openURL:request.URL];

        return NO;
        
    }
    
    
    return YES;
    

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
- (void)commentButtonAction:(UIButton *)commentButton
{
    [self.textView becomeFirstResponder];

}
- (void)sendButtonAction:(UIButton *)sendButton
{
    if ([self.textView.text isEqualToString:@""]||[self.textView.text isEqualToString:@"请输入评论内容"]) {
        NSLog(@"评论内容不能为空，请重新输入!");
        [self MBProgressWithString:@"评论内容不能为空，请重新输入!" timer:1 mode:MBProgressHUDModeText];
    }
    else if([NewsDetailController isEmpty:self.textView.text] == YES)
    {
        [self MBProgressWithString:@"评论内容不能为空，请重新输入!" timer:1 mode:MBProgressHUDModeText];
    }
    else if([NewsDetailController stringContainsEmoji:self.textView.text]== YES)
    {
        [self MBProgressWithString:@"评论内容不能为特殊字符，请重新输入!" timer:1 mode:MBProgressHUDModeText];
    }
    else
    {
        NSLog(@"提交评论");
        NSString *commentMessage =self.textView.text;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [defaults objectForKey:@"token"];
        NSString *URL = @"aaa";
        
        if (token == nil) {
            
            URL = NewsCommentURL;
        }
        else
        {
            URL = [[NewsCommentURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        }
        
        NSMutableDictionary *paraDic = [NSMutableDictionary new];
        [paraDic setObject:@"token" forKey:@"access_token"];
        [paraDic setObject:self.NewsID forKey:@"NewsID"];
        [paraDic setObject:commentMessage forKey:@"Content"];
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.mode = MBProgressHUDModeIndeterminate;
        [self.manager POST:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self getComments];
            self.textView.text = @"";
            [self.textView resignFirstResponder];
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            [self MBProgressWithString:@"评论发送成功！" timer:1 mode:MBProgressHUDModeText];
            NSLog(@"评论成功");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"评论失败");
            //          [self MBProgressWithString:@"评论失败，请重新发送" timer:1 mode:MBProgressHUDModeText];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            
        }];
        
    }


}

#pragma mark----TextView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.text = nil;
    self.textView.textColor = [UIColor blackColor];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.textView.text = @"请输入评论内容";
    self.textView.textColor = [UIColor grayColor];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    [self.mengban setHidden:YES];

    //    [self.view endEditing:YES];
}

//判断空格
+ (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
//判断表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (void) registerForKeyboardNotifications
{
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keboardWillChangeFrame:(NSNotification *) notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyboardF.origin.y == [UIScreen mainScreen].bounds.size.height) {
        [self.mengban setHidden:YES];
    }
    else
    {
    [self.mengban setHidden:NO];
    }
    [UIView animateWithDuration:duration animations:^{
        self.commentBackView.centerY = keyboardF.origin.y - 90;
    }];
}


- (void) keyboardWasShown:(NSNotification *) notif
{
    [self.mengban setHidden:NO];
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);//216
    self.height = keyboardSize.height +60;
    [self.commentBackView setFrame:CGRectMake(0, self.view.bounds.size.height - 60-self.height, self.view.bounds.size.width, 60)];
    
    
    //    [self animateTextField:self.textView up:YES height:self.height];
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    [self.mengban setHidden:YES];
    [self.commentBackView setFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
    
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    
    //    [self animateTextField:self.textView up:NO height:self.height];
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
}
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [self animateTextField:textView up:YES];
//}

- (void)animateTextField:(UITextView *)textView up:(BOOL)up height:(CGFloat)movementDistance
{
    CGFloat movenment = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.20];
    self.commentBackView.frame = CGRectOffset(self.commentBackView.frame, 0, movenment);
    //    self.commentView.frame = CGRectOffset(<#CGRect rect#>, <#CGFloat dx#>, <#CGFloat dy#>)
    [UIView commitAnimations];
    
}

- (void)getComments
{
    self.startpage = 1;
    self.sourceArray = [NSMutableArray new];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = NewsCommentListURL;
    
    
    if (token != nil) {
//        URL = [[[[URL stringByAppendingString:@"/"]stringByAppendingString:self.NewsID]stringByAppendingString:@"?token="]stringByAppendingString:token];
        
        URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.NewsID forKey:@"NewsID"];
    
//    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.HUD.delegate = self;
//    self.HUD.mode = MBProgressHUDModeIndeterminate;
[self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = dic[@"data"];
    for (NSDictionary *dic in dataArray) {
        CommentModel *model = [[CommentModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.sourceArray addObject:model];
    }
    self.startpage ++;
//    [self.HUD removeFromSuperViewOnHide];
//    [self.HUD hideAnimated:YES];
    NSLog(@"!!!!!!!!!%@",self.sourceArray);

    [self.tableView reloadData];
  
    
    
    
    [self.tableView.mj_header endRefreshing];

} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
//    [self.HUD removeFromSuperViewOnHide];
//    [self.HUD hideAnimated:YES];
    [self.tableView.mj_header endRefreshing];
    NSLog(@"请求评论失败");

}];
    
    
}

- (void)loadMoreContentData
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = NewsCommentListURL;
    
    if (token != nil) {
        URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.NewsID forKey:@"NewsID"];
    

    [dic setObject:[NSString stringWithFormat:@"%ld",self.startpage] forKey:@"startpage"];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArray = dic[@"data"];
        NSMutableArray *addArray = [NSMutableArray new];
        
        for (NSDictionary *dic in dataArray) {
            CommentModel *model = [[CommentModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [addArray addObject:model];
            
        }
        self.startpage ++;
        [self.sourceArray addObjectsFromArray:addArray];
        
        if (addArray.count == 0) {
            //            [self.tableView.mj_footer resetNoMoreData];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        else
        {
            NSLog(@"!!!!!!!!!%@",self.sourceArray);
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        NSLog(@"请求评论成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求评论失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sourceArray.count;
    //    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *model = [[CommentModel alloc]init];
    model = self.sourceArray[indexPath.row];
    CGFloat cellHeight =  [CommentsCell heightForTextCellWithNewsDic:model.Content];
    return  cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell" forIndexPath:indexPath];
    CommentModel *model = [[CommentModel alloc]init];
    
    model = self.sourceArray[indexPath.row];
    
    NSLog(@"%@",self.sourceArray);
    
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //    cell.label.text = @"sdfafdasdfsfdsadfasfsdfsfasdfasdfsdfsdfsdfsdfdsfsdfsdfsdfdsfsdfsadfsdf";
    ////    cell.model = self.sourceArray[indexPath.row];
    
    return cell;
}





- (CGSize)boundingRectWithSize:(CGSize)size Text:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
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
