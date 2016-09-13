//
//  PassWordCheck.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/13.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PassWordCheck.h"

@implementation PassWordCheck
+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}
@end
