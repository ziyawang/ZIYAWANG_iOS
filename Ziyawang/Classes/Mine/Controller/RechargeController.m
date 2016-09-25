//
//  RechargeController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/24.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "RechargeController.h"

@interface RechargeController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonSix;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsWidth;

@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;


@property (nonatomic,strong) UIImageView *selectedView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.navigationItem.title = @"充值";
    [self setButtonsView];
//    [self setupTitle];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self getYabiType];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)getYabiType
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    
    [self.manager GET:rechargeURL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.dataArray = [NSArray arrayWithArray:dataArray];
        [self addViewToButtonsWithButton:self.buttonOne labelText:dataArray[0][@"RealMoney"] longLabelText:dataArray[0][@"YBCount"] defaultFlag:dataArray[0][@"selected"]];
        [self addViewToButtonsWithButton:self.buttonTwo labelText:dataArray[1][@"RealMoney"] longLabelText:dataArray[1][@"YBCount"] defaultFlag:dataArray[1][@"selected"]];
        [self addViewToButtonsWithButton:self.buttonThree labelText:dataArray[2][@"RealMoney"] longLabelText:dataArray[2][@"YBCount"] defaultFlag:dataArray[2][@"selected"]];
        [self addViewToButtonsWithButton:self.buttonFour labelText:dataArray[3][@"RealMoney"] longLabelText:dataArray[3][@"YBCount"] defaultFlag:dataArray[3][@"selected"]];
        [self addViewToButtonsWithButton:self.buttonFive labelText:dataArray[4][@"RealMoney"] longLabelText:dataArray[4][@"YBCount"] defaultFlag:dataArray[4][@"selected"]];
        [self addViewToButtonsWithButton:self.buttonSix labelText:dataArray[5][@"RealMoney"] longLabelText:dataArray[5][@"YBCount"] defaultFlag:dataArray[5][@"selected"]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    

}
- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = @"充值";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;

    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)setButtonsView
{
    self.selectedView = [[UIImageView alloc]initWithFrame:CGRectMake([self widthForlabel] - [self widthForlabel]/4 +7, [self widthForlabel]/2 - [self widthForlabel]/4+7, [self widthForlabel]/4-10, [self widthForlabel]/4-10)];
    self.selectedView.image = [UIImage imageNamed:@"xuanzeqian"];
    
    self.buttonOne.tag = 0;
    self.buttonTwo.tag = 1;
    self.buttonThree.tag = 2;
    self.buttonFour.tag = 3;
    self.buttonFive.tag = 4;
    self.buttonSix.tag = 5;
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
//    [self addViewToButtonsWithButton:self.buttonOne labelText:@"10芽币" longLabelText:@"优惠价：1元"];
    [self.buttonOne addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonTwo addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonThree addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonFour addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonFive addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonSix addTarget:self action:@selector(buttonsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)addViewToButtonsWithButton:(UIButton *)button labelText:(NSString *)text longLabelText:(NSString *)longText defaultFlag:(NSString *)defaultFlag
{

    defaultFlag = [NSString stringWithFormat:@"%@",defaultFlag];
    if ([defaultFlag isEqualToString:@"1"]) {
        [button addSubview:self.selectedView];
        self.buttonLabel.text = [@"¥"stringByAppendingString:longText];
    }
    [button setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [button setBackgroundImage:[UIImage imageNamed:@"dahuangkuang"] forState:(UIControlStateNormal)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, [self constansForlabel], [self widthForlabel], 15)];
//    label.backgroundColor = [UIColor redColor];
    UILabel *longLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [self constansForlabel2], [self widthForlabel], 11)];
//    longLabel.backgroundColor = [UIColor blueColor];
//    label.centerX = button.centerX;
//    longLabel.centerX = button.centerX;
    
    label.textAlignment = NSTextAlignmentCenter;
    longLabel.textAlignment = NSTextAlignmentCenter;
    
    label.text = [text stringByAppendingString:@"芽币"];
    longLabel.text = [[@"优惠价:"stringByAppendingString:longText]stringByAppendingString:@"元"];
    label.font = [UIFont systemFontOfSize:15];
    longLabel.font = [UIFont systemFontOfSize:10];
    longLabel.textColor = [UIColor grayColor];
    [button addSubview:label];
    [button addSubview:longLabel];
    
    
    
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, button.bounds.size.width, button.bounds.size.height - 5)];
//    imageview.image = [UIImage imageNamed:@"xiaobai"];
//    [button addSubview:imageview];
    
}
- (void)buttonsAction:(UIButton *)button
{
    NSLog(@"%ld",button.tag);
    self.buttonLabel.text =[@"¥"stringByAppendingString:self.dataArray[button.tag][@"YBCount"]];
    
    [button addSubview:self.selectedView];
}
- (CGFloat)widthForlabel
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 91.7;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 110;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 123;
        
    }
    
    return 123;
}

- (CGFloat)constansForlabel
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 7;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 13;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 14;
        
    }
    
    return 10;
}

- (CGFloat)constansForlabel2
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 27;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 33;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 35;
        
    }
    
    return 10;
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
