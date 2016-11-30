//
//  FindInfoCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/3.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FindInfoCell.h"

@interface FindInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *TypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *FromWhere;
@property (weak, nonatomic) IBOutlet UILabel *AssetTypeLabel;


//需要判断的控件
@property (weak, nonatomic) IBOutlet UILabel *TotalMoney;
@property (weak, nonatomic) IBOutlet UILabel *TransferMoney;
@property (weak, nonatomic) IBOutlet UILabel *leftChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;

@property (weak, nonatomic) IBOutlet UIImageView *TotalMoneyImage;
@property (weak, nonatomic) IBOutlet UIImageView *TransMoneyImage;

@end


@implementation FindInfoCell




- (void)setModel:(PublishModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setDataForCell];
    }
}
- (void)setDataForCell
{
    self.TypeNameLabel.text = self.model.TypeName;
    self.ProAreaLabel.text = self.model.ProArea;
    self.FromWhere.text = self.model.FromWhere;
    self.AssetTypeLabel.text = self.model.AssetType;
    
    
    if ([self.model.TypeName isEqualToString:@"资产包转让"] || [self.model.TypeName isEqualToString:@"委外催收"] || [self.model.TypeName isEqualToString:@"商业保理"] || [self.model.TypeName isEqualToString:@"融资借贷"]) {
        if ([self.model.TypeName isEqualToString:@"资产包转让"]) {
            self.TotalMoney.text = self.model.TotalMoney;
            self.TransferMoney.text = self.model.TransferMoney;
            self.rightChangeLabel.text = @"转让价";
            self.leftChangeLabel.text = @"金额";
        }
        else if([self.model.TypeName isEqualToString:@"委外催收"])
        {
            self.midLabel.text = @"状态：";
            self.FromWhere.text = self.model.Status;
            self.TransMoneyImage.image = [UIImage imageNamed:@"yongjin"];
            
            
        }
        else if([self.model.TypeName isEqualToString:@"商业保理"])
        {
            [self.midLabel setHidden:YES];
            self.AssetTypeLabel.text = @"买方性质：";
            [self.TransMoneyImage setHidden:YES];
            
            
        }
        else if([self.model.TypeName isEqualToString:@"融资借贷"])
        {
            [self.midLabel setHidden:YES];
            self.AssetTypeLabel.text = @"方式：";
            //            [self.TransMoneyImage setHidden:YES];
            
            
        }
        else
        {
            [self.midLabel setHidden:YES];
            
        }
    }
    
    
    if ([self.model.TypeName isEqualToString:@"资产包转让"])
    {
        self.TotalMoney.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.TransferMoney.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.rightChangeLabel.text = @"转让价";
        self.leftChangeLabel.text = @"金额";
        [self.TotalMoney.text stringByAppendingString:@"万"];
        [self.TransferMoney.text stringByAppendingString:@"万"];
    }
    else if ([self.model.TypeName isEqualToString:@"委外催收"])
    {
        self.TotalMoney.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.TransferMoney.text = self.model.Rate;
        NSLog(@"??????????????%@",self.model.Rate);
        
    }
    else if ([self.model.TypeName isEqualToString:@"法律服务"])
    {
//        self.TotalMoney.text = self.model.Requirement;
        self.leftChangeLabel.text = @"需求";
        
        [self.TransferMoney setHidden:YES];
        [self.rightChangeLabel setHidden:YES];
        [self.TransMoneyImage setHidden:YES];
        self.TotalMoneyImage.image = [UIImage imageNamed:@"xuqiu"];
        [self.midLabel setHidden:YES];
        self.AssetTypeLabel.text = self.model.AssetType;
        
        
    }
    else if ([self.model.TypeName isEqualToString:@"商业保理"])
    {
        [self.TransferMoney setHidden:YES];
        [self.TransMoneyImage setHidden:YES];
        self.TotalMoney.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.leftChangeLabel.text = @"金额";
        [self.rightChangeLabel setHidden:YES];
        [self.midLabel setHidden:YES];
        
        
    }
    else if ([self.model.TypeName isEqualToString:@"融资借贷"])
    {
        self.TransferMoney.text = self.model.Rate;
        [self.rightChangeLabel setHidden:YES];
        self.leftChangeLabel.text = @"金额";
        self.TotalMoney.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        [self.midLabel setHidden:YES];
        
        
    }
    else if ([self.model.TypeName isEqualToString:@"典当担保"])
    {
        [self.TransferMoney setHidden:YES];
        [self.rightChangeLabel setHidden:YES];
        self.leftChangeLabel.text = @"金额";
        self.TotalMoney.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        [self.TransMoneyImage setHidden:YES];
        [self.midLabel setHidden:YES];
        
        
        
    }
    else if ([self.model.TypeName isEqualToString:@"悬赏信息"])
    {
        self.TotalMoney.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.leftChangeLabel.text = @"金额";
        self.TotalMoneyImage.image = [UIImage imageNamed:@"huibaolv"];
        [self.midLabel setHidden:YES];
        self.AssetTypeLabel.text = self.model.AssetType;
        [self.TransMoneyImage setHidden:YES];
        
        
        
    }
    else if ([self.model.TypeName isEqualToString:@"尽职调查"])
    {
//        self.TotalMoney.text = self.model.Informant;
        self.leftChangeLabel.text = @"被调查方";
        
        [self.TransferMoney setHidden:YES];
        [self.rightChangeLabel setHidden:YES];
        [self.midLabel setHidden:YES];
        
        
    }
    else if ([self.model.TypeName isEqualToString:@"固产转让"])
    {
        self.TotalMoney.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.leftChangeLabel.text = @"转让价";
        [self.rightChangeLabel setHidden:YES];
        [self.TransferMoney setHidden:YES];
        [self.TransMoneyImage setHidden:YES];
        [self.midLabel setHidden:YES];
        
        self.TotalMoneyImage.image = [UIImage imageNamed:@"zhuanrangjia"];
        
    }
    else if ([self.model.TypeName isEqualToString:@"资产求购"])
    {
        
        //        [self.TotalMoney.frame.size.width = 100];
        [self.rightChangeLabel setHidden:YES];
        [self.TransferMoney setHidden:YES];
//        self.TotalMoney.text = self.model.Buyer;
        self.leftChangeLabel.text = @"求购方";
        [self.TransMoneyImage setHidden:YES];
        self.TotalMoneyImage.image = [UIImage imageNamed:@"qiugou"];
        [self.midLabel setHidden:YES];
        
        
        
    }
    else if ([self.model.TypeName isEqualToString:@"债权转让"])
    {
        self.TotalMoney.text = [self.model.TotalMoney stringByAppendingString:@"万"];
        self.TransferMoney.text = [self.model.TransferMoney stringByAppendingString:@"万"];
        self.leftChangeLabel.text = @"金额";
        self.rightChangeLabel.text = @"转让价";
        [self.midLabel setHidden:YES];
        
        
    }
    
    
    
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
