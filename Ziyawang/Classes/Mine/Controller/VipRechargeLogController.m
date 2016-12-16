//
//  VipRechargeLogController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/14.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "VipRechargeLogController.h"
#import "VipRechargeLogCell.h"
@interface VipRechargeLogController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,assign) NSInteger startpage;
@end

@implementation VipRechargeLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.navigationItem.title = @"充值记录";
    self.sourceArray = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"VipRechargeLogCell" bundle:nil] forCellReuseIdentifier:@"VipRechargeLogCell"];
    [self getRechargeLogData];
}
- (void)getRechargeLogData
{
    self.startpage = 1;
    
    [self.sourceArray removeAllObjects];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;

    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:@"10" forKey:@"pagecount"];

    NSString *URL = [[VipRechargeLogURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary * dataDic in dic[@"data"]) {
            VipModel *model = [[VipModel alloc]init];
            [model setValuesForKeysWithDictionary:dataDic];
            [self.sourceArray addObject:model];
        }
        [self.tableView reloadData];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        self.startpage ++;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [self showAlerViewWithMessage:@"获取信息失败，请检查您的网络设置"];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
    }];
    
    
}

- (void)loadMoreData
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:[NSString stringWithFormat:@"%ld",self.startpage] forKey:@"startpage"];
    [dic setObject:@"10" forKey:@"pagecount"];
    NSString *URL = [[VipRechargeLogURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *addArray = [NSMutableArray new];
        
        for (NSDictionary * dataDic in dic[@"data"]) {
            VipModel *model = [[VipModel alloc]init];
            [model setValuesForKeysWithDictionary:dataDic];
            [addArray addObject:model];
            
        }
        if (addArray.count == 0) {
            [self showAlerViewWithMessage:@"没有更多记录"];
        }
        else
        {
        [self.sourceArray addObjectsFromArray:addArray];
            
        [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        self.startpage ++;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showAlerViewWithMessage:@"获取信息失败，请检查您的网络设置"];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
    }];
    
    
}
- (void)showAlerViewWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VipRechargeLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipRechargeLogCell" forIndexPath:indexPath];
    VipModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
