//
//  ChooseServiceViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/30.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ChooseServiceViewController.h"
#import "CSChooseServiceTypeCell.h"
#import "CSChooseServiceTypeModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ChooseServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation ChooseServiceViewController
#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        
        CSChooseServiceTypeModel *model1 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"收购资产包"];
        CSChooseServiceTypeModel *model2 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"委外催收"];
        CSChooseServiceTypeModel *model3 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"法律服务"];
        CSChooseServiceTypeModel *model4 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"保理公司"];
        CSChooseServiceTypeModel *model5 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"投融资服务"];
        CSChooseServiceTypeModel *model6 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"尽职调查"];
        CSChooseServiceTypeModel *model7 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"典当公司"];
        CSChooseServiceTypeModel *model8 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"担保公司"];
        CSChooseServiceTypeModel *model9 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"收购固产"];
        CSChooseServiceTypeModel *model10 = [[CSChooseServiceTypeModel alloc] initWithTitle:@"债权收购"];
        _dataArray = [NSMutableArray arrayWithObjects:model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, nil];
    }
    return _dataArray;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray new];
    }
    return _selectArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50 * kHeightScale * 10) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
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
    self.navigationItem.title = @"服务类型";
    
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
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickAction)];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton *sureButton = [UIButton new];
    [self.view addSubview:sureButton];
    sureButton.sd_layout.leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,20)
    .bottomSpaceToView(self.view,20)
    .heightIs(50 * kHeightScale);
    [sureButton setTitle:@"确认" forState:(UIControlStateNormal)];
    [sureButton addTarget:self action:@selector(didClickSureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [sureButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [sureButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    
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
        if ([model.title isEqualToString:@"资产包收购"])
        {
            [TypeIDArray addObject:@"01"];
            
        }
        else if([model.title isEqualToString:@"催收机构"])
        {
            [TypeIDArray addObject:@"02"];
        }
        if ([model.title isEqualToString:@"律师事务所"]) {
            [TypeIDArray addObject:@"03"];
            
        }
        else if([model.title isEqualToString:@"保理公司"])
        {
            [TypeIDArray addObject:@"04"];
        }
        else if([model.title isEqualToString:@"担保公司"])
        {
            [TypeIDArray addObject:@"05"];
        }
        else if([model.title isEqualToString:@"典当公司"])
        {
            [TypeIDArray addObject:@"05"];
        }
        else if([model.title isEqualToString:@"投融资服务"])
        {
            [TypeIDArray addObject:@"06"];
        }
        
        else if([model.title isEqualToString:@"尽职调查"])
        {
            [TypeIDArray addObject:@"10"];
        }
        else if([model.title isEqualToString:@"债权收购"])
        {
            [TypeIDArray addObject:@"14"];
        }
        else if([model.title isEqualToString:@"资产收购"])
        {
            [TypeIDArray addObject:@"12"];
        }
    }
    
    
    for (NSString *str in TypeIDArray) {
        
        string = [string stringByAppendingFormat:@",%@",str];
        NSLog(@"输出的类型的ID为%@",string);
    }
    
    if (self.selectArray.count != 0) {
        for (CSChooseServiceTypeModel *model in self.selectArray) {
            TypeString = [TypeString stringByAppendingFormat:@" %@",model.title];
        }
        [defaults setObject:TypeString forKey:@"服务的类型"];
    }
    
    
    
    //    string = [string stringByAppendingFormat:@",%@", model.title];
    if ([string isEqualToString:@""]==NO) {
        string = [string substringFromIndex:1];
        [defaults setObject:string forKey:@"服务类型"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择类型" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    NSLog(@"输出的类型的ID为%@",string);
    //    }
}

- (void)didClickSureButtonAction:(UIButton *)button
{
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
        if ([model.title isEqualToString:@"收购资产包"])
        {
            [TypeIDArray addObject:@"01"];
            
        }
        else if([model.title isEqualToString:@"委外催收"])
        {
            [TypeIDArray addObject:@"02"];
        }
        if ([model.title isEqualToString:@"法律服务"]) {
            [TypeIDArray addObject:@"03"];
            
        }
        else if([model.title isEqualToString:@"保理公司"])
        {
            [TypeIDArray addObject:@"04"];
        }
        else if([model.title isEqualToString:@"担保公司"])
        {
            [TypeIDArray addObject:@"05"];
        }
        else if([model.title isEqualToString:@"典当公司"])
        {
            [TypeIDArray addObject:@"05"];
        }
        else if([model.title isEqualToString:@"投融资服务"])
        {
            [TypeIDArray addObject:@"06"];
        }
        
        else if([model.title isEqualToString:@"尽职调查"])
        {
            [TypeIDArray addObject:@"10"];
        }
        else if([model.title isEqualToString:@"债权收购"])
        {
            [TypeIDArray addObject:@"14"];
        }
        else if([model.title isEqualToString:@"收购固产"])
        {
            [TypeIDArray addObject:@"12"];
        }
    }
    
    
    for (NSString *str in TypeIDArray) {
        
        string = [string stringByAppendingFormat:@",%@",str];
        NSLog(@"输出的类型的ID为%@",string);
    }
    
    if (self.selectArray.count != 0) {
        for (CSChooseServiceTypeModel *model in self.selectArray) {
            TypeString = [TypeString stringByAppendingFormat:@" %@",model.title];
        }
        [defaults setObject:TypeString forKey:@"服务的类型"];
    }
    
    
    NSLog(@"%@",string);
    
    //    string = [string stringByAppendingFormat:@",%@", model.title];
    if ([string isEqualToString:@""]==NO) {
        string = [string substringFromIndex:1];
        [defaults setObject:string forKey:@"服务类型"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择类型" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    NSLog(@"输出的类型的ID为%@",string);
    
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
