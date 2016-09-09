//
//  FindServiceController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/3.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FindServiceController.h"
#import "AFNetWorking.h"
#import "MBProgressHUD.h"
#import "MoreMenuView.h"
#import "FindServiceViewCell.h"
#import "FindServiceModel.h"
#import "ServiceDetailController.h"
#import "FindServiceModel.h"
@interface FindServiceController ()
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

@end

@implementation FindServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceArray = [NSMutableArray array];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FindServiceViewCell" bundle:nil] forCellReuseIdentifier:@"FindServiceViewCell"];

    self.dataDic = [NSMutableDictionary new];
    [self setHeadView];
    [self findServiceswithDic:self.dataDic];
}
- (void)findServiceswithDic:(NSMutableDictionary *)dataDic
{
    NSLog(@"@@@@@@@@@@@@@@@@@@@@@%@",dataDic);
    if (self.sourceArray != nil)
    {
        [self.sourceArray removeAllObjects];
    }
    NSString *getURL =[FindServiceURL stringByAppendingString:@"?access_token=token"];
//    NSString *getURL = @"http://api.ziyawang.com/v1/service/list/";
    NSMutableDictionary *getdic = dataDic;
    NSLog(@"#############%@",getdic);
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
    
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray) {
            
            FindServiceModel *model = [[FindServiceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:model];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
}


- (void)setHeadView
{
    NSArray *titles = @[@"服务类型",@"地区",@"等级"];
    MoreMenuView *menuView = [[MoreMenuView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 60) titles:titles];
    menuView.cornerMarkLocationType = CornerMarkLocationTypeRight;
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
    
    NSArray *infonmationType = @[@"资产包收购",@"催收机构",@"律师事务所",@"保理公司",@"典当担保",@"投融资服务",@"尽职调查",@"资产收购",@"债权收购"];
     NSArray *informationTypeID = @[@"01",@"02",@"03",@"04",@"05",@"06",@"10",@"12",@"14"];
    NSArray *level = @[@"VIP1"];
    menuView.indexsOneFist = infonmationType;
    menuView.indexsTwoFist = self.shengArray;
//    menuView.indexsTwoSecond = self.allshiArray;
    menuView.indexsThirFist = level;
    
     __weak typeof(self) weakSelf = self;
    self.headView = menuView;
    
    menuView.selectedIndex = ^(NSString *string)
    {
        for (NSString *str in self.shengArray) {
            if ([str isEqualToString:string]) {
                [self.dataDic setObject:string forKey:@"ProArea"];
                NSLog(@"得到的数据为%@",string);
                [weakSelf findServiceswithDic:self.dataDic];

//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf findServiceswithDic:self.dataDic];
//
//                });
                
            }
        }
       
        for (NSString *sstr in infonmationType) {
            if ([sstr isEqualToString:string]) {
                if ([sstr isEqualToString:infonmationType[0]]) {
                    [self.dataDic setObject:informationTypeID[0] forKey:@"ServiceID"];
                }
                else if([sstr isEqualToString:infonmationType[1]])
                {
                    [self.dataDic setObject:informationTypeID[1] forKey:@"ServiceID"];
                    
                }
                else if([sstr isEqualToString:infonmationType[2]])
                {
                    [self.dataDic setObject:informationTypeID[2] forKey:@"ServiceID"];
                    
                }
                else if([sstr isEqualToString:infonmationType[3]])
                {
                    [self.dataDic setObject:informationTypeID[3] forKey:@"ServiceID"];
                    
                }
                else if([sstr isEqualToString:infonmationType[4]])
                {
                    [self.dataDic setObject:informationTypeID[4] forKey:@"ServiceID"];
                    
                }
                else if([sstr isEqualToString:infonmationType[5]])
                {
                    [self.dataDic setObject:informationTypeID[5] forKey:@"ServiceID"];
                    
                }
                else if([sstr isEqualToString:infonmationType[6]])
                {
                    [self.dataDic setObject:informationTypeID[6] forKey:@"ServiceID"];
                    
                }
                else if([sstr isEqualToString:infonmationType[7]])
                {
                    [self.dataDic setObject:informationTypeID[7] forKey:@"ServiceID"];
                    
                }
                else if([sstr isEqualToString:infonmationType[8]])
                {
                    [self.dataDic setObject:informationTypeID[8] forKey:@"ServiceID"];
                    
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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

    NSLog(@"__________________%@",cell.model);
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    FindServiceModel *model = [[FindServiceModel alloc]init];
    model = self.sourceArray[indexPath.row];
    NSLog(@"!!!!!!!!!!%@",model.ServiceID);
    self.ServiceID = model.ServiceID;
    ServiceDetailController *ServiceDetailVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDetailController"];
    ServiceDetailVC.ServiceID = self.ServiceID;
    
    [self.navigationController pushViewController:ServiceDetailVC animated:YES];
    

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
