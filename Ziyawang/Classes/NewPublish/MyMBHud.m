//
//  MyMBHud.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "MyMBHud.h"

@interface MyMBHud ()<MBProgressHUDDelegate>

@end

@implementation MyMBHud

+ (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode target:(id)target

{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication]keyWindow] animated:YES];
    HUD.delegate = target;
    HUD.mode = mode;
    HUD.labelText = lableText;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hideAnimated:YES afterDelay:timer];
    
}
@end
