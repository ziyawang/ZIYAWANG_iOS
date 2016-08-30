//
//  PublishCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/23.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishModel.h"
@interface PublishCell : UITableViewCell

@property (nonatomic,strong) NSString *TypeName;
@property (nonatomic,strong) PublishModel *model;

@end
