//
//  UIAlertViewShow.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "UIAlertViewShow.h"

@implementation UIAlertViewShow

+ (void)showDismissedAlertDialog:(NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil   //NSLocalizedString(@"错误", nil)
                                                    message:NSLocalizedString(message, nil)
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:alert
                                    repeats:YES];    //弹出框消失倒计时
    
    [alert show];
}

#pragma mark -- 弹出框自动消失  使用倒计时
+ (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = nil;
    
    [theTimer invalidate];//使计时器无效
}

@end
