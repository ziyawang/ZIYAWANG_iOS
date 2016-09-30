//
//  CommentCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/12.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self setDataForCell];
//    }
//    return self;
//    
//}

- (void)setDataForCell
{
    NSString *str = getImageURL;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.height/2;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[str stringByAppendingString:self.model.UserPicture] ]];
    self.userName.text = self.model.UserName;
    self.commentTime.text = self.model.PubTime;
//    self.commentLabel.text = self.model.Content;
//    self.commentLabel.text = @"ifdjowihefiohwoiefhoeiwhfiowehoifhweoifhoiewhfioehfoihweofhowiehfoiwehfiohweiofhiowehfiowehfiohweoifhweiohfoiwehfiowhfiohweiofhweoifhoiwehfoiwehfiowehfiowhefiowehfoiwhfiowehfiowehf";
    [self setFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.commentLabel.bounds.size.height +80)];
    
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
