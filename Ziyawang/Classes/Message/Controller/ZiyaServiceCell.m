//
//  ZiyaServiceCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/20.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ZiyaServiceCell.h"

@implementation ZiyaServiceCell

- (instancetype)initWithFrame:(CGRect)frame
{
   self =  [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;

}
- (void)setModel:(ZiyaServiceModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setCell];
    }
}
- (void)setCell
{
    self.xitongImageView.image = [UIImage imageNamed:@"morentouxiang"];
    self.timeLabel.text = self.model.Time;
    
    self.contentLabel.text = self.model.Title;
//    self.timeLabel.font = [UIFont FontForLabel];
    self.contentLabel.font = [UIFont FontForLabel];
    
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
