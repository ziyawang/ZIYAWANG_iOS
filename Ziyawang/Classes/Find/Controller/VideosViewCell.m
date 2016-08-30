//
//  VideosViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/10.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "VideosViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@implementation VideosViewCell

- (void)setModel:(VideosModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setModelData];
    }
}

- (void)setModelData
{
    NSString *headURL = @"http://images.ziyawang.com";

    [self.VideoImageView sd_setImageWithURL:[NSURL URLWithString:[headURL stringByAppendingString:self.model.VideoLogo]]];
    self.ViedoDesLabel.text = self.model.VideoDes;
    NSString *str1= @"已播放";
    NSString *str2 = @"次";
    
    self.VideoCountLabel.text =  [[str1 stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.ViewCount]]stringByAppendingString:str2] ;
    NSLog(@"!!!!!!!!!!!视频观看次数：：：：：：%@",self.model.ViewCount);
    [self.contentView bringSubviewToFront:self.playButton];
    
    
}
- (IBAction)shareButtonAction:(id)sender {
    
    
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
