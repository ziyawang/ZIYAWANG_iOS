//
//  talkViewController.m
//  RongCloudDemo
//
//  Created by Mr.Xu on 16/7/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "talkViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <UMMobClick/MobClick.h>
@interface talkViewController ()<RCIMClientReceiveMessageDelegate>

@end

@implementation talkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    RCConversationViewController *chatVC = [[RCConversationViewController alloc]init];
//    chatVC.conversationType =  ConversationType_PRIVATE;
//    chatVC.targetId = @"444";
//    chatVC.title = @"哈哈哈";
//    [self.navigationController pushViewController:chatVC animated:YES];
    //是否显示聊天者的名字
    self.displayUserNameInCell = YES;
//     [RCIM sharedRCIM].userInfoDataSource = self;
    
    NSLog(@"%@", self.conversationDataRepository);
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Page123"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Page123"];
}

- (void)didTapCellPortrait:(NSString *)userId
{
    
    NSLog(@"＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃点击了用户的头像");
    NSLog(@"%@",userId);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName
{
    
    NSLog(@"%@",message);
    NSLog(@"%@",senderName);
    return YES;

}


@end

