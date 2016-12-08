//
//  LookupMyRushController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/8.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "LookupMyRushController.h"
#import "AFNetWorking.h"
#import "PublishModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PublishCell.h"
#import "NewPublishCell.h"
#import "LookUpMyRushCell.h"
#import "InfoDetailsController.h"
#import "DetailOfInfoController.h"
@interface LookupMyRushController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger startpage;

@end

@implementation LookupMyRushController
- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"我的约谈";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;
    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupTitle];
    self.navigationItem.title = @"我的约谈";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    //    [self setupTitle];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
    statuView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statuView];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
    
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];

 self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
//    [self.tableView registerNib:[UINib nibWithNibName:@"LookUpMyRushCell" bundle:nil] forCellReuseIdentifier:@"LookUpMyRushCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPublishCell" bundle:nil] forCellReuseIdentifier:@"NewPublishCell"];
    self.tableView.separatorStyle = NO;
    
    
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.sourceArray  = [NSMutableArray new];
    
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

    [self getMyRushList];
    
}

- (void)getMyRushList
{
    [self.sourceArray removeAllObjects];
    
    self.startpage = 1;
    
    NSLog(@"进入抢我的单列表");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *headurl = getDataURL;
    NSString *footurl = @"/project/myrush";
    NSString *URL =[[[headurl stringByAppendingString:footurl]stringByAppendingString:@"?token="]stringByAppendingString:token];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
   
    NSString *accesstoken = @"token";
//    [paraDic setObject:token forKey:@"token"];
    [paraDic setObject:accesstoken forKey:@"access_token"];
    [self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"----%@",dic);
        NSArray *array = dic[@"data"];
        for (NSDictionary *dic in array) {
            PublishModel *model = [[PublishModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:model];
        }
        NSString *count = [NSString stringWithFormat:@"%@",dic[@"counts"]];
        if ([count isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时没有抢单" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        self.startpage ++;
        [self.tableView reloadData];
        NSLog(@"请求自己抢的单子成功");
        NSLog(@"自己的单子%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"申请请求失败！%@",error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}
- (void)loadMoreData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *headurl = getDataURL;
    NSString *footurl = @"/project/myrush";
    NSString *URL =[[[headurl stringByAppendingString:footurl]stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    NSString *accesstoken = @"token";
    //    [paraDic setObject:token forKey:@"token"];
    [paraDic setObject:accesstoken forKey:@"access_token"];
    [paraDic setObject:[NSString stringWithFormat:@"%ld",self.startpage] forKey:@"startpage"];
    
    [self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"----%@",dic);
        NSArray *array = dic[@"data"];
        NSMutableArray *addArray = [NSMutableArray new];
        
        for (NSDictionary *dic in array) {
            PublishModel *model = [[PublishModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [addArray addObject:model];
//            [self.sourceArray addObject:model];
            
        }
        if(addArray.count == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
        [self.sourceArray addObjectsFromArray:addArray];
        self.startpage ++;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"请求自己抢的单子成功");
        NSLog(@"自己的单子%@",dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"申请请求失败！%@",error);
        [self.tableView.mj_footer endRefreshing];

    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPublishCell" forIndexPath:indexPath];
    cell.model = self.sourceArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    DetailOfInfoController *infoDetailsVC = [[DetailOfInfoController alloc]init];
    
    PublishModel *model = [[PublishModel alloc]init];
    model = self.sourceArray[indexPath.row];
    infoDetailsVC.ProjectID = model.ProjectID;
    infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
    NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
    infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
    infoDetailsVC.typeName = model.TypeName;

    [self.navigationController pushViewController:infoDetailsVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
