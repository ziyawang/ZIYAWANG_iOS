//
//  SearchTypeController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/12.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "SearchTypeController.h"
#import "FindServiceViewCell.h"
#import "PublishCell.h"
#import "PublishModel.h"
#import "FindServiceModel.h"
#import "InfoDetailsController.h"
#import "ServiceDetailController.h"

@interface SearchTypeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger startpage;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *sourceArray;

@end

@implementation SearchTypeController

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
//    
//    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
//    //让黑线消失的方法
//    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //让黑线消失的方法
    self.view.backgroundColor = [UIColor whiteColor];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.startpage = 1;
    self.sourceArray = [NSMutableArray new];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 30) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PublishCell" bundle:nil] forCellReuseIdentifier:@"PublishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindServiceViewCell" bundle:nil] forCellReuseIdentifier:@"FindServiceViewCell"];
    self.tableView.separatorStyle = NO;
    
    [self.view addSubview:self.tableView];
    [self getDataWithType:self.type SearchValue:self.searchValue];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataWithType:self.type SearchValue:self.searchValue];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreDataWithType:self.type SearchValue:self.searchValue];
    }];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonAction:)];
  
}

- (void)leftButtonAction:(UIBarButtonItem*)barbutton
{
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)loadMoreDataWithType:(NSString *)type SearchValue:(NSString *)searchvalue
{
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *getURL = @"123";
    NSString *access_token = @"token";
    NSString *startPage = [NSString stringWithFormat:@"%ld",self.startpage];
    [getdic setObject:access_token forKey:@"access_token"];
    [getdic setObject:startPage forKey:@"startpage"];
    [getdic setObject:@"10" forKey:@"pagecount"];
    
    if ([type isEqualToString:@"找信息"]) {
        [getdic setObject:searchvalue forKey:@"TypeID"];
        getURL = FindInformationURL;
        [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *sourceArray = dic[@"data"];
            NSMutableArray *addAddArray = [NSMutableArray new];
            for (NSDictionary *dic in sourceArray) {
                PublishModel *model = [[PublishModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [addAddArray addObject:model];
                
            }
            self.startpage ++;

            if (addAddArray.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer endRefreshing];

            }
            else
            {
            [self.sourceArray addObjectsFromArray:addAddArray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.tableView.mj_footer endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"搜索失败");
        }];
    }
    else
    {
        getURL = FindServiceURL;
        [getdic setObject:searchvalue forKey:@"ServiceType"];
        [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            self.startpage ++;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *sourceArray = dic[@"data"];
            NSMutableArray *addAddArray = [NSMutableArray new];
            for (NSDictionary *dic in sourceArray) {
                FindServiceModel *model = [[FindServiceModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [addAddArray addObject:model];
            }
            if (addAddArray.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer endRefreshing];
            }
            else
            {
                [self.sourceArray addObjectsFromArray:addAddArray];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.tableView.mj_footer endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"搜索失败");
        }];
    }
    


}

- (void)getDataWithType:(NSString *)type SearchValue:(NSString *)searchvalue
{
    [self.sourceArray removeAllObjects];
    self.startpage = 1;
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    NSString *getURL = @"123";
    NSString *access_token = @"token";
    NSString *startPage = [NSString stringWithFormat:@"%ld",self.startpage];
    [getdic setObject:access_token forKey:@"access_token"];
    [getdic setObject:startPage forKey:@"startpage"];
    [getdic setObject:@"5" forKey:@"pagecount"];

    if ([type isEqualToString:@"找信息"]) {
        [getdic setObject:searchvalue forKey:@"TypeID"];
        getURL = FindInformationURL;
        [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.startpage ++;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *sourceArray = dic[@"data"];
            for (NSDictionary *dic in sourceArray) {
                PublishModel *model = [[PublishModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.sourceArray addObject:model];
            }
          
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"搜索失败");

        }];
    }
    else
    {
      getURL = FindServiceURL;
        [getdic setObject:searchvalue forKey:@"ServiceType"];
        [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            self.startpage ++;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *sourceArray = dic[@"data"];
            for (NSDictionary *dic in sourceArray) {
                FindServiceModel *model = [[FindServiceModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.sourceArray addObject:model];
            }
          
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"搜索失败");

        }];
    }

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
        
        return 130;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 140;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 140;
        
    }
    
    return 150;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.type isEqualToString:@"找信息"]) {
        PublishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[PublishCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PublishCell"];
        }
        cell.model = self.sourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;


        return cell;
    }
    else
    {
        FindServiceViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FindServiceViewCell" forIndexPath:indexPath];
        
        if (cell == nil)
        {
            cell = [[FindServiceViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"FindServiceViewCell"];
        }
        cell.model = self.sourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;


        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"找信息"]) {
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
//        self.ServiceID = model.ServiceID;
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
