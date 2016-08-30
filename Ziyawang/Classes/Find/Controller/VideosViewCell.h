//
//  VideosViewCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/10.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideosModel.h"
@interface VideosViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *VideoImageView;
@property (weak, nonatomic) IBOutlet UILabel *ViedoDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *VideoCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *pinglunButton;
@property (weak, nonatomic) IBOutlet UILabel *pinglunCountLable;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic,strong) VideosModel *model;


@end
