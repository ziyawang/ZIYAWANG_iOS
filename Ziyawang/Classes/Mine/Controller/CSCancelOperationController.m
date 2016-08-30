
//
//  CSCancelOperationController.m
//  Ziyawang
//
//  Created by 崔丰帅 on 16/8/9.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CSCancelOperationController.h"
#import "UIView+Extension.h"
#import "CSCancelOperationCell.h"
#import "CSCancelOperationModel.h"
#import "CSTextView.h"

#import "CSChooseServiceArearController.h"

#define kWidthScale ([UIScreen mainScreen].bounds.size.width/414)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/736)

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface CSCancelOperationController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
/** 上次点击 */
@property (nonatomic, assign) NSInteger lastSelect;

@property (nonatomic, strong) CSTextView *textView;

@property (nonatomic,strong) AFHTTPSessionManager *manager;


@end

@implementation CSCancelOperationController

#pragma mark - 懒加载

- (void)viewWillAppear:(BOOL)animated
{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        
        CSCancelOperationModel *model1 = [[CSCancelOperationModel alloc] initWithTitle:@"与双方协商达成一致"];
        CSCancelOperationModel *model2 = [[CSCancelOperationModel alloc] initWithTitle:@"临时有事，无法参加"];
        CSCancelOperationModel *model3 = [[CSCancelOperationModel alloc] initWithTitle:@"不小心点错了，重新进行合作"];
        CSCancelOperationModel *model4 = [[CSCancelOperationModel alloc] initWithTitle:@"不想合作了"];
        
        _dataArray = [NSMutableArray arrayWithObjects:model1, model2, model3, model4, nil];
    }
    return _dataArray;
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textView resignFirstResponder];
}

#pragma mark - 初始化方法
/**
 *  自定义控件初始化
 */
- (void)setupSubViews {
    
    [self setupTitle];
    
    [self setupTableView];
    
    [self setupTextView];
    
    [self setupUploadButton];
}
/**
 *  初始化数据模型
 */
- (void)initData {
    
}

#pragma mark - 事件监听方法
- (void)uploadBtnClickAction:(UIButton *)sender {
    NSLog(@"点击取消按钮取消合作");
//    CSCancelOperationModel *newModel = self.dataArray.lastObject;
//    NSLog(@"------%@",newModel.title);
//    self.manager POST:<#(nonnull NSString *)#> parameters:<#(nullable id)#> progress:<#^(NSProgress * _Nonnull uploadProgress)uploadProgress#> success:<#^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)success#> failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#>
//    
    
}

#pragma mark - 实现代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CSCancelOperationCell";
    CSCancelOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CSCancelOperationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    CSCancelOperationModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_textView resignFirstResponder];
    
    if (indexPath.row != _lastSelect) {
        CSCancelOperationModel *newModel = self.dataArray[indexPath.row];
        newModel.chooseStatue = !newModel.chooseStatue;
        
        CSCancelOperationModel *lastModel = self.dataArray[_lastSelect];
        if (lastModel.chooseStatue) {
            lastModel.chooseStatue = NO;
        }
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newModel];
        [self.dataArray replaceObjectAtIndex:_lastSelect withObject:lastModel];
    } else {
        CSCancelOperationModel *newModel = self.dataArray[indexPath.row];
        newModel.chooseStatue = !newModel.chooseStatue;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newModel];
    }
    _lastSelect = indexPath.row;
    
    [_tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 * kHeightScale;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    for (CSCancelOperationModel *model in self.dataArray) {
        if (model.chooseStatue) {
            model.chooseStatue = NO;
        }
    }
    
    [_tableView reloadData];
    
    return YES;
}

#pragma mark - 其他方法
- (void)setupTitle {
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"取消原因";
    self.navigationItem.titleView = title;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)setupTableView {
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.frame = CGRectMake(0, 0, self.view.width, 200 * kHeightScale);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (void)setupTextView {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, 220 *kHeightScale, kScreenWidth, 150* kHeightScale);
    [self.view addSubview:backView];
    _textView = [[CSTextView alloc] init];
    _textView.delegate = self;
    _textView.frame = CGRectMake(10 * kWidthScale, 0, self.view.bounds.size.width - 20 *kWidthScale, 150 * kHeightScale);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.placeholder = @"输入其他原因...";
    _textView.font = [UIFont systemFontOfSize:18];
    _textView.placeholerColor = [UIColor lightGrayColor];
    [backView addSubview:_textView];
    
}


- (void)setupUploadButton {
    
    UIButton *uploadBtn = [[UIButton alloc] init];
    uploadBtn.frame = CGRectMake(20 * kWidthScale, kScreenHeight - 64 - 60 * kHeightScale, kScreenWidth - 40 * kWidthScale, 40 * kHeightScale);
    uploadBtn.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:206.0 / 255.0 blue:83.0 / 255.0 alpha:1.0];
    [uploadBtn setTitle:@"提交" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];
}

@end
