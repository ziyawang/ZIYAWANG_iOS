//
//  CommentsCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/14.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
@interface CommentsCell : UITableViewCell
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UIImageView *usericonImageView;
@property (nonatomic,strong) UILabel *commentLabel;
@property (nonatomic,strong) UILabel *commentContent;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) CommentModel *model;
@property (nonatomic,assign) CGFloat height;
+ (CGFloat)WidthForLabel;
+(CGFloat)heightForTextCellWithNewsDic:(NSString *)text;
+(CGFloat)heigthForText:(NSString *)text FontSize:(CGFloat)fontSize width:(CGFloat)width;
@end
