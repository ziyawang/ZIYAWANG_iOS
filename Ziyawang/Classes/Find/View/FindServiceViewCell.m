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
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

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
    [self.noLabel setHidden:YES];
    self.typeNameLable.text = self.model.ServiceType;
    self.projectNameLable.text = self.model.ServiceNumber;
    
    self.projectNameLable.font = [UIFont FontForSmallLabel];
    self.companyName.text = self.model.ServiceName;
    self.servplaceLable.text = self.model.ServiceArea;
    self.numberLabel.text = self.model.ServiceLevel;
    self.imageurl1 = self.model.ConfirmationP1;
    self.imageurl2 = self.model.ConfirmationP2;
    self.imageurl3 = self.model.ConfirmationP3;
    
    [self setImageViewsWithImageView:self.leftImageView];
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[getImageURL stringByAppendingString:self.imageurl1]]];
    
    if ([self.model.showrightiosStr isEqualToString:@""]||self.model.showrightiosStr == nil) {
        [self.noLabel setHidden:NO];
        self.noLabel.text = @"无";
        self.imag1.image = [UIImage new];
        self.imag2.image = [UIImage new];
        self.imag3.image = [UIImage new];
        self.imag4.image = [UIImage new];
        self.imag5.image = [UIImage new];

        
    }
    else
    {
    NSLog(@"%@",self.model.showrightiosStr);
    NSArray *vipArr = [self.model.showrightiosStr componentsSeparatedByString:@","];
     
        switch (vipArr.count) {
            case 0:
                [self.noLabel setHidden:NO];
                self.noLabel.text = @"无";
                self.imag1.image = [UIImage new];
                self.imag2.image = [UIImage new];
                self.imag3.image = [UIImage new];
                self.imag4.image = [UIImage new];
                self.imag5.image = [UIImage new];
                break;
                
            case 1:
                [self.noLabel setHidden:YES];
                self.noLabel.text = @"";
                self.imag1.image = [UIImage imageNamed:vipArr[0]];
                break;
            case 2:
                [self.noLabel setHidden:YES];
                self.noLabel.text = @"";

                self.imag1.image = [UIImage imageNamed:vipArr[0]];
                self.imag2.image = [UIImage imageNamed:vipArr[1]];
                break;
            case 3:
                [self.noLabel setHidden:YES];
                self.noLabel.text = @"";

                self.imag1.image = [UIImage imageNamed:vipArr[0]];
                self.imag2.image = [UIImage imageNamed:vipArr[1]];
                self.imag3.image = [UIImage imageNamed:vipArr[2]];
                break;
            case 4:
                [self.noLabel setHidden:YES];
                self.noLabel.text = @"";

                self.imag1.image = [UIImage imageNamed:vipArr[0]];
                self.imag2.image = [UIImage imageNamed:vipArr[1]];
                self.imag3.image = [UIImage imageNamed:vipArr[2]];
                self.imag4.image = [UIImage imageNamed:vipArr[3]];
                break;
            case 5:
                [self.noLabel setHidden:YES];
                self.noLabel.text = @"";

                self.imag1.image = [UIImage imageNamed:vipArr[0]];
                self.imag2.image = [UIImage imageNamed:vipArr[1]];
                self.imag3.image = [UIImage imageNamed:vipArr[2]];
                self.imag4.image = [UIImage imageNamed:vipArr[3]];
                self.imag5.image = [UIImage imageNamed:vipArr[4]];
                break;
            default:
                break;
        }
     }
    
    
    if ([self.model.Level isEqualToString:@""]||self.model.Level == nil) {
        self.ima1.image = [UIImage imageNamed:@"bao-hui"];
        self.ima2.image = [UIImage imageNamed:@"shi-hui"];
        self.ima3.image = [UIImage imageNamed:@"shi-hui-1"];
        self.ima4.image = [UIImage imageNamed:@"nuo-hui"];
        self.ima5.image = [UIImage imageNamed:@"zheng-hui"];

    }
    else
    {
        NSArray *starArr = [self.model.Level componentsSeparatedByString:@","];
        for (NSString *starStr in starArr)
        {
            if ([starStr isEqualToString:@"1"])
            {
                self.ima1.image = [UIImage imageNamed:@"baozhengjin"];
            }
       
            if ([starStr isEqualToString:@"2"])
            {
                self.ima2.image = [UIImage imageNamed:@"shi"];
            }
  
            if ([starStr isEqualToString:@"3"])
            {
                self.ima3.image = [UIImage imageNamed:@"shipin"];
            }

            if ([starStr isEqualToString:@"4"])
            {
                self.ima4.image = [UIImage imageNamed:@"nuo"];
            }

            if ([starStr isEqualToString:@"5"]) {
                self.ima5.image = [UIImage imageNamed:@"zheng"];
            }

        }
    }
}

- (void)setImageViewsWithImageView:(UIImageView *)imageView
{
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds = YES;
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
