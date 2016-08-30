//
//  CollectServiceViewCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"
@interface CollectServiceViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commanyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuwudiqu;
@property (weak, nonatomic) IBOutlet UILabel *fuwuleixing;
@property (weak, nonatomic) IBOutlet UILabel *serviceProArea;
@property (weak, nonatomic) IBOutlet UILabel *serviceType;
@property (nonatomic,strong) CollectModel *model;


@end
