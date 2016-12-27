//
//  AlertView.m
//  PropertyPayMent
//
//  Created by Mr.Xu on 2016/11/16.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView
+(void)showAlertWithMessage:(NSString *)message target:(id)target
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:target cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
@end
