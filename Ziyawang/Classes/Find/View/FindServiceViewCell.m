//
//  FindServiceViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/3.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FindServiceViewCell.h"

@interface FindServiceViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeNameLable;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLable;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *servplaceLable;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic,strong)NSString *imageurl1;
@property (nonatomic,strong)NSString *imageurl2;
@property (nonatomic,strong)NSString *imageurl3;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuwudengji;
@property (weak, nonatomic) IBOutlet UILabel *fuwuleixing;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ima1;
@property (weak, nonatomic) IBOutlet UIImageView *ima2;
@property (weak, nonatomic) IBOutlet UIImageView *ima3;
@property (weak, nonatomic) IBOutlet UIImageView *ima4;
@property (weak, nonatomic) IBOutlet UIImageView *ima5;
@property (weak, nonatomic) IBOutlet UIImageView *imag1;
@property (weak, nonatomic) IBOutlet UIImageView *imag2;
@property (weak, nonatomic) IBOutlet UIImageView *imag3;
@property (weak, nonatomic) IBOutlet UIImageView *imag4;
@property (weak, nonatomic) IBOutlet UIImageView *imag5;

@end

@implementation FindServiceViewCell

- (void)setModel:(FindServiceModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self layoutView];
    }
}




- (void)layoutView
{
//    NSLog(@"%@",self.model.ServiceType);
//    self.model.ServiceType = [NSString stringWithFormat:@"%@",self.model.ServiceType];
    
    
//    self.typeNameLable.font = [UIFont FontForLabel];
//    self.companyName.font = [UIFont FontForBigLabel];
//    self.servplaceLable.font = [UIFont FontForLabel];
//    self.placeLabel.font = [UIFont FontForLabel];
//    self.fuwudengji.font = [UIFont FontForLabel];
//    self.numberLabel.font = [UIFont FontForLabel];
//    self.fuwuleixing.font = [UIFont FontForLabel];
//    
    self.typeNameLable.text = self.model.ServiceType;
    self.projectNameLable.text = self.model.ServiceNumber;
    
    self.projectNameLable.font = [UIFont FontForSmallLabel];
    self.companyName.text = self.model.ServiceName;
    self.servplaceLable.text = self.model.ServiceArea;
    self.numberLabel.text = self.model.ServiceLevel;
    self.imageurl1 = self.model.ConfirmationP1;
    self.imageurl2 = self.model.ConfirmationP2;
    self.imageurl3 = self.model.ConfirmationP3;
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.imageurl1]]];
    
    
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
