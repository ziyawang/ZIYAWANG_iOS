//
//  MyPushController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MyPushController.h"
#import "PublishCell.h"
#import "NewPublishCell.h"
#import "AFNetWorking.h"
#import "MBProgressHUD.h"
#import "PublishModel.h"
#import "MyPushCell.h"
#import "SDVersion.h"
#import "SDiOSVersion.h"
#import "InfoDetailsController.h"
#import "DetailOfInfoController.h"
@interface MyPushController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger starpage;

@end

@implementation MyPushController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的发布";
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyPushCell" bundle:nil] forCellReuseIdentifier:@"MyPushCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMypushData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

    self.sourceArray = [NSMutableArray array];
    [self getMypushData];
}

- (void)getMypushData
{
///project/mypro
    self.starpage = 1;
    if (self.sourceArray != nil) {
        [self.sourceArray removeAllObjects];
        
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
//    NSString *url1 = @"https://apis.ziyawang.com/zll";
//    NSString *url2 = @"/project/mypro";
    NSString *accesstoken = @"token";
    
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:accesstoken forKey:@"access_token"];
    NSString *URL = getMyPushURL;
    [paraDic setObject:token forKey:@"token"];
    
    [self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求发布列表成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray)
        {
            PublishModel *model = [[PublishModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:model];
        }
        if (self.sourceArray.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未发布任何信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        NSLog(@"$$$$$$$$$$$$$$$$%@",self.sourceArray);
        self.starpage ++;
        
        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self.tableView.mj_header endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据失败，请检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        
        NSLog(@"请求我的发布列表失败");
        
        NSLog(@"%@",error);
    }];
}

- (void)loadMoreData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
//    NSString *url1 = @"https://apis.ziyawang.com/zll";
//    NSString *url2 = @"/project/mypro";
    
    NSString *accesstoken = @"token";
    
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:accesstoken forKey:@"access_token"];
    NSString *URL = getMyPushURL;
    [paraDic setObject:token forKey:@"token"];
    [paraDic setObject:[NSString stringWithFormat:@"%ld",self.starpage] forKey:@"startpage"];
    
[self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求发布列表成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        NSMutableArray *addArray = [NSMutableArray new];
        for (NSDictionary *dic in sourceArray)
        {
            PublishModel *model = [[PublishModel alloc]init];
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
        NSLog(@"$$$$$$$$$$$$$$$$%@",self.sourceArray);
        self.starpage ++;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.tableView.mj_footer endRefreshing];

        NSLog(@"请求我的发布列表失败");
        NSLog(@"%@",error);
    }];


}


- (CGFloat )getRowHight
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    return 115;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  self.sourceArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ 
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyPushCell";
    MyPushCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell= (MyPushCell *)[[[NSBundle  mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]  lastObject];
    }
//    MyPushCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyPushCell" forIndexPath:indexPath];
    
//    if (cell == nil) {
//        cell= (MyPushCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"MyPushCell" owner:self options:nil]  lastObject];
//    }
//    else
//    {
//        //删除cell的所有子视图
//        while ([cell.contentView.subviews lastObject] != nil)
//        {
//            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
//    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.sourceArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailOfInfoController *infoDetailsVC = [[DetailOfInfoController alloc]init];
    PublishModel *model = [[PublishModel alloc]init];
    model = self.sourceArray[indexPath.row];
    infoDetailsVC.ProjectID = [NSString stringWithFormat:@"%@",model.ProjectID];
    NSLog(@"我的发布点击projectid%@",infoDetailsVC.ProjectID);
    infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
    NSLog(@"我的发布点击userid%@",infoDetailsVC.ProjectID);
    infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
    infoDetailsVC.typeName = model.TypeName;
    NSLog(@"我的发布点击puserid%@",infoDetailsVC.ProjectID);
    
    model.CertifyState = [NSString stringWithFormat:@"%@",model.CertifyState];
    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@",model.CertifyState);
    
    if ([model.CertifyState isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的信息正在审核中" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if ([model.CertifyState isEqualToString:@"1"])
    {
        [self.navigationController pushViewController:infoDetailsVC animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的信息未通过审核，请重新提交" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
