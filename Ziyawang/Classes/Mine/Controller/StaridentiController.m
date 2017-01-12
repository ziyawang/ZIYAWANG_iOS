//
//  StaridentiController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/22.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "StaridentiController.h"
#import "GoldCertiViewController.h"
#import "AreaCertiController.h"
#import "VideoCertiController.h"
#import "PromiseBookController.h"
#import "ThreeBookController.h"
@interface StaridentiController ()
@property (weak, nonatomic) IBOutlet UIImageView *starima1;
@property (weak, nonatomic) IBOutlet UIImageView *starima2;
@property (weak, nonatomic) IBOutlet UIImageView *starima3;
@property (weak, nonatomic) IBOutlet UIImageView *starima4;
@property (weak, nonatomic) IBOutlet UIImageView *starima5;
@property (weak, nonatomic) IBOutlet UIButton *detailButton1;
@property (weak, nonatomic) IBOutlet UIButton *detailButton2;
@property (weak, nonatomic) IBOutlet UIButton *detailButton3;
@property (weak, nonatomic) IBOutlet UIButton *detailButton4;
@property (weak, nonatomic) IBOutlet UIButton *detailButton5;

@property (weak, nonatomic) IBOutlet UIButton *openButton1;
@property (weak, nonatomic) IBOutlet UIButton *openButton2;
@property (weak, nonatomic) IBOutlet UIButton *openButton3;
@property (weak, nonatomic) IBOutlet UIButton *openButton4;
@property (weak, nonatomic) IBOutlet UIButton *openButton5;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UIView *PromiseView;
@property (nonatomic,strong) NSMutableDictionary *starStatuDic;
@end

@implementation StaridentiController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserInfoFromDomin];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title = @"星级认证";
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self setViews];
  }

- (void)getUserInfoFromDomin
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    //    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    if (token != nil) {
        NSString *URL = [[getUserInfoURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"token" forKey:@"access_token"];
        [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"user"][@"right"] forKey:@"right"];
            
            NSDictionary *starDic = dic[@"service"][@"showlevelarr"];
            NSMutableDictionary *starArray = [NSMutableDictionary dictionaryWithDictionary:starDic];
            
            starArray[@"1"] = [NSString stringWithFormat:@"%@",starArray[@"1"]];
            starArray[@"2"] = [NSString stringWithFormat:@"%@",starArray[@"2"]];
            starArray[@"3"] = [NSString stringWithFormat:@"%@",starArray[@"3"]];
            starArray[@"4"] = [NSString stringWithFormat:@"%@",starArray[@"4"]];
            starArray[@"5"] = [NSString stringWithFormat:@"%@",starArray[@"5"]];

            self.starStatuDic = starArray;
            
            if ([starArray[@"1"] isEqualToString:@"2"]) {
                [self.openButton1 setTitle:@"已开通" forState:(UIControlStateNormal)];
                
                self.starima1.image = [UIImage imageNamed:@"baozhengjin"];
            }
            else if([starArray[@"1"] isEqualToString:@"0"])
            {
                self.openButton1.titleLabel.text = @"开通";

            }
            else if([starArray[@"1"] isEqualToString:@"1"])
            {
                [self.openButton1 setTitle:@"审核中" forState:(UIControlStateNormal)];
            }
            else
            {
                [self.openButton1 setTitle:@"未通过" forState:(UIControlStateNormal)];
   
            }
            
            if ([starArray[@"2"] isEqualToString:@"2"]) {
                [self.openButton2 setTitle:@"已开通" forState:(UIControlStateNormal)];

                self.starima2.image = [UIImage imageNamed:@"shi"];
            }
            else if([starArray[@"2"] isEqualToString:@"0"])
            {
                self.openButton2.titleLabel.text = @"开通";

            }
            else if([starArray[@"2"] isEqualToString:@"1"])
            {
                [self.openButton2 setTitle:@"审核中" forState:(UIControlStateNormal)];

            }
            else
            {
                [self.openButton2 setTitle:@"未通过" forState:(UIControlStateNormal)];

            }
            
            if ([starArray[@"3"] isEqualToString:@"2"]) {
                [self.openButton3 setTitle:@"已开通" forState:(UIControlStateNormal)];

                self.starima3.image = [UIImage imageNamed:@"shipin"];
            }
            else if([starArray[@"3"] isEqualToString:@"0"])
            {
                self.openButton3.titleLabel.text = @"开通";

            }
            else if([starArray[@"3"] isEqualToString:@"1"])
            {
                [self.openButton3 setTitle:@"审核中" forState:(UIControlStateNormal)];

            }
            else
            {
                [self.openButton3 setTitle:@"未通过" forState:(UIControlStateNormal)];

            }
            if ([starArray[@"4"] isEqualToString:@"2"]) {
                [self.openButton4 setTitle:@"已开通" forState:(UIControlStateNormal)];

                self.starima4.image = [UIImage imageNamed:@"nuo"];
            }
            else if([starArray[@"4"] isEqualToString:@"0"])
            {
                self.openButton4.titleLabel.text = @"开通";

            }
            else if([starArray[@"4"] isEqualToString:@"1"])
            {
                [self.openButton4 setTitle:@"审核中" forState:(UIControlStateNormal)];

            }
            else
            {
                [self.openButton4 setTitle:@"未通过" forState:(UIControlStateNormal)];

            }
            if ([starArray[@"5"] isEqualToString:@"2"]) {
                self.starima5.image = [UIImage imageNamed:@"zheng"];
                [self.openButton5 setTitle:@"已开通" forState:(UIControlStateNormal)];

            }
        
            else if([starArray[@"5"] isEqualToString:@"0"])
            {
                self.openButton5.titleLabel.text = @"开通";

            }
            else if([starArray[@"5"] isEqualToString:@"1"])
            {
                [self.openButton5 setTitle:@"审核中" forState:(UIControlStateNormal)];
            }
            else
            {
                [self.openButton5 setTitle:@"未通过" forState:(UIControlStateNormal)];

            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
}


- (void)setViews
{
    [self setButtonWithButton:self.detailButton1];
    [self setButtonWithButton:self.detailButton2];
    [self setButtonWithButton:self.detailButton3];
    [self setButtonWithButton:self.detailButton4];
    [self setButtonWithButton:self.detailButton5];

    [self setButtonWithButton:self.openButton1];
    [self setButtonWithButton:self.openButton2];
    [self setButtonWithButton:self.openButton3];
    [self setButtonWithButton:self.openButton4];
    [self setButtonWithButton:self.openButton5];

}

- (void)setPromiseViewWithButtonTag:(NSInteger)tag
{
    UIView *mengbanView= [UIView new];
    UIView *weituoView = [UIView new];
    UIImageView *tuziImage = [UIImageView new];
    UIView *imageBackView = [UIView new];
    
    UIView *bottomView = [UIView new];
    
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    
    
    UIButton *fabuButton = [UIButton new];
    UIButton *fanhuiButton = [UIButton new];
    UIButton *cancelButton = [UIButton new];
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:mengbanView];
    
    [mengbanView addSubview:weituoView];
    [weituoView addSubview:imageBackView];
    [imageBackView addSubview:tuziImage];
    [imageBackView addSubview:cancelButton];
    [weituoView addSubview:bottomView];
    
    [bottomView addSubview:label1];
    [bottomView addSubview:label2];
    [bottomView addSubview:label3];
    
    [bottomView addSubview:fabuButton];
    [bottomView addSubview:fanhuiButton];
    
    mengbanView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    imageBackView.backgroundColor = [UIColor colorWithHexString:@"#5dc1cf"];
    weituoView.backgroundColor = [UIColor whiteColor];
    
    
    
    mengbanView.sd_layout.leftSpaceToView(window,0)
    .rightSpaceToView(window,0)
    .topSpaceToView(window,0)
    .bottomSpaceToView(window,0);
    
    weituoView.sd_layout.centerXEqualToView(mengbanView)
    .centerYIs(self.view.centerY)
    .widthIs(285 * kWidthScale);
    
    
    imageBackView.sd_layout.leftSpaceToView(weituoView,0)
    .rightSpaceToView(weituoView,0)
    .heightIs(140 * kHeightScale)
    .topSpaceToView(weituoView,0);
    
    tuziImage.sd_layout.centerXEqualToView(imageBackView)
    .centerYEqualToView(imageBackView)
    .heightIs(95*kHeightScale)
    .widthIs(90*kWidthScale);
    tuziImage.image = [UIImage imageNamed:@"TUZI"];
    
    bottomView.sd_layout.leftSpaceToView(weituoView,0)
    .rightSpaceToView(weituoView,0)
    .topSpaceToView(imageBackView,0);
    
    label2.font = [UIFont systemFontOfSize:14];
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = [UIColor redColor];
    
    
    
    
    
    label1.sd_layout.centerXEqualToView(bottomView)
    .topSpaceToView(bottomView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    
    label2.sd_layout.leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15)
    .topSpaceToView(label1,15)
    .autoHeightRatio(0);
    label3.textAlignment = NSTextAlignmentLeft;
    
    switch (tag) {
        case 1:
            label1.text = @"保证金认证 ";
            label2.text = @"本认证是针对服务方在注册/使用资芽网过程中的一项行为认证标准 ，用以保证服务方以合法的操作行为使用本网站，不得盗取本网站的信息从事违法行为、牟取暴利，并保证所填写的相关信息真实有效。开通后将点亮本认证星级，并在服务方展示页面进行展示。";
            label3.text = @"注：保证金认证可在缴纳三个月后随时申请取消（取消认证后本网站将全额退还保证金）。";
            break;
        case 2:
            label1.text = @"实地认证";
            label2.text = @"本认证是由本网站认证人员前往服务方所在地实地考察，并依据本网站实地认证标准现场取证（如：经营场所拍照、人员拍照、实地访谈等）、材料备档。开通认证成功后将点亮本认证星级，并在服务方展示页面进行展示。";
            label3.text = @"注：实地认证成功后不可申请取消及退款（如遇地址变更等特殊原因可致电资芽网）";
            break;
        case 3:
            label1.text = @"视频认证";
            label2.text = @"本认证是由服务方按资芽网要求自主完成，需由服务方持拍摄设备（摄像机或手机）对服务方的经营场所（如：门头、企业名称、办公环境等）及相关员工，进行视频拍摄（一分钟以内），并同时口述相关拍摄内容（如：这是我们的员工、这是我们的前台或这是我们的会议室等），拍摄完成后，传与资芽网客服人员备档。开通认证成功后将点亮本认证星级，并在服务方展示页面进行展示。";
            label3.text = @"注：视频认证成功后不可申请取消及退款（如遇地址变更等特殊原因可致电资芽网）";
            break;
        case 4:
            label1.text = @"承诺书认证";
            label2.text = @"本认证不收取任何费用，由服务方点击“开通”按钮，下载承诺书并签字盖章上传至本网站；开通认证成功后将点亮本认证星级，并在服务方展示页面进行展示。";
            label3.text = @"注：承诺书认证成功后不可申请取消（如遇企业变更等特殊原因可致电资芽网）";
            break;
        case 5:
            label1.text = @"三证认证";
            label2.text = @"本认证不收取任何费用，由服务方点击“开通”按钮，上传三证原件（营业执照、组织机构代码证、税务登记证）或三证合一证件原件；开通认证成功后将点亮本认证星级，并在服务方展示页面进行展示（本网站将做水印和模糊处理，请放心上传）。";
            label3.text = @"注：三证认证成功后不可申请取消（如遇企业变更等特殊原因可致电资芽网）";
            break;
            
        default:
            break;
    }

    
    
    
    
    
    fabuButton.sd_layout.leftEqualToView(label2)
    .rightEqualToView(label2)
    .topSpaceToView(label2,20)
    .heightIs(40*kHeightScale);
    [fabuButton setTitle:@"关闭" forState:(UIControlStateNormal)];
    fabuButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
    
    label3.sd_layout.leftEqualToView(label2)
    .rightEqualToView(label2)
    .topSpaceToView(fabuButton,15)
    .autoHeightRatio(0);
    
    [bottomView setupAutoHeightWithBottomView:label3 bottomMargin:15];
    [weituoView setupAutoHeightWithBottomView:bottomView bottomMargin:10];
    

    
//    fanhuiButton.sd_layout.leftEqualToView(label2)
//    .rightEqualToView(label2)
//    .topSpaceToView(fabuButton,20)
//    .heightIs(40*kHeightScale);
//    fanhuiButton.layer.borderWidth = 1.5;
//    fanhuiButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
//    
    
//    cancelButton.sd_layout.rightSpaceToView(imageBackView,10)
//    .topSpaceToView(imageBackView,10)
//    .heightIs(25)
//    .widthIs(25);
//    
//    
//    
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
//    [cancelButton addTarget:self action:@selector(weituoCancelAction2:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    [fanhuiButton setTitle:@"不承诺" forState:(UIControlStateNormal)];
//    [fanhuiButton addTarget:self action:@selector(didClickFanhuiButtonAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [fabuButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [fanhuiButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [fabuButton addTarget:self action:@selector(didClickWeituoFabuAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //    self.weituoView = weituoView;
    weituoView.layer.cornerRadius = 10;
    weituoView.layer.masksToBounds = YES;
    self.PromiseView = mengbanView;
    //    [self.PromiseView setHidden:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didClickWeituoFabuAction2:(UIButton*)button
{
    [self.PromiseView removeFromSuperview];
    
}
- (void)setButtonWithButton:(UIButton *)button
{
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button addTarget:self action:@selector(didClickButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)didClickButtonAction:(UIButton *)button
{
    switch (button.tag) {
        case 1:
            [self setPromiseViewWithButtonTag:1];
            break;
        case 2:
             [self setPromiseViewWithButtonTag:2];
            break;
        case 3:
             [self setPromiseViewWithButtonTag:3];
            break;
        case 4:
             [self setPromiseViewWithButtonTag:4];
            break;
        case 5:
             [self setPromiseViewWithButtonTag:5];
            break;
            //0 开通 1 审核中 2 已认证 3 未通过
        case 6:
        {
            if ([self.starStatuDic[@"1"] isEqualToString:@"2"] == NO && [self.starStatuDic[@"1"] isEqualToString:@"1"] == NO) {
                GoldCertiViewController *goldVC = [[GoldCertiViewController alloc]init];
                [self.navigationController pushViewController:goldVC animated:YES];
            }
            else
            {
                GoldCertiViewController *goldVC = [[GoldCertiViewController alloc]init];
                goldVC.statu = @"已支付";
                
                [self.navigationController pushViewController:goldVC animated:YES];
            
            }
        }
            break;
        case 7:
        {
            if ([self.starStatuDic[@"2"] isEqualToString:@"2"] == NO && [self.starStatuDic[@"2"] isEqualToString:@"1"] == NO) {
                AreaCertiController *areaVC = [[AreaCertiController alloc]init];
                [self.navigationController pushViewController:areaVC animated:YES];
            }
            else
            {
                AreaCertiController *areaVC = [[AreaCertiController alloc]init];
                areaVC.statu = @"已支付";
                [self.navigationController pushViewController:areaVC animated:YES];
            }
        }
            break;
        case 8:
        {
            if ([self.starStatuDic[@"3"] isEqualToString:@"2"] == NO && [self.starStatuDic[@"3"] isEqualToString:@"1"] == NO) {
                VideoCertiController *videoVC = [[VideoCertiController alloc]init];
                [self.navigationController pushViewController:videoVC animated:YES];
            }
            else
            {
                VideoCertiController *videoVC = [[VideoCertiController alloc]init];
                videoVC.statu = @"已支付";
                [self.navigationController pushViewController:videoVC animated:YES];
            }
           
        }
            break;
        case 9:
        {
            if ([self.starStatuDic[@"4"] isEqualToString:@"2"] == NO && [self.starStatuDic[@"4"] isEqualToString:@"1"] == NO) {
                PromiseBookController *proVC = [[PromiseBookController alloc]init];
                [self.navigationController pushViewController:proVC animated:YES];
            }
        }
            break;
        case 10:
        {
            if ([self.starStatuDic[@"5"] isEqualToString:@"2"] == NO && [self.starStatuDic[@"5"] isEqualToString:@"1"] == NO) {
                ThreeBookController *threeVC = [[ThreeBookController alloc]init];
                [self.navigationController pushViewController:threeVC animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    
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
