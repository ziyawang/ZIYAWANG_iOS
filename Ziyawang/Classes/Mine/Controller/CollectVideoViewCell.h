//
//  CollectVideoViewCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"
@interface CollectVideoViewCell : UITableViewCell
@property (nonatomic,strong) CollectModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *videoDes;

@end
