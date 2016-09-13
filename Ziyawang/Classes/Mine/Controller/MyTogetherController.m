//
//  MyTogetherController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MyTogetherController.h"
#import "AFNetWorking.h"
#import "MBProgressHUD.h"
#import "PublishModel.h"
#import "MyTogetherCell.h"
#import "CSCancelOperationController.h"
#import "InfoDetailsController.h"
@interface MyTogetherController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic,strong) NSString *ProjectID;

@property (nonatomic,assign) NSInteger startpage;


@end

@implementation MyTogetherController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的合作";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height ) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTogetherCell" bundle:nil] forCellReuseIdentifier:@"MyTogetherCell"];
    self.tableView.separatorStyle = NO;
    
    self.sourceArray = [NSMutableArray array];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self getMyTogetherList];
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

    
}

- (void)getMyTogetherList
{
    self.startpage = 1;
    [self.sourceArray removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *url1 = getDataURL;
    NSString *url2 = @"/project/coolist";
    NSString *accesstoken = @"token";
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:accesstoken forKey:@"access_token"];
    NSString *URL = [[[url1 stringByAppendingString:url2]stringByAppendingString:@"?token="]stringByAppendingString:token];
//    [paraDic setObject:token forKey:@"token"];
    
    [self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求请求合作列表成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray)
        {
            PublishModel *model = [[PublishModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:model];
        }
        
        NSLog(@"$$$$$$$$$$$$$$$$%@",self.sourceArray);
                [self.tableView reloadData];
        self.startpage ++;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        NSLog(@"请求我的合作列表失败");
        NSLog(@"%@",error);
    }];

}

- (void)loadMoreData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *url1 = getDataURL;
    NSString *url2 = @"/project/coolist";
    NSString *accesstoken = @"token";
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    [paraDic setObject:accesstoken forKey:@"access_token"];
    [paraDic setObject:[NSString stringWithFormat:@"%d",self.startpage] forKey:@"startpage"];
    NSString *URL = [[[url1 stringByAppendingString:url2]stringByAppendingString:@"?token="]stringByAppendingString:token];
    //    [paraDic setObject:token forKey:@"token"];
    
    [self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求请求合作列表成功");
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
        [self.sourceArray addObjectsFromArray:addArray];
        NSLog(@"$$$$$$$$$$$$$$$$%@",self.sourceArray);
        [self.tableView reloadData];
        self.startpage ++;
        [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        [self.tableView.mj_footer endRefreshing];

        NSLog(@"请求我的合作列表失败");
        NSLog(@"%@",error);
    }];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 165;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 165;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 170;
        
    }
    
    return 165;
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
    
    MyTogetherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTogetherCell" forIndexPath:indexPath];
    cell.model = self.sourceArray[indexPath.row];
    cell.ProjectID = cell.model.ProjectID;
    self.ProjectID = [NSString stringWithFormat:@"%@",cell.model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
//跳转我的合作详情

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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

//- (void)cancelAction:(UIButton *)button
//{
////    CSCancelOperationController *cancelVC = [[CSCancelOperationController alloc]init];
////    [self.navigationController pushViewController:cancelVC animated:YES];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
//    NSString *url1 = @"http://api.ziyawang.com/v1";
//    NSString *url2 = @"/project/cancel";
//    NSString *URL = [[[url1 stringByAppendingString:url2]stringByAppendingString:@"?token="]stringByAppendingString:token];
//    NSMutableDictionary *paraDic = [NSMutableDictionary new];
//    [paraDic setObject:@"token" forKey:@"access_token"];
//    [paraDic setObject:self.ProjectID forKey:@"ProjectID"];
//    [self.manager POST:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"取消合作成功");
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"取消合租返回的数据%@",dic);
//        [self getMyTogetherList];
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"取消合作失败");
//    }];
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
