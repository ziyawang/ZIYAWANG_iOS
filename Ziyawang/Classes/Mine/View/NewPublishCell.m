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


@property (weak, nonatomic) IBOutlet UILabel *liangdianLabel1;
@property (weak, nonatomic) IBOutlet UILabel *liangdianLabel2;
@property (weak, nonatomic) IBOutlet UILabel *liangdianLabel3;
@property (weak, nonatomic) IBOutlet UILabel *liangdianLabel4;
@property (weak, nonatomic) IBOutlet UILabel *liangdianLabel5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liangdianHeight;


@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specialImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *yabi;


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
    [self.imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.imageview.clipsToBounds = YES;

    
    [self setLabelWithLabel:self.liangdianLabel1];
    [self setLabelWithLabel:self.liangdianLabel2];
    [self setLabelWithLabel:self.liangdianLabel3];
    [self setLabelWithLabel:self.liangdianLabel4];
    [self setLabelWithLabel:self.liangdianLabel5];
    
    [self.liangdianLabel1 setHidden:YES];
    [self.liangdianLabel2 setHidden:YES];
    [self.liangdianLabel3 setHidden:YES];
    [self.liangdianLabel4 setHidden:YES];
    [self.liangdianLabel5 setHidden:YES];
    
    _liangdianHeight.constant = 0;
    
    
    self.yabiCountLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    self.leftMoneyLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    self.rightMoneyLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    self.bottomLabel.textColor = [UIColor colorWithHexString:@"#ef8200"];
    
    self.titleLabel.text = self.model.Title;
    
    NSArray *areaArr = [self.model.ProArea componentsSeparatedByString:@"-"];
    self.diquLabel.text = areaArr[0];
    self.typeLabel.text = self.model.TypeName;
    self.yabiCountLabel.text = self.model.Price;
    
    self.diquLabel.font = [UIFont FontForLabel];
    self.typeLabel.font = [UIFont FontForLabel];
    self.yabi.font = [UIFont FontForLabel];
    self.yabiCountLabel.font = [UIFont FontForLabel];
    self.otherTypeLabel.font = [UIFont FontForLabel];
    
    
    self.liangdianLabel1.font = [UIFont FontForLabel2];
    self.liangdianLabel2.font = [UIFont FontForLabel2];
    self.liangdianLabel3.font = [UIFont FontForLabel2];
    
    
    [self.rightMoneyLabel setHidden:YES];
    [self.rightImageView setHidden:YES];
    [self.bottomLabel setHidden:YES];
    [self.bottomImageView setHidden:YES];
    
    
    if ([self.model.Member isEqualToString:@"1"]) {
        self.specialImage.image = [UIImage imageNamed:@"xinvip"];
        
        self.specialImageWidth.constant = 45;
        [self.specialImage setHidden:NO];
    }
    else if([self.model.Member isEqualToString:@"2"])
    {
        
        self.specialImageWidth.constant = 45;
        [self.specialImage setHidden:NO];
        self.specialImage.image = [UIImage imageNamed:@"shoufeiziyuan"];
    }
    else
    {
        self.specialImageWidth.constant = 0;
        [self.specialImage setHidden:YES];
        
    }
    
    if ([self.model.Price isEqualToString:@"0"]) {
        [self.yabiCountLabel setHidden:YES];
        [self.yabi setHidden:YES];
    }
    
    //维度信息布局
    NSInteger typeid = self.model.TypeID.integerValue;
    
    switch (typeid) {
            //资产包
        case 1:
        {
            if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
            {
                [self.bottomImageView setHidden:NO];
                [self.bottomLabel setHidden:NO];
            
                [self.rightMoneyLabel setHidden:YES];
                [self.rightImageView setHidden:YES];
            }
            else
            {
                [self.bottomImageView setHidden:YES];
                [self.bottomLabel setHidden:YES];
                [self.rightImageView setHidden:NO];
                [self.rightMoneyLabel setHidden:NO];
            }
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [[self.model.TotalMoney substringToIndex:self.model.TotalMoney.length - 3]stringByAppendingString:@"万"];
            
            self.rightMoneyLabel.text = [[self.model.TransferMoney substringToIndex:self.model.TransferMoney.length - 3]stringByAppendingString:@"万"];
            self.bottomLabel.text = [[self.model.TransferMoney substringToIndex:self.model.TransferMoney.length - 3]stringByAppendingString:@"万"];
            
            
            self.leftImageView.image = [UIImage imageNamed:@"zongjine"];
            self.rightImageView.image = [UIImage imageNamed:@"zhuanrangjia"];
            self.bottomImageView.image = [UIImage imageNamed:@"zhuanrangjia"];
        }
            break;
            //融资信息股权
        case 6:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            [self.leftMoneyLabel setHidden:NO];
            
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [[self.model.TotalMoney substringToIndex:self.model.TotalMoney.length - 3]stringByAppendingString:@"万"];
            self.leftImageView.image = [UIImage imageNamed:@"rongzie"];
            break;
            //固定资产房产
        case 12:
        {
            if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
            {
                [self.bottomImageView setHidden:NO];
                [self.bottomLabel setHidden:NO];
//
                [self.rightMoneyLabel setHidden:YES];
                [self.rightImageView setHidden:YES];
                
            }
            else
            {
            [self.bottomImageView setHidden:YES];
            [self.bottomLabel setHidden:YES];
            [self.rightImageView setHidden:NO];
            [self.rightMoneyLabel setHidden:NO];
            }
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [[self.model.MarketPrice substringToIndex:self.model.MarketPrice.length - 3]stringByAppendingString:@"万"];

            self.rightMoneyLabel.text = [[self.model.TransferMoney substringToIndex:self.model.TransferMoney.length - 3]stringByAppendingString:@"万"];
            self.bottomLabel.text = [[self.model.TransferMoney substringToIndex:self.model.TransferMoney.length - 3]stringByAppendingString:@"万"];
            
            
            self.leftImageView.image = [UIImage imageNamed:@"shichangjia"];
            self.rightImageView.image = [UIImage imageNamed:@"zhuanrangjia"];
            self.bottomImageView.image = [UIImage imageNamed:@"zhuanrangjia"];
        }
            break;
        
            //固定资产土地
        case 16:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [[self.model.TransferMoney substringToIndex:self.model.TransferMoney.length - 3]stringByAppendingString:@"万"];
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
            self.leftMoneyLabel.text = [[self.model.Money substringToIndex:self.model.Money.length - 3]stringByAppendingString:@"万"];

            self.leftImageView.image = [UIImage imageNamed:@"zhaiquane"];
            
            break;
            
            //个人债权
        case 19:
        {
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.leftMoneyLabel.text = [[self.model.TotalMoney substringToIndex:self.model.TotalMoney.length - 3]stringByAppendingString:@"万"];
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
            self.leftMoneyLabel.text = [[self.model.Money substringToIndex:self.model.Money.length - 3]stringByAppendingString:@"万"];

            self.leftImageView.image = [UIImage imageNamed:@"qipaijia"];
            
            break;
        case 21:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [[self.model.Money substringToIndex:self.model.Money.length - 3]stringByAppendingString:@"万"];
;
            self.leftImageView.image = [UIImage imageNamed:@"qipaijia"];
            break;
        case 22:
            [self.rightImageView setHidden:YES];
            [self.rightMoneyLabel setHidden:YES];
            self.otherTypeLabel.text = self.model.AssetType;
            self.leftMoneyLabel.text = [[self.model.Money substringToIndex:self.model.Money.length - 3]stringByAppendingString:@"万"];

            self.leftImageView.image = [UIImage imageNamed:@"qipaijia"];
            break;
              default:
            break;
    }
    
    
    
    
    
    if (self.model.ProLabel == nil || [self.model.ProLabel isEqualToString:@""]) {
        [self.liangdianLabel1 setHidden:YES];
        [self.liangdianLabel2 setHidden:YES];
        [self.liangdianLabel3 setHidden:YES];
        [self.liangdianLabel4 setHidden:YES];
        [self.liangdianLabel5 setHidden:YES];
        
        
    }
    else
    {
    //亮点布局
    NSArray *liangdianArray = [self.model.ProLabel componentsSeparatedByString:@","];
    switch (liangdianArray.count) {
        case 0:
            [self.liangdianLabel1 setHidden:YES];
            [self.liangdianLabel2 setHidden:YES];
            [self.liangdianLabel3 setHidden:YES];
            [self.liangdianLabel4 setHidden:YES];
            
            
            break;
        case 1:
        {
            [self.liangdianLabel1 setHidden:NO];
            [self.liangdianLabel2 setHidden:YES];
            [self.liangdianLabel3 setHidden:YES];
            [self.liangdianLabel4 setHidden:YES];
            
            NSString *liangdian1 = [[@" "stringByAppendingString:liangdianArray[0]]stringByAppendingString:@" "];
            self.liangdianLabel1.text = liangdian1;
            
//            self.liangdianLabel1.titleLabel.text = liangdianArray[0];
          
//            self.LiangdianLabel1.text = [[@" "stringByAppendingString:liangdianArray[0]]stringByAppendingString:@" "];
        }
            break;
        case 2:
        {
            NSLog(@"%@",self.model.ProLabel);
            
            [self.liangdianLabel1 setHidden:NO];
            [self.liangdianLabel2 setHidden:NO];
            [self.liangdianLabel3 setHidden:YES];
            [self.liangdianLabel4 setHidden:YES];
            
//            self.liangdianLabel1.titleLabel.text = liangdianArray[0];
//            self.liangdianLabel2.titleLabel.text = liangdianArray[1];
            
            NSString *liangdian1 = [[@" "stringByAppendingString:liangdianArray[0]]stringByAppendingString:@" "];
            self.liangdianLabel1.text = liangdian1;
            
//              [self.liangdianLabel1 setTitle:liangdian1 forState:(UIControlStateNormal)];
            
            NSString *liangdian2 = [[@" "stringByAppendingString:liangdianArray[1]]stringByAppendingString:@" "];
//            [self.liangdianLabel2 setTitle:liangdian2 forState:(UIControlStateNormal)];
            self.liangdianLabel2.text = liangdian2;
//            self.LiangdianLabel1.text = [[@" "stringByAppendingString:liangdianArray[0]]stringByAppendingString:@" "];
//            self.liangdianLabel2.text = [[@" "stringByAppendingString:liangdianArray[1]]stringByAppendingString:@" "];
        }
            break;
        case 3:
        {
            NSLog(@"%@",self.model.ProLabel);

            [self.liangdianLabel1 setHidden:NO];
            [self.liangdianLabel2 setHidden:NO];
            [self.liangdianLabel3 setHidden:NO];
            
            NSString *liangdian1 = [[@" "stringByAppendingString:liangdianArray[0]]stringByAppendingString:@" "];
//            [self.liangdianLabel1 setTitle:liangdian1 forState:(UIControlStateNormal)];
            self.liangdianLabel1.text = liangdian1;
            
            NSString *liangdian2 = [[@" "stringByAppendingString:liangdianArray[1]]stringByAppendingString:@" "];
//            [self.liangdianLabel2 setTitle:liangdian2 forState:(UIControlStateNormal)];
            self.liangdianLabel2.text = liangdian2;
            
            NSString *liangdian3 = [[@" "stringByAppendingString:liangdianArray[2]]stringByAppendingString:@" "];
//            [self.liangdianLabel3 setTitle:liangdian3 forState:(UIControlStateNormal)];
            self.liangdianLabel3.text = liangdian3;
            
          //            self.liangdianLabel1.titleLabel.text = liangdianArray[0];
//            self.liangdianLabel2.titleLabel.text = liangdianArray[1];
//            self.liangdianLabel3.titleLabel.text = liangdianArray[2];
//            
//            self.LiangdianLabel1.text = [[@" "stringByAppendingString:liangdianArray[0]]stringByAppendingString:@" "];
//            self.liangdianLabel2.text = [[@" "stringByAppendingString:liangdianArray[1]]stringByAppendingString:@" "];
//            self.liangdianLabel3.text = [[@" "stringByAppendingString:liangdianArray[2]]stringByAppendingString:@" "];
        }
            
            break;
        case 4:
        {
            [self.liangdianLabel1 setHidden:NO];
            [self.liangdianLabel2 setHidden:NO];
            [self.liangdianLabel3 setHidden:NO];
//            [self.liangdianLabel4 setHidden:NO];
//            
//            if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
//            {
//                [self.liangdianLabel4 setHidden:YES];
//                [self.liangdianLabel5 setHidden:NO];
//                self.liangdianHeight.constant = 16;
//                
//            }
//            else
//            {
//                [self.liangdianLabel4 setHidden:NO];
//                [self.liangdianLabel5 setHidden:YES];
//                self.liangdianHeight.constant = 0;
//
//            }
//            
//            [self.liangdianLabel1 setTitle:liangdianArray[0] forState:(UIControlStateNormal)];
//            [self.liangdianLabel2 setTitle:liangdianArray[1] forState:(UIControlStateNormal)];
//            [self.liangdianLabel3 setTitle:liangdianArray[2] forState:(UIControlStateNormal)];
//
//            
            NSString *liangdian1 = [[@" "stringByAppendingString:liangdianArray[0]]stringByAppendingString:@" "];
            self.liangdianLabel1.text = liangdian1;
//            [self.liangdianLabel1 setTitle:liangdian1 forState:(UIControlStateNormal)];
//            
            NSString *liangdian2 = [[@" "stringByAppendingString:liangdianArray[1]]stringByAppendingString:@" "];
            self.liangdianLabel2.text = liangdian2;
//            [self.liangdianLabel2 setTitle:liangdian2 forState:(UIControlStateNormal)];
//            
            NSString *liangdian3 = [[@" "stringByAppendingString:liangdianArray[2]]stringByAppendingString:@" "];
            self.liangdianLabel3.text = liangdian3;
            
//            [self.liangdianLabel3 setTitle:liangdian3 forState:(UIControlStateNormal)];
//            NSString *liangdian4 = [[@" "stringByAppendingString:liangdianArray[3]]stringByAppendingString:@" "];
//            [self.liangdianLabel4 setTitle:liangdian4 forState:(UIControlStateNormal)];
//            NSString *liangdian5 = [[@" "stringByAppendingString:liangdianArray[3]]stringByAppendingString:@" "];
//            [self.liangdianLabel5 setTitle:liangdian5 forState:(UIControlStateNormal)];
            //            self.liangdianLabel1.titleLabel.text = liangdianArray[0];
            //            self.liangdianLabel2.titleLabel.text = liangdianArray[1];
            //            self.liangdianLabel3.titleLabel.text = liangdianArray[2];
            //
            //            self.LiangdianLabel1.text = [[@" "stringByAppendingString:liangdianArray[0]]stringByAppendingString:@" "];
            //            self.liangdianLabel2.text = [[@" "stringByAppendingString:liangdianArray[1]]stringByAppendingString:@" "];
            //            self.liangdianLabel3.text = [[@" "stringByAppendingString:liangdianArray[2]]stringByAppendingString:@" "];
        }
            
            break;

  
        default:
            break;
    }
    }
    
    
    
}
- (void)setLabelWithLabel:(UILabel *)label
{
    label.layer.cornerRadius = 2;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.alpha = 0.5;
    
//    [label setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    label.textColor = [UIColor blackColor];
    
    
//    [label setTitleEdgeInsets:UIEdgeInsetsMake(2, 3, 2, 3)];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
