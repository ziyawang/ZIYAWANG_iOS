//
//  CostDetailController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/9/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CostDetailController.h"

@interface CostDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *CostType;
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;
@property (weak, nonatomic) IBOutlet UILabel *yabiLabel;
@property (weak, nonatomic) IBOutlet UILabel *type2;
@property (weak, nonatomic) IBOutlet UILabel *TimeLAbel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;

@end

@implementation CostDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
    // Do any additional setup after loading the view from its nib.
}
- (void)setViews
{
    self.navigationItem.title = @"明细";
    self.TimeLAbel.text = self.costTime;
    self.orderNumber.text = self.ordernumber;
    self.operationLabel.text = self.operate;
    if ([self.Type isEqualToString:@"1"]) {
        self.CostType.text = @"充值芽币";
        self.CountLabel.text = [@"+"stringByAppendingString:self.costCount];
        self.yabiLabel.textColor = [UIColor colorWithHexString:@"#90c31f"];
        self.CountLabel.textColor = [UIColor colorWithHexString:@"#90c31f"];
        self.type2.text = @"充值";
    }
    else
    {
        self.ProjectID = [NSString stringWithFormat:@"%@",self.ProjectID];
        
        if ([self.ProjectID isEqualToString:@"0"]) {
            self.CostType.text = @"付费视频";
        }
        else
        {
        self.CostType.text = @"付费约谈";
        }
        self.CountLabel.text = [@"-"stringByAppendingString:self.costCount];
        self.yabiLabel.textColor = [UIColor colorWithHexString:@"#eb6155"];
        self.CountLabel.textColor = [UIColor colorWithHexString:@"#eb6155"];
        self.type2.text = @"付费";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
