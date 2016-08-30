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
@interface ZiyaMainController ()<scrollHeadViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *backView2;

@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *searchBarbutton;

@property (nonatomic,strong) UIButton *findButton;

@property (nonatomic,strong) NSString *infoType;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) NSMutableArray *sourceArray2;
@property (nonatomic,strong) PublishModel *model;
@property (nonatomic,assign) BOOL reload;


@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *searchView;


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) SearchBar *searchBar;

@property (nonatomic,strong) UIViewController *infVc;

@property (nonatomic,strong) UIScrollView *scrollView2;
@property (nonatomic,strong) UIScrollView *scrollView1;


@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;


@property (nonatomic,strong) UIView *leftView2;
@property (nonatomic,strong) UIView *rightView2;


@property (nonatomic,strong) NSArray *array1;
@property (nonatomic,strong) NSArray *array2;
@property (nonatomic,strong) NSArray *array3;
@property (nonatomic,strong) NSArray *array4;
@property (nonatomic,strong) NSArray *array5;
@property (nonatomic,strong) NSArray *array6;
@property (nonatomic,assign) NSInteger startPage;
@property (nonatomic,strong) NSArray *imageDataArray;
@property (nonatomic,strong) UIImageView *jingxuanView;
@property (nonatomic,strong) NSMutableArray *imageSourceArray;
@property (nonatomic,strong) UIView *statuView;

@property (nonatomic,strong) NSString *findType;


@property (nonatomic,strong) NSMutableArray *lastSourceArray1;
@property (nonatomic,strong) NSMutableArray *lastSourceArray2;

@end

@implementation ZiyaMainController

//设置不能横屏
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait ;
//}
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}





//设置跳出后的导航栏风格
- (void)viewWillDisappear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor yellowColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getLunbotu];

//    [self setBackView];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.hidden =YES;

    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
//    [self loadNewInfoData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    
    self.array1 = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理"];
    self.array2 = @[@"典当信息",@"融资需求",@"悬赏信息",@"尽职调查"];
    self.array3 = @[@"委外催收",@"法律服务",@"资产求购",@"担保信息"];
    self.array4 = @[@"资产包收购",@"债权收购",@"律师事务所",@"保理公司"];
    self.array5 = @[@"典当公司",@"投融资服务",@"尽职调查",@"资产收购"];
    self.array6 = @[@"担保公司",@"催收机构"];

//    [self.view setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
//    self.view.backgroundColor = [UIColor blackColor];
//    self.navigationController.navigationBar.alpha=0;
    //    导航栏变为透明
//    [self.navigationController setTitle:@""];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@ "icon_left_jt" ] forBarMetrics:UIBarMetricsDefault];
    
//

    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
//    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    
//    self.navigationController.navigationBar.hidden = YES;
    
    self.findType = @"找信息";
    self.imageSourceArray = [NSMutableArray new];
    self.lastSourceArray1 = [NSMutableArray new];
    self.lastSourceArray2 = [NSMutableArray new];
    
    
    
//    [self getLunbotu];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PublishCell" bundle:nil] forCellReuseIdentifier:@"PublishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindServiceViewCell" bundle:nil] forCellReuseIdentifier:@"FindServiceViewCell"];
    self.tableView.separatorStyle = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 58, 0);
//    [self getLunbotu];
    self.sourceArray = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    [self.view addSubview:self.tableView];
    [self setView];
    [self setBackView];
    [self getLunbotu];
         UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    self.statuView = view;
    self.infVc = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
    [self loadNewInfoData];
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

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
    self.startPage = 0;
    
    
    NSString *getURL = @"http://api.ziyawang.com/v1/project/list";
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        });
       
    }];
}


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
    self.startPage = 0;
    
    NSString *getURL = @"http://api.ziyawang.com/v1/service/list";
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

        self.startPage ++;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray) {
            FindServiceModel *findModel = [[FindServiceModel alloc]init];
            [findModel setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:findModel];
            
        }
        [self.tableView reloadData];
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
- (void)loadMoreData
{
    if ([self.findType isEqualToString:@"找信息"]) {
        NSString *getURL = @"http://api.ziyawang.com/v1/project/list";
        NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
        NSString *access_token = @"token";
        NSString *startPage = [NSString stringWithFormat:@"%ld",self.startPage];
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
            [self.tableView.mj_footer resetNoMoreData];

            }
            [self.sourceArray addObjectsFromArray:addArray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshing];
        }];
        }
    else
    {
        NSString *getURL = @"http://api.ziyawang.com/v1/service/list";
        NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
        NSString *access_token = @"token";
        
        NSString *startPage = [NSString stringWithFormat:@"%ld",self.startPage];
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
                
                
                FindServiceModel *findModel = [[FindServiceModel alloc]init];
                [findModel setValuesForKeysWithDictionary:dic];
                [addArray addObject:findModel];
            }
            if (addArray.count == 0) {
                //            [self.tableView.mj_footer resetNoMoreData];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
            [self.sourceArray addObjectsFromArray:addArray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshing];
          
            

        }];
    }
   }



- (CGFloat )getSectionHaderHight
{
    //    self.messageLable.text = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSString *version = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSLog(@"%@",version);
    NSLog(@"!!!!!!%@",DeviceVersionNames[[SDiOSVersion deviceVersion]]);
    
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 170;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 197.5;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 230;
        
    }
    return 200;
    
}
- (CGFloat )getImageViewHight
{

    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 150;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 160;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 176;
        
    }
    
    return 150;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark ---- 设置HeaderView
- (void)setView
{
    [self setScroView];
    [self setPageControl];
    [self setSearchBar];
}


- (void)setScroView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, [self getImageViewHight], self.tableView.bounds.size.width, [self getSectionHaderHight] +99)];
//    UIView *jingxuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 38 + [self getSectionHaderHight], self.view.bounds.size.width, 30)];

    
    
    
//    self.backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [self getSectionHaderHight] +50)];
    NSLog(@"**********************%f",self.tableView.bounds.size.width);
    NSLog(@"2@@@@@@@@@@@@@@@@@@@@@@%f",[self getSectionHaderHight]);
    
    backView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    
//        backView.backgroundColor = [UIColor lightGrayColor];

    //    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 + [self getSectionHaderHight] +15, self.view.bounds.size.width, 50)];
    //    typeView.backgroundColor = [UIColor grayColor];
    //    [backView addSubview:typeView];
    
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
//    UIView *thirdView = [[UIView alloc]initWithFrame:
//                         CGRectMake(self.scrollView.bounds.size.width * 2, 0,
//                                    self.scrollView.bounds.size.width,
//                                    [self getSectionHaderHight])];
//    thirdView.backgroundColor = [UIColor whiteColor];
    
    
    [self setButtonWithleftView:leftView];
    [self setButtonWithrightView:rightView];
    [self setButtonWithleftView2:leftView2];
    [self setButtonWithrightView2:rightView2];

    self.leftView = leftView;
    self.rightView = rightView;
    self.leftView2 = leftView2;
    self.rightView2 = rightView2;
    
 
//    [scroView addSubview:thirdView];
    
//    [self.scrollView addSubview:leftView2];
//    [self.scrollView addSubview:rightView2];
    
    [self.scrollView addSubview:leftView];
    [self.scrollView addSubview:rightView];
//    [self.scrollView2 addSubview:thirdView];
    
  
    self.backView = backView;
    
    [self.backView addSubview:self.scrollView];
//    [self.backView addSubview:self.scrollView2];
    NSLog(@"%f)))))))))))))))))))))1",self.backView.bounds.size.height);
    
    
    

   
    
//    [self setButtonWithrthirdView:thirdView];
    

    
    NSLog(@"%f)))))))))))))))))))))2",self.backView.bounds.size.height);
}

- (void)setSearchBar
{
    SearchBar *searchBar= [[SearchBar alloc]initWithFrame:CGRectMake(20, 10, self.view.bounds.size.width-40, 38)];
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
    UIImageView *sanjiao = [[UIImageView alloc]initWithFrame:CGRectMake(self.searchBarbutton.bounds.size.width - 10, 22, 12, 6)];
    [searchBar.leftView addSubview:sanjiao];
    sanjiao.image = [UIImage imageNamed:@"xiala"];
    self.searchBarbutton.layer.cornerRadius = 10;
    searchBar.rightViewMode = UITextFieldViewModeAlways;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.borderWidth = 1.0f;
    searchBar.borderStyle = UITextBorderStyleRoundedRect;

    searchBar.layer.borderColor = [UIColor colorWithHexString:@"#ef8200"].CGColor;
    
    searchBar.layer.cornerRadius = 20;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureAction:)];
    
    [searchBar addGestureRecognizer:tapGesture];
    searchBar.delegate = self;
    [self.searchBarbutton addTarget:self action:@selector(searchBarbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.searchBar = searchBar;
    [self.backView addSubview:self.searchBar];
    
//    UIView *jingxuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 80 + [self getSectionHaderHight], self.view.bounds.size.width, 40)];
//    [jingxuanView setBackgroundColor:[UIColor lightGrayColor]];
//    jingxuanView.backgroundColor = [UIColor whiteColor];
    
//    jingxuanView.image = [UIImage imageNamed:@"jingxuanfuwu"];
    //精选服务视图
    UIImageView *jingxuanView = [[UIImageView alloc]initWithFrame:CGRectMake(3.5, 58 + [self getSectionHaderHight], self.view.bounds.size.width, 45)];
    [jingxuanView setBackgroundColor:[UIColor colorWithHexString:@"f4f4f4"]];
    jingxuanView.image = [UIImage imageNamed:@"jingxuanxinxi"];
    self.jingxuanView = jingxuanView;
    [self.backView addSubview:self.jingxuanView];
    NSLog(@"%f)))))))))))))))))))))3",self.backView.bounds.size.height);
    
}



//SearchBar轻拍事件
- (void)tapgestureAction:(UITapGestureRecognizer *)gesture
{
    SearchController *searchVC = [[SearchController alloc]init];
    searchVC.findType = self.searchBarbutton.titleLabel.text;
    
    [self.navigationController pushViewController:searchVC animated:YES];
//    [self presentViewController:searchVC animated:YES completion:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    SearchController *searchVC = [[SearchController alloc]init];
    searchVC.findType = self.searchBarbutton.titleLabel.text;
    [self.searchBar resignFirstResponder];
    [self.navigationController pushViewController:searchVC animated:YES];
//    [self presentViewController:searchVC animated:YES completion:nil];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//    
//}
//按钮点击事件
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

- (void)setPageControl
{      CGPoint pagePoint = CGPointMake(self.view.center.x, [self getSectionHaderHight] +45);
    
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


- (void)getLunbotu
{

    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
NSString *accesstoken = @"token";
    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:accesstoken forKey:@"access_token"];
    NSString *getbannerURL = @"http://api.ziyawang.com/v1/app/banner?access_token=token";
    
   // @" http://api.ziyawang.com/v1/app/banner?access_token=token"
[self.manager GET:getbannerURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
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

- (UIView *)setImageView
{
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self getImageViewHight])];
    //最上方轮播图
   
    NSString *url2 = [getImageURL stringByAppendingString:self.imageSourceArray[0]];
    NSString *url3 = [getImageURL stringByAppendingString:self.imageSourceArray[1]];
    NSString *url4 = [getImageURL stringByAppendingString:self.imageSourceArray[2]];
//
//    
//    
    NSArray *imagearray = @[url4,url2,url3,url4,url2];
    NSMutableArray *imageMuarray = [NSMutableArray arrayWithArray:imagearray];
    
    ScrollHeadView *scrollHeadView = [[ScrollHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self getImageViewHight]) arraySource:imageMuarray];
    scrollHeadView.Mydelegate = self;
    imageview.image = [UIImage imageNamed:@"lunbotu.jpg"];
    
//    [self.headView addSubview:imageview];
    [self.headView addSubview:scrollHeadView];
    
    return self.headView;
    
}
- (void)setBackView
{
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.backView.bounds.size.height + [self getImageViewHight])];

    [self.headView addSubview:self.backView];
}


- (void)didTapScrollHeadView
{
    VideosListController *videoVC = [[VideosListController alloc]init];
    [self.navigationController pushViewController:videoVC animated:YES];

}
/////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.searchBar resignFirstResponder];
    
    if (scrollView.contentOffset.y > [self getImageViewHight]) {
//        [self.view bringSubviewToFront:self.searchView];
        [self.searchBar setFrame:CGRectMake(20, 20, self.searchBar.bounds.size.width, self.searchBar.bounds.size.height)];
        self.navigationController.navigationBar.hidden = YES;
   
        self.statuView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.statuView];
        
//        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        [self.view addSubview:self.searchBar];
    }
    else
    {
        self.navigationController.navigationBar.hidden = NO;

//        [self.view sendSubviewToBack:self.searchView];
        [self.searchBar setFrame:CGRectMake(20, 10, self.searchBar.bounds.size.width, self.searchBar.bounds.size.height)];

        [self.backView addSubview:self.searchBar];

    }
}


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


- (void)pageControlAction:(UIPageControl *)pageControl
{
    NSLog(@"当前选中页数：%ld,%s,%d",pageControl.currentPage, __FUNCTION__,__LINE__);
    //改变self.scrollView的contenOffset
    //    [self.scrollView setContentInset:CGPointMake(self.view.bounds.size.width*pageControl.currentPage,0) animated:YES)];
    
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * pageControl.currentPage, 0) animated:YES];

    
}


- (void)setButtonWithleftView:(UIView *)view
{
    
     CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 5;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
//        button.backgroundColor = [UIColor whiteColor];
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        NSLog(@"___________________________________%f",button.frame.size.height);
        button.tag = i;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - 25)];
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
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - 25)];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        //        imageView.backgroundColor = [UIColor whiteColor];
        
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+4]];
        
        lable.text = self.array2[i-1];
        [button addSubview:imageView];
        [button addSubview:lable];
        [view addSubview:button];
    }
}

- (void)setButtonWithrightView:(UIView *)view
{
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 5;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        button.tag = i + 8;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - 25)];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        //        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+8]];
        lable.text = self.array3[i-1];
        [button addSubview:imageView];
        [button addSubview:lable];
        [view addSubview:button];
    }
    
//    for (int i = 1; i < 5; i ++) {
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [button setFrame:
//         CGRectMake(20 *i + Buttonheight * (i-1), 10 + Buttonheight + 20,
//                    Buttonheight, Buttonheight)];
//        
//        //        [leftView addSubview:button];
//        //        [rightView addSubview:button];
//        button.tag = i + 12;
//        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - 20)];
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.font = [UIFont systemFontOfSize:15];
//        //        imageView.backgroundColor = [UIColor whiteColor];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
//        lable.text = @"资产包转让";
//        [button addSubview:imageView];
//        [button addSubview:lable];
//        [view addSubview:button];
//    }
}

- (void)setButtonWithleftView2:(UIView *)view
{
  
    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
    for(int i = 1;i< 5;i ++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setFrame:
         CGRectMake(20 *i + Buttonheight * (i-1), 10,
                    Buttonheight, Buttonheight)];
        //        button.backgroundColor = [UIColor whiteColor];
        //        [leftView addSubview:button];
        //        [rightView addSubview:button];
        NSLog(@"_______=____________________________%f",button.frame.size.height);
        button.tag = i + 12;
        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - 25)];
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
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - 25)];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont FontForBigLabel];
        if (i==2) {
            lable = [[UILabel alloc]initWithFrame:CGRectMake(-5, button.bounds.size.height-8, button.bounds.size.width+10, 20)];
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
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - 25)];
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



//- (void)setButtonWithrthirdView:(UIView *)view
//{
//    
//    CGFloat Buttonheight = (self.tableView.bounds.size.width - 100) / 4;
//    
//    for(int i = 1;i< 4;i ++)
//    {
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [button setFrame:
//         CGRectMake(20 *i + Buttonheight * (i-1), 10,
//                    Buttonheight, Buttonheight)];
//        //        [leftView addSubview:button];
//        //        [rightView addSubview:button];
//        button.tag = i + 16;
//        [button addTarget:self action:@selector(addtatgetWithButtonTag:) forControlEvents:(UIControlEventTouchUpInside)];
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width -10, button.bounds.size.height - 20)];
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bounds.size.height-8, button.bounds.size.width, 20)];
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.font = [UIFont systemFontOfSize:15];
//        //        imageView.backgroundColor = [UIColor whiteColor];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
//        lable.text = @"资产包转让";
//        [button addSubview:imageView];
//        [button addSubview:lable];
//        [view addSubview:button];
//    }
//    
//}






- (void)addtatgetWithButtonTag:(UIButton *)sender
{
    SearchTypeController *searchVC = [[SearchTypeController alloc]init];
    
    @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"固产求购",@"融资借贷",@"法律服务",@"悬赏信息",@"尽职调查",@"委外催收",@"典当担保"];
    NSArray *level = @[@"VIP1"];
    NSArray *informationTypeID =@[@"01",@"14",@"12",@"04",@"13",@"06",@"03",@"09",@"10",@"02",@"05"];
    
    //    NSArray *infonmationType = @[@"资产包收购",@"催收机构",@"律师事务所",@"保理公司",@"典当担保",@"投融资服务",@"尽职调查",@"资产收购",@"债权收购"];
    //    NSArray *informationTypeID = @[@"01",@"02",@"03",@"04",@"05",@"06",@"10",@"12",@"14"];
    NSString *type = @"找信息";

    
    switch (sender.tag)
    
    {
        case 1:
            NSLog(@"1");
            searchVC.type = type;
            searchVC.searchValue = @"01";
            searchVC.navigationItem.title = @"资产包转让";
            
            break;
        case 2:
            NSLog(@"2");
            searchVC.type = type;
            searchVC.searchValue = @"14";
            searchVC.navigationItem.title = @"债权转让";

            break;
        case 3:
            NSLog(@"3");
            searchVC.type = type;
            searchVC.searchValue = @"12";
            searchVC.navigationItem.title = @"固产转让";

            break;
        case 4:
            NSLog(@"4");
            searchVC.type = type;
            searchVC.searchValue = @"04";
            searchVC.navigationItem.title = @"商业保理";

            break;
        case 5:
            NSLog(@"5");
            searchVC.type = type;
            searchVC.searchValue = @"05";
            searchVC.navigationItem.title = @"典当信息";

            break;
        case 6:
            NSLog(@"6");
            searchVC.type = type;
            searchVC.searchValue = @"06";
            searchVC.navigationItem.title = @"融资需求";

            break;
        case 7:
            NSLog(@"7");
            searchVC.type = type;
            searchVC.searchValue = @"09";
            searchVC.navigationItem.title = @"悬赏信息";

            break;
        case 8:
            NSLog(@"8");
            searchVC.type = type;
            searchVC.searchValue = @"10";
            searchVC.navigationItem.title = @"尽职调查";

            break;
        case 9:
            NSLog(@"9");
            searchVC.type = type;
            searchVC.searchValue = @"02";
            searchVC.navigationItem.title = @"委外催收";

            break;
        case 10:
            NSLog(@"10");
            searchVC.type = type;
            searchVC.searchValue = @"03";
            searchVC.navigationItem.title = @"法律服务";

            break;
        case 11:
            NSLog(@"11");
            searchVC.type = type;
            searchVC.searchValue = @"13";
            searchVC.navigationItem.title = @"资产求购";

            break;
        case 12:
            NSLog(@"12");
            searchVC.type = type;
            searchVC.searchValue = @"05";
            searchVC.navigationItem.title = @"担保信息";

            break;
        case 13:
            NSLog(@"13");
       
            searchVC.searchValue = @"01";
            searchVC.navigationItem.title = @"资产包收购";


            break;
        case 14:
            NSLog(@"14");
            searchVC.searchValue = @"14";
            searchVC.navigationItem.title = @"债权收购";


            break;
        case 15:
            NSLog(@"15");
            searchVC.searchValue = @"03";
            searchVC.navigationItem.title = @"律师事务所";


            break;
        case 16:
            NSLog(@"16");
            searchVC.searchValue = @"04";
            searchVC.navigationItem.title = @"保理服务";


            break;
        case 17:
            NSLog(@"17");
            searchVC.searchValue = @"05";
            searchVC.navigationItem.title = @"典当公司";


            break;
        case 18:
            NSLog(@"18");
            searchVC.searchValue = @"06";
            searchVC.navigationItem.title = @"投资放贷";


            break;
        case 19:
            NSLog(@"19");
            searchVC.searchValue = @"10";
            searchVC.navigationItem.title = @"尽职调查";

            break;
        case 20:
            NSLog(@"19");
            searchVC.searchValue = @"12";
            searchVC.navigationItem.title = @"资产收购";

            break;
        case 21:
            NSLog(@"19");
            searchVC.searchValue = @"05";
            searchVC.navigationItem.title = @"担保服务";

            break;
        case 22:
            NSLog(@"19");
            searchVC.searchValue = @"02";
            searchVC.navigationItem.title = @"催收机构";

            break;
        default:
            break;
    }
    [self.navigationController pushViewController:searchVC animated:YES];

    
    
}


#pragma mark - Table view data source


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return [self getSectionHaderHight] + 120;
//    
//    
//}


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
        
        return 100;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 100;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 110;
        
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
        if (self.sourceArray.count==0) {
            self.sourceArray = self.lastSourceArray1;
        }
        
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
        if (self.sourceArray.count == 0) {
            self.sourceArray = self.lastSourceArray2;
        }
        model = self.sourceArray[indexPath.row];
        infoDetailsVC.ProjectID = model.ProjectID;
        infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.PhoneNumber];
        NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
        infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
        [self.navigationController pushViewController:infoDetailsVC animated:YES];
    }
else
{
    FindServiceModel *model = [[FindServiceModel alloc]init];
    model = self.sourceArray[indexPath.row];
    NSLog(@"!!!!!!!!!!%@",model.ServiceID);
    ServiceDetailController *ServiceDetailVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDetailController"];
    ServiceDetailVC.ServiceID = model.ServiceID;
    ServiceDetailVC.userid = [NSString stringWithFormat:@"%@",model.ConnectPhone];

    [self.navigationController pushViewController:ServiceDetailVC animated:YES];

}
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
