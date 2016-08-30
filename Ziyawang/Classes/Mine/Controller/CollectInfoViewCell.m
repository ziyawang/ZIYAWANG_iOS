//
//  CollectInfoViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CollectInfoViewCell.h"

@implementation CollectInfoViewCell


- (void)setModel:(CollectModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setCell];
        
    }
}
- (void)setCell
{
    self.typeNameLabel.text = self.model.TypeName;
    self.proAreaLabel.text = self.model.ProArea;
    self.wordDesLabel.text = self.model.WordDes;
    self.typeNameLabel.font = [UIFont FontForBigLabel];
    self.proAreaLabel.font = [UIFont FontForLabel];
    self.wordDesLabel.font = [UIFont FontForLabel];
    self.diquLabel.font = [UIFont FontForLabel];
    self.wenziLabel.font = [UIFont FontForLabel];
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
