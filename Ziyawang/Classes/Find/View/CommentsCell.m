//
//  CommentsCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/14.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CommentsCell.h"

@implementation CommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
        
    }
    return self;

}

-  (void)setModel:(CommentModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setData];
    }
    
}

- (void)setData
{
    NSString *str = getImageURL;
    self.usericonImageView.layer.masksToBounds = YES;
    self.usericonImageView.layer.cornerRadius = self.usericonImageView.bounds.size.height/2;
    [self.usericonImageView sd_setImageWithURL:[NSURL URLWithString:[str stringByAppendingString:self.model.UserPicture] ]];
    self.userNameLabel.text = self.model.UserName;
    self.timeLabel.text = self.model.PubTime;
    self.commentLabel.text = self.model.Content;
    CGRect detailFrame = self.commentLabel.frame;
    
    NSLog(@"$$$$$$$$$$$$$$%@",self.commentLabel.text);
    //改变origin 点
    //detailFrame.origin.y = titleFrame.origin.y + titleFrame.size.height + 5;
    CGFloat detailHeight = [CommentsCell heigthForText:self.model.Content FontSize:12 width:detailFrame.size.width];
    
    //修改detailFrame的 高度
    detailFrame.size.height = detailHeight;
    //修改后的frame 设置detailLabel
    self.commentLabel.frame = detailFrame;
}
- (void)setupSubViews
{
//    @property (nonatomic,strong) UILabel *userNameLabel;
//    @property (nonatomic,strong) UIImageView *usericonImageView;
//    @property (nonatomic,strong) UILabel *commentLabel;
//    @property (nonatomic,strong) UILabel *commentContent;
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 10, 80, 20)];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 10, 200, 20)];
    self.usericonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 37, 37)];
    self.commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 30, 250, 20)];
    self.commentLabel.numberOfLines = 0;
    self.userNameLabel.font = [UIFont FontForLabel];
    self.commentLabel.font = [UIFont FontForLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:10]
   
    ;
    [self.contentView addSubview:self.usericonImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.userNameLabel];
}
//计算行高

+(CGFloat)heightForTextCellWithNewsDic:(NSString *)text{
    
//    CGFloat titleHeight = [self heigthForText:newsDic[@"title"] FontSize:22 width:250];
    CGFloat descHeight = [self heigthForText:text FontSize:12 width:250];

    CGFloat height =descHeight + 45;
    
    NSLog(@"%.2f",height);
    return height;
}

+(CGFloat)heigthForText:(NSString *)text FontSize:(CGFloat)fontSize width:(CGFloat)width{
    //字符绘制区域
    CGSize size = CGSizeMake(width, 1000);
    CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    //CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return textRect.size.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
