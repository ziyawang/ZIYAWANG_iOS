//
//  CostController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CostController.h"
#import "CostViewCell.h"
#import "CostModel.h"
#import "CostDetailController.h"
@interface CostController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,assign) NSInteger startpage;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIImageView *chooseImageView;

@property (nonatomic,strong) UIView *chooseView2;
@property (nonatomic,strong) NSMutableDictionary *requestDic;
@property (nonatomic,assign) BOOL barselected;
@property (nonatomic,assign) NSInteger selectedButtonTag;

@end

@implementation CostController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
 }
- (void)initViews
{
    self.barselected = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarbuttonAction:)];
    self.requestDic = [NSMutableDictionary dictionary];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.navigationItem.title = @"明细";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CostViewCell" bundle:nil] forCellReuseIdentifier:@"CostViewCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    
    self.sourceArray = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNewData];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    [self setChooseView];
}

- (void)setChooseView
{
    self.chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
   
    
    NSLog(@"%f",self.chooseView.bounds.size.width);
    self.chooseView.backgroundColor = [UIColor whiteColor];
    
    
    
    
//    self.chooseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
//    self.chooseImageView.backgroundColor = [UIColor blackColor];
//    self.chooseImageView.alpha = 0.1;
//    
//    [self.view addSubview:self.chooseImageView];
    CGFloat width = (self.view.bounds.size.width - 40)/3;
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, width, 50)];
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(width + 20, 10, width, 50)];
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(2 * width + 30, 10, width, 50)];
    button1.tag = 1;
    button2.tag = 2;
    button3.tag = 3;
    
    [button1 setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:(UIControlStateNormal)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:(UIControlStateNormal)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:(UIControlStateNormal)];
    
    [button1 addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button2 addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button3 addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"yixuanzhong"] forState:(UIControlStateHighlighted)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"yixuanzhong"] forState:(UIControlStateHighlighted)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"yixuanzhong"] forState:(UIControlStateHighlighted)];
    
    switch (self.selectedButtonTag) {
        case 1:
        [button1 setBackgroundImage:[UIImage imageNamed:@"yixuanzhong"] forState:(UIControlStateNormal)];
            break;
        case 2:
        [button2 setBackgroundImage:[UIImage imageNamed:@"yixuanzhong"] forState:(UIControlStateNormal)];
            break;
        case 3:
        [button3 setBackgroundImage:[UIImage imageNamed:@"yixuanzhong"] forState:(UIControlStateNormal)];
            break;
        default:
            break;
    }
    [button1 setTitle:@"全部" forState:(UIControlStateNormal)];
    [button2 setTitle:@"充值" forState:(UIControlStateNormal)];
    [button3 setTitle:@"付费" forState:(UIControlStateNormal)];
    
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    button2.titleLabel.font = [UIFont systemFontOfSize:16];
    button3.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button3 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [self.chooseView addSubview:button1];
    [self.chooseView addSubview:button2];
    [self.chooseView addSubview:button3];
    
    self.chooseView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50)];

    
    
    self.chooseView2.backgroundColor = [UIColor blackColor];
    self.chooseView2.alpha = 0.3;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChooseViewGestureAction:)];
    [self.chooseView2 addGestureRecognizer:gesture];
    
  }
- (void)ChooseViewGestureAction:(UITapGestureRecognizer *)gesture
{
    [self.chooseView removeFromSuperview];
    [self.chooseView2 removeFromSuperview];
}
- (void)rightBarbuttonAction:(UIBarButtonItem *)barbutton
{
    
    

   
    if (self.barselected == NO) {
//           [self setChooseView];
//                    [self.view addSubview:self.chooseView2];
//                    [self.view addSubview:self.chooseView];
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect chooseView2Frame = self.chooseView2.frame;
//            chooseView2Frame.size.height = self.view.bounds.size.height - 50;
//            self.chooseView2.frame = chooseView2Frame;
//            
//            
//        }];
        
       [self setChooseView];
        
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self.view addSubview:self.chooseView2];
            [self.view addSubview:self.chooseView];
            self.barselected = YES;
        } completion:nil];
        
        
     
        
    }
    else
    {
        [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [self.chooseView removeFromSuperview];
            [self.chooseView2 removeFromSuperview];
            self.barselected = NO;
        } completion:nil];
    
    }

}
- (void)buttonsAction:(UIButton *)button
{
    self.barselected = NO;
    [self.chooseView removeFromSuperview];
    [self.chooseView2 removeFromSuperview];
    self.requestDic = [NSMutableDictionary new];
    if (button.tag == 1) {
        
        
        [self loadNewData];
        self.selectedButtonTag = 1;
    }
    else if(button.tag == 2)
    {
        [self.requestDic setObject:@"1" forKey:@"Type"];
        [self loadNewData];
        self.selectedButtonTag = 2;
    }
    else
    {
        [self.requestDic setObject:@"2" forKey:@"Type"];
        [self loadNewData];
        self.selectedButtonTag = 3;
    }
}
- (void)loadNewData
{
    self.startpage = 1;
    [self.sourceArray removeAllObjects];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[CostURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    [self.requestDic setObject:@"token" forKey:@"access_token"];
    [self.requestDic setObject:@"10" forKey:@"pagecount"];
    
[self.manager POST:URL parameters:self.requestDic progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"获取信息成功");
    for (NSDictionary *Dic in dic[@"data"]) {
        CostModel *model = [[CostModel alloc]init];
        [model setValuesForKeysWithDictionary:Dic];
        [self.sourceArray addObject:model];
    }
    self.startpage ++;
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
    [self.tableView reloadData];
    
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
    NSString *URL = [[CostURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    [self.requestDic setObject:@"token" forKey:@"access_token"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%ld",self.startpage] forKey:@"startpage"];
    [self.requestDic setObject:@"10" forKey:@"pagecount"];
    [self.manager POST:URL parameters:self.requestDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"获取信息成功");
        
        NSMutableArray *addArray = [NSMutableArray new];
        
        for (NSDictionary *Dic in dic[@"data"]) {
            CostModel *model = [[CostModel alloc]init];
            [model setValuesForKeysWithDictionary:Dic];
            [addArray addObject:model];
        }
        if (addArray.count == 0) {
            [self.tableView.mj_footer endRefreshing];
            [self showAlerViewWithMessage:@"没有更多消费信息"];
        }
        else
        {
            [self.sourceArray addObjectsFromArray:addArray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            self.startpage ++;
            
        }
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showAlerViewWithMessage:@"获取信息失败，请检查您的网络设置"];
        [self.tableView.mj_footer endRefreshing];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
    }];
}
- (void)showAlerViewWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CostViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CostViewCell" forIndexPath:indexPath];
    CostModel *model = [[CostModel alloc]init];
    model = self.sourceArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CostDetailController *costDeatilVC = [[CostDetailController alloc]init];
    
    CostModel *model = [[CostModel alloc]init];
    model = self.sourceArray[indexPath.row];
    model.Type = [NSString stringWithFormat:@"%@",model.Type];
    
    costDeatilVC.Type = model.Type;
    costDeatilVC.costCount = model.Money;
    costDeatilVC.costTime = model.created_at;
    costDeatilVC.operate = model.Operates;
    costDeatilVC.ordernumber = model.OrderNumber;
    
    [self.navigationController pushViewController:costDeatilVC animated:YES];
    

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
