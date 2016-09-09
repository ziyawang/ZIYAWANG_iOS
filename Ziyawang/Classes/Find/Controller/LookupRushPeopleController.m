//
//  LookupRushPeopleController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/8.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "LookupRushPeopleController.h"
#import "AFNetWorking.h"
#import "PublishModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LookUpRushPeopleCell.h"
#import "RushPeopleModel.h"
#import "talkViewController.h"
#import "ServiceDetailController.h"
@interface LookupRushPeopleController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,pushDelegate>
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UITableView *tableVeiw;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) RushPeopleModel *model;
@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation LookupRushPeopleController
- (void)popAction:(UIBarButtonItem *)barbutton
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
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
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[RushPeopleModel alloc]init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    self.tableVeiw = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    [self.tableVeiw registerNib:[UINib nibWithNibName:@"LookUpRushPeopleCell" bundle:nil] forCellReuseIdentifier:@"LookUpRushPeopleCell"];
    [self.view addSubview:self.tableVeiw];
    self.tableVeiw.delegate = self;
    self.tableVeiw.dataSource = self;
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sourceArray = [NSMutableArray new];
    [self getRushPeopleData];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getRushPeopleData
{
    
    
    NSString *headurl = getDataURL;
    
    NSString *footurl = @"/project/rushlist/";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
//    NSString *token = [@"?token=" stringByAppendingString:token1];
//    NSString *projectID = [NSString stringWithFormat:@"%@",self.ProjectID];
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",self.ProjectID);
    NSString *projectID = [NSString stringWithFormat:@"%@",self.ProjectID];
    NSString *URL =[[headurl stringByAppendingString:footurl]stringByAppendingString:projectID];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    NSString *accesstoken = @"token";
    [paraDic setObject:token forKey:@"token"];
    [paraDic setObject:accesstoken forKey:@"access_token"];
//    [paraDic setObject:projectID forKey:@"ProjectID"];
    
    [self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress)
     {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"data"];
        for (NSDictionary *dic in array)
        {
            RushPeopleModel *model = [[RushPeopleModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:model];
        }
        [self.tableVeiw reloadData];
        NSLog(@"请求成功");
        NSLog(@"自己的抢单人返回的数据%@",dic);
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----------------------%@",error);
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        NSLog(@"申请请求失败！%@",error);
    }];
}

//- (void)collectButtonAction:(UIButton *)collectButton
//{
//    NSString *headurl = @"http://api.ziyawang.com/v1";
//    NSString *footurl = @"/project/myrush";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
//    NSString *URL =[[[headurl stringByAppendingString:footurl]stringByAppendingString:@"?token="]stringByAppendingString:token];
//    
//    
//    NSMutableDictionary *paraDic = [NSMutableDictionary new];
//    NSString *accesstoken = @"token";
//    NSString *type = @"1";
//    self.model.ServiceID = [NSString stringWithFormat:@"%@",self.model.ServiceID];
////    [paraDic setObject:token forKey:@"token"];
//    [paraDic setObject:accesstoken forKey:@"access_token"];
//    [paraDic setObject:type forKey:@"type"];
//    [paraDic setObject:self.model.ServiceID forKey:@"itemID"];
//
//    [self.manager GET:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"收藏成功");
//        [self MBProgressWithString:@"收藏成功" timer:1 mode:MBProgressHUDModeText];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        [self MBProgressWithString:@"收藏失败" timer:1 mode:MBProgressHUDModeText];
//        NSLog(@"请求失败%@",error);
//    }];
//    
//    
//}
//- (void)agreeButtonAction:(UIButton *)agreeButton
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
//
//    NSString *headurl = @"http://api.ziyawang.com/v1";
//    NSString *footurl = @"/project/cooperate";
//    self.ProjectID = [NSString stringWithFormat:@"%@",self.ProjectID];
//    NSLog(@"#################################%@",self.model.ServiceID);
//    self.model.ServiceID = [NSString stringWithFormat:@"%@",self.model.ServiceID];
//    NSString *URL= [[[[[[[[headurl stringByAppendingString:footurl]stringByAppendingString:@"?access_token=token"]stringByAppendingString:@"&token="]stringByAppendingString:token]stringByAppendingString:@"&ServiceID="]stringByAppendingString:self.model.ServiceID]stringByAppendingString:@"&ProjectID="]stringByAppendingString:self.ProjectID];
//    
//    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",URL);
////    NSString *URL =[headurl stringByAppendingString:footurl];
//    NSMutableDictionary *paraDic = [NSMutableDictionary new];
////        NSString *accesstoken = @"token";
////    [paraDic setObject:token forKey:@"token"];
////    [paraDic setObject:accesstoken forKey:@"access_token"];
////    [paraDic setObject:self.model.ServiceID forKey:@"ServiceID"];
////    [paraDic setObject:self.ProjectID forKey:@"ProjectID"];
//    
//    
//    [self.manager POST:URL parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"合作成功");
//        [self MBProgressWithString:@"合作成功" timer:1 mode:MBProgressHUDModeText];
//        NSLog(@"%@",dic[@"code"]);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self MBProgressWithString:@"合作失败" timer:1 mode:MBProgressHUDModeText];
//        NSLog(@"合作失败%@",error);
//    }];
//}
//
////转到私聊界面
//
//- (void)talkButtonAction:(UIButton *)talkButton
//{
//    talkViewController *talkVC = [[talkViewController alloc]init];
//    [self.navigationController pushViewController:talkVC animated:YES];
//    
//}



#pragma mark----tableview datasource delegate
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookUpRushPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookUpRushPeopleCell" forIndexPath:indexPath];
    cell.model = self.sourceArray[indexPath.row];
    self.model = cell.model;
//    [cell.collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [cell.agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [cell.talkButton addTarget:self action:@selector(talkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.ProjectID = self.ProjectID;
//    [cell.collectButton setImage:[UIImage imageNamed:@"shoucang-hui"] forState:(UIControlStateNormal)];
//    [cell.agreeButton setImage:[UIImage imageNamed:@"hezuo"] forState:(UIControlStateNormal)];
//    [cell.talkButton setImage:[UIImage imageNamed:@"siliao-hong"] forState:(UIControlStateNormal)];
    cell.Mydelegate = self;
    
//    if ([self.PublishState isEqualToString:@"0"]) {
//        NSLog(@"单子处在抢单状态");
//        [cell.agreeButton setHidden:NO];
//        
//    }
//    else if([self.PublishState isEqualToString:@"1"])
//    {
//        NSLog(@"单子处在合作中");
//        [cell.agreeButton setHidden:YES];
//        
//    }
//    else
//    {
//        NSLog(@"单子处在取消中");
//        
//    }
    cell.PublishState = self.PublishState;
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)pushToControllerWithModel:(RushPeopleModel *)model
{
    talkViewController *talkVC = [[talkViewController alloc]init];
    model.UserID = [NSString stringWithFormat:@"%@",model.UserID];
    talkVC.targetId = model.UserID;
    talkVC.title = model.ServiceName;
    talkVC.conversationType = ConversationType_PRIVATE;
    [self.navigationController pushViewController:talkVC animated:YES];

    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     RushPeopleModel *model = [[RushPeopleModel alloc]init];
    model = self.sourceArray[indexPath.row];
    NSLog(@"!!!!!!!!!!%@",model.ServiceID);
    ServiceDetailController *ServiceDetailVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDetailController"];
    ServiceDetailVC.ServiceID = model.ServiceID;
    ServiceDetailVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
[self.navigationController pushViewController:ServiceDetailVC animated:YES];
    
    
}



@end
