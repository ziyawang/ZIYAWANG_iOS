//
//  VideoPlayViewController.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/29.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "ZXVideoPlayerController.h"
#import "ZXVideo.h"


#import "CommentCell.h"
#import "CommentModel.h"
#import "CommentsCell.h"
#import "TableViewCell.h"
#import "UIView+Extension.h"
#import "LoginController.h"
#import "VideosModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AppDelegate.h"
#import "CSTextView.h"

@interface VideoPlayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) ZXVideoPlayerController *videoController;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *commentCountView;
@property (nonatomic,strong) UILabel *contentCountLabel;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) CSTextView *textView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,assign) NSInteger startvPage;
@property (nonatomic,strong) UIView *commentView;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,assign) NSInteger startpage;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) VideosModel *model;


@property (nonatomic,strong) UIButton *collectButton;
@property (nonatomic,strong) UIButton *fabiaoButton;
@property (nonatomic,strong) UIView *textBackView;
@property (nonatomic,strong) UIView *commentBackView;
@property (nonatomic,strong) UIView *mengban;


@end

@implementation VideoPlayViewController



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置允许横屏竖屏
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 1;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 0;
    self.navigationController.navigationBar.hidden = NO;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}


#pragma mark----ViewdidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[VideosModel alloc]init];
    
      NSLog(@"*********************************%@",self.video.playUrl);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat videoLabelHight = [VideoPlayViewController heightForTextLabel:self.videoDes];

//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kZXVideoPlayerOriginalHeight + videoLabelHight + 102+25 , self.view.bounds.size.width, self.view.bounds.size.height - (kZXVideoPlayerOriginalHeight + 210)) style:(UITableViewStylePlain)];
    self.tableView = [UITableView new];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.sourceArray = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
        [self.tableView registerClass:[CommentsCell class] forCellReuseIdentifier:@"CommentsCell"];
    [self.view addSubview:self.tableView];
    [self registerForKeyboardNotifications];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getContentData)];
//    [self.tableView scrollRectToVisible:CGRectMake(0, MJRefreshHeaderHeight, 1, 1) animated:YES];

  self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreContentData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
    [self getContentData];
    [self getVideoDetail];
     [self playVideo];
 }


- (void)getVideoDetail
{
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *headurl = getDataURL;
    NSString *footurl = @"/video/list/";
    NSLog(@"^^^^^^^^^^^^^^^^%@",self.videoID);

    NSString *URL = @"a";
    if (token!=nil) {
        URL =[[[[[[headurl stringByAppendingString:footurl]stringByAppendingString:self.videoID]stringByAppendingString:@"?access_token="]stringByAppendingString:@"token"]stringByAppendingString:@"&token="]stringByAppendingString:token];
    }
    else
    {
        URL =[[[[headurl stringByAppendingString:footurl]stringByAppendingString:self.videoID]stringByAppendingString:@"?access_token="]stringByAppendingString:@"token"];
        
    }    NSString *accesstoken = @"token";
    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:accesstoken forKey:@"access_token"];
    
    //    [dic setObject:pagecount forKey:@"pagecount"];
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求视频成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
//        NSArray *dataArray = dic[@"data"];
//        for (NSDictionary *dic in dataArray) {
//            VideosModel *model = [[VideosModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
//            [self.sourceArray addObject:model];
//        }
        
        
         VideosModel *model = [[VideosModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        self.model = model;
        NSLog(@"~~~~~~~~~~~~~~~~~~~%@",self.model);
//        [self layoutView];
        [self layOutViews];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        NSLog(@"获取信息失败");
        NSLog(@"%@",error);
    }];
}

- (void)layOutViews
{
    self.contentView = [UIView new];
    UILabel *titleLabel = [UILabel new];
    UILabel *viewCountLabel = [UILabel new];
    UILabel *timeLabel = [UILabel new];
    UILabel *jianjieLabel = [UILabel new];
    UILabel *allLabel = [UILabel new];
    
    self.commentCountView = [UIView new];
    UILabel *quanbuLabel = [UILabel new];
    
    titleLabel.font = [UIFont systemFontOfSize:14];
    viewCountLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.font = [UIFont systemFontOfSize:12];
    jianjieLabel.font = [UIFont systemFontOfSize:13];
    quanbuLabel.font = [UIFont systemFontOfSize:20];
    
    titleLabel.numberOfLines = 0;
    jianjieLabel.numberOfLines = 0;
    
    viewCountLabel.textColor = [UIColor grayColor];
    timeLabel.textColor = [UIColor grayColor];
    jianjieLabel.textColor = [UIColor grayColor];
    quanbuLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    quanbuLabel.text = @"全部评论";
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:viewCountLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:jianjieLabel];
    [self.contentView addSubview:allLabel];
    [self.view addSubview:self.commentCountView];
    [self.commentCountView addSubview:quanbuLabel];
    self.commentCountView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    
    
    self.contentView.sd_layout.topSpaceToView(self.view,kZXVideoPlayerOriginalHeight)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0);
    
    titleLabel.sd_layout.topSpaceToView(self.contentView,15)
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    
    viewCountLabel.sd_layout.topSpaceToView(titleLabel,20)
    .leftEqualToView(titleLabel)
    .rightSpaceToView(self.contentView,15)
    .heightIs(15);
    
    timeLabel.sd_layout.topSpaceToView(viewCountLabel,5)
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .heightIs(15);
    
    jianjieLabel.sd_layout.topSpaceToView(timeLabel,20)
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .autoHeightRatio(0);
    
    [self.contentView setupAutoHeightWithBottomView:jianjieLabel bottomMargin:20];
    self.commentCountView.sd_layout.leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(30)
    .topSpaceToView(self.contentView,0);
    
    self.tableView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.commentCountView,-15)
    .bottomSpaceToView(self.view,0);
    
    
    quanbuLabel.sd_layout.leftSpaceToView(self.commentCountView,15)
    .rightSpaceToView(self.commentCountView,15)
    .centerYEqualToView(self.commentCountView)
    .heightIs(20);
    
    titleLabel.text = self.model.VideoTitle;
    viewCountLabel.text =[[@"已播放"stringByAppendingString:self.model.ViewCount]stringByAppendingString:@"次"];
    timeLabel.text = self.model.PublishTime;
    jianjieLabel.text = [@"简介："stringByAppendingString:self.model.VideoDes];
    
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button setFrame:CGRectMake(self.view.bounds.size.width - 100, 10, 27, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    UILabel *shoucang = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 97, 40, 30, 14)];
    
    shoucang.centerX = button.centerX;
    
    shoucang.text = @"收藏";
    shoucang.textAlignment = NSTextAlignmentCenter;
    
    
    shoucang.font = [UIFont systemFontOfSize:10];
    shoucang.textColor = [UIColor darkGrayColor];
    
    
    
    //    self.collectButton = button;
    
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    [button2 setFrame:CGRectMake(self.view.bounds.size.width - 50, 10, 25, 25)];
    [button2 addTarget:self action:@selector(didClickShareButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *fenxiang = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 47, 40, 30, 14)];
    fenxiang.textAlignment = NSTextAlignmentCenter;
    fenxiang.centerX = button2.centerX;
    fenxiang.text = @"分享";
    fenxiang.font = [UIFont systemFontOfSize:10];
    fenxiang.textColor = [UIColor darkGrayColor];
    
    self.model.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
    if ([self.model.CollectFlag isEqualToString:@"0"]) {
        NSLog(@"没收藏过");
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    }
    else if([self.model.CollectFlag isEqualToString:@"1"])
    {
        NSLog(@"收藏过");
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
    }
    [self.collectButton addTarget:self action:@selector(didClickCollectbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.mengban = [UIView new];
    [self.view addSubview:self.mengban];
    
    
    UITapGestureRecognizer *mengbanGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menbanViewAction:)];
    [self.mengban addGestureRecognizer:mengbanGesture];
    self.mengban.backgroundColor = [UIColor blackColor];
    self.mengban.alpha = 0.5;
    [self.mengban setHidden:YES];
    
    self.mengban.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(700);
    
    self.commentBackView = [UIView new];
    self.commentBackView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    
    UIView *touchView = [UIView new];
    UIButton *commCountButton = [UIButton new];
    self.collectButton = [UIButton new];
    UIButton *sharebutton = [UIButton new];
    UILabel *xiepinglun = [UILabel new];
    self.fabiaoButton = [UIButton new];
    
    xiepinglun.text = @"写评论...";
    xiepinglun.textColor = [UIColor lightGrayColor];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchViewTouchAction:)];
    [touchView addGestureRecognizer:gesture];
    
    
    
    [commCountButton setBackgroundImage:[UIImage imageNamed:@"commentCount"] forState:(UIControlStateNormal)];
    //    sharebutton.backgroundColor = [UIColor redColor];
    //    self.collectButton.backgroundColor = [UIColor redColor];
    [self.collectButton addTarget:self action:@selector(didClickCollectbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //    [commCountButton addTarget:self action:@selector(commCountButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.model.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
    
    if ([self.model.CollectFlag isEqualToString:@"0"]) {
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucangxin"] forState:(UIControlStateNormal)];
        
    }
    else
    {
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shouc"] forState:(UIControlStateNormal)];
        
        
    }
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"fenxiang2"] forState:(UIControlStateNormal)];
    
    [sharebutton addTarget:self action:@selector(didClickShareButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.commentBackView addSubview:touchView];
    [self.commentBackView addSubview:commCountButton];
    [self.commentBackView addSubview:sharebutton];
    [self.commentBackView addSubview:self.collectButton];
    [touchView addSubview:xiepinglun];
    
    
    
    self.textBackView = [UIView new];
    
    self.textView = [[CSTextView alloc]init];
    self.textView.delegate = self;
    self.textView.placeholder = @"请输入评论内容";
    self.textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 1000, self.view.bounds.size.width, 150)];
    
    [self.view addSubview:self.textBackView];
    [self.textBackView addSubview:self.textView];
    [self.textBackView addSubview:self.fabiaoButton];
    self.fabiaoButton.layer.cornerRadius = 5;
    self.fabiaoButton.layer.masksToBounds = YES;
    
    [self.fabiaoButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    self.textBackView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.masksToBounds = YES;
    
    //    self.textBackView.sd_layout.leftSpaceToView(self.view,0)
    //    .rightSpaceToView(self.view,0)
    //    .heightIs(150)
    //    .topSpaceToView(self.commentBackView,0);
    
    self.textView.sd_layout.leftSpaceToView(self.textBackView,15)
    .rightSpaceToView(self.textBackView,15)
    .heightIs(80)
    .topSpaceToView(self.textBackView,15);
    
    
    self.fabiaoButton.sd_layout.rightEqualToView(self.textView)
    .topSpaceToView(self.textView,15)
    .heightIs(20)
    .widthIs(40);
    
    [self.fabiaoButton setTitle:@"发表" forState:(UIControlStateNormal)];
    [self.fabiaoButton setBackgroundColor:[UIColor grayColor]];
    
    self.fabiaoButton.titleLabel.font = [UIFont systemFontOfSize:14];

    //self.textView.layer.borderColor = [UIColor grayColor];
    
    
    
    
    
    
    UIButton *sendButton = [UIButton new];
    [sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
    [sendButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    
    [sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //    [self.commentBackView addSubview:sendButton];
    //    [self.commentBackView addSubview:self.textView];
    [self.view addSubview:self.commentBackView];
    
    touchView.sd_layout.leftSpaceToView(self.commentBackView,20)
    .widthIs(200)
    .centerYEqualToView(self.commentBackView)
    .heightIs(30);
    
    
    
    xiepinglun.sd_layout.leftSpaceToView(touchView,5)
    .centerYEqualToView(touchView)
    .heightIs(20);
    [xiepinglun setSingleLineAutoResizeWithMaxWidth:200];
    
    
    sharebutton.sd_layout.centerYEqualToView(touchView)
    .rightSpaceToView(self.commentBackView,20)
    .heightIs(20)
    .widthIs(15);
    
    self.collectButton.sd_layout.centerYEqualToView(touchView)
    .rightSpaceToView(sharebutton,30)
    .heightIs(20)
    .widthIs(25);
 
    
    
    touchView.layer.borderWidth = 1;
    touchView.layer.masksToBounds = YES;
    touchView.layer.cornerRadius = 15;
    touchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
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
    self.commentBackView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(50);
    
     self.textView.textColor = [UIColor darkGrayColor];
    //    self.textView.text = @"请输入评论内容";
    self.textView.font = [UIFont systemFontOfSize:17];


}
- (void)layoutView
{
    CGFloat videoLabelHight = [VideoPlayViewController heightForTextLabel:self.model.VideoDes];
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kZXVideoPlayerOriginalHeight, self.view.bounds.size.width,  videoLabelHight +110)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *videoTitle  = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width - 120, 20)];
    videoTitle.text = self.model.VideoTitle;
    videoTitle.font = [UIFont FontForBigLabel];
    UILabel *viewCount = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 150, 20)];
    NSString *str1 = @"已播放";
    NSString *str2 = @"次";
    self.model.ViewCount = [NSString stringWithFormat:@"%@",self.model.ViewCount];
    viewCount.text =[[str1 stringByAppendingString:self.model.ViewCount]stringByAppendingString:str2];
    viewCount.textColor = [UIColor darkGrayColor];
    viewCount.font = [UIFont systemFontOfSize:10];
    UILabel *commentTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 200, 20)];
    commentTime.font = [UIFont FontForVideoDesLabel];
    commentTime.textColor = [UIColor darkGrayColor];
    commentTime.text = self.model.PublishTime;
//    UILabel *jianjieLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 102, 30, 10)];
//    jianjieLabel.text = @"简介:";
//    jianjieLabel.font = [UIFont FontForVideoDesLabel];
//    jianjieLabel.textColor = [UIColor darkGrayColor];
//    [self.contentView addSubview:jianjieLabel];
    
    
    UILabel *videoDes = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, [VideoPlayViewController widthForVideoDes], videoLabelHight)];
//    NSString *jianjie = @"简介:";
    videoDes.text = [@"简介:"stringByAppendingString:self.model.VideoDes];
    
    videoDes.textColor = [UIColor darkGrayColor];
    videoDes.font = [UIFont FontForVideoDesLabel];
    videoDes.numberOfLines = 0;
    
    
    
    
    
    
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button setFrame:CGRectMake(self.view.bounds.size.width - 100, 10, 27, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    UILabel *shoucang = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 97, 40, 30, 14)];
    
    shoucang.centerX = button.centerX;
    
    shoucang.text = @"收藏";
    shoucang.textAlignment = NSTextAlignmentCenter;
    
    
    shoucang.font = [UIFont systemFontOfSize:10];
    shoucang.textColor = [UIColor darkGrayColor];
    
    
    
//    self.collectButton = button;
    
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    [button2 setFrame:CGRectMake(self.view.bounds.size.width - 50, 10, 25, 25)];
    [button2 addTarget:self action:@selector(didClickShareButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *fenxiang = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 47, 40, 30, 14)];
    fenxiang.textAlignment = NSTextAlignmentCenter;
    fenxiang.centerX = button2.centerX;
    fenxiang.text = @"分享";
    fenxiang.font = [UIFont systemFontOfSize:10];
    fenxiang.textColor = [UIColor darkGrayColor];
    
    self.model.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
      if ([self.model.CollectFlag isEqualToString:@"0"]) {
        NSLog(@"没收藏过");
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
    }
    else if([self.model.CollectFlag isEqualToString:@"1"])
    {
        NSLog(@"收藏过");
       [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
    }
    [self.collectButton addTarget:self action:@selector(didClickCollectbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    
//    [self.contentView addSubview:fenxiang];
//    [self.contentView addSubview:shoucang];
    
    
//    [self.contentView addSubview:self.collectButton];
//    [self.contentView addSubview:button2];
    
    [self.contentView addSubview:videoTitle];
    [self.contentView addSubview:viewCount];
    [self.contentView addSubview:commentTime];
    [self.contentView addSubview:videoDes];
    [self.view addSubview:self.contentView];
    
    
    
    
    
    
    self.commentCountView = [[UIView alloc]initWithFrame:CGRectMake(0, kZXVideoPlayerOriginalHeight + videoLabelHight +100 + 10, self.view.bounds.size.width, 40)];
    UILabel *contentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 20)];
    self.commentCountView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    contentCountLabel.text = @"全部评论";
    contentCountLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    
    self.contentCountLabel = contentCountLabel;
    [self.commentCountView addSubview:self.contentCountLabel];
    [self.view addSubview:self.commentCountView];
    
   //    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
//    
//    commentView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
//    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 60, 40)];
//    self.textView.font = [UIFont FontForLabel];
//    
//    self.commentButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    [self.commentButton setFrame:CGRectMake(self.view.bounds.size.width - 50, 13, 50, 30 )];
//    
//    [self.commentButton setTitle:@"发送" forState:(UIControlStateNormal)];
////    self.commentButton.titleLabel.textColor = [UIColor lightGrayColor];
//    [self.commentButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
//    
//    [self.commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [commentView addSubview:self.commentButton];
//    self.textView.delegate = self;
//    self.textView.textColor = [UIColor darkGrayColor];
//    self.textView.text = @"请输入评论内容";
//    self.textView.font = [UIFont systemFontOfSize:15];
//    self.view.backgroundColor = [UIColor whiteColor];
//    [commentView addSubview:self.textView];
//    self.commentView = commentView;
//    [self.view addSubview:self.commentView];
    
    self.mengban = [UIView new];
    [self.view addSubview:self.mengban];
    UITapGestureRecognizer *mengbanGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menbanViewAction:)];
    [self.mengban addGestureRecognizer:mengbanGesture];
    self.mengban.backgroundColor = [UIColor blackColor];
    self.mengban.alpha = 0.5;
    [self.mengban setHidden:YES];
    
    self.mengban.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(700);
    
    self.commentBackView = [UIView new];
    self.commentBackView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    
    UIView *touchView = [UIView new];
    UIButton *commCountButton = [UIButton new];
    self.collectButton = [UIButton new];
    UIButton *sharebutton = [UIButton new];
    UILabel *xiepinglun = [UILabel new];
    self.fabiaoButton = [UIButton new];
    
    xiepinglun.text = @"写评论...";
    xiepinglun.textColor = [UIColor lightGrayColor];
    
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchViewTouchAction:)];
    [touchView addGestureRecognizer:gesture];
    
    
    
    [commCountButton setBackgroundImage:[UIImage imageNamed:@"commentCount"] forState:(UIControlStateNormal)];
    //    sharebutton.backgroundColor = [UIColor redColor];
    //    self.collectButton.backgroundColor = [UIColor redColor];
    [self.collectButton addTarget:self action:@selector(didClickCollectbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    
//    [commCountButton addTarget:self action:@selector(commCountButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.model.CollectFlag = [NSString stringWithFormat:@"%@",self.model.CollectFlag];
    
    if ([self.model.CollectFlag isEqualToString:@"0"]) {
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucangxin"] forState:(UIControlStateNormal)];
        
    }
    else
    {
        [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shouc"] forState:(UIControlStateNormal)];
        
        
    }
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"fenxiang2"] forState:(UIControlStateNormal)];
    
    [sharebutton addTarget:self action:@selector(didClickShareButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.commentBackView addSubview:touchView];
    [self.commentBackView addSubview:commCountButton];
    [self.commentBackView addSubview:sharebutton];
    [self.commentBackView addSubview:self.collectButton];
    [touchView addSubview:xiepinglun];
    
    
    
    self.textBackView = [UIView new];
    
    self.textView = [[CSTextView alloc]init];
    self.textView.delegate = self;
    self.textView.placeholder = @"请输入评论内容";
    self.textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 1000, self.view.bounds.size.width, 150)];

    [self.view addSubview:self.textBackView];
    [self.textBackView addSubview:self.textView];
    [self.textBackView addSubview:self.fabiaoButton];
    self.fabiaoButton.layer.cornerRadius = 5;
    self.fabiaoButton.layer.masksToBounds = YES;
    
    [self.fabiaoButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    self.textBackView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.masksToBounds = YES;
    
//    self.textBackView.sd_layout.leftSpaceToView(self.view,0)
//    .rightSpaceToView(self.view,0)
//    .heightIs(150)
//    .topSpaceToView(self.commentBackView,0);
    
    self.textView.sd_layout.leftSpaceToView(self.textBackView,15)
    .rightSpaceToView(self.textBackView,15)
    .heightIs(80)
    .topSpaceToView(self.textBackView,15);
    
    
    self.fabiaoButton.sd_layout.rightEqualToView(self.textView)
    .topSpaceToView(self.textView,15)
    .heightIs(20)
    .widthIs(40);
    
    [self.fabiaoButton setTitle:@"发表" forState:(UIControlStateNormal)];
    [self.fabiaoButton setBackgroundColor:[UIColor grayColor]];
    
    
    //self.textView.layer.borderColor = [UIColor grayColor];
    
    
    
    
    
    
    UIButton *sendButton = [UIButton new];
    [sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
    [sendButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    
    [sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //    [self.commentBackView addSubview:sendButton];
    //    [self.commentBackView addSubview:self.textView];
    [self.view addSubview:self.commentBackView];
    
    touchView.sd_layout.leftSpaceToView(self.commentBackView,20)
    .widthIs(200)
    .centerYEqualToView(self.commentBackView)
    .heightIs(30);
    
    
    
    xiepinglun.sd_layout.leftSpaceToView(touchView,5)
    .centerYEqualToView(touchView)
    .heightIs(20);
    [xiepinglun setSingleLineAutoResizeWithMaxWidth:200];
    
    
    sharebutton.sd_layout.centerYEqualToView(touchView)
    .rightSpaceToView(self.commentBackView,20)
    .heightIs(20)
    .widthIs(15);
    
    self.collectButton.sd_layout.centerYEqualToView(touchView)
    .rightSpaceToView(sharebutton,30)
    .heightIs(20)
    .widthIs(25);

    
//    commCountButton.sd_layout.centerYEqualToView(touchView)
//    .rightSpaceToView(self.collectButton,30)
//    .widthIs(25)
//    .heightIs(25);
    
    
    touchView.layer.borderWidth = 1;
    touchView.layer.masksToBounds = YES;
    touchView.layer.cornerRadius = 15;
    touchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    
    
    
    
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
    
    
    
    //    commentButton.sd_layout.leftSpaceToView(self.view,0)
    //    .rightSpaceToView(self.view,0)
    //    .bottomSpaceToView(self.view,0)
    //    .heightIs(60);
    
    //    pinglun.sd_layout.centerXEqualToView(commentButton)
    //    .centerYEqualToView(commentButton)
    //    .heightIs(20)
    //    .widthIs);
    //
    //
    //    image.sd_layout.leftSpaceToView(pinglun,0)
    //    .topSpaceToView(pinglun,0)
    //    .heightIs(20)
    //    .widthIs(17)
    //    .centerYEqualToView(pinglun);
    //
    //    label.sd_layout.leftSpaceToView(image,5)
    //    .topEqualToView(image)
    //    .heightIs(20)
    //    .widthIs(30)
    //    .centerYEqualToView(pinglun);
    
    self.commentBackView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(50);
    
    
    //    sendButton.sd_layout.rightSpaceToView(self.commentBackView,10)
    //    .centerYEqualToView(self.commentBackView)
    //    .widthIs(40)
    //    .heightIs(30);
    //
    //    self.textView.sd_layout.leftSpaceToView(self.commentBackView,10)
    //    .centerYEqualToView(self.commentBackView)
    //    .rightSpaceToView(sendButton,10)
    //    .heightIs(40);
    
    
    self.textView.textColor = [UIColor darkGrayColor];
    //    self.textView.text = @"请输入评论内容";
    self.textView.font = [UIFont systemFontOfSize:17];
}
#pragma mark----label自适应高度

+(CGFloat)widthForVideoDes
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 300;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 340;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 390;
        
    }
    
    return 280;
}

+(CGFloat)heightForTextLabel:(NSString *)text{
    
    //    CGFloat titleHeight = [self heigthForText:newsDic[@"title"] FontSize:22 width:250];
    CGFloat descHeight = [self heigthForText:text FontSize:12 width:[VideoPlayViewController widthForVideoDes]];
    return descHeight;
}

+(CGFloat)heigthForText:(NSString *)text FontSize:(CGFloat)fontSize width:(CGFloat)width{
    //字符绘制区域
    CGSize size = CGSizeMake(width, 1000);
    CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    //CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return textRect.size.height;
}

- (void)touchViewTouchAction:(UITapGestureRecognizer *)geture
{
    [self.textView becomeFirstResponder];
    
    
}
- (void)menbanViewAction:(UITapGestureRecognizer *)gesture
{
    [self.textView resignFirstResponder];
    [self.mengban setHidden:YES];
}

- (void)didClickShareButton:(UIButton*)button2
{
    
    NSString *url = @"http://ziyawang.com/video/";
    self.model.VideoID = [NSString stringWithFormat:@"%@",self.model.VideoID];
    
    NSString *URL = [url stringByAppendingString:self.model.VideoID];
//    NSString *URL = [@"http://ziyawang.com/service/" stringByAppendingString:self.model.ServiceID];
//    NSString *shareURL1 = @"http://ziyawang.com/project/";
//    NSString *shareURL = [shareURL1 stringByAppendingString:self.model.ServiceID];
    UIImage *image = [UIImage imageNamed:@"morentouxiang"];
    NSArray *imageArray = @[image];
    
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.model.VideoDes
                                     images:imageArray
                                        url:[NSURL URLWithString:URL]
                                      title:self.model.VideoTitle
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

- (void)commentButtonAction:(UIButton *)commentButton
{
    [self.textView becomeFirstResponder];
    
}

- (void)didClickCollectbutton:(UIButton*)button
{
    if ([self.model.CollectFlag isEqualToString:@"0"]) {
        
        [self collectORCancelCollectWithFlag:@"0"];
    }
    else
    {
        [self collectORCancelCollectWithFlag:@"1"];
    }
    

}

- (void)collectORCancelCollectWithFlag:(NSString *)flag
{
    NSLog(@"^^^^^^^^^^^^^^^^^^^^%@",flag);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
//        NSString *Token = @"?token=";
        NSString *url = [getDataURL stringByAppendingString:@"/collect"];
//        NSString *url2 = @"/collect";
//        NSString *access_token = @"token";
        
        NSString *URL = [[[[url stringByAppendingString:@"?access_token="]stringByAppendingString:@"token"]stringByAppendingString:@"&token="]stringByAppendingString:token];
        
        
        //    NSString *getURL = @"https://apis.ziyawang.com/zll/service/list?access_token=token";
        NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
//        [postdic setObject:access_token forKey:@"access_token"];
        //    [postdic setObject:token forKey:@"token"];
        
        self.videoID = [NSString stringWithFormat:@"%@",self.videoID];
        
        NSLog(@"%@",self.model.VideoID);
        [postdic setObject:@"2" forKey:@"type"];
        [postdic setObject:self.videoID forKey:@"itemID"];
        
//       NSString *uurl =@"https://apis.ziyawang.com/zll/collect?access_token=token&token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjQ2LCJpc3MiOiJodHRwOlwvXC9hcGkueml5YS56bGwuc2NpZW5jZVwvdjFcL2F1dGhcL2xvZ2luIiwiaWF0IjoiMTQ3MTc3NzI5NiIsImV4cCI6IjE0NzIzODIwOTYiLCJuYmYiOiIxNDcxNzc3Mjk2IiwianRpIjoiM2M2NmIwYTY5MTI4Mjk0ZWUwNGE2MzFjNGNmNTE0YmUifQ.FOQSAs-4jrAIv87uN65BbvrFOANJsQ1K_4ySop_fcFU&type=2&itemID=13";
         if ([flag isEqualToString:@"0"])
        {
            NSLog(@"未收藏过,改变button的状态,调用收藏接口");
            [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
             {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 NSLog(@"~~~~~~~~~~~~~~~~~~~%@",dic);
                 NSLog(@"%@",dic[@"msg"]);
                 
                 NSLog(@"收藏成功");
                 self.model.CollectFlag = @"1";
                 [self MBProgressWithString:@"收藏成功" timer:1 mode:MBProgressHUDModeText];
                 //                 收藏按钮状态改变
                 [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shouc"] forState:(UIControlStateNormal)];
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
//                 [self MBProgressWithString:@"收藏失败" timer:1 mode:MBProgressHUDModeText];
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
                 NSLog(@"收藏失败");
             }];
            
        }
        else
        {
            [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
             {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"取消收藏成功");
                 [self.collectButton setBackgroundImage:[UIImage imageNamed:@"shoucangxin"] forState:(UIControlStateNormal)];
                 self.model.CollectFlag = @"0";
                 [self MBProgressWithString:@"已取消收藏" timer:1 mode:MBProgressHUDModeText];
                 //收藏按钮状态改变
                 //            self.saveButton.imageView.image = [UIImage imageNamed:<#(nonnull NSString *)#>]
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
//                 [self MBProgressWithString:@"取消收藏失败" timer:1 mode:MBProgressHUDModeText];
                 NSLog(@"取消收藏失败");
             }];
        }
    }
  
}


#pragma mark----TextView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //    self.textView.text = nil;
    self.textView.textColor = [UIColor blackColor];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""] == NO&&textView.text != nil) {
        [self.fabiaoButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
        self.fabiaoButton.userInteractionEnabled = YES;
    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""] == NO&&textView.text != nil) {
        [self.fabiaoButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
        self.fabiaoButton.userInteractionEnabled = YES;
    }
    else
    {
        [self.fabiaoButton setBackgroundColor:[UIColor grayColor]];
        self.fabiaoButton.userInteractionEnabled = NO;
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
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

- (void)sendButtonAction:(UIButton *)button
{
    if ([self.textView.text isEqualToString:@""]||[self.textView.text isEqualToString:@"请输入评论内容"]) {
        NSLog(@"评论内容不能为空，请重新输入!");
        [self MBProgressWithString:@"评论内容不能为空，请重新输入!" timer:1 mode:MBProgressHUDModeText];
    }
    else if([VideoPlayViewController isEmpty:self.textView.text] == YES)
    {
        [self MBProgressWithString:@"评论内容不能为空，请重新输入!" timer:1 mode:MBProgressHUDModeText];
    }
    else if([VideoPlayViewController stringContainsEmoji:self.textView.text]== YES)
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
  
        URL = SentCommentContentURL;
    }
    else
    {
    URL = [[SentCommentContentURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    }

    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:@"token" forKey:@"access_token"];
    [paraDic setObject:self.videoID forKey:@"VideoID"];
    [paraDic setObject:commentMessage forKey:@"Content"];
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.manager POST:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self getContentData];
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
        [UIView animateWithDuration:duration animations:^{
            //            self.textBackView.y = keyboardF.origin.y ;
            [self.textBackView setFrame:CGRectMake(0, keyboardF.origin.y, self.view.bounds.size.width, 150)];
        }];
    }
    else
    {
        [self.mengban setHidden:NO];
        [self.textBackView setFrame:CGRectMake(0, keyboardF.origin.y - 150, self.view.bounds.size.width, 150)];
        //        [UIView animateWithDuration:duration animations:^{
        ////            self.textBackView.y = keyboardF.origin.y - 220;
        ////            [self.textBackView setFrame:CGRectMake(0, keyboardF.origin.y - 220, self.view.bounds.size.width, 150)];
        //
        //
        //        }];
        
        
    }
    
}


- (void) keyboardWasShown:(NSNotification *) notif
{
    [self.mengban setHidden:NO];
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);//216
    self.height = keyboardSize.height +150;
    [self.textBackView setFrame:CGRectMake(0, self.view.bounds.size.height - 150-self.height, self.view.bounds.size.width, 150)];
    
    
    //    [self animateTextField:self.textView up:YES height:self.height];
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    [self.mengban setHidden:YES];
    [self.textBackView setFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 150)];
    
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
    self.commentView.frame = CGRectOffset(self.commentView.frame, 0, movenment);
//    self.commentView.frame = CGRectOffset(<#CGRect rect#>, <#CGFloat dx#>, <#CGFloat dy#>)
    [UIView commitAnimations];
    
}

- (void)getContentData
{
    self.startpage = 1;
    [self.sourceArray removeAllObjects];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [getDataURL stringByAppendingString:@"/video/comment/list"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.videoID forKey:@"VideoID"];
[self.manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = dic[@"data"];
    for (NSDictionary *dic in dataArray) {
        CommentModel *model = [[CommentModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.sourceArray addObject:model];
    }
    
    self.startpage ++;
    NSLog(@"!!!!!!!!!%@",self.sourceArray);
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
     NSLog(@"请求评论成功");
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [self.tableView.mj_header endRefreshing];

    NSLog(@"请求评论失败");
}];

}
- (void)loadMoreContentData
{
    
    NSString *url = [getDataURL stringByAppendingString:@"/video/comment/list"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.videoID forKey:@"VideoID"];
    [dic setObject:[NSString stringWithFormat:@"%ld",self.startpage] forKey:@"startpage"];
    
    [self.manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
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
        NSLog(@"请求评论成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求评论失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
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
  
//    cell.label.text = @"sdfafdasdfsfdsadfasfsdfsfasdfasdfsdfsdfsdfsdfdsfsdfsdfsdfdsfsdfsadfsdf";
////    cell.model = self.sourceArray[indexPath.row];
    
    return cell;
}

- (void)playVideo
{
   
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:
                                CGRectMake(0, 0, kZXVideoPlayerOriginalWidth,
                                           kZXVideoPlayerOriginalHeight)];
        
        __weak typeof(self) weakSelf = self;
        self.videoController.videoPlayerGoBackBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
           
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
            
            strongSelf.videoController = nil;
        };
        
        
        self.videoController.videoPlayerGoBackBlock = ^()
        {
        
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        };
        
        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
            NSLog(@"切换为竖屏模式");
            [weakSelf.contentView setHidden:NO];
            [weakSelf.commentCountView setHidden:NO];
            [weakSelf.tableView setHidden:NO];
            [weakSelf.commentBackView setHidden:NO];
            
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
            [weakSelf.contentView setHidden:YES];
            [weakSelf.commentCountView setHidden:YES];
            [weakSelf.tableView setHidden:YES];
            [weakSelf.commentBackView setHidden:YES];

        };
        [self.videoController showInView:self.view];
    }
    self.videoController.video = self.video;
}

@end
