//
//  CollectVideoViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CollectVideoViewCell.h"

@implementation CollectVideoViewCell
- (void)setModel:(CollectModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setDataForVideo];
    }
    
}
- (void)setDataForVideo
{
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$%@",self.model.VideoLogo);
    
    NSString *URL = [getImageURL stringByAppendingString:self.model.VideoLogo];
    
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:URL]];
    self.videoTitle.text = self.model.VideoTitle;
    self.videoDes.text = self.model.VideoDes;
    self.videoDes.font = [UIFont FontForLabel];
    self.videoTitle.font = [UIFont FontForBigLabel];
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
