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
#import "InfoDetailsController.h"
#import "ServiceDetailController.h"
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sourceArray = [[NSMutableArray alloc]init];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 58, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PublishCell" bundle:nil] forCellReuseIdentifier:@"PublishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindServiceViewCell" bundle:nil] forCellReuseIdentifier:@"FindServiceViewCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 74, 0);
    
    [self setSearchBar];
    NSString *headURL = getDataURL;
    NSString *footURL = @"/search";
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
    NSString *footURL = @"/search";
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
    NSString *footURL = @"/search";
    NSString *URL = [headURL stringByAppendingString:footURL];
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
        PublishCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
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
        InfoDetailsController *infoDetailsVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil]instantiateViewControllerWithIdentifier:@"InfoDetailsController"];
        
        PublishModel *model = [[PublishModel alloc]init];
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
