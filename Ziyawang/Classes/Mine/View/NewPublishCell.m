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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specialImageWidth;

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
    //总体布局
    NSString *ImageURL = [getImageURL stringByAppendingString:self.model.PictureDes1];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:ImageURL]];
    
    
    [self setLabelWithLabel:self.LiangdianLabel1];
    [self setLabelWithLabel:self.liangdianLabel2];
    [self setLabelWithLabel:self.liangdianLabel3];
    
    self.yabiCountLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    self.leftMoneyLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    self.rightMoneyLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    
    self.titleLabel.text = self.model.Title;
    
    NSArray *areaArr = [self.model.ProArea componentsSeparatedByString:@"-"];
    self.diquLabel.text = areaArr[0];
    self.typeLabel.text = self.model.TypeName;
    self.yabiCountLabel.text = self.model.Price;
    
    [self.rightMoneyLabel setHidden:YES];
    [self.rightImageView setHidden:YES];
    
    if ([self.model.Member isEqualToString:@"1"]) {
        self.specialImage.image = [UIImage imageNamed:@"vip_ziyuan"];
        
        self.specialImageWidth.constant = 50;
        [self.specialImage setHidden:NO];
    }
    else if([self.model.Member isEqualToString:@"2"])
    {
        
        self.specialImageWidth.constant = 50;
        [self.specialImage setHidden:NO];
        self.specialImage.image = [UIImage imageNamed:@"shoufeiziyuan"];
        
    }
    else
    {
        self.specialImageWidth.constant = 0;
        [self.specialImage setHidden:YES];
        
    }
    //维度信息布局
    NSInteger typeid = self.model.TypeID.integerValue;
    
    switch (typeid) {
            //资产包
        case 1:
            [self.rightImageView setHidden:NO];
            [self.rightMoneyLabel setHidden:NO];
            self.otherTypeLabel.text = self.model.FromWhere;
            self.leftMoneyLabel.text = [self.model.TotalMoney stringByAppendingString:@"万"];
            self.rightMoneyLabel.text = [self.model.TransferMoney stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"zongjine"];
            self.rightImageView.image = [UIImage imageNamed:@"zhuanrangjia"];
            break;
            //融资信息股权
        case 6:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [self.model.Money stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"rongzie"];
            break;
            //固定资产房产
        case 12:
            [self.rightImageView setHidden:NO];
            [self.rightMoneyLabel setHidden:NO];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [self.model.MarketPrice stringByAppendingString:@"万"];
            self.rightMoneyLabel.text = [self.model.TransferMoney stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"shichangjia"];
            self.rightImageView.image = [UIImage imageNamed:@"zhuanrangjia"];
            
            break;
            //固定资产土地
        case 16:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [self.model.TransferMoney stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"zhuanrangjia"];
            break;
            //融资信息债权
        case 17:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [self.model.Money stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"rongzie"];
            
            break;
            //企业商账
        case 18:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [self.model.Money stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"zhaiquane"];
            
            break;
            
            //个人债权
        case 19:
        {
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.leftMoneyLabel.text = [self.model.TotalMoney stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"zongjine"];
            if (self.model.Law == nil) {
                self.otherTypeLabel.text = self.model.UnLaw;
                
            }
            else if(self.model.UnLaw == nil)
            {
                self.otherTypeLabel.text = self.model.Law;
            }
        }
            break;
            //法拍资产
        case 20:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [self.model.Money stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"qipaijia"];
            
            break;
        case 21:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [self.model.Money stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"qipaijia"];
            break;
        case 22:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [self.model.Money stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"qipaijia"];
            break;
              default:
            break;
    }
    
    
    
    
    //亮点布局
    NSArray *liangdianArray = [self.model.ProLabel componentsSeparatedByString:@","];
    switch (liangdianArray.count) {
        case 0:
            [self.LiangdianLabel1 setHidden:YES];
            [self.liangdianLabel2 setHidden:YES];
            [self.liangdianLabel3 setHidden:YES];
            
            break;
        case 1:
            [self.LiangdianLabel1 setHidden:NO];
            [self.liangdianLabel2 setHidden:YES];
            [self.liangdianLabel3 setHidden:YES];
            self.LiangdianLabel1.text = liangdianArray[0];
            break;
        case 2:
            [self.LiangdianLabel1 setHidden:NO];
            [self.liangdianLabel2 setHidden:NO];
            [self.liangdianLabel3 setHidden:YES];
            self.LiangdianLabel1.text = liangdianArray[0];
            self.liangdianLabel2.text = liangdianArray[1];
            break;
        case 3:
            [self.LiangdianLabel1 setHidden:NO];
            [self.liangdianLabel2 setHidden:NO];
            [self.liangdianLabel3 setHidden:NO];
            self.LiangdianLabel1.text = liangdianArray[0];
            self.liangdianLabel2.text = liangdianArray[1];
            self.liangdianLabel3.text = liangdianArray[2];
            
            break;
  
        default:
            break;
    }
  
    
    
    
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
