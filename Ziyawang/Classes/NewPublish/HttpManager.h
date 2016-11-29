//
//  HttpManager.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HttpManager : NSObject
+(HttpManager *)httpManager;
- (void)postDataWithURL:(NSString *)URL ImageArray:(NSMutableArray *)imageArray audioURL:(NSURL *)url param:(NSMutableDictionary *)param;


@end
