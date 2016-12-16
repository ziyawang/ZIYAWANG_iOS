//
//  KnowVipController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/14.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "KnowVipController.h"

@interface KnowVipController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (nonatomic,strong) NSArray *imageNameArray;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

@end

@implementation KnowVipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"了解特权";
    self.imageNameArray = @[@"superbao",@"superqi",@"supergu",@"superrong",@"superge",@"superSvip"];

    switch (self.vipType.integerValue) {
        case 1:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[0]];

            self.label1.text = @"在会员期间内，可免费查看本网站所有资产包类VIP和收费信息。";
            self.label2.text = @"按办理会员的价格赠送芽币（例：月度会员6498元赠送6498芽币）。可方便您查看其他类型信息。";
            self.label3.text = @"系统会根据您的指定需求帮您筛选指定的资产包信息，并推送到您的系统消息或手机短信中（客服人员会主动联系您录入需求）。";
            self.label4.text = @"升级为会员后，您服务方的展示页面联系方式将公开，会有更多用户第一时间主动联系您。";
            break;
        case 2:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[1]];
            self.label1.text = @"在会员期间内，可免费查看本网站所有企业商账类VIP和收费信息。";
            self.label2.text = @"按办理会员的价格赠送芽币（例：季度会员1498元赠送1498芽币，年度会员4998元赠送4998芽币）。可方便您查看其他类型信息。";
            self.label3.text = @"系统会根据您的指定需求帮您筛选指定的企业商账信息，并推送到您的系统消息或手机短信中（客服人员会主动联系您录入需求）。";
            self.label4.text = @"升级为会员后，您服务方的展示页面联系方式将公开，会有更多用户第一时间主动联系您。";
            break;
        case 3:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[2]];
            self.label1.text = @"在会员期间内，可免费查看本网站所有固定资产类VIP和收费信息。";
            self.label2.text = @"按办理会员的价格赠送芽币（例：季度会员3998元赠送3998芽币）。可方便您查看其他类型信息。";
            self.label3.text = @"系统会根据您的指定需求帮您筛选指定的固定资产信息，并推送到您的系统消息或手机短信中（客服人员会主动联系您录入需求）。";
            self.label4.text = @"升级为会员后，您服务方的展示页面联系方式将公开，会有更多用户第一时间主动联系您。";
            break;
        case 4:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[3]];

            self.label1.text = @"在会员期间内，可免费查看本网站所有融资信息类VIP和收费信息。";
            self.label2.text = @"按办理会员的价格赠送芽币（例：季度会员998元赠送998芽币，年度会员2998元赠送2998芽币）。可方便您查看其他类型信息。";
            self.label3.text = @"系统会根据您的指定需求帮您筛选指定的融资信息信息，并推送到您的系统消息或手机短信中（客服人员会主动联系您录入需求）。";
            self.label4.text = @"升级为会员后，您服务方的展示页面联系方式将公开，会有更多用户第一时间主动联系您";
            break;
        case 5:
            self.bigImageView.image = [UIImage imageNamed:self.imageNameArray[4]];

            self.label1.text = @"在会员期间内，可免费查看本网站所有个人债权类VIP和收费信息。";
            self.label2.text = @"按办理会员的价格赠送芽币（例：季度会员998元赠送998芽币，年度会员2998元赠送2998芽币）。可方便您查看其他类型信息。";
            self.label3.text = @"系统会根据您的指定需求帮您筛选指定的个人债权信息，并推送到您的系统消息或手机短信中（客服人员会主动联系您录入需求）。";
            self.label4.text = @"升级为会员后，您服务方的展示页面联系方式将公开，会有更多用户第一时间主动联系您";
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
