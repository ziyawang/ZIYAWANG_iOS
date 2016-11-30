//
//  NewPublishCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "NewPublishCell.h"

@interface NewPublishCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *specialImage;
@property (weak, nonatomic) IBOutlet UILabel *diquLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yabiCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *LiangdianLabel1;
@property (weak, nonatomic) IBOutlet UILabel *liangdianLabel2;
@property (weak, nonatomic) IBOutlet UILabel *liangdianLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightMoneyLabel;

@end


@implementation NewPublishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(PublishModel *)model
{
    if (_model != model)
    {
        _model = nil;
        _model = model;
        [self setDataForCell];
    }
}

- (void)setDataForCell
{
    
    NSString *ImageURL = [getImageURL stringByAppendingString:self.model.PictureDes1];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:ImageURL]];
    
    
    [self setLabelWithLabel:self.LiangdianLabel1];
    [self setLabelWithLabel:self.liangdianLabel2];
    [self setLabelWithLabel:self.liangdianLabel3];
    
    
    self.titleLabel.text = self.model.Title;
    
    NSArray *areaArr = [self.model.ProArea componentsSeparatedByString:@"-"];
    self.diquLabel.text = areaArr[0];
    self.typeLabel.text = self.model.TypeName;
    self.yabiCountLabel.text = self.model.Price;
    
    NSArray *liangdianArray = [self.model.ProLabel componentsSeparatedByString:@","];
//    if (liangdianArray.count) {
//        <#statements#>
//    }
//    
    
}
- (void)setLabelWithLabel:(UILabel *)label
{
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.textColor = [UIColor grayColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
