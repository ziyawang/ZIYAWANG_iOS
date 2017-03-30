//
//  JiangtangController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/10/31.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "JiangtangController.h"
#import "ZixunViewCell.h"
#import "NewsModel.h"
@interface JiangtangController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,assign) NSInteger startpage;
@property (nonatomic,assign) CGFloat scroViewHight;
@end

@implementation JiangtangController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceArray = [NSMutableArray new];
    //    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.scroViewHight = [self getImageViewHight] + 40;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZixunViewCell" bundle:nil] forCellReuseIdentifier:@"ZixunViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getNewsList];
     self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewsList)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
}

- (void)getNewsList
{
    
    self.sourceArray = [NSMutableArray array];
    self.startpage = 1;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *startpage = [NSString stringWithFormat:@"%ld",self.startpage];
    
    [dic setObject:startpage  forKey:@"startpage"];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:@"zyjt" forKey:@"NewsLabel"];
    [dic setObject:@"10" forKey:@"pagecount"];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    [self.manager GET:NewsListURL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary dictionary];
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *Dic in dic[@"data"]) {
            NewsModel *model = [[NewsModel alloc]init];
            [model setValuesForKeysWithDictionary:Dic];
            [self.sourceArray addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        self.startpage ++;
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.tableView.mj_header endRefreshing];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
    }];
}
- (void)loadMoreData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *startpage = [NSString stringWithFormat:@"%ld",self.startpage];
    
    [dic setObject:startpage  forKey:@"startpage"];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:@"zyjt" forKey:@"NewsLabel"];
    [dic setObject:@"10" forKey:@"pagecount"];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.manager GET:NewsListURL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary dictionary];
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *addArray = [NSMutableArray array];
        
        for (NSDictionary *Dic in dic[@"data"]) {
            NewsModel *model = [[NewsModel alloc]init];
            [model setValuesForKeysWithDictionary:Dic];
            [addArray addObject:model];
        }
        if (addArray.count == 0) {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多资讯" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            return;
        }
        else
        {
            [self.sourceArray addObjectsFromArray:addArray];
            [self.tableView reloadData];
            self.startpage ++;

            [self.tableView.mj_footer endRefreshing];
        }
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.tableView.mj_footer endRefreshing];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
        
    }];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.sourceArray.count;
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    //    {
    //
    //        return 230;
    //    }
    //    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    //    {
    //        return 250;
    //    }
    //    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    //    {
    //        return 270;
    //
    //    }
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZixunViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZixunViewCell" forIndexPath:indexPath];
    NewsModel *model = [[NewsModel alloc]init];
    model = self.sourceArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = [[NewsModel alloc]init];
    model = self.sourceArray[indexPath.row];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    userInfo[@"NewsID"] = model.NewsID;
    userInfo[@"NewsTime"] = [ZixunViewCell getDateWithString:model.PublishTime];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"NewsControllerpush" object:nil userInfo:userInfo];
    
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToMovieDentailControllerNotification" object:nil userInfo:userInfo];
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
