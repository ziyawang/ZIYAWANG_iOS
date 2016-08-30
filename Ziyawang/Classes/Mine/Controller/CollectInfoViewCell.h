//
//  CollectInfoViewCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"
@interface CollectInfoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *diquLabel;
@property (weak, nonatomic) IBOutlet UILabel *proAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *wenziLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordDesLabel;
@property (nonatomic,strong) CollectModel *model;
@end
