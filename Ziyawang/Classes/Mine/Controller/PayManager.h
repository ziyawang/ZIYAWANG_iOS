//
//  PayManager.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/27.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayManager : NSObject
+ (void)PayForPruduct:(NSString *)pruduct WithURL:(NSString *)url param:(NSMutableDictionary *)param;


@end
