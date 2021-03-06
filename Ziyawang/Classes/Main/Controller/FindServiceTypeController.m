//
//  FindServiceTypeController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/19.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FindServiceTypeController.h"
#import "FindServiceController.h"
#import "AFNetWorking.h"
#import "MBProgressHUD.h"
#import "MoreMenuView.h"
#import "FindServiceViewCell.h"
#import "FindServiceModel.h"
#import "ServiceDetailController.h"
#import "FindView.h"
@interface FindServiceTypeController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    UINib *nib;
}
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic,strong) NSMutableArray *shengArray;

@property (nonatomic,strong) NSMutableArray *shiArray;


@property (nonatomic,strong) NSMutableArray *allshiArray;

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) NSString *ServiceID;

@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,assign) NSInteger startPage;
@property (nonatomic,strong) FindView *findV;
@property (nonatomic,strong) NSString *chooseType;

@end

@implementation FindServiceTypeController

- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"找服务";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找服务";
    [self setupTitle];
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    
    self.sourceArray = [NSMutableArray array];
    self.manager = [AFHTTPSessionManager manager];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindServiceViewCell" bundle:nil] forCellReuseIdentifier:@"FindServiceViewCell"];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(findServiceswithDic:)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreServiceData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    self.dataDic = [NSMutableDictionary new];
    //    [self setHeadView];
    [self setHeadFindView];
    
    [self.dataDic setObject:self.searchValue forKey:@"ServiceType"];
    [self findServiceswithDic:self.dataDic];
}

- (void)findServiceswithDic:(NSMutableDictionary *)dataDic
{
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    
    self.startPage = 1;
    
    NSLog(@"@@@@@@@@@@@@@@@@@@@@@%@",dataDic);
    if (self.sourceArray != nil)
    {
        [self.sourceArray removeAllObjects];
    }
    
    NSString *getURL =[FindServiceURL stringByAppendingString:@"?access_token=token"];
    //    NSString *getURL = @"https://apis.ziyawang.com/zll/service/list/";
    NSMutableDictionary *getdic = self.dataDic;
    NSLog(@"#############%@",getdic);
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
    [getdic setObject:[NSString stringWithFormat:@"%ld",self.startPage] forKey:@"startpage"];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.startPage ++;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray) {
            
            FindServiceModel *model = [[FindServiceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:model];
        }
        
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
    }];
}

- (void)loadMoreServiceData
{
    NSString *getURL =[FindServiceURL stringByAppendingString:@"?access_token=token"];
    //    NSString *getURL = @"https://apis.ziyawang.com/zll/service/list/";
    NSMutableDictionary *getdic = self.dataDic;
    NSLog(@"#############%@",getdic);
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
    [getdic setObject:[NSString stringWithFormat:@"%ld",self.startPage] forKey:@"startpage"];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.startPage ++;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        NSMutableArray *addArray = [NSMutableArray new];
        for (NSDictionary *dic in sourceArray) {
            
            FindServiceModel *model = [[FindServiceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [addArray addObject:model];
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
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        
    }];
    
}
- (void)creatFindViewWithString:(NSString *)string
{
    NSArray *arr = @[self.type];
    self.findV = [[FindView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40) titles:arr];
    [self.view addSubview:self.findV];
    self.findV.sourArrayOne = @[@"收购资产包",@"投融资服务",@"法律服务",@"收购固产",@"委外催收",@"典当公司",@"担保公司",@"尽职调查",@"保理公司",@"债权收购"];
    self.findV.sourArrayTwo = @[@"全国",@"北京",@"上海",@"广东",@"江苏",@"浙江",@"河南",@"河北",@"辽宁",@"四川",@"湖北",@"湖南",@"福建",@"安徽",@"陕西",@"天津",@"江西",@"重庆",@"吉林",@"云南",@"山西",@"新疆",@"贵州",@"甘肃",@"海南",@"宁夏",@"青海",@"西藏",@"黑龙江",@"内蒙古",@"山东",@"广西"];
    
    NSArray *serviceType = @[@"收购资产包",@"投融资服务",@"法律服务",@"收购固产",@"委外催收",@"典当公司",@"担保公司",@"尽职调查",@"保理公司",@"债权收购"];
    NSArray *seviceTypeID = @[@"01",@"06",@"03",@"12",@"02",@"05",@"05",@"10",@"04",@"14"];
    
    NSArray *array = @[@"不限",@"会员"];
    NSDictionary *dic = @{@"data":array,@"title":@"筛选条件"};
    NSMutableArray *sourArr = [NSMutableArray new];
    [sourArr addObject:dic];
    self.findV.sourArrayThree = sourArr;
    self.chooseType = string;
    self.findV.titleArray = @[string,@"地区",@"等级"];
    
    
    self.findV.strblock1 = ^(NSString *string)
    {
        self.dataDic = [NSMutableDictionary new];
        
        NSArray *serviceType = @[@"收购资产包",@"投融资服务",@"法律服务",@"收购固产",@"委外催收",@"典当公司",@"担保公司",@"尽职调查",@"保理公司",@"债权收购"];
        NSArray *seviceTypeID = @[@"01",@"06",@"03",@"12",@"02",@"05",@"05",@"10",@"04",@"14"];
        
        NSLog(@"%@",string);
        if ([string isEqualToString:serviceType[0]])
        {
            
            [self.dataDic setObject:seviceTypeID[0] forKey:@"ServiceType"];
            
        }
        else if([string isEqualToString:serviceType[1]])
        {
            [self.dataDic setObject:seviceTypeID[1] forKey:@"ServiceType"];
            
        }
        else if([string isEqualToString:serviceType[2]])
        {
            [self.dataDic setObject:seviceTypeID[2] forKey:@"ServiceType"];
            
            
        }
        else if([string isEqualToString:serviceType[3]])
        {
            [self.dataDic setObject:seviceTypeID[3] forKey:@"ServiceType"];
            
            
        }
        else if([string isEqualToString:serviceType[4]])
        {
            [self.dataDic setObject:seviceTypeID[4] forKey:@"ServiceType"];
            
            
        }
        else if([string isEqualToString:serviceType[5]])
        {
            [self.dataDic setObject:seviceTypeID[5] forKey:@"ServiceType"];
            
        }
        else if([string isEqualToString:serviceType[6]])
        {
            [self.dataDic setObject:seviceTypeID[6] forKey:@"ServiceType"];
            
        }
        else if([string isEqualToString:serviceType[7]])
        {
            [self.dataDic setObject:seviceTypeID[7] forKey:@"ServiceType"];
            
        }
        else if([string isEqualToString:serviceType[8]])
        {
            [self.dataDic setObject:seviceTypeID[8] forKey:@"ServiceType"];
            
        }
        else if([string isEqualToString:serviceType[9]])
        {
            [self.dataDic setObject:seviceTypeID[9] forKey:@"ServiceType"];
            
        }
        
        NSArray *array = @[@"不限",@"会员"];
        NSDictionary *dic = @{@"data":array,@"title":@"筛选条件"};
        NSMutableArray *sourArr = [NSMutableArray new];
        [sourArr addObject:dic];
        self.findV.sourArrayThree = sourArr;
        
        self.chooseType = string;
        self.findV.titleArray = @[string,@"地区",@"等级"];
        [self findServiceswithDic:self.dataDic];
    };
    self.findV.strblock2 = ^(NSString *string)
    {
        [self.dataDic setObject:string forKey:@"ServiceArea"];
        [self findServiceswithDic:self.dataDic];
    };
    self.findV.strblock3 = ^(NSString *string,NSString *string2)
    {
        if ([string isEqualToString:@"会员"]) {
            [self.dataDic setObject:@"1" forKey:@"ServiceLevel"];
        }
        else
        {
            [self.dataDic removeObjectForKey:@"ServiceLevel"];
        }
        [self findServiceswithDic:self.dataDic];
        
    };
}
- (void)setHeadFindView
{
    [self creatFindViewWithString:self.type];
}
- (void)setHeadView
{
    NSArray *titles = @[self.type,@"地区",@"等级"];
    MoreMenuView *menuView = [[MoreMenuView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 45) titles:titles];
    menuView.cornerMarkLocationType = CornerMarkLocationTypeRight;
    
    [self.view addSubview:menuView];
    
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    self.shengArray = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [self.shengArray addObject:dic[@"state"]];
    }
    NSLog(@"%@",self.shengArray);
    self.allshiArray = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        self.shiArray = [NSMutableArray array];
        
        for (NSDictionary *dic2 in dic[@"cities"]) {
            
            [self.shiArray addObject:dic2[@"city"]];
        }
        [self.allshiArray addObject:self.shiArray];
    }
    
    //    NSArray *infonmationType = @[@"资产包收购",@"催收机构",@"律师事务所",@"保理公司",@"典当担保",@"投融资服务",@"尽职调查",@"资产收购",@"债权收购"];
    //    NSArray *informationTypeID = @[@"01",@"02",@"03",@"04",@"05",@"06",@"10",@"12",@"14"];
    
    
    //
    //    NSArray *infonmationType = @[@"资产包收购",@"催收机构",@"律师事务所",@"保理公司",@"典当担保",@"投融资服务",@"尽职调查",@"资产收购",@"债权收购"];
    //    NSArray *informationTypeID = @[@"01",@"02",@"03",@"04",@"05",@"06",@"10",@"12",@"14"];
    
    //    NSArray *infonmationType = @[@"收购资产包",@"投融资服务",@"法律服务",@"保理公司",@"典当公司",@"担保公司",@"委外催收",@"尽职调查",@"收购固产",@"债权收购"];
    //    NSArray *informationTypeID = @[@"01",@"06",@"03",@"04",@"05",@"05",@"02",@"10",@"12",@"14"];
    
    NSArray *infonmationType = @[@"收购资产包",@"投融资服务",@"法律服务",@"收购固产",@"委外催收",@"典当公司",@"担保公司",@"尽职调查",@"保理公司",@"债权收购"];
    NSArray *informationTypeID = @[@"01",@"06",@"03",@"12",@"02",@"05",@"05",@"10",@"04",@"14"];
    
    
    
    
    
    NSArray *level = @[@"不限",@"会员"];
    menuView.indexsOneFist = infonmationType;
    menuView.indexsTwoFist = self.shengArray;
    //    menuView.indexsTwoSecond = self.allshiArray;
    menuView.indexsThirFist = level;
    
    __weak typeof(self) weakSelf = self;
    
    menuView.selectedIndex = ^(NSString *string)
    {
        for (NSString *str in self.shengArray) {
            if ([str isEqualToString:string]) {
                if (str.length == 3) {
                    string = [string substringToIndex:2];
                }
                if (str.length == 4) {
                    string = [string substringToIndex:3];
                }
                if (str.length == 2) {
                    string = string;
                }
                [self.dataDic setObject:string forKey:@"ServiceArea"];
                NSLog(@"得到的数据为%@",string);
                [weakSelf findServiceswithDic:self.dataDic];
                
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    [weakSelf findServiceswithDic:self.dataDic];
                //
                //                });
            }
        }
        for (NSString *tyStr in level) {
            if ([tyStr isEqualToString:string]) {
                if ([tyStr isEqualToString:@"不限"] == NO) {
                    [self.dataDic setObject:@"1" forKey:@"ServiceLevel"];
                }
                else
                {
                    [self.dataDic removeObjectForKey:@"ServiceLevel"];
                }
                [weakSelf findServiceswithDic:self.dataDic];
            }
        }
        
        for (NSString *sstr in infonmationType) {
            if ([sstr isEqualToString:string]) {
                if ([sstr isEqualToString:infonmationType[0]]) {
                    [self.dataDic setObject:informationTypeID[0] forKey:@"ServiceType"];
                }
                else if([sstr isEqualToString:infonmationType[1]])
                {
                    [self.dataDic setObject:informationTypeID[1] forKey:@"ServiceType"];
                }
                else if([sstr isEqualToString:infonmationType[2]])
                {
                    [self.dataDic setObject:informationTypeID[2] forKey:@"ServiceType"];
                    
                }
                else if([sstr isEqualToString:infonmationType[3]])
                {
                    [self.dataDic setObject:informationTypeID[3] forKey:@"ServiceType"];
                    
                }
                else if([sstr isEqualToString:infonmationType[4]])
                {
                    [self.dataDic setObject:informationTypeID[4] forKey:@"ServiceType"];
                    
                }
                else if([sstr isEqualToString:infonmationType[5]])
                {
                    [self.dataDic setObject:informationTypeID[5] forKey:@"ServiceType"];
                    
                }
                else if([sstr isEqualToString:infonmationType[6]])
                {
                    [self.dataDic setObject:informationTypeID[6] forKey:@"ServiceType"];
                    
                }
                else if([sstr isEqualToString:infonmationType[7]])
                {
                    [self.dataDic setObject:informationTypeID[7] forKey:@"ServiceType"];
                    
                }
                else if([sstr isEqualToString:infonmationType[8]])
                {
                    [self.dataDic setObject:informationTypeID[8] forKey:@"ServiceType"];
                    
                }
                
                else if([sstr isEqualToString:infonmationType[9]])
                {
                    [self.dataDic setObject:informationTypeID[9] forKey:@"ServiceType"];
                    
                }
                [weakSelf findServiceswithDic:self.dataDic];
                
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    [weakSelf findServiceswithDic:self.dataDic];
                //
                //                });
            }
        }
        
    };
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//这两个代理方法必须同时存在才起作用
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.headView;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (nib == nil) {
        nib = [UINib nibWithNibName:@"FindServiceViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"FindServiceViewCell"];
        NSLog(@"我是从nib过来的");
    }
    FindServiceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindServiceViewCell" forIndexPath:indexPath];
    cell.model = self.sourceArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FindServiceModel *model = [[FindServiceModel alloc]init];
    model = self.sourceArray[indexPath.row];
    NSLog(@"!!!!!!!!!!%@",model.ServiceID);
    self.ServiceID = model.ServiceID;
    
    ServiceDetailController *ServiceDetailVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDetailController"];
    ServiceDetailVC.ServiceID = model.ServiceID;
    //    ServiceDetailVC.userid = [NSString stringWithFormat:@"%@",model.ServiceName];
    
    ServiceDetailVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
    [self.navigationController pushViewController:ServiceDetailVC animated:YES];
    
    
}



@end
