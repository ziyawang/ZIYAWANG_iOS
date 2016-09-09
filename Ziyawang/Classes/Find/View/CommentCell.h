//
//  CommentCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/12.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic,strong) CommentModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
