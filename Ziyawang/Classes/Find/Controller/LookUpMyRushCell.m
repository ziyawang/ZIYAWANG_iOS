//
//  LookUpMyRushCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/8.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "LookUpMyRushCell.h"

@interface LookUpMyRushCell ()
@property (weak, nonatomic) IBOutlet UILabel *TypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *FromWhere;
@property (weak, nonatomic) IBOutlet UILabel *AssetTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *diquLabel;
@property (weak, nonatomic) IBOutlet UILabel *laiyuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *wan1;
@property (weak, nonatomic) IBOutlet UILabel *wan2;

//需要判断的控件
@property (weak, nonatomic) IBOutlet UILabel *TotalMoney;
@property (weak, nonatomic) IBOutlet UILabel *TransferMoney;
@property (weak, nonatomic) IBOutlet UILabel *leftChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *asettyoeWidth;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoqiangdanButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FromWhereWidth;
@property (weak, nonatomic) IBOutlet UIImageView *TotalMoneyImage;
@property (weak, nonatomic) IBOutlet UIImageView *TransMoneyImage;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSString *ProjectID;
@end

@implementation LookUpMyRushCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cancelButtonAction:(id)sender {
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *url1= @"http://api.ziyawang.com/v1";
    NSString *url2 = @"/project/rushcancel?token=";
    NSString *url = [url1 stringByAppendingString:url2];
    NSString *URL = [[[url stringByAppendingString:token]stringByAppendingString:@"&access_token="]stringByAppendingString:@"token"];
//    NSString *URL = [[url stringByAppendingString:token]stringByAppendingString:self.model.ProjectID];
      NSLog(@"-------%@",URL);
    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:self.model.ProjectID forKey:@"ProjectID"];
//    [dic setObject:@"token" forKey:@"access_token"];
//    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.model.ProjectID forKey:@"ProjectID"];
    
    
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *dic = [NSDictionary new];
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"~~~~~~~~~~~~~~%@",dic);
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"成功取消抢单" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        
        NSLog(@"取消抢单成功");
//        [self.quxiaoqiangdanButton setHidden:YES];
        [self.quxiaoqiangdanButton setUserInteractionEnabled:NO];
        [self.quxiaoqiangdanButton.titleLabel setText:@"已取消"];

//        [self.quxiaoqiangdanButton setTitle:@"已取消" forState:(UIControlStateNormal)];
//        [self.quxiaoqiangdanButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        
//        self.quxiaoqiangdanButton.selected = YES;
        //通知页面刷新;
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"--------%@",error);
        NSLog(@"取消抢单失败");
        
    }];
    
    
}

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
    
    [self.quxiaoqiangdanButton setUserInteractionEnabled:YES];

    self.diquLabel.font = [UIFont FontForLabel];
    self.downLabel.font = [UIFont FontForLabel];
    self.midLabel.font = [UIFont FontForLabel];
    self.TypeNameLabel.text = self.model.TypeName;
    
    [self.wan1 setHidden:NO];
    [self.wan2 setHidden:NO];
    
    
    self.FromWhereWidth.constant = [self getwidth];
    self.asettyoeWidth.constant = [self getwidth];
    
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
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
