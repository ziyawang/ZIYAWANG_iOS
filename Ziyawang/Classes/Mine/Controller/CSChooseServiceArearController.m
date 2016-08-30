//
//  CSChooseServiceArearController.m
//  Ziyawang
//
//  Created by 崔丰帅 on 16/8/10.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CSChooseServiceArearController.h"
#import "UIView+Extension.h"

#define kWidthScale ([UIScreen mainScreen].bounds.size.width/414)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/736)

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kTotalColumns 3
#define kMarginWidth 30
#define kMarginHeight 10
@interface CSChooseServiceArearController ()
@property (nonatomic, strong) NSArray *cityArray;

@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation CSChooseServiceArearController

#pragma mark - 懒加载

- (NSArray *)cityArray {
    if (!_cityArray) {
        _cityArray = @[@"全国", @"北京", @"上海", @"广东", @"江苏", @"山东", @"浙江", @"河南", @"河北", @"辽宁", @"四川", @"湖北", @"湖南", @"福建", @"安徽", @"陕西", @"天津", @"江西", @"广西", @"重庆", @"吉林", @"云南", @"山西", @"新疆", @"贵州", @"甘肃", @"海南", @"宁夏", @"青海", @"西藏", @"黑龙江", @"内蒙古"];
    }
    return _cityArray;
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
    
    [self setupTitle];
    
    [self setupButtonView];
}
/**
 *  初始化数据模型
 */
- (void)initData {
    
}

#pragma mark - 事件监听方法
/**
 *  保存按钮
 */
- (void)rightBarButtonClickAction {
    NSString *string = [NSString string];
    
    
    
    if (self.selectArray.count > 5) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"地区选择不能超过5个，请重新选择" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    else
    {
    
    for (NSString *title in self.selectArray) {
        if ([title isEqualToString:@"全国"]) {
            string = @" 全国";
        }
      else
      {
        string = [string stringByAppendingFormat:@" %@", title];
      }
        
    }
        
        
        
    string = [string substringFromIndex:1];
    NSLog(@"!!!!!!!!!!!!!%@",string);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.selectArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择服务地区" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
    [defaults setObject:string forKey:@"服务地区"];
    [self.navigationController popViewControllerAnimated:YES];
    }
    }
}

- (void)cityButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.selectArray addObject:sender.titleLabel.text];
    } else {
        [self.selectArray removeObject:sender.titleLabel.text];
    }
    
}

#pragma mark - 实现代理方法


#pragma mark - 其他方法
- (void)setupTitle {
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"服务地区";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickAction)];
}

- (void)setupButtonView {
    
    CGFloat viewWidth = kScreenWidth - 20 * kWidthScale;
    
    CGFloat W = (viewWidth - kMarginWidth * (kTotalColumns - 1)) / kTotalColumns;
    CGFloat H = 40 * kHeightScale;
    
    for (int index = 0; index < self.cityArray.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
//        button.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0];
        
        int row = index / kTotalColumns;
        int col = index % kTotalColumns;
        
        CGFloat viewX = 10 * kWidthScale + col * (W + kMarginWidth);
        CGFloat viewY = kMarginHeight + row * (H + kMarginHeight);
        
        button.frame = CGRectMake(viewX, viewY, W, H);
        
        button.layer.cornerRadius = 1;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0].CGColor;
        [button setTitle:self.cityArray[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];

        button.imageEdgeInsets = UIEdgeInsetsMake(0, 90 * kWidthScale, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30 * kWidthScale);
        
        [button addTarget:self action:@selector(cityButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    
}
@end
