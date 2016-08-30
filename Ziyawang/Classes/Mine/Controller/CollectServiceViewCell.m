//
//  CollectServiceViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/18.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CollectServiceViewCell.h"

@implementation CollectServiceViewCell


- (void)setModel:(CollectModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self layoutView];
    }
}

- (void)layoutView
{
    NSLog(@"%@",self.model.ServiceType);
    
    self.serviceType.text = self.model.ServiceType;
    self.commanyNameLabel.text = self.model.ServiceName;
    self.serviceProArea.text = self.model.ServiceArea;
    self.serviceType.font = [UIFont FontForLabel];
    self.commanyNameLabel.font = [UIFont FontForBigLabel];
    self.serviceProArea.font = [UIFont FontForLabel];
    self.fuwudiqu.font = [UIFont FontForLabel];
    self.fuwuleixing.font = [UIFont FontForLabel];
    
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
