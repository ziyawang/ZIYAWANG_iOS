//
//  LBTabBarController.m
//  XianYu
//
//  Created by Mr.Xuon 16/5/28.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "LBTabBarController.h"
#import "LBNavigationController.h"

//#import "LBFishViewController.h"
//#import "LBHomeViewController.h"
//#import "LBMineViewController.h"
//#import "LBpostViewController.h"
//#import "LBMessageViewController.h"
#import "PushController.h"
#import "PushViewController.h"
#import "FindController.h"
#import "MineViewController.h"
#import "ZiyaMainController.h"
#import "UserCenterController.h"
#import "NewsController.h"
#import "talkViewController.h"
#import "MessageListViewController.h"
#import "LBTabBar.h"
#import "UIImage+Image.h"
#import "UITabBar+CustomBadge.h"

@interface LBTabBarController ()<LBTabBarDelegate,RCIMReceiveMessageDelegate>
@property (nonatomic,strong) UserCenterController *userCenterVC;

@end

@implementation LBTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题


//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return [self.viewControllers.lastObject supportedInterfaceOrientations];
//}
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
//}


- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    NSInteger unreadcount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    //        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",left]];
    //    [[[[[self tabBarController]tabBar]items]objectAtIndex:3]setBadgeValue:[NSString stringWithFormat:@"%ld",unreadcount]];
    
    //    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:3];
    //
    //    item.badgeValue = [NSString stringWithFormat:@"%ld",unreadcount];
    
    [self.userCenterVC.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",unreadcount]];
    
    //    NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
    //    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:3];
    //    personCenterTabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",unreadcount];//显示消息条数为 2
    
    NSLog(@"%ld",unreadcount);
    
    //    [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%d",left];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [RCIM sharedRCIM].receiveMessageDelegate=self;

    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification2:)
     name:RCKitDispatchMessageNotification
     object:nil];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:RCKitDispatchMessageNotification
     object:nil];
}
- (void)didReceiveMessageNotification2:(NSNotification *)notification {
    RCMessage *message = notification.object;
    
//    [[self.tabBar.items objectAtIndex:2] setBadgeValue:@"3"];
//    [self.tabBar setTabIconWidth:0];
//    [self.tabBar setBadgeTop:0];
//    [self.tabBar setBadgeStyle:kCustomBadgeStyleNumber value:3 atIndex:2];
//    
    
//    if (message.messageDirection == MessageDirection_RECEIVE) {
//     
//                UITabBarItem *item = [self.tabBar.items objectAtIndex:2];
//        //        item.badgeValue = nil;
//                item.badgeValue = [NSString stringWithFormat:@"%d",[item.badgeValue intValue] + 1];
//    }
}

- (BOOL)shouldAutorotate
{
    return self.viewControllers.lastObject.shouldAutorotate;
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

+ (void)initialize
{
    
//    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#FDCA00"];
    
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];

//    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
//    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    [[UITabBarItem appearance]setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
}


- (void)viewDidLoad {
    [super viewDidLoad];

//    [RCIM sharedRCIM].receiveMessageDelegate=self;

    [self setUpAllChildVc];

    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    LBTabBar *tabbar = [[LBTabBar alloc] init];

    
    NSLog(@"%@",tabbar.items);
    
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
}


#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{
//#import "PushViewController.h"
//#import "FindController.h"
//#import "MineViewController.h"
//#import "ZiyaMainController.h"
//    
//#import "talkViewController.h"
//#import "MessageListViewController.h"
    ZiyaMainController *MainVC = [[ZiyaMainController alloc]init];
    
    FindController *FindVC = [[FindController alloc]init];
    MessageListViewController *MessageVC = [[MessageListViewController alloc]init];

    MineViewController *MineVC = [UIStoryboard storyboardWithName:@"Mine" bundle:nil].instantiateInitialViewController;
    
     self.userCenterVC = [[UserCenterController alloc]initWithNibName:@"UserCenterController" bundle:nil];
    
    NewsController *newsVC = [[NewsController alloc]init];
    

    
    [self setUpOneChildVcWithVc:MainVC Image:@"shouye" selectedImage:@"shouye-xuanzhong" title:@"首页"];
    [self setUpOneChildVcWithVc:FindVC Image:@"chakan" selectedImage:@"chakan-xuanzhong" title:@"查看"];
    [self setUpOneChildVcWithVc:newsVC Image:@"zixuntab" selectedImage:@"zixunxuanzhong" title:@"资讯"];
//    [self setUpOneChildVcWithVc:MineVC Image:@"wode" selectedImage:@"wode-xuanzhong" title:@"我的"];
    [self setUpOneChildVcWithVc:self.userCenterVC Image:@"wode" selectedImage:@"wode-xuanzhong" title:@"我的"];

    
    //    LBHomeViewController *HomeVC = [[LBHomeViewController alloc] init];
//    [self setUpOneChildVcWithVc:HomeVC Image:@"home_normal" selectedImage:@"home_highlight" title:@"首页"];
//
//    LBFishViewController *FishVC = [[LBFishViewController alloc] init];
//    [self setUpOneChildVcWithVc:FishVC Image:@"fish_normal" selectedImage:@"fish_highlight" title:@"鱼塘"];
//
//    LBMessageViewController *MessageVC = [[LBMessageViewController alloc] init];
//    [self setUpOneChildVcWithVc:MessageVC Image:@"message_normal" selectedImage:@"message_highlight" title:@"消息"];
//
//    LBMineViewController *MineVC = [[LBMineViewController alloc] init];
//    [self setUpOneChildVcWithVc:MineVC Image:@"account_normal" selectedImage:@"account_highlight" title:@"我的"];
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    LBNavigationController *nav = [[LBNavigationController alloc] initWithRootViewController:Vc];

    Vc.view.backgroundColor = [UIColor whiteColor];

    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
//    if ([[Vc class] isEqual:[UserCenterController class]]) {
//        [Vc.tabBarItem setBadgeValue:@"2"];
//        
//        
//    }
    
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
//    Vc.navigationItem.title = title;
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"-----------%@",item);

}



#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{
        PushViewController *PushVC = [[PushViewController alloc]init];
        LBNavigationController *navVc = [[LBNavigationController alloc] initWithRootViewController:PushVC];
//    [self presentViewController:navVc animated:YES completion:^{
//        [self setHidesBottomBarWhenPushed:NO]
//    }]
    [self presentViewController:navVc animated:YES completion:nil];

//    LBpostViewController *plusVC = [[LBpostViewController alloc] init];
//    plusVC.view.backgroundColor = [self randomColor];

}


- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

}

@end
