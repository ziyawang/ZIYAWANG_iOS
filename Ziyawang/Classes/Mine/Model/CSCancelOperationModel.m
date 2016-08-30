//
//  CSCancelOperationModel.m
//  Ziyawang
//
//  Created by 崔丰帅 on 16/8/9.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CSCancelOperationModel.h"

@implementation CSCancelOperationModel
- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
        _chooseStatue = NO;
    }
    return self;
}

@end
