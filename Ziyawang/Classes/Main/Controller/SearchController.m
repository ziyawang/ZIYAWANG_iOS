//
//  SearchController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/15.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "SearchController.h"
#import "SearchBar.h"

#import "FindServiceModel.h"
#import "PublishModel.h"
#import "FindServiceViewCell.h"
#import "PublishCell.h"
#import "NewPublishCell.h"
#import "InfoDetailsController.h"
#import "ServiceDetailController.h"


#import "LoginController.h"
#import "UserInfoModel.h"
#import "MyidentifiController.h"
#import "RechargeController.h"
#import "ChuzhiDetailController.h"
#import "DetailOfInfoController.h"
#import "VipViewController.h"

#define kWidthScale ([UIScreen mainScreen].bounds.size.width/375)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/667)
@interface SearchController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (nonatomic,strong) UIButton *searchBarbutton;
@property (nonatomic,strong) SearchBar *searchBar;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) NSString *searchURL;
@property (nonatomic,assign) NSInteger statrpage;
@property (nonatomic,assign) NSInteger startpage2;

@property (nonatomic,strong) NSString *searchType;


@property (nonatomic,strong) PublishModel *model;

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
@property (nonatomic,strong) UIView *PromiseView;
@property (nonatomic,strong) NSString *selectTypeName;

@end

@implementation SearchController
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self getUserInfoFromDomin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userModel = [[UserInfoModel alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title = @"搜索";
    self.sourceArray = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 58, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPublishCell" bundle:nil] forCellReuseIdentifier:@"NewPublishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindServiceViewCell" bundle:nil] forCellReuseIdentifier:@"FindServiceViewCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 74, 0);
    
    [self setSearchBar];
    NSString *headURL = getDataURL;
    NSString *footURL = @"/searchs";
    NSString *URL = [headURL stringByAppendingString:footURL];
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:@"token" forKey:@"access_token"];
    [paraDic setObject:self.searchBar.text forKey:@"content"];
    self.searchURL = URL;
    
    
    
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:paraDic];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self loadMoreDataWithURL:URL Dic:self.dataDic];
//    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

    
    
    
    
      self.searchType = self.findType;
    NSLog(@"----------%@",self.searchType);
        if ([self.findType isEqualToString:@"找信息"]) {
        
        [self getInfoData];

    }
    else
    {
        [self getServiceData];
    }
//    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    [button setTitle:@"返回" forState:(UIControlStateNormal)];
//    
////    [button setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
//    [button setFrame:CGRectMake(10, 20, 40, 40)];
//                                
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:button];
}
- (void)getServiceData
{
    NSString *headURL = getDataURL;
    NSString *footURL = @"/searchs";
    NSString *URL = [headURL stringByAppendingString:footURL];
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:@"token" forKey:@"access_token"];
    [paraDic setObject:self.searchBar.text forKey:@"content"];
    [paraDic setObject:@"4" forKey:@"type"];
    [self getDataWithURL:URL paraDic:paraDic];
}

- (void)getInfoData
{
    NSString *headURL = getDataURL;
    NSString *footURL = @"/searchs";
    NSString *URL = [headURL stringByAppendingString:footURL];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token != nil) {
        URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:@"token" forKey:@"access_token"];
    [paraDic setObject:self.searchBar.text forKey:@"content"];
        [paraDic setObject:@"1" forKey:@"type"];
        [self getDataWithURL:URL paraDic:paraDic];
}

- (void)buttonAction:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)setSearchBar
{
    SearchBar *searchBar= [[SearchBar alloc]initWithFrame:CGRectMake(20, 10, self.view.bounds.size.width-40, 38)];
    self.searchBarbutton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.searchBarbutton.backgroundColor = [UIColor whiteColor];
    [self.searchBarbutton setTitle:self.findType forState:(UIControlStateNormal)];
    [self.searchBarbutton setTitleColor:[UIColor colorWithHexString:@"#ef8200"] forState:(UIControlStateNormal)];
    self.searchBarbutton.titleLabel.font = [UIFont systemFontOfSize:17];
    //    self.searchBarbutton.titleLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    searchBar.placeholder = @"请输入搜索内容";
    
    self.searchBarbutton.frame = CGRectMake(0, 0, 90, 50);
    searchBar.leftView = self.searchBarbutton;
    //设置搜索框它的右侧视图
        UIView *searchBarRightView = [[UIView alloc]initWithFrame:CGRectMake(0, searchBar.bounds.size.width - 60, 60, 38)];
    UIButton *rightSearchbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightSearchbutton setFrame:CGRectMake(25, 4, 30, 30)];
    [rightSearchbutton setImage:[UIImage imageNamed:@"xiaosousuo"] forState:(UIControlStateNormal)];
    [rightSearchbutton addTarget:self action:@selector(rightButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    

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
    searchBar.userInteractionEnabled = YES;
    searchBar.layer.masksToBounds = YES;
    self.searchBarbutton.userInteractionEnabled = YES;

    [self.searchBarbutton addTarget:self action:@selector(searchBarbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];

    
    self.searchBar = searchBar;
    UIView *searchBarBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 58)];
    searchBarBackView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [searchBarBackView addSubview:self.searchBar];
    [self.view addSubview:searchBarBackView];
    
   }

- (void)rightButtonAction:(UIButton*)button
{
    [self.searchBar resignFirstResponder];
    
    NSString *headURL = getDataURL;
    NSString *footURL = @"/search";
    NSString *URL = [headURL stringByAppendingString:footURL];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token != nil) {
        URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    
    
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:@"token" forKey:@"access_token"];
    [paraDic setObject:self.searchBar.text forKey:@"content"];
    if ([self.searchType isEqualToString:@"找信息"])
    {
        [paraDic setObject:@"1" forKey:@"type"];
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:paraDic];
        [self getDataWithURL:URL paraDic:paraDic];
        
    }
    else
    {
        [paraDic setObject:@"4" forKey:@"type"];
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:paraDic];
        [self getDataWithURL:URL paraDic:paraDic];
    }

//    if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"])
//    {
//        [paraDic setObject:@"1" forKey:@"type"];
//        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:paraDic];
//        [self getDataWithURL:URL paraDic:paraDic];
//        
//    }
//    else
//    {
//        [paraDic setObject:@"4" forKey:@"type"];
//        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:paraDic];
//        [self getDataWithURL:URL paraDic:paraDic];
//        
//    }
    
}

- (void)searchBarbuttonAction:(UIButton *)button
{    NSString *headURL = getDataURL;
     NSString *footURL = @"/search";
     NSString *URL = [headURL stringByAppendingString:footURL];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token != nil) {
        URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    
    
     NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:@"token" forKey:@"access_token"];
    [paraDic setObject:self.searchBar.text forKey:@"content"];
    
    
    if ([self.searchType isEqualToString:@"找服务"]) {
        self.searchType = @"找信息";
        [button setTitle:@"找信息" forState:(UIControlStateNormal)];
        [paraDic setObject:@"1" forKey:@"type"];
        [self getDataWithURL:URL paraDic:paraDic];
    }
   else if ([self.searchType isEqualToString:@"找信息"]) {
        self.searchType = @"找服务";
        [button setTitle:@"找服务" forState:(UIControlStateNormal)];
        [paraDic setObject:@"4" forKey:@"type"];
        [self getDataWithURL:URL paraDic:paraDic];
        
    }
    
//    if ([button.titleLabel.text isEqualToString:@"找服务"]) {
//        [button setTitle:@"找信息" forState:(UIControlStateNormal)];
//        [paraDic setObject:@"1" forKey:@"type"];
//        [self getDataWithURL:URL paraDic:paraDic];
//    }
//    if ([button.titleLabel.text isEqualToString:@"找信息"]) {
//        [button setTitle:@"找服务" forState:(UIControlStateNormal)];
//        [paraDic setObject:@"4" forKey:@"type"];
//        [self getDataWithURL:URL paraDic:paraDic];
//    }

}


- (void)getDataWithURL:(NSString*)url paraDic:(NSMutableDictionary *)dic
{
    self.statrpage = 1;
    self.startpage2 = 1;
    
    [self.sourceArray removeAllObjects];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress)
    {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {

         NSLog(@"请求成功");
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSArray *array = dic[@"data"];
         for (NSDictionary *dic in array)
         {
             
             if ([self.searchType isEqualToString:@"找信息"]) {
                 PublishModel *model = [[PublishModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 
                 [self.sourceArray addObject:model];
                 
             }
             
             else if([self.searchType isEqualToString:@"找服务"])
             {
                 
                 FindServiceModel *model = [[FindServiceModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 [self.sourceArray addObject:model];
             }
             
             
//             if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
//                 PublishModel *model = [[PublishModel alloc]init];
//                 [model setValuesForKeysWithDictionary:dic];
//                 [self.sourceArray addObject:model];
//                 
//             }
//             else
//             {
//                 FindServiceModel *model = [[FindServiceModel alloc]init];
//                 [model setValuesForKeysWithDictionary:dic];
//                 [self.sourceArray addObject:model];
//             }
           
//             [self MBProgressWithString:@"搜索完毕" timer:1 mode:MBProgressHUDModeText];
         }
         if (self.sourceArray.count == 0) {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有您想要搜索的信息，请尝试更换关键词" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alert show];
         }
          [self.tableView reloadData];
             [self.tableView.mj_footer endRefreshing];
             [self.HUD removeFromSuperViewOnHide];
             [self.HUD hideAnimated:YES];
        
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        [self.tableView.mj_footer endRefreshing];
//        [self MBProgressWithString:@"搜索失败" timer:1 mode:MBProgressHUDModeText];
        NSLog(@"请求失败");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"搜索失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
}


- (void)loadMoreData
{
    
    
    NSString *headURL = getDataURL;
    NSString *footURL = @"/search";
    NSString *URL = [headURL stringByAppendingString:footURL];
//    NSMutableDictionary *paraDic = [NSMutableDictionary new];
//    [paraDic setObject:@"token" forKey:@"access_token"];
//    [paraDic setObject:self.searchBar.text forKey:@"content"];
    self.searchURL = URL;
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token != nil) {
        URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    
    
    
    NSMutableDictionary *dic = self.dataDic;
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.searchBar.text forKey:@"content"];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSLog(@"-------%@",dic);
    if ([self.searchType isEqualToString:@"找信息"]) {
        [dic setObject:[NSString stringWithFormat:@"%ld",self.statrpage] forKey:@"startpage"];
        [dic setObject:@"1" forKey:@"type"];
    }
    else if([self.searchType isEqualToString:@"找服务"])
    {
        [dic setObject:[NSString stringWithFormat:@"%ld",self.startpage2] forKey:@"startpage"];
        [dic setObject:@"4" forKey:@"type"];
        
    }
    //    if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
    //        [dic setObject:[NSString stringWithFormat:@"%ld",self.statrpage] forKey:@"startpage"];
    //    }
    //    else
    //    {
    //        [dic setObject:[NSString stringWithFormat:@"%ld",self.startpage2] forKey:@"startpage"];
    //    }
    
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSLog(@"请求成功");
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSArray *array = dic[@"data"];
         NSMutableArray *addArray = [NSMutableArray new];
         if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
             for (NSDictionary *dic in array) {
                 PublishModel *model = [[PublishModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 [addArray addObject:model];
             }
             self.statrpage ++;
             
             if (addArray.count == 0) {
                 UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];

             }
             
             [self.sourceArray addObjectsFromArray:addArray];
             [self.tableView reloadData];
             [self.HUD removeFromSuperViewOnHide];
             [self.tableView.mj_footer endRefreshing];

             [self.HUD hideAnimated:YES];
         }
         
         else
         {
             
             for (NSDictionary *dic in array) {
                 FindServiceModel *model = [[FindServiceModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 [addArray addObject:model];
             }
             if (addArray.count == 0) {
                 UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];

             }
             self.startpage2 ++;
             
             [self.sourceArray addObjectsFromArray:addArray];
             [self.tableView reloadData];
             [self.tableView.mj_footer endRefreshing];
             [self.HUD removeFromSuperViewOnHide];
             [self.HUD hideAnimated:YES];
             
         }
         
         
         
         //         [self.tableView reloadData];
         [self.HUD removeFromSuperViewOnHide];
         [self.HUD hideAnimated:YES];
         
         //         for (NSDictionary *dic in array)
         //         {
         //             if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"])
         //             {
         //                PublishModel *model = [[PublishModel alloc]init];
         //                 [model setValuesForKeysWithDictionary:dic];
         //                 [self.sourceArray addObject:model];
         //
         //             }
         //             else
         //             {
         //                 FindServiceModel *model = [[FindServiceModel alloc]init];
         //                 [model setValuesForKeysWithDictionary:dic];
         //                 [self.sourceArray addObject:model];
         //             }
         
         //             [self MBProgressWithString:@"搜索完毕" timer:1 mode:MBProgressHUDModeText];
         //         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [self.HUD removeFromSuperViewOnHide];
         [self.HUD hideAnimated:YES];
         [self.tableView.mj_footer endRefreshing];

         //        [self MBProgressWithString:@"搜索失败" timer:1 mode:MBProgressHUDModeText];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"搜索失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
     }];
}
- (void)loadMoreDataWithURL:(NSString*)url Dic:(NSMutableDictionary *)dic
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSLog(@"-------%@",dic);
    if ([self.searchType isEqualToString:@"找信息"]) {
        [dic setObject:[NSString stringWithFormat:@"%ld",self.statrpage] forKey:@"startpage"];
        [dic setObject:@"1" forKey:@"type"];
    }
    else if([self.searchType isEqualToString:@"找服务"])
    {
        [dic setObject:[NSString stringWithFormat:@"%ld",self.startpage2] forKey:@"startpage"];
        [dic setObject:@"4" forKey:@"type"];

    }
//    if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
//        [dic setObject:[NSString stringWithFormat:@"%ld",self.statrpage] forKey:@"startpage"];
//    }
//    else
//    {
//        [dic setObject:[NSString stringWithFormat:@"%ld",self.startpage2] forKey:@"startpage"];
//    }
    
    [self.manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSLog(@"请求成功");
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSArray *array = dic[@"data"];
         NSMutableArray *addArray = [NSMutableArray new];
         if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
             for (NSDictionary *dic in array) {
                 PublishModel *model = [[PublishModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 [addArray addObject:model];
             }
             self.statrpage ++;
             
             if (addArray.count == 0) {
                    UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
             }
             
             [self.sourceArray addObjectsFromArray:addArray];
             [self.tableView reloadData];
             [self.HUD removeFromSuperViewOnHide];
             [self.HUD hideAnimated:YES];
         }
         
         else
         {
             
             for (NSDictionary *dic in array) {
                 FindServiceModel *model = [[FindServiceModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 [addArray addObject:model];
             }
             if (addArray.count == 0) {
                 UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
             }
             self.startpage2 ++;
             
             [self.sourceArray addObjectsFromArray:addArray];
             [self.tableView reloadData];
             [self.HUD removeFromSuperViewOnHide];
             [self.HUD hideAnimated:YES];
             
         }
     
         
         
//         [self.tableView reloadData];
         [self.HUD removeFromSuperViewOnHide];
         [self.HUD hideAnimated:YES];
         
//         for (NSDictionary *dic in array)
//         {
//             if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"])
//             {
//                PublishModel *model = [[PublishModel alloc]init];
//                 [model setValuesForKeysWithDictionary:dic];
//                 [self.sourceArray addObject:model];
//                 
//             }
//             else
//             {
//                 FindServiceModel *model = [[FindServiceModel alloc]init];
//                 [model setValuesForKeysWithDictionary:dic];
//                 [self.sourceArray addObject:model];
//             }
         
             //             [self MBProgressWithString:@"搜索完毕" timer:1 mode:MBProgressHUDModeText];
//         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [self.HUD removeFromSuperViewOnHide];
         [self.HUD hideAnimated:YES];
         //        [self MBProgressWithString:@"搜索失败" timer:1 mode:MBProgressHUDModeText];
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"搜索失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         
         
     }];


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


- (void)ShowAlertViewControllerWithMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
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

#pragma mark----tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            
            return 116;
        }
        else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
        {
            return 116;
        }
        else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
        {
            return 116;
        }
        
    }
    
    return 115;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchType isEqualToString:@"找信息"]) {
        NewPublishCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"NewPublishCell" forIndexPath:indexPath];
        cell.model = self.sourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        FindServiceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindServiceViewCell" forIndexPath:indexPath];
        cell.model =self.sourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }

    
//    if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"]) {
//      PublishCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
//        cell.model = self.sourceArray[indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//
//        return cell;
//      }
//    else
//    {
//       FindServiceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindServiceViewCell" forIndexPath:indexPath];
//        cell.model =self.sourceArray[indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        
//        return cell;
//    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.searchType isEqualToString:@"找信息"])
    {
//        InfoDetailsController *infoDetailsVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil]instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
//        
//        PublishModel *model = [[PublishModel alloc]init];
//        model = self.sourceArray[indexPath.row];
//        infoDetailsVC.ProjectID = model.ProjectID;
//        infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
//        NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
//        infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
//        infoDetailsVC.typeName = model.TypeName;
//
//        [self.navigationController pushViewController:infoDetailsVC animated:YES];
        
        ChuzhiDetailController *chuzhiVC = [[ChuzhiDetailController alloc]init];
         DetailOfInfoController *infoDetailsVC = [[DetailOfInfoController alloc]init];
        PublishModel *model = [[PublishModel alloc]init];
        model = self.sourceArray[indexPath.row];
        infoDetailsVC.ProjectID = model.ProjectID;
        infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
        NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
        infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
        infoDetailsVC.typeName = model.TypeName;
        self.selectTypeName = model.TypeName;


        model.Hide = [NSString stringWithFormat:@"%@",model.Hide];

        NSArray *TypeIDArray = [model.right componentsSeparatedByString:@","];
        for (NSString *typeID in TypeIDArray) {
            if ([model.TypeID isEqualToString:typeID]) {
                [self.navigationController pushViewController:infoDetailsVC animated:YES];
                return;
            }
        }
        
        if ([model.Member isEqualToString:@"1"] && [model.Hide isEqualToString:@"0"]) {
            if ([self.role isEqualToString:@"1"])
            {
                [self setPromiseView];
            }
            else
            {
                [self ShowAlertViewControllerWithMessage:@"您需要先通过服务方认证才可查看VIP类信息"];
            }
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
      
        self.pubModel = model;
        
            
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
                    [self ShowAlertViewControllerWithMessage:@"您需要先通过服务方认证才可查看收费类信息"];
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

    
//    if ([self.searchBarbutton.titleLabel.text isEqualToString:@"找信息"])
//    {
//        InfoDetailsController *infoDetailsVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil]instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
//        
//        PublishModel *model = [[PublishModel alloc]init];
//        model = self.sourceArray[indexPath.row];
//        infoDetailsVC.ProjectID = model.ProjectID;
//        infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.PhoneNumber];
//        NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
//        infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
//        [self.navigationController pushViewController:infoDetailsVC animated:YES];
//     
//    }
//    else
//    {
//        
//        FindServiceModel *model = [[FindServiceModel alloc]init];
//        model = self.sourceArray[indexPath.row];
//        NSLog(@"!!!!!!!!!!%@",model.ServiceID);
//        ServiceDetailController *ServiceDetailVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDetailController"];
//        ServiceDetailVC.ServiceID = model.ServiceID;
//        ServiceDetailVC.userid = [NSString stringWithFormat:@"%@",model.ServiceName];
//        
//        
//        [self.navigationController pushViewController:ServiceDetailVC animated:YES];
//      
//    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 38;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.searchBar;
//    
//}

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
    .heightIs(360 * kHeightScale);
    
    
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
    
//    label2.text = @"本条VIP信息只针对本类型会员免费开放，开通相应类型会员后即可查看";
    label2.text = [[@"本条VIP信息只针对"stringByAppendingString:self.selectTypeName]stringByAppendingString:@"类型会员免费开放，详情请咨询会员专线：010-56052557"];

    label2.font = [UIFont systemFontOfSize:13];
    
    fabuButton.sd_layout.leftEqualToView(label2)
    .rightEqualToView(label2)
    .topSpaceToView(label2,30*kHeightScale)
    .heightIs(40*kHeightScale);
    [fabuButton setTitle:@"取消" forState:(UIControlStateNormal)];
    fabuButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
    UIButton *kaitongButton = [UIButton new];
    [bottomView addSubview:kaitongButton];
    [kaitongButton setTitle:@"取消" forState:(UIControlStateNormal)];
    kaitongButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    kaitongButton.backgroundColor = [UIColor whiteColor];
    kaitongButton.layer.borderWidth = 1;    kaitongButton.sd_layout.leftEqualToView(fabuButton)
    .rightEqualToView(fabuButton)
    .topSpaceToView(fabuButton,20*kHeightScale)
    .heightIs(40*kHeightScale);
    [kaitongButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [kaitongButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [kaitongButton addTarget:self action:@selector(kaitongButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
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
    
    [fabuButton addTarget:self action:@selector(kaitongButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //    self.weituoView = weituoView;
    weituoView.layer.cornerRadius = 10;
    weituoView.layer.masksToBounds = YES;
    self.PromiseView = mengbanView;
    //    [self.PromiseView setHidden:YES];
    
    
}
- (void)kaitongButtonAction:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];

    VipViewController *vipRVC = [[VipViewController alloc]init];
    
    [self.navigationController pushViewController:vipRVC animated:YES];
    
    
}
- (void)CancelAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
}

- (void)didClickfabuFabuAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
    
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
