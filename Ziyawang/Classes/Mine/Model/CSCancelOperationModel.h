//
//  CSCancelOperationModel.h
//  Ziyawang
//
//  Created by 崔丰帅 on 16/8/9.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCancelOperationModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL chooseStatue;

- (instancetype)initWithTitle:(NSString *)title;

@end

