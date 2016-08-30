//
//  UIAlertViewShow.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertViewShow : NSObject
+ (void)showDismissedAlertDialog:(NSString*)message;
+ (void)timerFireMethod:(NSTimer*)theTimer;//弹出框
@end
