//
//  ChooseAreaController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ChooseAreaController.h"
#import "MoreMenuView.h"
#import "PushStartController.h"
@interface ChooseAreaController ()
@property (nonatomic,strong) NSMutableArray *shengArray;

@property (nonatomic,strong) NSMutableArray *shiArray;


@property (nonatomic,strong) NSMutableArray *allshiArray;

@property (nonatomic,strong) NSString *chooseArea;
@end

@implementation ChooseAreaController

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
- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择地区";
    self.view.backgroundColor = [UIColor whiteColor];
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];

    [self setHeadView];
}


- (void)setHeadView
{
    NSArray *titles = @[@"点击选择地区"];
    MoreMenuView *menuView = [[MoreMenuView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 45) titles:titles];
    menuView.cornerMarkLocationType = CornerMarkLocationTypeRight;
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    [self.view addSubview:menuView];
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
    
 
    menuView.indexsOneFist = self.shengArray;
    menuView.indexsOneSecond = self.allshiArray;
    //    menuView.indexsTwoSecond = self.allshiArray;
    
    __weak typeof(self) weakSelf = self;
    menuView.selectedIndex = ^(NSString *string)
    {
        self.chooseArea = string;
        NSString *str = nil;
        NSString *str2 = nil;
        NSArray *stringArray = [NSArray array];
        for (int i = 0;i<[self.chooseArea length]-1;i++) {
            str = [self.chooseArea substringWithRange:NSMakeRange(i, 1)];
            if ([str isEqualToString:@"省"]) {
                str2=@"省";
            }
            else if([str isEqualToString:@"市"])
            {
                str2 = @"市";
            }
        }
        if ([str2 isEqualToString:@"省"]) {
            stringArray = [self.chooseArea componentsSeparatedByString:str2];
            self.chooseArea = [[[stringArray[0] stringByAppendingString:str2]stringByAppendingString:@"-"]stringByAppendingString:stringArray[1]];
            
            NSLog(@"%@",self.chooseArea);
        }
        else if ([str2 isEqualToString:@"市"]) {
            stringArray = [self.chooseArea componentsSeparatedByString:str2];
            self.chooseArea = [[[stringArray[0] stringByAppendingString:str2]stringByAppendingString:@"-"]stringByAppendingString:stringArray[1]];
        }
        else
        {
            NSString *str1 = [string substringToIndex:2];
            NSString *str2 = [string substringFromIndex:2];
            self.chooseArea = [[str1 stringByAppendingString:@"-"]stringByAppendingString:str2];
        }

        NSLog(@"选择的地区为：%@",self.chooseArea);
//        PushStartController *pushStartVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        if (self.selectCell) {
//            [defaults setObject:self.chooseArea forKey:self.selectCell];
//        }
//        else
//        {
        
        if (self.chooseArea != nil) {
            if ([self.type isEqualToString:@"信息"]) {
                 [defaults setObject:self.chooseArea forKey:@"企业所在"];
                [defaults setObject:self.chooseArea forKey:self.selectCell];
            }
            else
            {
            [defaults setObject:self.chooseArea forKey:@"企业地区"];
            }
            
        }

//        }
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    };
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
