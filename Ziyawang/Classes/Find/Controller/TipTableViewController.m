//
//  TipTableViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/10/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "TipTableViewController.h"
#import "CSChooseServiceTypeCell.h"
#import "CSChooseServiceTypeModel.h"
#import "UILabel+UIFonts.h"
#define kWidthScale ([UIScreen mainScreen].bounds.size.width/414)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/736)

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface TipTableViewController ()

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic,strong) NSString *tipID;

@end

@implementation TipTableViewController
#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
         CSChooseServiceTypeModel *model1 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"已合作或已处置"];
        if ([self.Type isEqualToString:@"1"]) {
            model1 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"已合作或已处置"];
            
        }
        else
        {
        model1 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"服务方描述与事实不符"];
        }
       
        CSChooseServiceTypeModel *model2 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"虚假信息"];
        CSChooseServiceTypeModel *model3 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"泄露私密"];
        CSChooseServiceTypeModel *model4 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"垃圾广告"];
        CSChooseServiceTypeModel *model5 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"人身攻击"];
        CSChooseServiceTypeModel *model6 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"无法联系"];
   
        _dataArray = [NSMutableArray arrayWithObjects:model1, model2, model3, model4, model5, model6, nil];
    }
    return _dataArray;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray new];
    }
    return _selectArray;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [AFHTTPSessionManager manager];
     self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 自定义控件初始化
    [self setupSubViews];
    
    // 初始化数据模型
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}
#pragma mark - 初始化方法
/**
 *  自定义控件初始化
 */
- (void)setupSubViews {
    
    //    [self setupTitle];
    self.navigationItem.title = @"选择举报原因";
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
//    //    [self setupTitle];
//    UIColor *color = [UIColor blackColor];
//    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
//    UIView *statuView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
//    statuView.backgroundColor = [UIColor blackColor];
//    [self.navigationController.navigationBar addSubview:statuView];
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.shadowImage=[UIImage new];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarMetrics:0];
//    
//    
//    self.navigationController.navigationBar.titleTextAttributes = dict;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickAction)];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [sureButton setTitle:@"确认举报" forState:(UIControlStateNormal)];
    [sureButton setFrame:CGRectMake(20, 50 * kHeightScale * 6 + 30, self.view.bounds.size.width - 40, 50)];
    [sureButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [sureButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    
    [sureButton addTarget:self action:@selector(rightBarButtonClickAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIView *labelBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 * kHeightScale * 6 + 30 + 64, 230, 20)];
    labelBackView.backgroundColor = [UIColor whiteColor];
    
    
    
    UILabel *kefuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 125, 20)];
    UILabel *phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 0, 115, 20)];
    UIFont *font1 = [UIFont systemFontOfSize:11];
    kefuLabel.font = font1;
    phoneNumberLabel.font = font1;
    
    kefuLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    phoneNumberLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    kefuLabel.text = @"资芽网全国服务热线";
    phoneNumberLabel.text = @"400-898-8557";
    
    [UILabel setFontDistanceWithLabel:kefuLabel Font:font1];
    [UILabel setFontDistanceWithLabel:phoneNumberLabel Font:font1];
    
    
    [labelBackView addSubview:kefuLabel];
    [labelBackView addSubview:phoneNumberLabel];
    
    labelBackView.centerX = self.view.centerX;
    
    [self.view addSubview:labelBackView];
    
    [self.view addSubview:sureButton];
    
}
/**
 *  初始化数据模型
 */
- (void)initData {
    
}

#pragma mark - 事件监听方法
- (void)rightBarButtonClickAction {
    
    NSString *string = [NSString string];
    NSMutableArray *TypeIDArray = [NSMutableArray new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *TypeString = [NSString string];
    
    
    //    if (self.selectArray.count > 3) {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"类型选择不能超过3个，请重新选择" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //        [alert show];
    //    }
    //    else
    //    {
    //    if (self.selectArray.count == 0)
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    
    
    
    for (CSChooseServiceTypeModel *model in self.selectArray) {
        if ([model.title isEqualToString:@"已合作或已处置"] || [model.title isEqualToString:@"服务方描述与事实不符"])
         {
            [TypeIDArray addObject:@"1"];
        }
        else if([model.title isEqualToString:@"虚假信息"])
        {
            [TypeIDArray addObject:@"2"];
        }
        else if ([model.title isEqualToString:@"泄露私密"]) {
            [TypeIDArray addObject:@"3"];
        }
        else if([model.title isEqualToString:@"垃圾广告"])
        {
            [TypeIDArray addObject:@"4"];
        }
        else if([model.title isEqualToString:@"人身攻击"])
        {
            [TypeIDArray addObject:@"5"];
        }
        else if([model.title isEqualToString:@"无法联系"])
        {
            [TypeIDArray addObject:@"6"];
        }
    }

    for (NSString *str in TypeIDArray) {
        string = [string stringByAppendingFormat:@",%@",str];
        NSLog(@"输出的类型的ID为%@",string);
    }
    
//    if (self.selectArray.count != 0) {
//        for (CSChooseServiceTypeModel *model in self.selectArray) {
//            TypeString = [TypeString stringByAppendingFormat:@" %@",model.title];
//        }
//        [defaults setObject:TypeString forKey:@"服务的类型"];
//    }
    
    //    string = [string stringByAppendingFormat:@",%@", model.title];
    if ([string isEqualToString:@""]==NO) {
        string = [string substringFromIndex:1];
//       [defaults setObject:string forKey:@"服务类型"];
    }
    
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择举报原因" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSLog(@"输出的类型的ID为%@",string);
   
    NSString *getURL = TipURL;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token != nil) {
        getURL = [[getURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:string forKey:@"ReasonID"];
    [dic setObject:self.ItemID forKey:@"ItemID"];
    [dic setObject:self.Type forKey:@"Type"];
    [dic setObject:@"IOS" forKey:@"Channel"];

    [self.manager POST:getURL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status_code"] isEqualToString:@"200"])
        {
        [self showAlertViewControllerWithMessage:@"客服人员将尽快进行处理"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"举报失败" message:@"举报失败，请稍后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
    
    
    
    
    //    }
}

- (void)showAlertViewControllerWithMessage:(NSString *)str
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"举报成功！" message:str preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [alertVC addAction:alertAction];
    [self presentViewController:alertVC animated:YES completion:nil];
   
}

#pragma mark - 实现代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CSChooseServiceTypeCell";
    CSChooseServiceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CSChooseServiceTypeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CSChooseServiceTypeModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSChooseServiceTypeModel *model = self.dataArray[indexPath.row];
    
    if (model.chooseStatue) {
        [self.selectArray removeObject:model];
    } else {
        [self.selectArray addObject:model];
    }
    model.chooseStatue = !model.chooseStatue;
    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 * kHeightScale;
}
#pragma mark - 其他方法
- (void)setupTitle {
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"服务类型";
    self.navigationItem.titleView = title;
    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickAction)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


@end
