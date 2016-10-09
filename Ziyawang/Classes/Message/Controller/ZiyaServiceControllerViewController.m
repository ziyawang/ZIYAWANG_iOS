//
//  ZiyaServiceControllerViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/20.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ZiyaServiceControllerViewController.h"
#import "ZiyaServiceModel.h"
#import "ZiyaServiceCell.h"
#import "ServiceMessageController.h"
@interface ZiyaServiceControllerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,assign) NSInteger startpage;


@end

@implementation ZiyaServiceControllerViewController

- (void)viewWillAppear:(BOOL)animated
{
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
    
    [self getSerViceData];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"系统消息";
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZiyaServiceCell" bundle:nil] forCellReuseIdentifier:@"ZiyaServiceCell"];
    [self.view addSubview:self.tableView];
    self.sourceArray = [NSMutableArray new];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getSerViceData) ];
    
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
}

- (void)getSerViceData
{
    if (self.sourceArray != nil) {
        [self.sourceArray removeAllObjects];
    }
    self.startpage = 1;
    NSString *url = [getDataURL stringByAppendingString:@"/getmessage"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:@"10" forKey:@"pagecount"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[url stringByAppendingString:@"?token="]stringByAppendingString:token];
    
    
[self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    if ([dic[@"status_code"] isEqualToString:@"200"]) {
        NSLog(@"获取系统消息成功");
        NSArray *dataArray = dic[@"data"];
        for (NSDictionary *dic in dataArray) {
            ZiyaServiceModel *model = [[ZiyaServiceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:model];
            
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        self.startpage ++;
        
    }
    NSLog(@"------系统消息数据%@",dic);
    
//    if(dic[@"statu"])
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"请求系统消息失败%@",error);
    [self.tableView.mj_header endRefreshing];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}];
    
}

- (void)loadMoreData
{
    NSString *url = [getDataURL stringByAppendingString:@"/getmessage"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"token" forKey:@"access_token"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[url stringByAppendingString:@"?token="]stringByAppendingString:token];
    [dic setObject:[NSString stringWithFormat:@"%ld",self.startpage] forKey:@"startpage"];

    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status_code"] isEqualToString:@"200"]) {
            NSLog(@"获取系统消息成功");
            NSArray *dataArray = dic[@"data"];
            NSMutableArray *addArray = [NSMutableArray new];
            for (NSDictionary *dic in dataArray) {
                ZiyaServiceModel *model = [[ZiyaServiceModel alloc]init];
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

            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            self.startpage ++;
            }
        }
        NSLog(@"------系统消息数据%@",dic);
        //    if(dic[@"statu"])
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求系统消息失败%@",error);
        [self.tableView.mj_footer endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        
    }];
    


}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZiyaServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZiyaServiceCell" forIndexPath:indexPath];
    if (cell ==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ZiyaServiceCell" forIndexPath:indexPath];
    }
    ZiyaServiceModel *model = [[ZiyaServiceModel alloc]init];
    model = self.sourceArray[indexPath.row];
    cell.model = model;
    cell.model.Status = [NSString stringWithFormat:@"%@",cell.model.Status];
    if ([cell.model.Status isEqualToString:@"0"]) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    }
   
    else
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceMessageController *servicceVC = [[ServiceMessageController alloc]init];
    ZiyaServiceModel *model = [[ZiyaServiceModel alloc]init];
    model = self.sourceArray[indexPath.row];
    servicceVC.Text = model.Text;
    servicceVC.TextID = model.TextID;
    servicceVC.Time = model.Time;
    
//    ZiyaServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZiyaServiceCell" forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:servicceVC animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除此条消息吗" preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
            
            ZiyaServiceModel *model = [[ZiyaServiceModel alloc]init];
            model = self.sourceArray[indexPath.row];
            [self.sourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            NSString *url = [getDataURL stringByAppendingString:@"/delmessage"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"token" forKey:@"access_token"];
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
            NSString *URL = [[url stringByAppendingString:@"?token="]stringByAppendingString:token];
            NSMutableDictionary *postdic = [NSMutableDictionary dictionary];
            [postdic setObject:@"token" forKey:@"access_token"];
            //    [postdic setObject:token forKey:@"token"];
            //空
               [postdic setObject:model.TextID forKey:@"TextID"];
            [self.manager POST:URL parameters:postdic progress:^(NSProgress * _Nonnull uploadProgress)
             {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 NSLog(@"%@",dic);
                 NSLog(@"删除系统消息成功");
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状态" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
             }];
            
         
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
