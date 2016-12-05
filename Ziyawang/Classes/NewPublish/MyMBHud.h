//
//  MyMBHud.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMBHud : NSObject
+ (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode target:(id)target;



@end
