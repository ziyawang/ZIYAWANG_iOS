//
//  PublishCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/23.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PublishCell.h"


@interface PublishCell ()
//property (nonatomic,strong) NSString *TypeName;//需求名字类型
//@property (nonatomic,strong) NSString *ProArea;//地区
//@property (nonatomic,strong) NSString *FromWhere;//来源
//@property (nonatomic,strong) NSString *AssetType;//类型
//
//@property (nonatomic,strong) NSString *TotalMoney;//金额
//@property (nonatomic,strong) NSString *TransferMoney;//转让价
//@property (nonatomic,strong) NSString *Status;//状态
//@property (nonatomic,strong) NSString *Rate;//佣金比例
//@property (nonatomic,strong) NSString *Requirement;//需求
//@property (nonatomic,strong) NSString *BuyerNature;//买方性质
//@property (nonatomic,strong) NSString *Informant;//被调查方
//@property (nonatomic,strong) NSString *Buyer;//求购方
@property (weak, nonatomic) IBOutlet UILabel *TypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *FromWhere;
@property (weak, nonatomic) IBOutlet UILabel *AssetTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *ContentView;
@property (weak, nonatomic) IBOutlet UILabel *diquLabel;

@property (weak, nonatomic) IBOutlet UILabel *wordDesLabel;
//需要判断的控件
@property (weak, nonatomic) IBOutlet UILabel *TotalMoney;
@property (weak, nonatomic) IBOutlet UILabel *TransferMoney;
@property (weak, nonatomic) IBOutlet UILabel *leftChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;

@property (weak, nonatomic) IBOutlet UIImageView *TotalMoneyImage;
@property (weak, nonatomic) IBOutlet UIImageView *TransMoneyImage;
@property (weak, nonatomic) IBOutlet UIImageView *VipImage;
@property (weak, nonatomic) IBOutlet UILabel *wan1;
@property (weak, nonatomic) IBOutlet UILabel *wan2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FromWhereWidth;
@property (weak, nonatomic) IBOutlet UILabel *AsetTypeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *asettyoeWidth;

@end
@implementation PublishCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
//    return self;
//}


- (void)setModel:(PublishModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setDataForCell];
    }
}

- (CGFloat )getwidth
{
    
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 35;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S )
    {
        return 70;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus)
    {
        return 80;
    }
    
    return 40;
    
}
- (void)setDataForCell
{
//    NSLog(@"--------------------%@",self.model.Member);
    self.model.Member = [NSString stringWithFormat:@"%@",self.model.Member];
    if ([self.model.Member isEqualToString:@"1"] == NO ) {
        [self.VipImage setHidden:YES];
    }
    else 
    {
        [self.VipImage setHidden:NO];
    }
    [self.wan1 setHidden:NO];
    [self.wan2 setHidden:NO];
    self.wan1.text = @"万";
    
    self.FromWhereWidth.constant = [self getwidth];
    self.asettyoeWidth.constant = [self getwidth];
    
    self.wordDesLabel.font = [UIFont FontForLabel];
    self.wordDesLabel.text = self.model.WordDes;
    self.TypeNameLabel.font = [UIFont FontForBigLabel];
     [self.TypeNameLabel setTextColor:[UIColor colorWithHexString:@"#ef8200"]];
    self.ProAreaLabel.font = [UIFont FontForLabel];
    self.FromWhere.font = [UIFont FontForLabel];
    self.AssetTypeLabel.font = [UIFont FontForLabel];
    self.projectNumberLabel.font = [UIFont FontForSmallLabel];
    [self.projectNumberLabel setTextColor:[UIColor lightGrayColor]];
    
    self.midLabel.font = [UIFont FontForLabel];
    self.diquLabel.font = [UIFont FontForLabel];
    self.downLabel.font = [UIFont FontForLabel];
    
    self.TotalMoney.font = [UIFont FontForBigLabel];
    self.TransferMoney.font = [UIFont FontForBigLabel];
    [self.TotalMoney setTextColor:[UIColor colorWithHexString:@"#ef8200"]];
    [self.TransferMoney setTextColor:[UIColor colorWithHexString:@"#ef8200"]];

    self.TransferMoney.shadowColor = [UIColor colorWithHexString:@"#ef8200"];
    self.TotalMoney.shadowColor = [UIColor colorWithHexString:@"#ef8200"];
    self.wan1.font = [UIFont FontForSmallLabel];
    self.wan2.font = [UIFont FontForSmallLabel];
    
    
    NSLog(@"-------------------%@",self.model.ProArea);
  
    NSLog(@"%@",self.model.ProArea);
    
    //    self.TotalMoney.font = [UIFont FontForLabel];
//    self.TransferMoney.font = [UIFont FontForLabel];
    
    
    NSArray *array = [self.model.ProArea componentsSeparatedByString:@"-"];
    self.model.ProArea = array[0];
    NSLog(@"%@",self.model.ProArea);
    
    
    
    self.TypeNameLabel.text = self.model.TypeName;
    self.ProAreaLabel.text = self.model.ProArea;
    self.FromWhere.text = self.model.FromWhere;
    self.AssetTypeLabel.text = self.model.AssetType;
    self.projectNumberLabel.text = self.model.ProjectNumber;
    
    
    
    
//    if ([self.model.TypeName isEqualToString:@"资产包转让"] || [self.model.TypeName isEqualToString:@"委外催收"] || [self.model.TypeName isEqualToString:@"商业保理"] || [self.model.TypeName isEqualToString:@"融资需求"]) {
//        if ([self.model.TypeName isEqualToString:@"资产包转让"]) {
//            self.TotalMoney.text = self.model.TotalMoney;
//            self.TransferMoney.text = self.model.TransferMoney;
//            [self.TotalMoney setHidden:NO];
//            [self.TransferMoney setHidden:NO];
//            [self.wan1 setHidden:NO];
//            [self.wan2 setHidden:NO];
//            self.rightChangeLabel.text = @"转让价";
//            self.leftChangeLabel.text = @"总金额";
//        }
    if([self.model.TypeName isEqualToString:@"委外催收"])
    {
    self.diquLabel.text = @"债务人所在地：";
    }
    else
    {
    self.diquLabel.text = @"地区：";
    }
    self.downLabel.text = @"类型：";
    
    
            if([self.model.TypeName isEqualToString:@"委外催收"])
        {
            [self.midLabel setHidden:NO];
             self.leftChangeLabel.text = @"金额";
             self.midLabel.text = @"状态：";
            self.diquLabel.text = @"债务人所在地：";
             self.FromWhere.text = self.model.Status;
             self.TotalMoneyImage.image = [UIImage imageNamed:@"jine"];
             self.TransMoneyImage.image = [UIImage imageNamed:@"yongjinbili"];
            [self.TransMoneyImage setHidden:NO];
            self.TransferMoney.text = self.model.Rate;//后台自己就带%
            [self.TransferMoney setHidden:NO];
            [self.wan2 setHidden:NO];
            [self.wan1 setHidden:NO];
        }
        else if([self.model.TypeName isEqualToString:@"商业保理"])
        {
            [self.midLabel setHidden:YES];
            self.TotalMoney.text = self.model.TotalMoney;
            
            [self.TransferMoney setHidden:YES];
            self.
            self.downLabel.text = @"买方性质：";
            self.AssetTypeLabel.text = self.model.BuyerNature;
            [self.TransMoneyImage setHidden:YES];
            
            self.TotalMoneyImage.image = [UIImage imageNamed:@"hetongjine"];
            
            [self.wan2 setHidden:YES];
            [self.wan1 setHidden:NO];
        }
    
//        else if([self.model.TypeName isEqualToString:@"融资需求"])
//        {
//            [self.midLabel setHidden:YES];
//            self.AssetTypeLabel.text = self.model.AssetType;
////            [self.TransMoneyImage setHidden:YES];
//            self.TotalMoney.text = self.model.Rate;
//            self.TotalMoneyImage.image = [UIImage imageNamed:@"huibaolv"];
//            [self.wan2 setHidden:YES];
//            [self.wan1 setHidden:YES];
//        }
        else
        {
            [self.midLabel setHidden:YES];
            
        }
//    }
    if ([self.model.TypeName isEqualToString:@"资产包转让"])
    {
        [self.midLabel setHidden:NO];
        self.midLabel.text = @"来源：";
        self.TotalMoney.text = self.model.TotalMoney;
        self.TransferMoney.text = self.model.TransferMoney;
        self.rightChangeLabel.text = @"转让价";
        self.leftChangeLabel.text = @"总金额";
        self.TotalMoneyImage.image = [UIImage imageNamed:@"zongjine"];
        self.TransMoneyImage.image = [UIImage imageNamed:@"zhuanrangjia"];
        [self.TotalMoney setHidden:NO];
        [self.TransferMoney setHidden:NO];
        [self.wan2 setHidden:NO];
        [self.wan1 setHidden:NO];
        [self.TransMoneyImage setHidden:NO];
//        [self.TotalMoney.text stringByAppendingString:@"万"];
//        [self.TransferMoney.text stringByAppendingString:@"万"];
    }
    else if ([self.model.TypeName isEqualToString:@"委外催收"])
    {
        self.TotalMoney.text = self.model.TotalMoney;
        self.TransferMoney.text = self.model.Rate;
        NSLog(@"??????????????%@",self.model.Rate);
        [self.wan2 setHidden:YES];
        [self.wan1 setHidden:NO];
    }
    else if ([self.model.TypeName isEqualToString:@"法律服务"])
    {
        self.TotalMoney.text = self.model.Requirement;
        self.diquLabel.text = @"地区：";
        self.leftChangeLabel.text = @"需求";
//        self.downLabel.text = @"类型";
        
        [self.TransferMoney setHidden:YES];
        [self.rightChangeLabel setHidden:YES];
        [self.TransMoneyImage setHidden:YES];
        self.TotalMoneyImage.image = [UIImage imageNamed:@"xuqiu"];
        [self.midLabel setHidden:YES];
        self.AssetTypeLabel.text = self.model.AssetType;
        [self.wan2 setHidden:YES];
        [self.wan1 setHidden:YES];
        
    }
//    else if ([self.model.TypeName isEqualToString:@"商业保理"])
//    {
//        [self.TransferMoney setHidden:YES];
//        [self.TransMoneyImage setHidden:YES];
//        self.TotalMoney.text = self.model.TotalMoney;
//        self.leftChangeLabel.text = @"金额";
//        [self.rightChangeLabel setHidden:YES];
//        [self.midLabel setHidden:YES];
//        [self.wan2 setHidden:YES];
//        [self.wan1 setHidden:NO];
//
//        
//    }
    else if ([self.model.TypeName isEqualToString:@"融资需求"])
    {
        
        [self.TransferMoney setHidden:NO];
        self.TransferMoney.text = [self.model.Rate stringByAppendingString:@"%"];
        [self.TransMoneyImage setHidden:NO];
        self.TransMoneyImage.image = [UIImage imageNamed:@"huibaolv"];
        
//        [self.rightChangeLabel setHidden:YES];
        self.downLabel.text = @"方式：";
        self.leftChangeLabel.text = @"金额";
        self.TotalMoney.text = self.model.TotalMoney;
        self.TotalMoneyImage.image = [UIImage imageNamed:@"jine"];
        [self.midLabel setHidden:YES];
        [self.wan2 setHidden:YES];
        [self.wan1 setHidden:NO];
        
    }
    else if ([self.model.TypeName isEqualToString:@"典当担保"])
    {
        [self.TransferMoney setHidden:YES];
        [self.rightChangeLabel setHidden:YES];
        self.leftChangeLabel.text = @"金额";
//        self.downLabel.text = @"类型：";
        [self.downLabel setHidden:NO];
        self.TotalMoney.text = self.model.TotalMoney;
        [self.TransMoneyImage setHidden:YES];
        self.TotalMoneyImage.image = [UIImage imageNamed:@"jine"];
//        [self.midLabel setHidden:NO];
        [self.wan2 setHidden:YES];
        [self.wan1 setHidden:NO];
    }
    else if ([self.model.TypeName isEqualToString:@"悬赏信息"])
    {
        self.model.TotalMoney = [NSString stringWithFormat:@"%@",self.model.TotalMoney];
        self.TotalMoney.text = [self.model.TotalMoney stringByAppendingString:@"元"];
    self.leftChangeLabel.text = @"金额";
        self.diquLabel.text = @"目标地区：";
        
        self.TotalMoneyImage.image = [UIImage imageNamed:@"jine"];
        [self.midLabel setHidden:YES];
        self.AssetTypeLabel.text = self.model.AssetType;
        [self.TransMoneyImage setHidden:YES];
        [self.TransferMoney setHidden:YES];
        [self.rightChangeLabel setHidden:YES];
        [self.wan2 setHidden:YES];
        [self.wan1 setHidden:YES];
    }
    else if ([self.model.TypeName isEqualToString:@"尽职调查"])
    {
        self.TotalMoney.text = self.model.Informant;
      self.leftChangeLabel.text = @"被调查方";
        self.downLabel.text = @"类型：";
        self.TotalMoneyImage.image = [UIImage imageNamed:@"beidiaochafang"];
        [self.TransMoneyImage setHidden:YES];
        [self.TransferMoney setHidden:YES];
        [self.rightChangeLabel setHidden:YES];
        [self.midLabel setHidden:YES];
        [self.wan2 setHidden:YES];
        [self.wan1 setHidden:YES];

        
    }
    else if ([self.model.TypeName isEqualToString:@"固产转让"])
    {
        self.TotalMoney.text = self.model.TransferMoney;
        self.leftChangeLabel.text = @"转让价";
        [self.rightChangeLabel setHidden:YES];
        [self.TransferMoney setHidden:YES];
        [self.TransMoneyImage setHidden:YES];
        [self.midLabel setHidden:YES];
        [self.wan2 setHidden:YES];
        [self.wan1 setHidden:NO];
        
        self.TotalMoneyImage.image = [UIImage imageNamed:@"zhuanrangjia"];
        
    }
    else if ([self.model.TypeName isEqualToString:@"资产求购"])
    {
        
//        [self.TotalMoney.frame.size.width = 100];
        [self.rightChangeLabel setHidden:YES];
        [self.TransferMoney setHidden:YES];
        self.TotalMoney.text = self.model.Buyer;
        self.leftChangeLabel.text = @"求购方";
        
        [self.TransMoneyImage setHidden:YES];
        self.TotalMoneyImage.image = [UIImage imageNamed:@"qiugoufang"];
        [self.midLabel setHidden:YES];
        [self.wan2 setHidden:YES];
        [self.wan1 setHidden:YES];
        
    }
    else if ([self.model.TypeName isEqualToString:@"债权转让"])
    {
        self.TotalMoney.text = self.model.TotalMoney;
        self.TransferMoney.text = self.model.TransferMoney;
        self.leftChangeLabel.text = @"金额";
        [self.TransferMoney setHidden:NO];
        [self.TransMoneyImage setHidden:NO];
        self.TransMoneyImage.image = [UIImage imageNamed:@"zhuanrangjia"];
        self.TotalMoneyImage.image = [UIImage imageNamed:@"jine"];
        [self.wan2 setHidden:NO];
        [self.wan1 setHidden:NO];
        self.rightChangeLabel.text = @"转让价";
        [self.midLabel setHidden:YES];

        
    }
  else if([self.model.TypeName isEqualToString:@"投资需求"])
  {
      [self.midLabel setHidden:NO];
      self.ProAreaLabel.text = self.model.ProArea;
      self.FromWhere.text = self.model.investType;
      [self.TotalMoney setHidden:NO];
      [self.TransferMoney setHidden:NO];
      self.TotalMoney.text = self.model.Year;
      
      self.TransferMoney.text = [self.model.Rate stringByAppendingString:@"%"];
      [self.wan1 setHidden:NO];
      [self.wan2 setHidden:YES];
      self.wan1.text = @"年";
      [self.TotalMoneyImage setHidden:NO];
      [self.TransferMoney setHidden:NO];
      self.TotalMoneyImage.image = [UIImage imageNamed:@"year"];
      self.TransMoneyImage.image = [UIImage imageNamed:@"huibaolv"];
      self.midLabel.text = @"投资方式：";
      self.diquLabel.text = @"投资地区：";
      self.downLabel.text = @"投资类型：";
  }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
