//
//  VipRechargeLogCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/15.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "VipRechargeLogCell.h"

@interface VipRechargeLogCell ()
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;

@end

@implementation VipRechargeLogCell




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(VipModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setCell];
        
    }
}
- (void)setCell
{
    self.memberNameLabel.text = [[@"充值"stringByAppendingString:self.model.MemberName]stringByAppendingString:@"VIP"];
    self.timeLabel.text = self.model.StartTime;
    NSLog(@"%@",self.model.PayMoney);
    
    self.payMoneyLabel.text = [NSString stringWithFormat:@"%ld",self.model.PayMoney.integerValue/100];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
