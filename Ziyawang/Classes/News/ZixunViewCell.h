//
//  ZixunViewCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/10/31.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
@interface ZixunViewCell : UITableViewCell
@property (nonatomic,strong) NewsModel *model;
+ (NSString *)getDateWithString:(NSString *)date;

@end
