//
//  ChuzhiDetailController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/1.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ChuzhiDetailController.h"
#import "NewsModel.h"
@interface ChuzhiDetailController ()<UIWebViewDelegate,MBProgressHUDDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NewsModel *model;

@end

@implementation ChuzhiDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"处置公告";
    self.view.backgroundColor = [UIColor whiteColor];
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
        [self setViews];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
    }];
    
}

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
