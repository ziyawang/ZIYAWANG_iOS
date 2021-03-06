//
//  FindController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/3.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FindController.h"
#import "SDVersion.h"
#import "SDiOSVersion.h"
#import "FindServicesController.h"
#import "FindInfoController.h"
#import "FindVideoController.h"
#import "VideosListController.h"


#define kWidthScale ([UIScreen mainScreen].bounds.size.width/375)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/667)

@interface FindController ()


@end

@implementation FindController
- (void)tabBarBadgeValueNotiFication:(NSNotification *)sender
{
    NSString *value = sender.userInfo[@"BadgeValue"];
    NSLog(@"%@",value);
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
    [item setValue:value forKeyPath:@"badgeValue"];
    //    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    view.backgroundColor = [UIColor redColor];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    //    label.text = @"12";
    //    label.textColor = [UIColor whiteColor];
    //    label.font = [UIFont systemFontOfSize:10];
    //
    //    [self.tabBarController.tabBar addSubview:view];
    //    [self.tabBarController.tabBar addSubview:label];
    
    
    //    item.badgeValue = value;
    //    item.badgeValue = @"2";
    
    //    item.badgeColor = [UIColor redColor];
    
    
    NSLog(@"%@",sender.userInfo[@"BadgeValue"]);
    
    //    [self.tabBarItem setBadgeValue:@"2"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    NSInteger unreadcount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    NSString *unreadStr = [NSString stringWithFormat:@"%ld",unreadcount];
    
    
    if (unreadcount == 99 || unreadcount>99) {
        unreadStr = @"99+";
    }
    if (unreadcount == 0 || unreadcount < 0) {
        unreadStr = nil;
        
    }
    [[[[[self tabBarController]tabBar]items]objectAtIndex:3]setBadgeValue:unreadStr];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarBadgeValueNotiFication:) name:@"tabBarBadgeValueNotifi" object:nil];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查看";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    UIButton *button3 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self getViewHight])];
    imageview.image = [UIImage imageNamed:@"tu"];
    [self.view addSubview:imageview];
    
    button.backgroundColor = [UIColor whiteColor];
    button2.backgroundColor = [UIColor whiteColor];
    button3.backgroundColor = [UIColor whiteColor];
//    
//    [button setTitle:@"找信息" forState:(UIControlStateNormal)];
//    [button2 setTitle:@"找服务" forState:(UIControlStateNormal)];
//    [button3 setTitle:@"找视频" forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(0, 15 + [self getViewHight], self.view.bounds.size.width - 20, [self getViewHight])];
    [button2 setFrame:CGRectMake(20, 35+ [self getViewHight]*2 , self.view.bounds.size.width - 20, [self getViewHight])];
    [button3 setFrame:CGRectMake(0, [self getViewHight] * 3 +55, self.view.bounds.size.width - 20, [self getViewHight])];
    
    //    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, 100, 30)];
//    lable1.text = @"找信息";
//    [button addSubview:lable1];
    
//  UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(button2.frame.origin.x, button2.frame.origin.y, 100, 30)];
//    lable2.text = @"找服务";
//    [button addSubview:lable2];
//      UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(button3.frame.origin.x, button3.frame.origin.y, 100, 30)];
//    lable3.text = @"找视频";
//    [button addSubview:lable3];
    UILabel *labe1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
    UILabel *labe2 = [[UILabel alloc]initWithFrame:CGRectMake(button2.bounds.size.width - 110, 20, 30, 30)];
    UILabel *labe3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
    labe1.text = @"找";
    labe2.text = @"找";
    labe3.text = @"找";
    
    labe1.textColor = [UIColor colorWithHexString:@"#d25852"];
    labe2.textColor = [UIColor colorWithHexString:@"#2d9cad"];
    labe3.textColor = [UIColor colorWithHexString:@"#b67630"];
    
    labe1.font = [UIFont systemFontOfSize:30];
    labe2.font = [UIFont systemFontOfSize:30];
    labe3.font = [UIFont systemFontOfSize:30];
    
    labe1.font = [UIFont boldSystemFontOfSize:30];
    labe2.font = [UIFont boldSystemFontOfSize:30];
    labe3.font = [UIFont boldSystemFontOfSize:30];
    
    [button addSubview:labe1];
    [button2 addSubview:labe2];
    [button3 addSubview:labe3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 30)];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 30)];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(button2.bounds.size.width - 120, 20, 100, 30)];
    label2.textAlignment = NSTextAlignmentRight;
    
    
    label1.text = @"信息";
    label1.textColor = [UIColor colorWithHexString:@"#d25852"];
    label2.text = @"服务";
    label2.textColor = [UIColor colorWithHexString:@"#2d9cad"];
    label3.text = @"视频";
    label3.textColor = [UIColor colorWithHexString:@"#b67630"];
    
    
    [button addSubview:label1];
    [button2 addSubview:label2];
    [button3 addSubview:label3];
    
    label1.font = [UIFont systemFontOfSize:30];
    label2.font = [UIFont systemFontOfSize:30];
    label3.font = [UIFont systemFontOfSize:30];

    UILabel *longlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 65 * kHeightScale, self.view.bounds.size.width , 25)];
    UILabel *longlabel2 = [[UILabel alloc]initWithFrame:CGRectMake(button2.bounds.size.width - 240 , 65 * kHeightScale, 220, 25)];
    longlabel2.textAlignment = NSTextAlignmentRight;
    UILabel *longlabel3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 65 * kHeightScale, self.view.bounds.size.width, 25)];
    //适配三套
    
    
    longlabel1.text = @"汇集不良资产和相关需求信息";
    longlabel2.text = @"整合全国各类处置服务机构";
    longlabel3.text = @"热点话题、行业声音、法律常识";
    longlabel1.textColor = [UIColor whiteColor];
    longlabel2.textColor = [UIColor whiteColor];
    longlabel3.textColor = [UIColor whiteColor];

    
    longlabel1.font = [UIFont FontForBigLabel];
    longlabel2.font = [UIFont FontForBigLabel];
    longlabel3.font = [UIFont FontForBigLabel];
    
   
    [button addSubview:longlabel1];
    [button2 addSubview:longlabel2];
    [button3 addSubview:longlabel3];
    
    
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button3 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [button setBackgroundImage:[UIImage imageNamed:@"zhaoxinxi"] forState:(UIControlStateNormal)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"zhaofuwu"] forState:(UIControlStateNormal)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"zhaoshipin"] forState:(UIControlStateNormal)];
    [button setBackgroundImage:[UIImage imageNamed:@"chakanxuanzhong3"] forState:(UIControlStateHighlighted)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"chakanxuanzhong"] forState:(UIControlStateHighlighted)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"chakanxuanzhong2"] forState:(UIControlStateHighlighted)];
    [self.view addSubview:button];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    
    [button addTarget:self action:@selector(didClickbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    [button2 addTarget:self action:@selector(didClickbutton2:) forControlEvents:(UIControlEventTouchUpInside)];
    [button3 addTarget:self action:@selector(didClickbutton3:) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)didClickbutton:(UIButton *)button
{
    FindInfoController *findInfoVC = [[FindInfoController alloc]init];
    
    [self.navigationController pushViewController:findInfoVC animated:YES];
    
}
- (void)didClickbutton2:(UIButton *)button2
{
    FindServicesController *findServiceVC = [[FindServicesController alloc]init];
    [self.navigationController pushViewController:findServiceVC animated:YES];
}
- (void)didClickbutton3:(UIButton *)button
{
    VideosListController *VideoVC = [[VideosListController alloc]init];
//    [self presentViewController:VideoVC animated:YES completion:nil];
    [self.navigationController pushViewController:VideoVC animated:YES];
}


- (CGFloat )getViewHight
{
    //    self.messageLable.text = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSString *version = DeviceVersionNames[[SDiOSVersion deviceVersion]];
    NSLog(@"%@",version);
    NSLog(@"!!!!!!%@",DeviceVersionNames[[SDiOSVersion deviceVersion]]);
    
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return 95;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7)
    {
        return 120;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 130;
    }
    return 130;
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
