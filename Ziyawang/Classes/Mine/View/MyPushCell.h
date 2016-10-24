//
//  MyPushCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/10/20.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishModel.h"
@interface MyPushCell : UITableViewCell
@property (nonatomic,strong) NSString *TypeName;
@property (nonatomic,strong) PublishModel *model;
@end
