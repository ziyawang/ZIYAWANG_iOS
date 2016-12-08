//
//  ZiyaMainController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/29.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ZiyaMainController.h"
#import "MainSectionHeadView.h"
#import "SDVersion.h"
#import "SDiOSVersion.h"
#import "SearchBar.h"
#import "PublishCell.h"
#import "NewPublishCell.h"
#import "AFNetWorking.h"
#import "PublishModel.h"

#import "FindServiceViewCell.h"
#import "FindServiceModel.h"
#import "SearchTypeController.h"

#import "InfoDetailsController.h"
#import "ScrollHeadView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+StringToColor.h"
#import "UIView+Extension.h"
#import "InfoDetailsController.h"
#import "ServiceDetailController.h"
#import "SearchController.h"
#import "VideosListController.h"
#import "LunboModel.h"
#import "VideosModel.h"

#import "FindTypeController.h"
#import "FindServiceTypeController.h"

#import "LoginController.h"
#import "UserInfoModel.h"
#import "MyidentifiController.h"
#import "RechargeController.h"
#import <RongIMKit/RongIMKit.h>

#import "WZLBadgeImport.h"

#import "DetailOfInfoController.h"
#import "ChuzhiDetailController.h"
#import "DetailOfInfoController.h"
#import "ChuzhiCell.h"
#import "TestViewController.h"
#define kWidthScale ([UIScreen mainScreen].bounds.size.width/375)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/667)
@interface ZiyaMainController ()<scrollHeadViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate,RCIMReceiveMessageDelegate>

/**
 *  三方属性
 */
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;
/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) NSMutableArray *sourceArray2;
@property (nonatomic,strong) PublishModel *model;
/**
 * scrollview以及searchbar的backView
 */
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *backView2;
/**
 *  精选视图
 */
@property (nonatomic,strong) UIImageView *jingxuanView;
/**
 *  scrollView pageControl
 */
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *scrollView;
/**
 *  搜索按钮
 */
@property (nonatomic,strong) UIButton *searchBarbutton;
/**
 *  头视图
 */
@property (nonatomic,strong) UIView *headView;
/**
 *  搜索视图
 */
@property (nonatomic,strong) UIView *searchView;
/**
 *  搜索框背视图
 */
@property (nonatomic,strong) UIView *searchBarBackView;
/**
 *  tableView
 */
@property (nonatomic,strong) UITableView *tableView;
/**
 *  自定义搜索框
 */
@property (nonatomic,strong) SearchBar *searchBar;

@property (nonatomic,strong) UIViewController *infVc;
/**
 *  测试滚动视图
 */
@property (nonatomic,strong) UIScrollView *scrollView2;
@property (nonatomic,strong) UIScrollView *scrollView1;

/**
 *  scrollView 左侧 找信息
 */
@property (nonatomic,strong) UIView *leftView;
/**
 *  scrollView 右侧 找信息
 */
@property (nonatomic,strong) UIView *rightView;
/**
 *  scrollView 左侧 找服务
 */
@property (nonatomic,strong) UIView *leftView2;
/**
 *  scrillView 右侧 找服务
 */
@property (nonatomic,strong) UIView *rightView2;
/**
 *  视频红点
 */
@property (nonatomic,strong) UIButton *redbutton;
/**
 *  类型数据源
 */
@property (nonatomic,strong) NSArray *array1;
@property (nonatomic,strong) NSArray *array2;
@property (nonatomic,strong) NSArray *array3;
@property (nonatomic,strong) NSArray *array4;
@property (nonatomic,strong) NSArray *array5;
@property (nonatomic,strong) NSArray *array6;
@property (nonatomic,strong) NSArray *array7;
/**
 *  起始页
 */
@property (nonatomic,assign) NSInteger startPage;
@property (nonatomic,assign) NSInteger startPage2;

/**
 *  数据请求轮播图接收数组
 */
@property (nonatomic,strong) NSArray *imageDataArray;

/**
 *  轮播图数据源
 */
@property (nonatomic,strong) NSMutableArray *imageSourceArray;
/**
 *  轮播图scrollview
 */
@property (nonatomic,strong) ScrollHeadView *scrollHeadView;
/**
 *  状态栏view
 */
@property (nonatomic,strong) UIView *statuView;
/**
 *  查找类型
 */
@property (nonatomic,strong) NSString *findType;
/**
 *  找信息last数据
 */
@property (nonatomic,strong) NSMutableArray *lastSourceArray1;
/**
 *  找服务last数据
 */
@property (nonatomic,strong) NSMutableArray *lastSourceArray2;


@property (nonatomic,strong) UIView *alertView1;
@property (nonatomic,strong) UIView *alertView2;
@property (nonatomic,strong) UIView *blackBackView1;
@property (nonatomic,strong) UIView *blackBackView2;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *AccountLabel1;
@property (nonatomic,strong) UILabel *AccountLabel2;
@property (nonatomic,strong) UILabel *buzuLabel;

@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) UserInfoModel *userModel;
@property (nonatomic,strong) NSString *USERID;

@property (nonatomic,strong) InfoDetailsController *infoDetailsVC;
@property (nonatomic,strong) PublishModel *pubModel;

@property (nonatomic,strong) NSArray *imageArray1;
@property (nonatomic,strong) NSArray *imageArray2;

@property (nonatomic,strong) UIView *PromiseView;

@end

@implementation ZiyaMainController
#pragma mark----系统方法视图周期

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)tabBarBadgeValueNotiFication:(NSNotification *)sender
{
//    NSString *value = sender.userInfo[@"BadgeValue"];
//    NSLog(@"%@",value);
//    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
//    [item setValue:value forKeyPath:@"badgeValue"];
    
    [[[[[self tabBarController]tabBar]items]objectAtIndex:0] showBadgeWithStyle:WBadgeStyleNumber value:1 animationType:WBadgeAnimTypeShake];
    
    
    NSString *value = [[[[self tabBarController]tabBar]items]objectAtIndex:0].badgeValue;
    NSLog(@"%@",value);
    
    //    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    view.backgroundColor = [UIColor redColor];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    //    label.text = @"12";
    //    label.textColor = [UIColor whiteColor];
    //    label.font = [UIFont systemFontOfSize:10];
    //
    //    [self.tabBarController.tabBar addSubview:view];
    //    [self.tabBarController.tabBar addSubview:label];
    
    
    //    item.badgeValue = value;
    //    item.badgeValue = @"2";
    
    //    item.badgeColor = [UIColor redColor];
    
    NSLog(@"%@",sender.userInfo[@"BadgeValue"]);
    
    //    [self.tabBarItem setBadgeValue:@"2"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    //    [self.navigationController.navigationBar setBackgroundColor:[UIColor yellowColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger unreadcount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    
    NSLog(@"%ld",unreadcount);
    
    NSString *unreadStr = [NSString stringWithFormat:@"%ld",unreadcount];
    
    
    if (unreadcount == 99 || unreadcount>99) {
      unreadStr = @"99+";
    }
    if (unreadcount == 0 || unreadcount < 0) {
        unreadStr = nil;
        
    }
    [[[[[self tabBarController]tabBar]items]objectAtIndex:3]setBadgeValue:unreadStr];

    
    [RCIM sharedRCIM].receiveMessageDelegate=self;


//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarBadgeValueNotiFication:) name:@"tabBarBadgeValueNotifi" object:nil];

    
    
//    /**
//     *  设置主页视图数据源
//     */
//    [self setArrays];
//    /**
//     初始化tableView以及其他属性
//     */
//    [self setViewsAndinitOthers];
//    /**
//     *  初始化scrollview pagecontrol searchbar backView
//     */
//    [self setView];
//    /**
//     *  初始化头视图
//     */
//    [self setHeadView];
//    /**
//     *  获取轮播图
//     */
//    [self getLunbotu];
//    /**
//     *  获取信息数据
//     */
//    [self loadNewInfoData];
//    /**
//     *  上拉加载
//     *
//     *  @param loadMoreData 获取更多数据
//     *
//     *  @return NO
//     */
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
    
    
self.navigationItem.title = @"首页";
    UIColor *color = [UIColor clearColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self setNavigation];
    [self getVideoStatu];
    [self getUserInfoFromDomin];
    
    
}
- (void)getVideoStatu
{
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URL =getVideoListURL;
    NSString *accesstoken = @"token";
    //    NSString *pagecount = @"10";
    NSString *VideoLabel = @"tj";
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:accesstoken forKey:@"access_token"];
    
    //    [dic setObject:pagecount forKey:@"pagecount"];
//    [dic setObject:[NSString stringWithFormat:@"%ld",self.startPage] forKey:@"startpage"];
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取信息成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *dataArray = dic[@"data"];
       NSString  *VideoID = dataArray.firstObject[@"VideoID"];
        NSString *videoid = [[NSUserDefaults standardUserDefaults]objectForKey:@"videostatu"];
        if ([VideoID isEqualToString:videoid]) {
            [self.redbutton setHidden:YES];
        }
        NSLog(@"%@",VideoID);
//        for (NSDictionary *dic in dataArray) {
//            VideosModel *model = [[VideosModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
//            [self.sourceArray addObject:model];
//        }
//        self.startPage ++;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取信息失败");
        NSLog(@"%@",error);
        
    }];


}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [RCIM sharedRCIM].receiveMessageDelegate=self;

//    [[[[[self tabBarController]tabBar]items]objectAtIndex:0]setBadgeValue:@"1"];

//    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    //        });
    self.userModel = [[UserInfoModel alloc]init];
    /**
     *  设置主页视图数据源
     */
    [self setArrays];
    /**
     初始化tableView以及其他属性
     */
    [self setViewsAndinitOthers];
    /**
     *  初始化scrollview pagecontrol searchbar backView
     */
    [self setView];
    /**
     *  初始化头视图
     */
    [self setHeadView];
    /**
     *  获取轮播图
     */
    [self getLunbotu];
    /**
     *  获取信息数据
     */
    [self loadNewInfoData];
    /**
     *  上拉加载
     *
     *  @param loadMoreData 获取更多数据
     *
     *  @return NO
     */
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
            [self loadNewInfoData];
            [self getLunbotu];
        }
        else
        {
            [self loadNewServiceData];
            [self getLunbotu];
            
        }
        // 进入刷新状态后会自动调用这个block
        
    }];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

}
#pragma mark----初始化数据以及视图
/**
 *  设置导航栏View
 */
- (void)setNavigation
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.navigationController.navigationBar.translucent = NO;
    //    self.navigationController.navigationBar.hidden =YES;
    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor blackColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    self.statuView = view;
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    self.navigationController.navigationBar.hidden = YES;
    self.statuView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.statuView];
    //    [self loadNewInfoData];
}

/**
 *  设置主页视图，并初始化
 */
- (void)setViewsAndinitOthers
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPublishCell" bundle:nil] forCellReuseIdentifier:@"NewPublishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindServiceViewCell" bundle:nil] forCellReuseIdentifier:@"FindServiceViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChuzhiCell" bundle:nil] forCellReuseIdentifier:@"ChuzhiCell"];
    
    self.tableView.separatorStyle = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 58, 0);
    self.sourceArray = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.view addSubview:self.tableView];
    self.infVc = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
    
}
/**
 *  设置视图array数据源
 */
- (void)setArrays
{
    self.view.userInteractionEnabled = YES;
    self.array1 = @[@"资产包",@"融资信息",@"固定资产",@"个人债权"];
    self.array2 = @[@"投资需求",@"融资需求",@"悬赏信息",@"委外催收"];
    self.array3 = @[@"企业商账",@"法拍资产",@"处置公告",@"担保信息"];
    self.array4 = @[@"资产包收购",@"债权收购",@"律师事务所",@"保理公司"];
    self.array5 = @[@"典当公司",@"投融资服务",@"尽职调查",@"资产收购"];
    self.array6 = @[@"担保公司",@"催收机构"];
    self.array7 = @[@"投资需求"];
    
    self.findType = @"找信息";
    self.imageSourceArray = [NSMutableArray new];
    self.lastSourceArray1 = [NSMutableArray new];
    self.lastSourceArray2 = [NSMutableArray new];
    
    self.imageArray1 = @[@"bao",@"rong",@"gu",@"gerenzhaiquan"];
    self.imageArray2 = @[@"qiye",@"fapai",@"chuzhi"];
}
#pragma mark ---- 设置HeaderView
/**
 *  设置scrollview page searchbar
 */
- (void)setView
{
    [self setScroView];
    [self setPageControl];
    [self setSearchBar];
}
/**
 *  设置Scrollview
 */
- (void)setScroView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, [self getImageViewHight], self.tableView.bounds.size.width, [self getSectionHaderHight] +99)];
    self.searchBarBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 58)];
    self.searchBarBackView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [backView addSubview:self.searchBarBackView];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:
                              CGRectMake(0, 58,backView.bounds.size.width,
                                         [self getSectionHaderHight]
                                         )];
    
    scroView.contentSize = CGSizeMake(backView.bounds.size.width * 2,
                                      [self getSectionHaderHight]);
    scroView.pagingEnabled = YES;
    scroView.delegate = self;
    scroView.alwaysBounceVertical = NO;
    scroView.alwaysBounceHorizontal = YES;
    scroView.showsVerticalScrollIndicator = FALSE;
    scroView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView = scroView;
    
    self.scrollView2 = scroView;
    UIView *leftView = [[UIView alloc]initWithFrame:
                        CGRectMake(0, 0,
                                   self.scrollView.bounds.size.width,
                                   [self getSectionHaderHight])];
    leftView.backgroundColor = [UIColor whiteColor];
    UIView *rightView = [[UIView alloc]initWithFrame:
                         CGRectMake(self.scrollView.bounds.size.width, 0,
                                    self.scrollView.bounds.size.width,
                                    [self getSectionHaderHight])];
    rightView.backgroundColor = [UIColor whiteColor];
    UIView *leftView2 = [[UIView alloc]initWithFrame:
                         CGRectMake(0, 0,
                                    self.scrollView.bounds.size.width,
                                    [self getSectionHaderHight])];
    leftView2.backgroundColor = [UIColor whiteColor];
    UIView *rightView2 = [[UIView alloc]initWithFrame:
                          CGRectMake(self.scrollView.bounds.size.width, 0,
                                     self.scrollView.bounds.size.width,
                                     [self getSectionHaderHight])];
    rightView2.backgroundColor = [UIColor whiteColor];
    [self setButtonWithleftView:leftView];
    [self setButtonWithrightView:rightView];
    [self setButtonWithleftView2:leftView2];
    [self setButtonWithrightView2:rightView2];
    
    self.leftView = leftView;
    self.rightView = rightView;
    self.leftView2 = leftView2;
    self.rightView2 = rightView2;
    
    [self.scrollView addSubview:leftView];
    [self.scrollView addSubview:rightView];
     self.backView = backView;
    [self.backView addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
}
/**
 *  设置pageControl
 */
- (void)setPageControl
{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height , 80, 5)];
     CGPoint pagePoint = CGPointMake(self.view.center.x, [self getSectionHaderHight] +45);
    [self.pageControl setCenter:pagePoint];
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#ef9555"];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#ef8200"];
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * self.pageControl.currentPage, 0) animated:YES];
    [self.scrollView2 setContentOffset:CGPointMake(self.view.bounds.size.width * self.pageControl.currentPage, 0) animated:YES];
    [self.backView addSubview:self.pageControl];
    NSLog(@"%f)))))))))))))))))))))4",self.backView.bounds.size.height);
    [self.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:(UIControlEventValueChanged)];
}
/**
 *  设置SearchBar
 */
- (void)setSearchBar
{
    SearchBar *searchBar= [[SearchBar alloc]initWithFrame:CGRectMake(15, 10, self.view.bounds.size.width-212, 38)];
    self.searchBarbutton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.searchBarbutton.backgroundColor = [UIColor whiteColor];
    [self.searchBarbutton setTitle:@"找信息" forState:(UIControlStateNormal)];
    [self.searchBarbutton setTitleColor:[UIColor colorWithHexString:@"#ef8200"] forState:(UIControlStateNormal)];
    self.searchBarbutton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    
    //    self.searchBarbutton.titleLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    self.searchBarbutton.frame = CGRectMake(0, 0, 90, 50);
    searchBar.leftView = self.searchBarbutton;
    //设置搜索框它的右侧视图
    //设置搜索框它的右侧视图
    UIView *searchBarRightView = [[UIView alloc]initWithFrame:CGRectMake(0, searchBar.bounds.size.width - 60, 60, 38)];
    UIButton *rightSearchbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightSearchbutton setFrame:CGRectMake(25, 4, 30, 30)];
    [rightSearchbutton setImage:[UIImage imageNamed:@"xiaosousuo"] forState:(UIControlStateNormal)];
   
    [rightSearchbutton addTarget:self action:@selector(SrachBarRightButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    searchBar.rightView = searchBarRightView;
    [searchBarRightView addSubview:rightSearchbutton];
    
    //添加小三角
    UIImageView *sanjiao = [[UIImageView alloc]initWithFrame:CGRectMake(self.searchBarbutton.bounds.size.width - 12, 22, 12, 6)];
    [searchBar.leftView addSubview:sanjiao];
    sanjiao.image = [UIImage imageNamed:@"xiala"];
    self.searchBarbutton.layer.cornerRadius = 10;
    self.searchBarbutton.layer.masksToBounds = YES;
    searchBar.rightViewMode = UITextFieldViewModeAlways;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.borderWidth = 1.0f;
    searchBar.borderStyle = UITextBorderStyleRoundedRect;
    
    searchBar.layer.borderColor = [UIColor colorWithHexString:@"#ef8200"].CGColor;
    
  
    searchBar.layer.cornerRadius = 19;
      searchBar.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureAction:)];
    
    [searchBar addGestureRecognizer:tapGesture];
    searchBar.delegate = self;
    [self.searchBarbutton addTarget:self action:@selector(searchBarbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.searchBar = searchBar;
    [self.searchBarBackView addSubview:self.searchBar];
    /**
     设置视频播放按钮
     */
    UIButton *VideoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [VideoButton setFrame:CGRectMake(self.view.bounds.size.width-182, 10, 76, 38)];
    [VideoButton setBackgroundImage:[UIImage imageNamed:@"video_btn"] forState:(UIControlStateNormal)];
    [VideoButton addTarget:self action:@selector(didClickVideoButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *cepingButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cepingButton setFrame:CGRectMake(self.view.bounds.size.width-91, 10, 76, 38)];
    [cepingButton setBackgroundImage:[UIImage imageNamed:@"ping_gu"] forState:(UIControlStateNormal)];
    [cepingButton addTarget:self action:@selector(didClickCepingButton:) forControlEvents:(UIControlEventTouchUpInside)];

    
    
    /**
     *  设置小红点
     */
    UIButton *redButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [redButton setFrame:CGRectMake(VideoButton.bounds.size.width - 15, 0 , 7, 7)];
    [redButton setBackgroundImage:[UIImage imageNamed:@"red_point"] forState:(UIControlStateNormal)];
    self.redbutton = redButton;
    [VideoButton addSubview:self.redbutton];
    
    [self.searchBarBackView addSubview:VideoButton];
    
    [self.searchBarBackView addSubview:cepingButton];
    
    //精选服务视图
    UIImageView *jingxuanView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 58 + [self getSectionHaderHight], self.view.bounds.size.width - 10, 45)];
    
//    UIImageView *jingxuanView = [UIImageView new];
    self.jingxuanView = jingxuanView;
 
    
    [self.jingxuanView setBackgroundColor:[UIColor colorWithHexString:@"f4f4f4"]];
    self.jingxuanView.image = [UIImage imageNamed:@"xinxi"];
    [self.backView addSubview:self.jingxuanView];

    NSLog(@"%f)))))))))))))))))))))3",self.backView.bounds.size.height);
    
}

/**
 *  设置轮播图
 *
 *  @return tableView头视图
 */
- (UIView *)setImageView
{
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self getImageViewHight])];
    //最上方轮播图
    NSString *path = [[NSBundle mainBundle]pathForResource:@"lunbotu1@2x" ofType:@"png"];
    
    NSString *url2 = path;
    NSString *url3 = path;
    NSString *url4 = path;
    NSString *url5 = path;
    /**
     *  为0
     */
    if (self.imageSourceArray.count == 0) {
        url2 = path;
        url3 = path;
        url4 = path;
        url5 = path;
    }
    else
    {
        url2 = [getImageURL stringByAppendingString:self.imageSourceArray[0]];
        url3 = [getImageURL stringByAppendingString:self.imageSourceArray[1]];
        url4 = [getImageURL stringByAppendingString:self.imageSourceArray[2]];
        url5 = [getImageURL stringByAppendingString:self.imageSourceArray[3]];
        
    }
    NSArray *imagearray = @[url5,url2,url3,url4,url5,url2];
    
    NSMutableArray *imageMuarray = [NSMutableArray arrayWithArray:imagearray];
    self.scrollHeadView = [[ScrollHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self getImageViewHight]) arraySource:imageMuarray];
    self.scrollHeadView.Mydelegate = self;
    imageview.image = [UIImage imageNamed:@"lunbotu.jpg"];
    
    //    [self.headView addSubview:imageview];
    [self.headView addSubview:self.scrollHeadView];
    return self.headView;
    
}
- (UIView *)setImageView2
{
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self getImageViewHight])];
    //最上方轮播图
    NSString *path = [[NSBundle mainBundle]pathForResource:@"lunbotu1@2x" ofType:@"png"];
    
    NSString *url2 = path;
    NSString *url3 = path;
    NSString *url4 = path;
    NSString *url5 = path;
    /**
     *  为0
     */
    if (self.imageSourceArray.count == 0) {
        url2 = path;
        url3 = path;
        url4 = path;
        url5 = path;
    }
    else
    {
        url2 = [getImageURL stringByAppendingString:self.imageSourceArray[0]];
        url3 = [getImageURL stringByAppendingString:self.imageSourceArray[1]];
        url4 = [getImageURL stringByAppendingString:self.imageSourceArray[2]];
        url5 = [getImageURL stringByAppendingString:self.imageSourceArray[3]];
        
    }
    NSArray *imagearray = @[url5,url2,url3,url4,url5,url2];
    
    NSMutableArray *imageMuarray = [NSMutableArray arrayWithArray:imagearray];
    self.scrollHeadView = [[ScrollHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self getImageViewHight]) arraySource:imageMuarray];
    self.scrollHeadView.Mydelegate = self;
    imageview.image = [UIImage imageNamed:@"lunbotu.jpg"];
    
    //    [self.headView addSubview:imageview];
    [self.headView addSubview:self.scrollHeadView];
    return self.headView;
    
}

/**
 *  初始化headView
 */
- (void)setHeadView
{
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.backView.bounds.size.height + [self getImageViewHight])];
    [self.headView addSubview:self.backView];
    [self.tableView setTableHeaderView:[self setImageView]];
}

- (CGFloat)heightFotypeimageViews
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 20;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 25;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 25;
    }
    return 0;
}
/**
 *  找信息左侧
 *
 *  @param view 找信息左侧View
 */
- (void)setButtonWithleftView:(UIView *)view
{
    
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 5;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        button.tag = i;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, Buttonheight -20, Buttonheight - 20)];
        imageView.sd_layout.centerXEqualToView(button);
        
        
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, Buttonheight, 20)];
        lable.centerX = imageView.centerX;
        
        
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        
        
        //        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = [UIImage imageNamed:self.imageArray1[i - 1]];
        
        lable.text = self.array1[i-1];
        [button addSubview:imageView];
        [button addSubview:lable];
        [view addSubview:button];
        
        
    }
    //设置按钮的图片---图片数组
//    for (int i = 1; i < 5; i ++) {
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [button setFrame:
//         CGRectMake(20 *i + Buttonheight * (i-1), 10 + Buttonheight + 20,
//                    Buttonheight, Buttonheight)];
//        //        button.backgroundColor = [UIColor blackColor];
//        button.tag = i + 4;
//        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - [self heightFotypeimageViews])];
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.font = [UIFont FontForBigLabel];
//        //        imageView.backgroundColor = [UIColor whiteColor];
//        
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+4]];
//        if (i==1) {
//            imageView.image = [UIImage imageNamed:@"13"];
//        }
//        lable.text = self.array2[i-1];
//        [button addSubview:imageView];
//        [button addSubview:lable];
//        [view addSubview:button];
//    }
}
/**
 *  找信息右侧
 *
 *  @param view 找信息右侧视图
 */
- (void)setButtonWithrightView:(UIView *)view
{
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 4;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        button.tag = i + 8;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, Buttonheight -20, Buttonheight - 20)];
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(-5, button.bounds.size.height-8, button.bounds.size.width, 20)];
        
        lable.centerX = imageView.centerX;

        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        // imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = [UIImage imageNamed:self.imageArray2[i-1]];
        lable.text = self.array3[i-1];
        [button addSubview:imageView];
        [button addSubview:lable];
        [view addSubview:button];
        
//        for (int i = 1; i < 2; i ++) {
//            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//            [button setFrame:
//             CGRectMake(20 *i + Buttonheight * (i-1), 10 + Buttonheight + 20,
//                        Buttonheight, Buttonheight)];
//            //        button.backgroundColor = [UIColor blackColor];
//            button.tag = 25;
//            [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - [self heightFotypeimageViews])];
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
//            lable.textAlignment = NSTextAlignmentCenter;
//            lable.font = [UIFont FontForBigLabel];
//            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",13]];
//            lable.text = self.array7[0];
//            [button addSubview:imageView];
//            [button addSubview:lable];
//            [view addSubview:button];
//        }
        
    }
    
}
/**
 *  找服务左侧
 *
 *  @param view 找服务左侧视图
 */
- (void)setButtonWithleftView2:(UIView *)view
{
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 5;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        button.tag = i + 12;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - [self heightFotypeimageViews])];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        if (i == 1 || i == 3) {
            lable = [[UILabel alloc]initWithFrame:CGRectMake(-5, button.bounds.size.height-8, button.bounds.size.width+10, 20)];
        }
        
        imageView.backgroundColor = [UIColor whiteColor];
        
        lable.font = [UIFont FontForBigLabel];
        lable.textAlignment = NSTextAlignmentCenter;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        if (i==3) {
            imageView.image = [UIImage imageNamed:@"10"];
            
        }
        lable.text = self.array4[i-1];
        [button addSubview:imageView];
        [button addSubview:lable];
        [view addSubview:button];
    }
    //设置按钮的图片---图片数组
    for (int i = 1; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10 + Buttonheight + 20,
                    Buttonheight, Buttonheight)];
        //        button.backgroundColor = [UIColor blackColor];
        button.tag = i + 16;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - [self heightFotypeimageViews])];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        if (i==2) {
            lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width+10, 20)];
        }
        //        imageView.backgroundColor = [UIColor whiteColor];
        lable.font = [UIFont FontForBigLabel];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+4]];
        if (i ==2) {
            imageView.image = [UIImage imageNamed:@"14"];
        }
        if(i==3)
        {
            imageView.image = [UIImage imageNamed:@"8"];
            
        }
        if (i==4) {
            imageView.image = [UIImage imageNamed:@"3"];
        }
        
        lable.text = self.array5[i-1];
        [button addSubview:imageView];
        [button addSubview:lable];
        [view addSubview:button];
    }
}
/**
 *  找服务右侧
 *
 *  @param view 找服务右侧视图
 */
- (void)setButtonWithrightView2:(UIView *)view
{
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 3;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        button.tag = i + 16;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - [self heightFotypeimageViews])];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        //        imageView.backgroundColor = [UIColor whiteColor];
        
        if (i == 1) {
            imageView.image = [UIImage imageNamed:@"12"];
            
        }
        if (i == 2) {
            imageView.image = [UIImage imageNamed:@"9"];
            
        }
        lable.text = self.array6[i-1];
        [button addSubview:imageView];
        [button addSubview:lable];
        [view addSubview:button];
    }
    
    
}


- (void)setPromiseView
{
    UIView *mengbanView= [UIView new];
    UIView *weituoView = [UIView new];
    UIImageView *tuziImage = [UIImageView new];
    UIView *imageBackView = [UIView new];
    
    UIView *bottomView = [UIView new];
    
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    
    
    UIButton *fabuButton = [UIButton new];
    UIButton *fanhuiButton = [UIButton new];
    UIButton *cancelButton = [UIButton new];
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:mengbanView];
    
    [mengbanView addSubview:weituoView];
    [weituoView addSubview:imageBackView];
    [imageBackView addSubview:tuziImage];
    [imageBackView addSubview:cancelButton];
    [weituoView addSubview:bottomView];
    
    [bottomView addSubview:label1];
    [bottomView addSubview:label2];
    
    [bottomView addSubview:fabuButton];
    [bottomView addSubview:fanhuiButton];
    
    mengbanView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    imageBackView.backgroundColor = [UIColor colorWithHexString:@"#5dc1cf"];
    weituoView.backgroundColor = [UIColor whiteColor];
    
    
    
    mengbanView.sd_layout.leftSpaceToView(window,0)
    .rightSpaceToView(window,0)
    .topSpaceToView(window,0)
    .bottomSpaceToView(window,0);
    
    weituoView.sd_layout.centerXEqualToView(mengbanView)
    .centerYIs(self.view.centerY)
    .widthIs(285 * kWidthScale)
    .heightIs(300 * kHeightScale);
    
    imageBackView.sd_layout.leftSpaceToView(weituoView,0)
    .rightSpaceToView(weituoView,0)
    .heightIs(140 * kHeightScale)
    .topSpaceToView(weituoView,0);
    
    tuziImage.sd_layout.centerXEqualToView(imageBackView)
    .centerYEqualToView(imageBackView)
    .heightIs(95*kHeightScale)
    .widthIs(90*kWidthScale);
    tuziImage.image = [UIImage imageNamed:@"TUZI"];
    
    bottomView.sd_layout.leftSpaceToView(weituoView,0)
    .rightSpaceToView(weituoView,0)
    .topSpaceToView(imageBackView,0)
    .bottomSpaceToView(weituoView,0);
    
    
    
    label1.sd_layout.centerXEqualToView(bottomView)
    .topSpaceToView(bottomView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    label1.text = @"温馨提示";
    
    label2.sd_layout.leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15)
    .topSpaceToView(label1,15)
    .autoHeightRatio(0);
    
    label2.text = @"本条VIP信息只针对本类型会员免费开放，详情请咨询会员专线：010-56052557";
    label2.font = [UIFont systemFontOfSize:13];
    
    fabuButton.sd_layout.leftEqualToView(label2)
    .rightEqualToView(label2)
    .topSpaceToView(label2,30*kHeightScale)
    .heightIs(40*kHeightScale);
    [fabuButton setTitle:@"确定" forState:(UIControlStateNormal)];
    fabuButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
//    fanhuiButton.sd_layout.leftEqualToView(label2)
//    .rightEqualToView(label2)
//    .topSpaceToView(fabuButton,20)
//    .heightIs(40*kHeightScale);
//    fanhuiButton.layer.borderWidth = 1.5;
//    fanhuiButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    
    
    cancelButton.sd_layout.rightSpaceToView(imageBackView,10)
    .topSpaceToView(imageBackView,10)
    .heightIs(25)
    .widthIs(25);
    
    
    
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(CancelAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
//    [fanhuiButton setTitle:@"不承诺" forState:(UIControlStateNormal)];
//    [fanhuiButton addTarget:self action:@selector(didClickFanhuiButtonAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [fabuButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [fanhuiButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [fabuButton addTarget:self action:@selector(didClickfabuFabuAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //    self.weituoView = weituoView;
    weituoView.layer.cornerRadius = 10;
    weituoView.layer.masksToBounds = YES;
    self.PromiseView = mengbanView;
    //    [self.PromiseView setHidden:YES];
    
    
}

- (void)CancelAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
}

- (void)didClickfabuFabuAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
    
}


/**
 *  不同机型头视图的高度
 *
 *  @return 视图高度
 */
- (CGFloat )getSectionHaderHight
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 95;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 110;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 120;
        
    }
    return 200;
    
}

- (CGFloat )getSectionHaderHight2
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 170;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 197.5;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 230;
        
    }
    return 200;
    
}
/**
 *  不同机型轮播图的高度
 *
 *  @return 图片高度
 */
- (CGFloat )getImageViewHight
{
    
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 150;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 160;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 176;
        
    }
    
    return 150;
    
}
#pragma mark----网络请求
/**
 *  获取最新信息数据
 */
- (void)loadNewInfoData
{
    self.lastSourceArray1 = self.sourceArray;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    if (self.sourceArray != nil)
    {
        [self.sourceArray removeAllObjects];
    }
    self.startPage = 1;
    
    
    NSString *getURL =FindInformationURL;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token != nil) {
        getURL = [[getURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    }
    
    
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *access_token = @"token";
    NSString *startPage = [NSString stringWithFormat:@"%ld",self.startPage];
    [getdic setObject:startPage forKey:@"startpage"];
    [getdic setObject:access_token forKey:@"access_token"];
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.startPage ++;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray) {
            self.model = [[PublishModel alloc]init];
            [self.model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:self.model];
        }
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
        [self.tableView reloadData];
        [self setHeadView];

        [self.tableView.mj_footer endRefreshing];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.tableView.mj_header endRefreshing];
        
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
   
        
    }];
}
/**
 *  获取最新服务数据
 */
- (void)loadNewServiceData
{
    self.lastSourceArray2 = self.sourceArray;
    
    [self.sourceArray removeAllObjects];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    if (self.sourceArray != nil) {
        [self.sourceArray removeAllObjects];
    }
    self.startPage2 = 1;
    
    NSString *getURL = FindServiceURL;
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *access_token = @"token";
    NSString *startPage = [NSString stringWithFormat:@"%ld",self.startPage2];
    
    [getdic setObject:startPage forKey:@"startpage"];
    [getdic setObject:access_token forKey:@"access_token"];
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"请求服务成功");
        
        self.startPage2 ++;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray) {
            FindServiceModel *findModel = [[FindServiceModel alloc]init];
            [findModel setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:findModel];
            
        }
        [self.tableView reloadData];
        [self setHeadView];

        [self.tableView.mj_header endRefreshing];

        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求服务失败");
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
     }];
}
/**
 *  获取更多数据（信息与服务）
 */
- (void)loadMoreData
{
    if ([self.findType isEqualToString:@"找信息"]) {
        NSString *getURL =FindInformationURL;
        
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        
        if (token != nil) {
            getURL = [[getURL stringByAppendingString:@"?token="]stringByAppendingString:token];
            
        }
        
        
        
        NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
        NSString *access_token = @"token";
        NSString *startPage = [NSString stringWithFormat:@"%ld",self.startPage];
        NSString *pagecount = @"5";
        [getdic setObject:pagecount forKey:@"pagecount"];
        [getdic setObject:access_token forKey:@"access_token"];
        [getdic setObject:startPage forKey:@"startpage"];
        
        [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.startPage ++;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *sourceArray = dic[@"data"];
            NSMutableArray *addArray = [NSMutableArray new];
            for (NSDictionary *dic in sourceArray) {
                self.model = [[PublishModel alloc]init];
                [self.model setValuesForKeysWithDictionary:dic];
                [addArray addObject:self.model];
            }
            if (addArray.count==0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else
            {
            [self.sourceArray addObjectsFromArray:addArray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshing];
        }];
    }
    else
    {
        NSString *getURL = FindServiceURL;
        NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
        NSString *access_token = @"token";
        NSString *startPage = [NSString stringWithFormat:@"%ld",self.startPage2];
        NSString *pagecount = @"5";
        [getdic setObject:pagecount forKey:@"pagecount"];
        [getdic setObject:access_token forKey:@"access_token"];
        [getdic setObject:startPage forKey:@"startpage"];
        [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            self.startPage2 ++;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *sourceArray = dic[@"data"];
            NSMutableArray *addArray = [NSMutableArray new];
            
            for (NSDictionary *dic in sourceArray) {
                
                
                FindServiceModel *findModel = [[FindServiceModel alloc]init];
                [findModel setValuesForKeysWithDictionary:dic];
                [addArray addObject:findModel];
            }
            if (addArray.count == 0) {
                //            [self.tableView.mj_footer resetNoMoreData];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];

            }
            else
            {
            [self.sourceArray addObjectsFromArray:addArray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshing];
           }];
    }
}
/**
 *  获取轮播图
 */
- (void)getLunbotu
{
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *accesstoken = @"token";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    [dic setObject:accesstoken forKey:@"access_token"];
//    NSString *getbannerURL = [getDataURL stringByAppendingString:@"/app/banner?access_token=token"];
       NSString *getbannerURL = [getDataURL stringByAppendingString:@"/app/twobanner?access_token=token"];
//    http://api.ziyawang.com/v1/app/twobanner?access_token=token
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //    })
    
    // @" http://api.ziyawang.com/v1/app/banner?access_token=token"
    [self.manager GET:getbannerURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
    {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"!!!!!!!!%@",responseObject);
        self.imageDataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"111111111111111%@",self.imageDataArray);
        for (NSDictionary *dic in self.imageDataArray) {
            LunboModel *model = [[LunboModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.imageSourceArray addObject:model.BannerLink];
        }
        [self.tableView setTableHeaderView:[self setImageView]];
        NSLog(@"%@",self.imageSourceArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求轮播图失败");
        
        
    }];
    
    
}

#pragma mark---监听事件


- (void)SrachBarRightButtonAction:(UIButton *)button
{
    SearchController *searchVC = [[SearchController alloc]init];
    searchVC.findType = self.searchBarbutton.titleLabel.text;
    
    [self.navigationController pushViewController:searchVC animated:YES];

}

/**
 *  测评入口
 */

- (void)didClickCepingButton:(UIButton *)button
{
    TestViewController *testVC = [[TestViewController alloc]init];
    [self.navigationController pushViewController:testVC animated:YES];
    
}
- (void)didClickVideoButton:(UIButton*)button
{
    VideosListController *videoVC = [[VideosListController alloc]init];
    [self.navigationController pushViewController:videoVC animated:YES];
}
/**
 *  searchBar轻拍事件
 *
 *  @param gesture gesture description
 */
- (void)tapgestureAction:(UITapGestureRecognizer *)gesture
{
    SearchController *searchVC = [[SearchController alloc]init];
    searchVC.findType = self.searchBarbutton.titleLabel.text;
    
    [self.navigationController pushViewController:searchVC animated:YES];
    //    [self presentViewController:searchVC animated:YES completion:nil];
}
/**
 *  搜索框按钮点击事件
 *
 *  @param searchButton <#searchButton description#>
 */
- (void)searchBarbuttonAction:(UIButton *)searchButton
{
    
    if ([searchButton.titleLabel.text isEqualToString:@"找信息"]) {
//        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, [self getImageViewHight], self.tableView.bounds.size.width, [self getSectionHaderHight2] +99)];
//        
//       self.scrollView = [[UIScrollView alloc]initWithFrame:
//                                  CGRectMake(0, 58,self.backView.bounds.size.width,
//                                             [self getSectionHaderHight2]
//                                             )];
//        
        [self.backView setFrame:CGRectMake(0, [self getImageViewHight], self.tableView.bounds.size.width, [self getSectionHaderHight2] +99)];
        [self.scrollView setFrame:CGRectMake(0, 58,self.backView.bounds.size.width,
                                            [self getSectionHaderHight2]
                                             )];
        
        
        [self.jingxuanView setFrame:CGRectMake(3.5, 58 + [self getSectionHaderHight2], self.view.bounds.size.width, 45)];
        
        [self.pageControl setFrame:CGRectMake(0, self.scrollView.bounds.size.height , 80, 5)];
        CGPoint pagePoint = CGPointMake(self.view.center.x, [self getSectionHaderHight2] +45);
        [self.pageControl setCenter:pagePoint];
        
        
        [self loadNewServiceData];
        [searchButton setTitle:@"找服务" forState:(UIControlStateNormal)];
        self.findType = @"找服务";
        self.jingxuanView.image = [UIImage imageNamed:@"youzhifuwu"];
        [self.scrollView addSubview:self.leftView2];
        [self.scrollView addSubview:self.rightView2];

    }
    if ([searchButton.titleLabel.text isEqualToString:@"找服务"]) {
        [self.backView setFrame:CGRectMake(0, [self getImageViewHight], self.tableView.bounds.size.width, [self getSectionHaderHight] +99)];
        [self.scrollView setFrame:CGRectMake(0, 58,self.backView.bounds.size.width,
                                             [self getSectionHaderHight]
                                             )];
        [self.jingxuanView setFrame:CGRectMake(3.5, 58 + [self getSectionHaderHight], self.view.bounds.size.width, 45)];
        [self.pageControl setFrame:CGRectMake(0, self.scrollView.bounds.size.height , 80, 5)];
        CGPoint pagePoint = CGPointMake(self.view.center.x, [self getSectionHaderHight] +45);
        [self.pageControl setCenter:pagePoint];

        [self loadNewInfoData];
        [searchButton setTitle:@"找信息" forState:(UIControlStateNormal)];
        self.findType = @"找信息";
        self.jingxuanView.image = [UIImage imageNamed:@"xinxi"];
        
        [self.scrollView addSubview:self.leftView];
        [self.scrollView addSubview:self.rightView];

    }
    
}
/**
 *  轻拍轮播图事件
 */
- (void)didTapScrollHeadView
{
    VideosListController *videoVC = [[VideosListController alloc]init];
    [self.navigationController pushViewController:videoVC animated:YES];
}
#pragma mark----scrollview textfield代理方法
/**
 *  textField开始编辑
 *
 *  @param textField textField description
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    SearchController *searchVC = [[SearchController alloc]init];
    searchVC.findType = self.searchBarbutton.titleLabel.text;
    [self.searchBar resignFirstResponder];
    [self.navigationController pushViewController:searchVC animated:YES];
    //    [self presentViewController:searchVC animated:YES completion:nil];
}
/**
 *  scrollview拖动
 *
 *  @param scrollView scrollView description
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.searchBar resignFirstResponder];
    
    if (scrollView.contentOffset.y > [self getImageViewHight]||scrollView.contentOffset.y == [self getImageViewHight]) {
        //        [self.view bringSubviewToFront:self.searchView];
        [self.searchBarBackView setFrame:CGRectMake(0, 20, self.searchBarBackView.bounds.size.width, self.searchBarBackView.bounds.size.height)];
        //        [self.searchBar setFrame:CGRectMake(20, 20, self.searchBar.bounds.size.width, self.searchBar.bounds.size.height)];
        self.navigationController.navigationBar.hidden = YES;
        self.statuView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.statuView];
        //        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        //        [self.view addSubview:self.searchBar];
        [self.view addSubview:self.searchBarBackView];
    }
    else
    {
//        self.navigationController.navigationBar.hidden = NO;
        
        //        [self.view sendSubviewToBack:self.searchView];
        //        [self.searchBar setFrame:CGRectMake(20, 10, self.searchBar.bounds.size.width, self.searchBar.bounds.size.height)];
        [self.searchBarBackView setFrame:CGRectMake(0, 0, self.searchBarBackView.bounds.size.width, self.searchBarBackView.bounds.size.height)];
        
        //        [self.backView addSubview:self.searchBar];
        [self.backView addSubview:self.searchBarBackView];
        
        
    }
}
/**
 *  结束拖动
 *
 *  @param scrollView scrollView description
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        NSLog(@"------是列表---");
    }
    else {
        //滑动scrollView后，改变pageControl当前点
        CGPoint contentOffset = scrollView.contentOffset;
        NSInteger currentPage = contentOffset.x / self.view.bounds.size.width;
        //设置self.pageControl的选中点
        [self.pageControl setCurrentPage:currentPage];
        
        NSLog(@"%f(((((((((((((((((((((",self.backView.bounds.size.height);
        
        
        //        if (currentPage == 0) {
        //            [self findInfomations];
        //            [self.searchBarbutton setTitle:@"找信息" forState:(UIControlStateNormal)];
        //        }
        //        else
        //        {
        //            [self.searchBarbutton setTitle:@"找服务" forState:(UIControlStateNormal)];
        //
        //
        //        }
    }
    
}
/**
 *  pageAction
 *
 *  @param pageControl pageControl description
 */
- (void)pageControlAction:(UIPageControl *)pageControl
{
    NSLog(@"当前选中页数：%ld,%s,%d",pageControl.currentPage, __FUNCTION__,__LINE__);
    //改变self.scrollView的contenOffset
    //    [self.scrollView setContentInset:CGPointMake(self.view.bounds.size.width*pageControl.currentPage,0) animated:YES)];
    
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * pageControl.currentPage, 0) animated:YES];
 }
/**
 *  主页循环按钮点击事件
 *
 *  @param sender buttons
 */
- (void)addtatgetWithButtonTag:(UIButton *)sender
{
//    SearchTypeController *searchVC = [[SearchTypeController alloc]init];
    FindTypeController *searchVC = [[FindTypeController alloc]init];
    FindServiceTypeController *findserviceVC = [[FindServiceTypeController alloc]init];
    
    
//    @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"固产求购",@"融资借贷",@"法律服务",@"悬赏信息",@"委外催收",@"尽职调查",@"典当担保"];
    NSArray *level = @[@"VIP1"];
    NSArray *informationTypeID =@[@"01",@"14",@"12",@"04",@"13",@"06",@"03",@"09",@"10",@"02",@"05"];
    
    //    NSArray *infonmationType = @[@"资产包收购",@"催收机构",@"律师事务所",@"保理公司",@"典当担保",@"投融资服务",@"尽职调查",@"资产收购",@"债权收购"];
    //    NSArray *informationTypeID = @[@"01",@"02",@"03",@"04",@"05",@"06",@"10",@"12",@"14"];
    NSString *type = @"找信息";
    
    
    
    DetailOfInfoController *detailVC = [[DetailOfInfoController alloc]init];
    
    switch (sender.tag)
    
    {
        case 1:
            
            
//            NSLog(@"1");
//            
            searchVC.type = @"资产包";
            searchVC.searchValue = @"1";
            searchVC.navigationItem.title = @"资产包";
            [self.navigationController pushViewController:searchVC animated:YES];
//            [self.navigationController pushViewController:detailVC animated:YES];

            
            break;
        case 2:
            NSLog(@"2");
            searchVC.type = @"融资信息";
            searchVC.searchValue = @"rzxx";
            searchVC.navigationItem.title = @"融资信息";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 3:
            NSLog(@"3");
            searchVC.type = @"固定资产";
            searchVC.searchValue = @"gdzc";
            searchVC.navigationItem.title = @"固定资产";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 4:
            NSLog(@"4");
            searchVC.type = @"个人债权";
            searchVC.searchValue = @"19";
            searchVC.navigationItem.title = @"个人债权";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 5:
            NSLog(@"5");
            searchVC.type = @"投资需求";
            searchVC.searchValue = @"15";
            searchVC.navigationItem.title = @"投资需求";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 6:
            NSLog(@"6");
            searchVC.type = @"融资需求";
            searchVC.searchValue = @"06";
            searchVC.navigationItem.title = @"融资需求";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 7:
            NSLog(@"7");
            searchVC.type = @"悬赏信息";
            searchVC.searchValue = @"09";
            searchVC.navigationItem.title = @"悬赏信息";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 8:
            NSLog(@"8");
            searchVC.type = @"委外催收";
            searchVC.searchValue = @"02";
            searchVC.navigationItem.title = @"委外催收";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 9:
            NSLog(@"9");
            searchVC.type = @"企业商账";
            searchVC.searchValue = @"18";
            searchVC.navigationItem.title = @"企业商账";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 10:
            NSLog(@"10");
            searchVC.type = @"法拍资产";
            searchVC.searchValue = @"fpzc";
            searchVC.navigationItem.title = @"法拍资产";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 11:
            NSLog(@"11");
            searchVC.type = @"处置公告";
            searchVC.searchValue = @"czgg";
            searchVC.navigationItem.title = @"处置公告";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 12:
            NSLog(@"12");
            searchVC.type = type;
            searchVC.searchValue = @"05";
            searchVC.navigationItem.title = @"担保信息";
        [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 13:
            NSLog(@"13");
            
            findserviceVC.searchValue = @"01";
            findserviceVC.type = @"资产包收购";
            findserviceVC.navigationItem.title = @"资产包收购";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            
            break;
            
        case 14:
            NSLog(@"14");
            findserviceVC.searchValue = @"14";
            findserviceVC.type = @"债权收购";
            findserviceVC.navigationItem.title = @"债权收购";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            
            break;
        case 15:
            NSLog(@"15");
            findserviceVC.searchValue = @"03";
            findserviceVC.type = @"律师事务所";
            findserviceVC.navigationItem.title = @"律师事务所";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            
            break;
        case 16:
            NSLog(@"16");
            findserviceVC.searchValue = @"04";
            findserviceVC.type = @"保理服务";

            findserviceVC.navigationItem.title = @"保理服务";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            
            break;
        case 17:
            NSLog(@"17");
            findserviceVC.searchValue = @"05";
            findserviceVC.type = @"典当公司";

            findserviceVC.navigationItem.title = @"典当公司";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            
            break;
        case 18:
            NSLog(@"18");
            findserviceVC.searchValue = @"06";
            findserviceVC.type = @"投资放贷";

            findserviceVC.navigationItem.title = @"投资放贷";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            
            break;
        case 19:
            NSLog(@"19");
            findserviceVC.searchValue = @"10";
            findserviceVC.type = @"尽职调查";

            findserviceVC.navigationItem.title = @"尽职调查";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            break;
        case 20:
            NSLog(@"19");
            findserviceVC.searchValue = @"12";
            findserviceVC.type = @"资产收购";

            findserviceVC.navigationItem.title = @"资产收购";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            break;
        case 21:
            NSLog(@"19");
            findserviceVC.searchValue = @"05";
            findserviceVC.type = @"担保服务";

            findserviceVC.navigationItem.title = @"担保服务";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            break;
        case 22:
            NSLog(@"19");
            findserviceVC.searchValue = @"02";
            findserviceVC.type = @"债权收购";
            findserviceVC.navigationItem.title = @"催收机构";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            break;
        case 25:
            NSLog(@"25");
            findserviceVC.type = @"投资需求";
            findserviceVC.searchValue = @"15";
            findserviceVC.navigationItem.title = @"投资需求";
            [self.navigationController pushViewController:findserviceVC animated:YES];
            break;
        default:
            break;
    }
    
    
    
}


#pragma mark----支付
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
            self.account = dic[@"user"][@"Account"];
            self.role = dic[@"role"];
            self.USERID = dic[@"user"][@"userid"];
            
            
            [self.userModel setValuesForKeysWithDictionary:dic[@"user"]];
            [self.userModel setValuesForKeysWithDictionary:dic[@"service"]];
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
    }
    
}

- (void)payForMessage
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    [dataDic setObject:@"token" forKey:@"access_token"];
    [dataDic setObject:self.pubModel.ProjectID forKey:@"ProjectID"];
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
             self.pubModel.PayFlag = @"1";
             
             [self.navigationController pushViewController:self.infoDetailsVC animated:YES];
             
             
             //             [self.connectButton setTitle:@"已约谈" forState:(UIControlStateNormal)];
             [self.blackBackView2 removeFromSuperview];
             [self.alertView2 removeFromSuperview];
         }
         [self.HUD removeFromSuperViewOnHide];
         [self.HUD hideAnimated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         
     }];
    
}


- (void)ShowAlertViewController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要先通过服务方认证才可查看收费类信息" preferredStyle:UIAlertControllerStyleAlert];
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
    textLabel.text = @"消耗芽币可查看详细信息";
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
    
    CGSize labelSize2 = [self.pubModel.Price sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width,Height + 20*kHeightScale,labelSize2.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label1.numberOfLines = 0;
    label1.text = self.pubModel.Price;
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
    CGSize labelSize22 = [self.account sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width,Height + 20*kHeightScale + 32* kHeightScale,labelSize22.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label2.numberOfLines = 0;
    label2.text = self.account;
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
    if (self.account.integerValue < self.pubModel.Price.integerValue)
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
    if(self.pubModel.Price.integerValue > self.account.integerValue)
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
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PublishModel *model = [[PublishModel alloc]init];
//    model = self.sourceArray[indexPath.row];
//    model.TypeID = [NSString stringWithFormat:@"%@",model.TypeID];
    
//    if ([model.TypeID isEqualToString:@"1"]||[model.TypeID isEqualToString:@"12"]) {
//        return 135;
//    }
//    
//    else
//    {
//        return 115;
//    }
    if ([self.findType isEqualToString:@"找信息"]) {
        if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
        {
            
            return 125;
        }
        else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
        {
            return 115;
        }
        else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
        {
            return 115;
        }
        

    }
    else
    {
        if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
        {
            
            return 125;
        }
        else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
        {
            return 135;
        }
        else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
        {
            return 135;
        }

    }
    
        return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    if ([self.findType isEqualToString:@"找信息"]) {
        
        PublishModel *model = [[PublishModel alloc]init];
        model = self.sourceArray[indexPath.row];
        model.TypeID = [NSString stringWithFormat:@"%@",model.TypeID];
        if ([model.TypeID isEqualToString:@"99"]) {
            ChuzhiCell *cell2 = [self.tableView dequeueReusableCellWithIdentifier:@"ChuzhiCell" forIndexPath:indexPath];
            
            cell2.model = self.sourceArray[indexPath.row];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell2;
        }
        else
        {
        
        NewPublishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewPublishCell" forIndexPath:indexPath];
        
        
        //        if (cell == nil)
        //        {
        //            cell = [[PublishCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PublishCell"];
        //        }
        cell.model = self.sourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        }
    }
    else
    {
     
        
    FindServiceViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FindServiceViewCell" forIndexPath:indexPath];
        //        if (cell == nil)
        //        {
        //            cell = [[FindServiceViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"FindServiceViewCell"];
        //        }
//        if (self.sourceArray.count==0) {
//            self.sourceArray = self.lastSourceArray1;
//        }
        cell.model = self.sourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    
    
    ChuzhiDetailController *chuzhiVC = [[ChuzhiDetailController alloc]init];
    
    //    InfoDetailsController *infoDetailsVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil]instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
    
 
    
    
    if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
//        InfoDetailsController *infoDetailsVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil]instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
//        PublishModel *model = [[PublishModel alloc]init];
////        if (self.sourceArray.count == 0) {
////            self.sourceArray = self.lastSourceArray2;
////        }
//        model = self.sourceArray[indexPath.row];
//        infoDetailsVC.ProjectID = model.ProjectID;
//        infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
//        NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
//        infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
//        infoDetailsVC.typeName = model.TypeName;
//        [self.navigationController pushViewController:infoDetailsVC animated:YES];
        
        
        PublishModel *model = [[PublishModel alloc]init];
        model = self.sourceArray[indexPath.row];
        if ([model.Member isEqualToString:@"1"])
        {
            [self setPromiseView];
        }
        
        else
        {
        
        
        if ([model.TypeID isEqualToString:@"99"]) {
            chuzhiVC.NewsID = model.NewsID;
            
            [self.navigationController pushViewController:chuzhiVC animated:YES];
            
        }
            else
                
            {

        
        /**
         *  新支付
         */
        DetailOfInfoController *infoDetailsVC = [[DetailOfInfoController alloc]init];
        
//        InfoDetailsController *infoDetailsVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil]instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
        PublishModel *model = [[PublishModel alloc]init];
        model = self.sourceArray[indexPath.row];
        self.pubModel = model;
        
        infoDetailsVC.ProjectID = model.ProjectID;
        infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
        NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
        infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
        infoDetailsVC.typeName = model.TypeName;
        self.infoDetailsVC = infoDetailsVC;
        
        model.Member = [NSString stringWithFormat:@"%@",model.Member];
        
        if ([self.USERID isEqualToString:model.UserID])
        {
            [self.navigationController pushViewController:infoDetailsVC animated:YES];
            return;
        }
        
        if ([model.Member isEqualToString:@"2"] == NO)
        {
            [self.navigationController pushViewController:infoDetailsVC animated:YES];
        }
        else
        {
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
            if (token == nil) {
                NSLog(@"未登录,提示登录");
                LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            else if([self.role isEqualToString:@"1"])
            {
            self.pubModel.PayFlag = [NSString stringWithFormat:@"%@",self.pubModel.PayFlag];
            if ([self.pubModel.Member isEqualToString:@"2"] == NO )
                {
//                    if([self.pubModel.PayFlag isEqualToString:@"1"]== NO)
//                    {
//                        [self payForMessage];
//                    }
                    [self.navigationController pushViewController:infoDetailsVC animated:YES];
                }
                else
                {
                    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
                    NSString *URL = IfHadPayMessageURL;
                    if (token != nil) {
                        URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setObject:@"token" forKey:@"access_token"];
                        [dic setObject:self.pubModel.ProjectID forKey:@"ProjectID"];
                        
                    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                        if ([dic[@"status_code"] isEqualToString:@"200"]) {
                            self.pubModel.PayFlag = dic[@"PayFlag"];
                            self.pubModel.PayFlag = [NSString stringWithFormat:@"%@",self.pubModel.PayFlag];
                            
                            
                            if ([self.pubModel.PayFlag isEqualToString:@"1"] == NO)
                            {
                                    [self createViewForLessMoney];

                            }
                            else
                            {
                                [self.navigationController pushViewController:infoDetailsVC animated:YES];
                            }
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                    }];
                        
                    }
                    

                    
          
                }
            }
            else if([self.role isEqualToString:@"0"]||[self.role isEqualToString:@"2"])
            {
                
                if([self.pubModel.TypeName isEqualToString:@"投资需求"] || [self.pubModel.TypeName isEqualToString:@"资产求购"])
                {
                    [self.navigationController pushViewController:infoDetailsVC animated:YES];
                    
                }
                else
                {
                    [self ShowAlertViewController];
                }
            }
            
            
        }
            }
        
        }
        
        
    }
    else
    {
        FindServiceModel *model = [[FindServiceModel alloc]init];
        model = self.sourceArray[indexPath.row];
        NSLog(@"!!!!!!!!!!%@",model.ServiceID);
        ServiceDetailController *ServiceDetailVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDetailController"];
        ServiceDetailVC.ServiceID = model.ServiceID;
        ServiceDetailVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
        [self.navigationController pushViewController:ServiceDetailVC animated:YES];
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
