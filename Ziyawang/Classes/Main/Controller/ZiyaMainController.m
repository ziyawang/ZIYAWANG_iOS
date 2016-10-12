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
@interface ZiyaMainController ()<scrollHeadViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate>

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

@end

@implementation ZiyaMainController
#pragma mark----系统方法视图周期
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    //    [self.navigationController.navigationBar setBackgroundColor:[UIColor yellowColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
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
//    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    //        });
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
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
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
    [self.tableView registerNib:[UINib nibWithNibName:@"PublishCell" bundle:nil] forCellReuseIdentifier:@"PublishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindServiceViewCell" bundle:nil] forCellReuseIdentifier:@"FindServiceViewCell"];
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
    self.array1 = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理"];
    self.array2 = @[@"投资需求",@"融资需求",@"悬赏信息",@"委外催收"];
    self.array3 = @[@"尽职调查",@"法律服务",@"资产求购",@"担保信息"];
    self.array4 = @[@"资产包收购",@"债权收购",@"律师事务所",@"保理公司"];
    self.array5 = @[@"典当公司",@"投融资服务",@"尽职调查",@"资产收购"];
    self.array6 = @[@"担保公司",@"催收机构"];
    self.array7 = @[@"投资需求"];
    
    self.findType = @"找信息";
    self.imageSourceArray = [NSMutableArray new];
    self.lastSourceArray1 = [NSMutableArray new];
    self.lastSourceArray2 = [NSMutableArray new];
    
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
}
/**
 *  设置pageControl
 */
- (void)setPageControl
{    CGPoint pagePoint = CGPointMake(self.view.center.x, [self getSectionHaderHight] +45);
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height , 80, 5)];
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
    SearchBar *searchBar= [[SearchBar alloc]initWithFrame:CGRectMake(15, 10, self.view.bounds.size.width-121, 38)];
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
    //    [rightSearchbutton addTarget:self action:@selector(rightButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
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
    [VideoButton setFrame:CGRectMake(self.view.bounds.size.width-91, 10, 76, 38)];
    [VideoButton setBackgroundImage:[UIImage imageNamed:@"video_btn"] forState:(UIControlStateNormal)];
    [VideoButton addTarget:self action:@selector(didClickVideoButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    /**
     *  设置小红点
     */
    UIButton *redButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [redButton setFrame:CGRectMake(VideoButton.bounds.size.width - 15, 0 , 7, 7)];
    [redButton setBackgroundImage:[UIImage imageNamed:@"red_point"] forState:(UIControlStateNormal)];
    self.redbutton = redButton;
    [VideoButton addSubview:self.redbutton];
    
    [self.searchBarBackView addSubview:VideoButton];
    
    
    //精选服务视图
    UIImageView *jingxuanView = [[UIImageView alloc]initWithFrame:CGRectMake(3.5, 58 + [self getSectionHaderHight], self.view.bounds.size.width, 45)];
    [jingxuanView setBackgroundColor:[UIColor colorWithHexString:@"f4f4f4"]];
    jingxuanView.image = [UIImage imageNamed:@"jingxuanxinxi"];
    self.jingxuanView = jingxuanView;
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
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - [self heightFotypeimageViews])];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        if (i == 1) {
            lable = [[UILabel alloc]initWithFrame:CGRectMake(-5, button.bounds.size.height-8, button.bounds.size.width+10, 20)];
        }
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        //        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        lable.text = self.array1[i-1];
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
        button.tag = i + 4;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - [self heightFotypeimageViews])];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        //        imageView.backgroundColor = [UIColor whiteColor];
        
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+4]];
        if (i==1) {
            imageView.image = [UIImage imageNamed:@"13"];
        }
        
        lable.text = self.array2[i-1];
        [button addSubview:imageView];
        [button addSubview:lable];
        [view addSubview:button];
    }
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
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - [self heightFotypeimageViews])];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        //        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+8]];
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
/**
 *  不同机型头视图的高度
 *
 *  @return 视图高度
 */
- (CGFloat )getSectionHaderHight
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
    
    
    NSString *getURL = FindInformationURL;
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
    NSString *startPage = [NSString stringWithFormat:@"%ld",self.startPage];
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
        NSString *getURL = FindInformationURL;
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
        [self loadNewServiceData];
        [searchButton setTitle:@"找服务" forState:(UIControlStateNormal)];
        self.findType = @"找服务";
        self.jingxuanView.image = [UIImage imageNamed:@"youzhifuwu"];
        [self.scrollView addSubview:self.leftView2];
        [self.scrollView addSubview:self.rightView2];
    }
    if ([searchButton.titleLabel.text isEqualToString:@"找服务"]) {
        [self loadNewInfoData];
        [searchButton setTitle:@"找信息" forState:(UIControlStateNormal)];
        self.findType = @"找信息";
        self.jingxuanView.image = [UIImage imageNamed:@"jingxuanxinxi"];
        
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
    
    
    switch (sender.tag)
    
    {
        case 1:
            NSLog(@"1");
            
            searchVC.type = @"资产包转让";
            searchVC.searchValue = @"01";
            searchVC.navigationItem.title = @"资产包转让";
            [self.navigationController pushViewController:searchVC animated:YES];
            
            break;
        case 2:
            NSLog(@"2");
            searchVC.type = @"债权转让";
            searchVC.searchValue = @"14";
            searchVC.navigationItem.title = @"债权转让";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 3:
            NSLog(@"3");
            searchVC.type = @"固产转让";
            searchVC.searchValue = @"12";
            searchVC.navigationItem.title = @"固产转让";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 4:
            NSLog(@"4");
            searchVC.type = @"商业保理";
            searchVC.searchValue = @"04";
            searchVC.navigationItem.title = @"商业保理";
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
            searchVC.type = @"尽职调查";
            searchVC.searchValue = @"10";
            searchVC.navigationItem.title = @"尽职调查";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 10:
            NSLog(@"10");
            searchVC.type = @"法律服务";
            searchVC.searchValue = @"03";
            searchVC.navigationItem.title = @"法律服务";
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        case 11:
            NSLog(@"11");
            searchVC.type = @"资产求购";
            searchVC.searchValue = @"13";
            searchVC.navigationItem.title = @"资产求购";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 130;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 140;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 140;
        
    }
    
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.findType isEqualToString:@"找信息"]) {
        PublishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
        
        
        //        if (cell == nil)
        //        {
        //            cell = [[PublishCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PublishCell"];
        //        }
        cell.model = self.sourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
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
    if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
        InfoDetailsController *infoDetailsVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil]instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
        PublishModel *model = [[PublishModel alloc]init];
//        if (self.sourceArray.count == 0) {
//            self.sourceArray = self.lastSourceArray2;
//        }
        model = self.sourceArray[indexPath.row];
        infoDetailsVC.ProjectID = model.ProjectID;
        infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
        NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
        infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
        infoDetailsVC.typeName = model.TypeName;
        
        [self.navigationController pushViewController:infoDetailsVC animated:YES];
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
