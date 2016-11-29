//
//  DetailOfInfoController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "DetailOfInfoController.h"

@interface DetailOfInfoController ()
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *imageBackView;
@property (nonatomic,strong) UIView *changeView;

@property (nonatomic,strong) UIView *ContentView;

@end

@implementation DetailOfInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.Type = @"2";
    [self getInfoData];
    

    
}

- (void)getInfoData
{
//成功
    [self setViews];
}
- (void)setViews
{
    self.scrollView = [UIScrollView new];
    self.ContentView = [UIView new];
    
    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.ContentView];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    //    [self.scrollView setupAutoContentSizeWithRightView:self.imageBackView rightMargin:10];

    
    UIView *titleView = [UIView new];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"dfhiasuhfiuewhiugweuigweiugtiuewgt";
    
    [self.scrollView addSubview:titleView];
    [titleView addSubview:titleLabel];
    
    titleView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(self.scrollView,0);
    
    [titleView setupAutoHeightWithBottomView:titleLabel bottomMargin:15];
    titleLabel.sd_layout.leftSpaceToView(titleView,15)
    .rightSpaceToView(titleView,15)
    .heightIs(20)
    .topSpaceToView(titleView,20)
    .autoHeightRatio(0);
    
    
    UIView *infoView = [UIView new];
    infoView.backgroundColor = [UIColor whiteColor];

    UIImageView *imageview = [UIImageView new];
    UILabel *nameLabel = [UILabel new];
    UILabel *numberLabel = [UILabel new];
    UILabel *viewCountLabel = [UILabel new];
    UILabel *timeLabel = [UILabel new];
    UIButton *jubaoButton = [UIButton new];
    
    [self.scrollView addSubview:infoView];
    [infoView addSubview:imageview];
    [infoView addSubview:nameLabel];
    [infoView addSubview:numberLabel];
    [infoView addSubview:viewCountLabel];
    [infoView addSubview:timeLabel];
    [infoView addSubview:jubaoButton];
    
    nameLabel.text = @"aaaa";
    imageview.backgroundColor = [UIColor redColor];
    numberLabel.text = @"efwefwe";
    viewCountLabel.text = @"22423";
    timeLabel.text = @"sdfsfsfs";
    
    
    infoView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(titleView,1)
    .heightIs(80);
    
    imageview.sd_layout.leftSpaceToView(infoView,15)
    .topSpaceToView(infoView,15)
    .widthIs(50)
    .heightIs(50);
    
    nameLabel.sd_layout.leftSpaceToView(imageview,10)
    .topSpaceToView(infoView,13)
    .heightIs(20);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    numberLabel.sd_layout.leftSpaceToView(nameLabel,10)
    .bottomEqualToView(nameLabel)
    .heightIs(15);
    [numberLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    viewCountLabel.sd_layout.leftSpaceToView(imageview,10)
    .topSpaceToView(nameLabel,10)
    .heightIs(20);
    [viewCountLabel setSingleLineAutoResizeWithMaxWidth:200];
    timeLabel.sd_layout.leftSpaceToView(viewCountLabel,10)
    .topSpaceToView(numberLabel,10)
    .heightIs(20);
    
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    jubaoButton.sd_layout.centerYEqualToView(imageview)
    .rightSpaceToView(infoView,15)
    .heightIs(20)
    .widthIs(60);
    [jubaoButton setTitle:@"举报" forState:(UIControlStateNormal)];
    [jubaoButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    
    [jubaoButton addTarget:self action:@selector(jubaoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.changeView = [UIView new];
    self.changeView.backgroundColor = [UIColor whiteColor];

    [self.scrollView addSubview:self.changeView];
    
    self.changeView.sd_layout.topSpaceToView(infoView,1)
    .leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0);
    
    UIView *wordDesView = [UIView new];
    UIView *wenziView = [UIView new];
    
    
    wordDesView.backgroundColor = [UIColor whiteColor];
    wenziView.backgroundColor = [UIColor whiteColor];

    UILabel *wenziLabel = [UILabel new];
    UILabel *desLabel = [UILabel new];
    [self.scrollView addSubview:wordDesView];
    [self.scrollView addSubview:wenziView];
    
    [wenziView addSubview:wenziLabel];
    [wordDesView addSubview:desLabel];
    

    
    wenziView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(self.changeView,10)
    .heightIs(50);
    
    
    wenziLabel.sd_layout.centerYEqualToView(wenziView)
    .centerXEqualToView(wenziView);
    [wenziLabel setSingleLineAutoResizeWithMaxWidth:200];
    wenziLabel.textAlignment = NSTextAlignmentCenter;
    
    wenziLabel.text = @"文字描述";
    
    wordDesView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(wenziView,1);
    
    
    [wordDesView setupAutoHeightWithBottomView:desLabel bottomMargin:15];
    desLabel.sd_layout.leftSpaceToView(wordDesView,15)
    .rightSpaceToView(wordDesView,15)
    .topSpaceToView(wordDesView,15)
    .autoHeightRatio(0);
    
    desLabel.text = @"sdfoiheirheihtie4htihweoitheihtoiehtoierhtiohewrtoiheroitho";
    
    
    UIView *audioView = [UIView new];
    audioView.backgroundColor = [UIColor whiteColor];

    UILabel *yuyinLabel = [UILabel new];
    UIButton *recordButton = [UIButton new];
    
    [self.scrollView addSubview:audioView];
    [audioView addSubview:yuyinLabel];
    [audioView addSubview:recordButton];
    
    audioView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(wordDesView,10)
    .heightIs(70);
    
    yuyinLabel.sd_layout.leftSpaceToView(audioView,15)
    .centerYEqualToView(audioView);
    [yuyinLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    yuyinLabel.text = @"语音描述";
    
    recordButton.sd_layout.leftSpaceToView(yuyinLabel,10)
    .centerYEqualToView(yuyinLabel)
    .heightIs(30)
    .widthIs(120);
    
    UIView *xiangguanView = [UIView new];
    xiangguanView.backgroundColor = [UIColor whiteColor];

    UILabel *xiangguanLabel = [UILabel new];
    [xiangguanView addSubview:xiangguanLabel];
    [self.scrollView addSubview:xiangguanView];

    
    self.imageBackView = [UIView new];
    self.imageBackView.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView1 = [UIImageView new];
    UIImageView *imageView2 = [UIImageView new];
    UIImageView *imageView3 = [UIImageView new];
    
    imageView1.backgroundColor = [UIColor redColor];
    imageView2.backgroundColor = [UIColor redColor];
    imageView3.backgroundColor = [UIColor redColor];
    
    
    [self.scrollView addSubview:self.imageBackView];
    [self.imageBackView addSubview:imageView1];
    [self.imageBackView addSubview:imageView2];
    [self.imageBackView addSubview:imageView3];
    
    imageView2.sd_layout.centerXEqualToView(self.imageBackView)
    .centerYEqualToView(self.imageBackView)
    .heightIs(90)
    .widthIs(90);
    
    imageView1.sd_layout.rightSpaceToView(imageView2,30)
    .centerYEqualToView(self.imageBackView)
    .heightIs(90)
    .widthIs(90);
    
    imageView3.sd_layout.leftSpaceToView(imageView2,30)
    .centerYEqualToView(self.imageBackView)
    .heightIs(90)
    .widthIs(90);
    
    
    xiangguanView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(audioView,10)
    .heightIs(50);
    
    xiangguanLabel.sd_layout.centerXEqualToView(xiangguanView)
    .centerYEqualToView(xiangguanView);
    [xiangguanLabel setSingleLineAutoResizeWithMaxWidth:200];
    xiangguanLabel.text = @"相关凭证";
    
    self.imageBackView.sd_layout.leftSpaceToView(self.scrollView,0)
    .rightSpaceToView(self.scrollView,0)
    .topSpaceToView(xiangguanView,1)
    .heightIs(110);
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.imageBackView bottomMargin:10];

    
    
    if ([self.Type isEqualToString:@"1"]) {
        [self carFapaiView];
    }
    else if([self.Type isEqualToString:@""])
    {
        [self houseFapaiView];
    }
    else if([self.Type isEqualToString:@""])
    {
        [self personZhaiquanView];
    }
    else if([self.Type isEqualToString:@""])
    {
        [self HouseProductionView];
    }
    else if([self.Type isEqualToString:@""])
    {
        [self landProductionView];
    }
    else if([self.Type isEqualToString:@""])
    {
        [self businesssView];
    }
    else if([self.Type isEqualToString:@""])
    {
        [self finanCingGuquanView];
    }
    else if([self.Type isEqualToString:@""])
    {
        [self finaCingZhaiquanView];
    }
    else if([self.Type isEqualToString:@"2"])
    {
        [self asetBackView];
    }
}

- (void)carFapaiView
{
    
    self.imageBackView.backgroundColor = [UIColor blueColor];

//    addView = self.changeView;
    
//    [self.scrollView addSubview:addView];
    
    UILabel *zichanLabel = [UILabel new];
    UILabel *zichanTypeLabel = [UILabel new];
    
    UILabel *pinpaiLabel = [UILabel new];
    UILabel *pinpaiNumber = [UILabel new];
    
    UILabel *qipaiLabel = [UILabel new];
    UILabel *qipaiMoney = [UILabel new];
    
    UILabel *didianLabel = [UILabel new];
    UILabel *areaLabel = [UILabel new];
    
    UILabel *shijianLabel = [UILabel new];
    UILabel *timeLabel = [UILabel new];
    
    UILabel *paimaijieduan = [UILabel new];
    UILabel *jieduanLabel = [UILabel new];
    
    UILabel *chuzhidanwei = [UILabel new];
    UILabel *chuzhiLabel = [UILabel new];
    
    [self.changeView addSubview:zichanLabel];
    [self.changeView addSubview:zichanTypeLabel];
    [self.changeView addSubview:pinpaiLabel];
    [self.changeView addSubview:pinpaiNumber];
    [self.changeView addSubview:qipaiLabel];
    [self.changeView addSubview:qipaiMoney];
    [self.changeView addSubview:didianLabel];
    [self.changeView addSubview:areaLabel];
    [self.changeView addSubview:shijianLabel];
    [self.changeView addSubview:timeLabel];
    [self.changeView addSubview:paimaijieduan];
    [self.changeView addSubview:jieduanLabel];
    [self.changeView addSubview:chuzhidanwei];
    [self.changeView addSubview:chuzhiLabel];
    zichanLabel.text = @"资产类型：";
    pinpaiLabel.text = @"品牌型号：";
    qipaiLabel.text = @"起拍价：";
    didianLabel.text = @"拍卖地点：";
    shijianLabel.text = @"拍卖时间：";
    paimaijieduan.text = @"拍卖阶段：";
    chuzhidanwei.text = @"处置单位：";
    
    
   
    zichanLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [zichanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    zichanTypeLabel.sd_layout.leftSpaceToView(zichanLabel,5)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [zichanTypeLabel setSingleLineAutoResizeWithMaxWidth:200];

    pinpaiLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(zichanLabel,15)
    .heightIs(20);
    [pinpaiLabel setSingleLineAutoResizeWithMaxWidth:200];

    pinpaiNumber.sd_layout.leftSpaceToView(pinpaiLabel,5)
    .topEqualToView(pinpaiLabel)
    .heightIs(20);
    [pinpaiNumber setSingleLineAutoResizeWithMaxWidth:200];

    qipaiLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(pinpaiLabel,15)
    .heightIs(20);
    [qipaiLabel setSingleLineAutoResizeWithMaxWidth:200];

    qipaiMoney.sd_layout.leftSpaceToView(qipaiLabel,5)
    .topEqualToView(qipaiLabel)
    .heightIs(20);
    [qipaiMoney setSingleLineAutoResizeWithMaxWidth:200];

    didianLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(qipaiLabel,15)
    .heightIs(20);
    [didianLabel setSingleLineAutoResizeWithMaxWidth:200];

    areaLabel.sd_layout.leftSpaceToView(didianLabel,5)
    .topSpaceToView(qipaiMoney,15)
    .heightIs(20);
    [areaLabel setSingleLineAutoResizeWithMaxWidth:200];

    
    shijianLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(didianLabel,15)
    .heightIs(20);
    [shijianLabel setSingleLineAutoResizeWithMaxWidth:200];

    timeLabel.sd_layout.leftSpaceToView(shijianLabel,5)
    .topEqualToView(shijianLabel)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];

    paimaijieduan.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(shijianLabel,15)
    .heightIs(20);
    [paimaijieduan setSingleLineAutoResizeWithMaxWidth:200];

    jieduanLabel.sd_layout.leftSpaceToView(paimaijieduan,5)
    .topEqualToView(paimaijieduan)
    .heightIs(20);
    [jieduanLabel setSingleLineAutoResizeWithMaxWidth:200];

    chuzhidanwei.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(paimaijieduan,15)
    .heightIs(20);
    [chuzhidanwei setSingleLineAutoResizeWithMaxWidth:200];

    chuzhiLabel.sd_layout.leftSpaceToView(chuzhidanwei,5)
    .topEqualToView(chuzhidanwei)
    .heightIs(20);
    [chuzhiLabel setSingleLineAutoResizeWithMaxWidth:200];

    [self.changeView setupAutoHeightWithBottomView:chuzhiLabel bottomMargin:35];
    
//    self.changeView = addView;
    
    
    
    
    
    
}
- (void)houseFapaiView
{
    UILabel *zichanLabel = [UILabel new];
    UILabel *zichanTypeLabel = [UILabel new];
    
    UILabel *mianjiLabel = [UILabel new];
    UILabel *mianjishuLabel = [UILabel new];
    UILabel *xingzhiLabel = [UILabel new];
    UILabel *xingzhiLabel2 = [UILabel new];
    

    UILabel *qipaiLabel = [UILabel new];
    UILabel *qipaiMoney = [UILabel new];
    
    UILabel *didianLabel = [UILabel new];
    UILabel *areaLabel = [UILabel new];
    
    UILabel *shijianLabel = [UILabel new];
    UILabel *timeLabel = [UILabel new];
    
    UILabel *paimaijieduan = [UILabel new];
    UILabel *jieduanLabel = [UILabel new];
    
    UILabel *chuzhidanwei = [UILabel new];
    UILabel *chuzhiLabel = [UILabel new];
    
    [self.changeView addSubview:zichanLabel];
    [self.changeView addSubview:zichanTypeLabel];
    [self.changeView addSubview:mianjiLabel];
    [self.changeView addSubview:xingzhiLabel];
    
    [self.changeView addSubview:mianjishuLabel];
    [self.changeView addSubview:qipaiLabel];
    [self.changeView addSubview:qipaiMoney];
    [self.changeView addSubview:didianLabel];
    [self.changeView addSubview:areaLabel];
    [self.changeView addSubview:shijianLabel];
    [self.changeView addSubview:timeLabel];
    [self.changeView addSubview:paimaijieduan];
    [self.changeView addSubview:jieduanLabel];
    [self.changeView addSubview:chuzhidanwei];
    [self.changeView addSubview:chuzhiLabel];
    zichanLabel.text = @"资产类型：";
    mianjiLabel.text = @"面积：";
    xingzhiLabel.text = @"性质：";
    
    qipaiLabel.text = @"起拍价：";
    didianLabel.text = @"拍卖地点：";
    shijianLabel.text = @"拍卖时间：";
    paimaijieduan.text = @"拍卖阶段：";
    chuzhidanwei.text = @"处置单位：";
    
    
    
    zichanLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [zichanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    zichanTypeLabel.sd_layout.leftSpaceToView(zichanLabel,5)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [zichanTypeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    mianjiLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(zichanLabel,15)
    .heightIs(20);
    [mianjiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    mianjishuLabel.sd_layout.leftSpaceToView(mianjiLabel,5)
    .topEqualToView(mianjiLabel)
    .heightIs(20);
    [mianjishuLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    xingzhiLabel.sd_layout.leftEqualToView(mianjiLabel)
    .topSpaceToView(mianjiLabel,15)
    .heightIs(20);
    [xingzhiLabel setSingleLineAutoResizeWithMaxWidth:200];

    xingzhiLabel2.sd_layout.leftSpaceToView(xingzhiLabel,0)
    .topEqualToView(xingzhiLabel)
    .heightIs(20);
    [xingzhiLabel2 setSingleLineAutoResizeWithMaxWidth:200];

    
    qipaiLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(xingzhiLabel,15)
    .heightIs(20);
    [qipaiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    qipaiMoney.sd_layout.leftSpaceToView(qipaiLabel,5)
    .topEqualToView(qipaiLabel)
    .heightIs(20);
    [qipaiMoney setSingleLineAutoResizeWithMaxWidth:200];
    
    didianLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(qipaiLabel,15)
    .heightIs(20);
    [didianLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    areaLabel.sd_layout.leftSpaceToView(didianLabel,5)
    .topSpaceToView(qipaiMoney,15)
    .heightIs(20);
    [areaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    shijianLabel.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(didianLabel,15)
    .heightIs(20);
    [shijianLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    timeLabel.sd_layout.leftSpaceToView(shijianLabel,5)
    .topEqualToView(shijianLabel)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    paimaijieduan.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(shijianLabel,15)
    .heightIs(20);
    [paimaijieduan setSingleLineAutoResizeWithMaxWidth:200];
    
    jieduanLabel.sd_layout.leftSpaceToView(paimaijieduan,5)
    .topEqualToView(paimaijieduan)
    .heightIs(20);
    [jieduanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    chuzhidanwei.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(paimaijieduan,15)
    .heightIs(20);
    [chuzhidanwei setSingleLineAutoResizeWithMaxWidth:200];
    
    chuzhiLabel.sd_layout.leftSpaceToView(chuzhidanwei,5)
    .topEqualToView(chuzhidanwei)
    .heightIs(20);
    [chuzhiLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    [self.changeView setupAutoHeightWithBottomView:chuzhiLabel bottomMargin:35];

    
}
- (void)personZhaiquanView
{
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];

    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    UILabel *label13 = [UILabel new];
    UILabel *label14 = [UILabel new];
    UILabel *label15 = [UILabel new];
    
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    [self.changeView addSubview:label13];
    [self.changeView addSubview:label14];
    [self.changeView addSubview:label15];

    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label5,15)
    .heightIs(20);
    
    label8.sd_layout.leftEqualToView(label1)
    .topSpaceToView(label7,15)
    .heightIs(20);
    
    label9.sd_layout.leftSpaceToView(label8,0)
    .topEqualToView(label8)
    .heightIs(20);
    
    
    label10.sd_layout.leftEqualToView(label1)
    .topSpaceToView(label8,15)
    .heightIs(20);
    
    label11.sd_layout.leftSpaceToView(label10,0)
    .topEqualToView(label10)
    .heightIs(20);
    
    label12.sd_layout.leftEqualToView(label1)
    .topSpaceToView(label10,15)
    .heightIs(20);
    
    label13.sd_layout.leftSpaceToView(label12,0)
    .topEqualToView(label12)
    .heightIs(20);
    
    
    label14.sd_layout.leftEqualToView(label1)
    .topSpaceToView(label12,15)
    .heightIs(20);
    
    label15.sd_layout.leftSpaceToView(label14,0)
    .topEqualToView(label14)
    .heightIs(20);
    
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    [label13 setSingleLineAutoResizeWithMaxWidth:200];
    [label14 setSingleLineAutoResizeWithMaxWidth:200];
    [label15 setSingleLineAutoResizeWithMaxWidth:200];


    label1.text = @"身份：";
    label2.text = @"身份：";
    
    label3.text = @"总金额：";
    label4.text = @"身份：";
    
    label5.text = @"逾期时间：";
    label6.text = @"身份：";
    
    label7.text = @"处置方式：";
    
    label8.text = @"诉讼：";
    label9.text = @"身份：";
    
    label10.text = @"非诉催收：";
    label11.text = @"身份：";
    
    label12.text = @"债权人所在地：";
    label13.text = @"身份：";
    
    label14.text = @"债务人所在地：";
    label15.text = @"身份：";
    
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];

//    line1.backgroundColor = [UIColor redColor];
//    line2.backgroundColor = [UIColor blueColor];
//    line3.backgroundColor = [UIColor blackColor];
    
    UIView *qitaView = [UIView new];
    UILabel *qitaLabel = [UILabel new];
    qitaLabel.text = @"其他信息";
    qitaView.backgroundColor = [UIColor whiteColor];
    
    UIView *qitaBottView = [UIView new];
    qitaBottView.backgroundColor = [UIColor whiteColor];
    
    UILabel *danbaoLabel = [UILabel new];
    UILabel *changhuanLabel = [UILabel new];
    UILabel *diyaLabel = [UILabel new];
    UILabel *pingzhenLabel = [UILabel new];
    UILabel *zhaiwurenLabel = [UILabel new];
    
    [qitaView addSubview:qitaLabel];
    
    [self.changeView addSubview:qitaView];
    [self.changeView addSubview:qitaBottView];
    
    [self.changeView addSubview:line1];
    [self.changeView addSubview:line2];
    [self.changeView addSubview:line3];
    
    [qitaBottView addSubview:danbaoLabel];
    [qitaBottView addSubview:changhuanLabel];
    [qitaBottView addSubview:diyaLabel];
    [qitaBottView addSubview:pingzhenLabel];
    [qitaBottView addSubview:zhaiwurenLabel];
    
    
    qitaBottView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(line2,0);
    [qitaBottView setupAutoHeightWithBottomView:zhaiwurenLabel bottomMargin:15];
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label14,15)
    .heightIs(10);
    
    qitaView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    qitaLabel.sd_layout.centerXEqualToView(qitaView)
    .centerYEqualToView(qitaView)
    .heightIs(20);
    [qitaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(qitaView,0)
    .heightIs(1);
    
    line3.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightIs(10)
    .topSpaceToView(qitaBottView,15);
    
    danbaoLabel.sd_layout.leftSpaceToView(qitaBottView,15)
    .topSpaceToView(qitaBottView,15)
    .heightIs(20);
    [danbaoLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    changhuanLabel.sd_layout.rightSpaceToView(qitaBottView,15)
    .topEqualToView(danbaoLabel)
    .heightIs(20);
    [changhuanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    diyaLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(danbaoLabel,15)
    .heightIs(20);
    [diyaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    pingzhenLabel.sd_layout.rightSpaceToView(qitaBottView,15)
    .topEqualToView(diyaLabel)
    .heightIs(20);
    [pingzhenLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    zhaiwurenLabel.sd_layout.leftEqualToView(diyaLabel)
    .topSpaceToView(diyaLabel,15)
    .heightIs(20);
    [zhaiwurenLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    danbaoLabel.text = @"有无担保：";
    changhuanLabel.text = @"债务人有偿还能力：";
    diyaLabel.text = @"有无抵押：";
    pingzhenLabel.text = @"相关凭证齐是否全：";
    zhaiwurenLabel.text = @"债务人是否失联：";
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UIView *line4 = [UIView new];
    
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    
    liangdianTopView.sd_layout.leftEqualToView(line3)
    .rightEqualToView(line3)
    .topSpaceToView(line3,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.centerXEqualToView(liangdianTopView)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    
    line4.sd_layout.leftEqualToView(liangdianTopView)
    .rightEqualToView(liangdianTopView)
    .heightIs(1)
    .topSpaceToView(liangdianTopView,0);
    
    line4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:35];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line4,0);
    
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    button1.text = @"佣金比例高";
    button2.text = @"法律关系明确";
    
    
}
- (void)HouseProductionView
{

}
- (void)landProductionView
{
    
}
- (void)businesssView
{
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
    UILabel *label13 = [UILabel new];
    UILabel *label14 = [UILabel new];
    UILabel *label15 = [UILabel new];
    
    UILabel *label16 = [UILabel new];
    UILabel *label17 = [UILabel new];
    UILabel *label18 = [UILabel new];
    UILabel *label19 = [UILabel new];

    
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    [self.changeView addSubview:label13];
    [self.changeView addSubview:label14];
    [self.changeView addSubview:label15];
    
    [self.changeView addSubview:label16];

    [self.changeView addSubview:label17];

    [self.changeView addSubview:label18];

    [self.changeView addSubview:label19];

    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label5,15)
    .heightIs(20);
    
    label8.sd_layout.leftSpaceToView(label7,0)
    .topEqualToView(label7)
    .heightIs(20);
 
    label9.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,15)
    .heightIs(20);
    
    label10.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(20);
    
    label11.sd_layout.leftSpaceToView(label10,0)
    .topEqualToView(label10)
    .heightIs(20);
    
    label12.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label10,15)
    .heightIs(20);
    
    label13.sd_layout.leftSpaceToView(label12,0)
    .topEqualToView(label12)
    .heightIs(20);
    
    
    label14.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label12,15)
    .heightIs(20);
    
    label15.sd_layout.leftSpaceToView(label14,0)
    .topEqualToView(label14)
    .heightIs(20);
    
    label16.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label14,15)
    .heightIs(20);
    
    label17.sd_layout.leftSpaceToView(label16,0)
    .topEqualToView(label16)
    .heightIs(20);
    
    label18.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label16,15)
    .heightIs(20);
    
    label19.sd_layout.leftSpaceToView(label18,0)
    .topEqualToView(label18)
    .heightIs(20);
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    [label13 setSingleLineAutoResizeWithMaxWidth:200];
    [label14 setSingleLineAutoResizeWithMaxWidth:200];
    [label15 setSingleLineAutoResizeWithMaxWidth:200];
    [label16 setSingleLineAutoResizeWithMaxWidth:200];
    [label17 setSingleLineAutoResizeWithMaxWidth:200];
    [label18 setSingleLineAutoResizeWithMaxWidth:200];
    [label19 setSingleLineAutoResizeWithMaxWidth:200];
 

    label1.text = @"身份：";
    label2.text = @"身份：";
    label3.text = @"商账类型：";
    label4.text = @"身份：";
    label5.text = @"债权金额：";
    label6.text = @"身份：";
    label7.text = @"逾期时间：";
    label8.text = @"身份：";
    label9.text = @"处置方式：";
    label10.text = @"诉讼：";
    label11.text = @"身份：";
    label12.text = @"非诉催收：";
    label13.text = @"身份：";
    label14.text = @"债务方地区：";
    label15.text = @"身份：";
    label16.text = @"债务方企业性质：";
    label17.text = @"身份：";
    label18.text = @"债务方经营状况：";
    label19.text = @"身份：";
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];

    UIView *qitaView = [UIView new];
    UILabel *qitaLabel = [UILabel new];
    qitaLabel.text = @"其他信息";
    qitaView.backgroundColor = [UIColor whiteColor];
    
    UIView *qitaBottView = [UIView new];
    qitaBottView.backgroundColor = [UIColor whiteColor];
    
    UILabel *pingzheng = [UILabel new];
    UILabel *hangyeLabel = [UILabel new];
    UILabel *shesuLabel = [UILabel new];
//    UILabel *pingzhenLabel = [UILabel new];
//    UILabel *zhaiwurenLabel = [UILabel new];
    
    [qitaView addSubview:qitaLabel];
    
    [self.changeView addSubview:qitaView];
    [self.changeView addSubview:qitaBottView];
    
    [self.changeView addSubview:line1];
    [self.changeView addSubview:line2];
    [self.changeView addSubview:line3];
    
    [qitaBottView addSubview:pingzheng];
    [qitaBottView addSubview:hangyeLabel];
    [qitaBottView addSubview:shesuLabel];
   
    
    
    qitaBottView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(line2,0);
    [qitaBottView setupAutoHeightWithBottomView:shesuLabel bottomMargin:15];
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label18,15)
    .heightIs(10);
    
    qitaView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    qitaLabel.sd_layout.centerXEqualToView(qitaView)
    .centerYEqualToView(qitaView)
    .heightIs(20);
    [qitaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(qitaView,0)
    .heightIs(1);
    
    line3.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightIs(10)
    .topSpaceToView(qitaBottView,15);
    
    pingzheng.sd_layout.leftSpaceToView(qitaBottView,15)
    .topSpaceToView(qitaBottView,15)
    .heightIs(20);
    [pingzheng setSingleLineAutoResizeWithMaxWidth:200];
    
    hangyeLabel.sd_layout.rightSpaceToView(qitaBottView,15)
    .topEqualToView(pingzheng)
    .heightIs(20);
    [hangyeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    shesuLabel.sd_layout.leftEqualToView(pingzheng)
    .topSpaceToView(pingzheng,15)
    .heightIs(20);
    [shesuLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    pingzheng.text = @"有无债权相关凭证：";
    hangyeLabel.text = @"债务方行业：";
    shesuLabel.text = @"债权涉诉情况：";

    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UIView *line4 = [UIView new];
    
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    
    liangdianTopView.sd_layout.leftEqualToView(line3)
    .rightEqualToView(line3)
    .topSpaceToView(line3,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.centerXEqualToView(liangdianTopView)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    
    line4.sd_layout.leftEqualToView(liangdianTopView)
    .rightEqualToView(liangdianTopView)
    .heightIs(1)
    .topSpaceToView(liangdianTopView,0);
    
    line4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:35];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line4,0);
    
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    button1.text = @"债务方有还款能力";
    button2.text = @"法律关系明确";

    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:15];
    
    
    
}

- (void)finanCingGuquanView
{
}
- (void)finaCingZhaiquanView
{
}
- (void)asetBackView
{
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UILabel *label3 = [UILabel new];
    
    UILabel *label4 = [UILabel new];
    UILabel *label5 = [UILabel new];
    UILabel *label6 = [UILabel new];
    UILabel *label7 = [UILabel new];
    UILabel *label8 = [UILabel new];
    UILabel *label9 = [UILabel new];
    UILabel *label10 = [UILabel new];
    UILabel *label11 = [UILabel new];
    UILabel *label12 = [UILabel new];
  
    [self.changeView addSubview:label1];
    [self.changeView addSubview:label2];
    [self.changeView addSubview:label3];
    [self.changeView addSubview:label4];
    [self.changeView addSubview:label5];
    [self.changeView addSubview:label6];
    [self.changeView addSubview:label7];
    [self.changeView addSubview:label8];
    [self.changeView addSubview:label9];
    [self.changeView addSubview:label10];
    [self.changeView addSubview:label11];
    [self.changeView addSubview:label12];
    
    label1.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(self.changeView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label2.sd_layout.leftSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    label3.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label1,15)
    .heightIs(20);
    
    label4.sd_layout.leftSpaceToView(label3,0)
    .topEqualToView(label3)
    .heightIs(20);
    
    label5.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label3,15)
    .heightIs(20);
    
    label6.sd_layout.leftSpaceToView(label5,0)
    .topEqualToView(label5)
    .heightIs(20);
    
    label7.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label6,15)
    .heightIs(20);
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    label8.sd_layout.leftSpaceToView(label7,0)
    .topEqualToView(label7)
    .heightIs(20);
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    
    label9.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label7,15)
    .heightIs(20);
    
    label10.sd_layout.leftSpaceToView(label9,0)
    .topEqualToView(label9)
    .heightIs(20);
    
    label11.sd_layout.leftSpaceToView(self.changeView,15)
    .topSpaceToView(label9,15)
    .heightIs(20);
    
    label12.sd_layout.leftSpaceToView(label11,0)
    .topEqualToView(label11)
    .heightIs(20);
    
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    [label2 setSingleLineAutoResizeWithMaxWidth:200];
    [label3 setSingleLineAutoResizeWithMaxWidth:200];
    [label4 setSingleLineAutoResizeWithMaxWidth:200];
    [label5 setSingleLineAutoResizeWithMaxWidth:200];
    [label6 setSingleLineAutoResizeWithMaxWidth:200];
    [label7 setSingleLineAutoResizeWithMaxWidth:200];
    [label8 setSingleLineAutoResizeWithMaxWidth:200];
    [label9 setSingleLineAutoResizeWithMaxWidth:200];
    [label10 setSingleLineAutoResizeWithMaxWidth:200];
    [label11 setSingleLineAutoResizeWithMaxWidth:200];
    [label12 setSingleLineAutoResizeWithMaxWidth:200];
    

    
    label1.text = @"身份：";
    label2.text = @"身份：";
    label3.text = @"资产包类型：";
    label4.text = @"身份：";
    label5.text = @"来源：";
    label6.text = @"身份：";
    label7.text = @"地区：";
    label8.text = @"身份：";
    label9.text = @"总金额：";
    label10.text = @"诉讼：";
    label11.text = @"转让价：";
    label12.text = @"非诉催收：";
    
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    line3.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    //    line1.backgroundColor = [UIColor redColor];
    //    line2.backgroundColor = [UIColor blueColor];
    //    line3.backgroundColor = [UIColor blackColor];
    
    UIView *qitaView = [UIView new];
    UILabel *qitaLabel = [UILabel new];
    qitaLabel.text = @"其他信息";
    qitaView.backgroundColor = [UIColor whiteColor];
    
    UIView *qitaBottView = [UIView new];
    qitaBottView.backgroundColor = [UIColor whiteColor];
    
    UILabel *danbaoLabel = [UILabel new];
    UILabel *changhuanLabel = [UILabel new];
    UILabel *diyaLabel = [UILabel new];
    UILabel *pingzhenLabel = [UILabel new];
    UILabel *zhaiwurenLabel = [UILabel new];
    UILabel *diyawuLeiXing = [UILabel new];
    
    
    [qitaView addSubview:qitaLabel];
    
    [self.changeView addSubview:qitaView];
    [self.changeView addSubview:qitaBottView];
    
    [self.changeView addSubview:line1];
    [self.changeView addSubview:line2];
    [self.changeView addSubview:line3];
    
    [qitaBottView addSubview:danbaoLabel];
    [qitaBottView addSubview:changhuanLabel];
    [qitaBottView addSubview:diyaLabel];
    [qitaBottView addSubview:pingzhenLabel];
    [qitaBottView addSubview:zhaiwurenLabel];
    [qitaBottView addSubview:diyawuLeiXing];
    
    
    
    qitaBottView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(line2,0);
    [qitaBottView setupAutoHeightWithBottomView:zhaiwurenLabel bottomMargin:15];
    
    
    line1.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .topSpaceToView(label11,15)
    .heightIs(10);
    
    qitaView.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(line1,0)
    .heightIs(50);
    
    qitaLabel.sd_layout.centerXEqualToView(qitaView)
    .centerYEqualToView(qitaView)
    .heightIs(20);
    [qitaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    line2.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .topSpaceToView(qitaView,0)
    .heightIs(1);
    
    line3.sd_layout.leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightIs(10)
    .topSpaceToView(qitaBottView,15);
    
    danbaoLabel.sd_layout.leftSpaceToView(qitaBottView,15)
    .topSpaceToView(qitaBottView,15)
    .heightIs(20);
    [danbaoLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    changhuanLabel.sd_layout.rightSpaceToView(qitaBottView,15)
    .topEqualToView(danbaoLabel)
    .heightIs(20);
    [changhuanLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    diyaLabel.sd_layout.leftEqualToView(danbaoLabel)
    .topSpaceToView(danbaoLabel,15)
    .heightIs(20);
    [diyaLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    pingzhenLabel.sd_layout.rightSpaceToView(qitaBottView,15)
    .topEqualToView(diyaLabel)
    .heightIs(20);
    [pingzhenLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    zhaiwurenLabel.sd_layout.leftEqualToView(diyaLabel)
    .topSpaceToView(diyaLabel,15)
    .heightIs(20);
    [zhaiwurenLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    diyawuLeiXing.sd_layout.rightSpaceToView(qitaBottView,15)
    .topEqualToView(zhaiwurenLabel)
    .heightIs(20);
    [diyawuLeiXing setSingleLineAutoResizeWithMaxWidth:200];
    
    danbaoLabel.text = @"本金：";
    changhuanLabel.text = @"是否有尽调报告：";
    diyaLabel.text = @"利息：";
    pingzhenLabel.text = @"出表时间：";
    zhaiwurenLabel.text = @"户数：";
    diyawuLeiXing.text = @"抵押物类型：";
    
    UIView *liangdianTopView = [UIView new];
    UILabel *liandianLabel = [UILabel new];
    UIView *liangdianBottomView = [UIView new];
    UILabel *button1 = [UILabel new];
    UILabel *button2 = [UILabel new];
    UILabel *button3 = [UILabel new];
    
    UIView *line4 = [UIView new];
    
    
    [self.changeView addSubview:liangdianTopView];
    [self.changeView addSubview:liangdianBottomView];
    [self.changeView addSubview:line4];
    [liangdianTopView addSubview:liandianLabel];
    [liangdianBottomView addSubview:button1];
    [liangdianBottomView addSubview:button2];
    [liangdianBottomView addSubview:button3];

    
    liangdianTopView.sd_layout.leftEqualToView(line3)
    .rightEqualToView(line3)
    .topSpaceToView(line3,0)
    .heightIs(50);
    
    liandianLabel.sd_layout.centerXEqualToView(liangdianTopView)
    .centerYEqualToView(liangdianTopView)
    .heightIs(20);
    [liandianLabel setSingleLineAutoResizeWithMaxWidth:200];
    liandianLabel.text = @"项目亮点";
    
    line4.sd_layout.leftEqualToView(liangdianTopView)
    .rightEqualToView(liangdianTopView)
    .heightIs(1)
    .topSpaceToView(liangdianTopView,0);
    
    line4.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.changeView setupAutoHeightWithBottomView:liangdianBottomView bottomMargin:35];
    
    liangdianBottomView.sd_layout.leftSpaceToView(self.changeView,0)
    .rightSpaceToView(self.changeView,0)
    .heightIs(60)
    .topSpaceToView(line4,0);
    
    
    button1.sd_layout.leftSpaceToView(liangdianBottomView,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button1 setSingleLineAutoResizeWithMaxWidth:200];
    
    button2.sd_layout.leftSpaceToView(button1,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button2 setSingleLineAutoResizeWithMaxWidth:200];
    
    button3.sd_layout.leftSpaceToView(button2,15)
    .centerYEqualToView(liangdianBottomView)
    .heightIs(20);
    [button3 setSingleLineAutoResizeWithMaxWidth:200];
    
    button1.text = @"抵押物足值";
    button2.text = @"可拆包";
    button3.text = @"一手包";

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
