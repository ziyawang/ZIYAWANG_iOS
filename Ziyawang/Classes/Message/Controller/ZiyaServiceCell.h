//
//  ZiyaServiceCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/20.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiyaServiceModel.h"
@interface ZiyaServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *xitongImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) ZiyaServiceModel *model;

@end
