//
//  CostViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CostViewCell.h"

@interface CostViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *rechargeTitle;
@property (weak, nonatomic) IBOutlet UILabel *rechargeAccount;
@property (weak, nonatomic) IBOutlet UILabel *rechargeTime;
@property (weak, nonatomic) IBOutlet UILabel *yabiLabel;

@end

@implementation CostViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setModel:(CostModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setCell];
    }
}
- (void)setCell
{
    self.model.Type = [NSString stringWithFormat:@"%@",self.model.Type];
    if ([self.model.Type isEqualToString:@"1"]) {
        self.rechargeTitle.text = @"充值芽币";
        self.rechargeAccount.text = [@"+"stringByAppendingString:self.model.Money];
        self.rechargeAccount.textColor = [UIColor colorWithHexString:@"#90c31f"];
        self.yabiLabel.textColor = [UIColor colorWithHexString:@"#90c31f"];
    }
    else
    {
    self.rechargeTitle.text = @"付费约谈";
        self.rechargeAccount.text = [@"-"stringByAppendingString:self.model.Money];
        self.rechargeAccount.textColor = [UIColor colorWithHexString:@"#eb6155"];
        self.yabiLabel.textColor = [UIColor colorWithHexString:@"#eb6155"];
    }
    self.rechargeTime.text = self.model.created_at;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
