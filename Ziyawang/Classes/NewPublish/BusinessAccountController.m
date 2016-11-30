//
//  BusinessAccountController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "BusinessAccountController.h"
#import "RecordManager.h"
#import "AddImageManager.h"
#import "HttpManager.h"
#import "ChooseAreaController.h"
@interface BusinessAccountController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *shenfenView;
@property (weak, nonatomic) IBOutlet UIView *shangzhangleixingView;
@property (weak, nonatomic) IBOutlet UIView *susongView;
@property (weak, nonatomic) IBOutlet UIView *feisusonView;
@property (weak, nonatomic) IBOutlet UIView *diquView;
@property (weak, nonatomic) IBOutlet UIView *zhaiwufangxingzhiView;
@property (weak, nonatomic) IBOutlet UIView *jingyingzhuangView;
@property (weak, nonatomic) IBOutlet UIView *pingzhengView;
@property (weak, nonatomic) IBOutlet UIView *shesuView;
@property (weak, nonatomic) IBOutlet UIView *zhaiwufanghangyeView;

@property (weak, nonatomic) IBOutlet UILabel *shenfenLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangzhangLabel;
@property (weak, nonatomic) IBOutlet UILabel *susongLabel;
@property (weak, nonatomic) IBOutlet UILabel *feisusongLabel;

@property (weak, nonatomic) IBOutlet UILabel *diquLabel;
@property (weak, nonatomic) IBOutlet UILabel *qiyexingzhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jingyingzhuangLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingzhengLabel;
@property (weak, nonatomic) IBOutlet UILabel *shesuLabel;
@property (weak, nonatomic) IBOutlet UILabel *hangyeLabel;





@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;





@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITextField *jineTextField;
@property (weak, nonatomic) IBOutlet UITextField *yuqiTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;



@property (nonatomic,strong) NSMutableArray *viewArray;


@property (nonatomic,assign) BOOL choose1;
@property (nonatomic,assign) BOOL choose2;

@property (weak, nonatomic) IBOutlet UIImageView *chooseImage1;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage2;

@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *pickerBackView;
@property (nonatomic,strong) UIView *DatepickerBackView;

@property (nonatomic,strong) UIView *mengbanView;
@property (nonatomic,strong) NSString *selectStr;
@property (nonatomic,assign) NSInteger row;

@property (nonatomic,strong) NSMutableArray *AllArray;
@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *ImageBackView;

@property (nonatomic,strong) NSMutableArray *SelectedButtonsArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UIView *weituoView;

@property (nonatomic,strong) UITextField *lianxirenTextField;
@property (nonatomic,strong) UITextField *lianxifangshiTextfield;

@property (weak, nonatomic) IBOutlet UIView *ContentView;

@property (nonatomic,strong) NSMutableArray *liangdianArray;
@property (nonatomic,strong) NSString *liangdianStr;
@property (nonatomic,assign) BOOL isHave;
@property (nonatomic,strong) UIView *PromiseView;

@end

@implementation BusinessAccountController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *suozai = [[NSUserDefaults standardUserDefaults]objectForKey:@"企业所在"];
    if (suozai == nil) {
        
    }
    else
    {
        self.diquLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"企业所在"];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;

    self.sendButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];

    self.navigationItem.title = @"企业商账";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"委托发布" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
    self.SelectedButtonsArray = [NSMutableArray new];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    self.viewArray = [NSMutableArray new];
    self.AllArray = [NSMutableArray new];
    self.sourceArray = [NSMutableArray new];
    
    [self setPickerView];
    [self setViews];
    

    
    [[RecordManager recordManager] setaudioWithView:self.view recordView:self.recordView];
    //    [[AddImageManager AddManager] setAddimageViewWithView:self.ImageBackView];
    [[AddImageManager AddManager]setAddimageViewWithView:self.ImageBackView target:self];
    
    
    
    self.SelectedButtonsArray = [NSMutableArray new];
    UIButton *button = [UIButton new];
    button.tag = 3;
    [self.SelectedButtonsArray addObject:button];
    self.liangdianArray = [NSMutableArray new];
    self.liangdianStr = [NSString string];
    
    [self setstatuForButtonsWithType:@"0" button:self.button1];
    [self setstatuForButtonsWithType:@"0" button:self.button2];
       [self.button1 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button2 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.textView.text = @"请输入文字描述";
    self.textView.textColor = [UIColor grayColor];
    self.textView.delegate = self;
   
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    textView.text = nil;
}
- (void)findButtonWithButton:(UIButton *)button
{
    
    NSMutableArray *addArray = [NSMutableArray new];
    
    for (UIButton *btn in self.SelectedButtonsArray)
    {
        
        if (button == btn) {
            
            self.isHave = YES;
            return;
        }
        else
        {
            
            self.isHave = NO;
            [addArray addObject:button];
        }
    }
    
}
- (void)selectButtonAction:(UIButton *)button
{
    
    [self findButtonWithButton:button];
    
    if (self.isHave == YES)
    {
        [self setstatuForButtonsWithType:@"0" button:button];
        
        [self.SelectedButtonsArray removeObject:button];
        [self.liangdianArray removeObject:button.titleLabel.text];
        NSLog(@"%@",button.titleLabel.text);
        NSLog(@"%@",self.liangdianArray);
    }
    else
    {
        
        [self setstatuForButtonsWithType:@"1" button:button];
        [self.SelectedButtonsArray addObject:button];
        [self.liangdianArray addObject:button.titleLabel.text];
        NSLog(@"%@",button.titleLabel.text);
        NSLog(@"%@",self.liangdianArray);
        
    }
}
- (void)setstatuForButtonsWithType:(NSString *)type button:(UIButton *)button
{
    if ([type isEqualToString:@"0"]) {
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    else
    {
        button.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
        [button setTitleColor:[UIColor colorWithHexString:@"fdd000"] forState:(UIControlStateNormal)];
    }
    
}

- (void)setPromiseView
{
    UIView *mengbanView= [UIView new];
    UIView *weituoView = [UIView new];
    UIImageView *tuziImage = [UIImageView new];
    UIView *imageBackView = [UIView new];
    
    UIView *bottomView = [UIView new];
    
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    
    
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
    .widthIs(285 * kWidthScale)
    .heightIs(440 * kHeightScale);
    
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
    .topSpaceToView(imageBackView,0)
    .bottomSpaceToView(weituoView,0);
    
    
    
    label1.sd_layout.centerXEqualToView(bottomView)
    .topSpaceToView(bottomView,15)
    .heightIs(20);
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    label1.text = @"重要提示";
    
    label2.sd_layout.leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15)
    .topSpaceToView(label1,15)
    .autoHeightRatio(0);
    
    label2.text = @"您是否对您发布的信息进行真实性承诺，承诺后更能吸引服务方主动联系您，更有助于达成您的需求。无论承诺与否都不影响您的正常发布。";
    
    
    
    
    fabuButton.sd_layout.leftEqualToView(label2)
    .rightEqualToView(label2)
    .topSpaceToView(label2,20)
    .heightIs(40*kHeightScale);
    [fabuButton setTitle:@"承诺" forState:(UIControlStateNormal)];
    fabuButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
    fanhuiButton.sd_layout.leftEqualToView(label2)
    .rightEqualToView(label2)
    .topSpaceToView(fabuButton,20)
    .heightIs(40*kHeightScale);
    fanhuiButton.layer.borderWidth = 1.5;
    fanhuiButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    
    
    cancelButton.sd_layout.rightSpaceToView(imageBackView,10)
    .topSpaceToView(imageBackView,10)
    .heightIs(25)
    .widthIs(25);
    
    
    
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(weituoCancelAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [fanhuiButton setTitle:@"不承诺" forState:(UIControlStateNormal)];
    [fanhuiButton addTarget:self action:@selector(didClickFanhuiButtonAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [fabuButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [fanhuiButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [fabuButton addTarget:self action:@selector(didClickWeituoFabuAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //    self.weituoView = weituoView;
    weituoView.layer.cornerRadius = 10;
    weituoView.layer.masksToBounds = YES;
    self.PromiseView = mengbanView;
    //    [self.PromiseView setHidden:YES];
    
    
}
- (void)setWeituoView
{
    UIView *mengbanView= [UIView new];
    UIView *weituoView = [UIView new];
    UIImageView *tuziImage = [UIImageView new];
    UIView *imageBackView = [UIView new];
    
    UIView *bottomView = [UIView new];
    
    UILabel *pleaseLabel = [UILabel new];
    UILabel *kefuPhoneLabel = [UILabel new];
    
    UILabel *lianxiren = [UILabel new];
    UILabel *lianxifangshi = [UILabel new];
    
    self.lianxirenTextField = [UITextField new];
    self.lianxifangshiTextfield = [UITextField new];
    
    UIButton *fabuButton = [UIButton new];
    UIButton *fanhuiButton = [UIButton new];
    UIButton *cancelButton = [UIButton new];
    
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    UIView *line3 = [UIView new];
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:mengbanView];
    
    //    [self.ContentView addSubview:mengbanView];
    [mengbanView addSubview:weituoView];
    [weituoView addSubview:imageBackView];
    [imageBackView addSubview:tuziImage];
    [imageBackView addSubview:cancelButton];
    [weituoView addSubview:bottomView];
    [bottomView addSubview:pleaseLabel];
    [bottomView addSubview:kefuPhoneLabel];
    [bottomView addSubview:lianxiren];
    [bottomView addSubview:line1];
    [bottomView addSubview:line2];
    [bottomView addSubview:line3];
    [bottomView addSubview:lianxiren];
    [bottomView addSubview:lianxifangshi];
    [bottomView addSubview:self.lianxirenTextField];
    [bottomView addSubview:self.lianxifangshiTextfield];
    
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
    .widthIs(285 * kWidthScale)
    .heightIs(460 * kHeightScale);
    
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
    .topSpaceToView(imageBackView,0)
    .bottomSpaceToView(weituoView,0);
    
    
    pleaseLabel.sd_layout.leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15)
    .heightIs(20)
    .topSpaceToView(bottomView,15)
    .autoHeightRatio(0);
    pleaseLabel.text = @"请留下姓名及联系方式以便资芽网客服人员与您联系。";
    
    kefuPhoneLabel.sd_layout.leftEqualToView(pleaseLabel)
    .rightEqualToView(pleaseLabel)
    .heightIs(20)
    .topSpaceToView(pleaseLabel,10);
    
    kefuPhoneLabel.text = @"客服电话：400-898-8557";
    
    lianxiren.sd_layout.leftEqualToView(kefuPhoneLabel)
    .topSpaceToView(kefuPhoneLabel,30)
    .heightIs(20);
    
    lianxiren.text = @"联系人姓名：";
    
    
    line1.sd_layout.topSpaceToView(kefuPhoneLabel,15)
    .leftEqualToView(kefuPhoneLabel)
    .rightEqualToView(kefuPhoneLabel)
    .heightIs(1);
    
    [lianxiren setSingleLineAutoResizeWithMaxWidth:200];
    
    lianxifangshi.sd_layout.leftEqualToView(kefuPhoneLabel)
    .topSpaceToView(lianxiren,30)
    .heightIs(20);
    
    lianxifangshi.text = @"联系方式：";
    
    
    [lianxifangshi setSingleLineAutoResizeWithMaxWidth:200];
    
    
    line2.sd_layout.topSpaceToView(lianxiren,15)
    .leftEqualToView(kefuPhoneLabel)
    .rightEqualToView(kefuPhoneLabel)
    .heightIs(1);
    
    line3.sd_layout.topSpaceToView(lianxifangshi,15)
    .leftEqualToView(kefuPhoneLabel)
    .rightEqualToView(kefuPhoneLabel)
    .heightIs(1);
    
    line1.backgroundColor = [UIColor lightGrayColor];
    line2.backgroundColor = [UIColor lightGrayColor];
    line3.backgroundColor = [UIColor lightGrayColor];
    
    
    
    fabuButton.sd_layout.leftEqualToView(kefuPhoneLabel)
    .rightEqualToView(kefuPhoneLabel)
    .topSpaceToView(line3,20)
    .heightIs(40*kHeightScale);
    [fabuButton setTitle:@"委托发布" forState:(UIControlStateNormal)];
    fabuButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
    fanhuiButton.sd_layout.leftEqualToView(kefuPhoneLabel)
    .rightEqualToView(kefuPhoneLabel)
    .topSpaceToView(fabuButton,20)
    .heightIs(40*kHeightScale);
    fanhuiButton.layer.borderWidth = 1.5;
    fanhuiButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    
    
    cancelButton.sd_layout.rightSpaceToView(imageBackView,10)
    .topSpaceToView(imageBackView,10)
    .heightIs(25)
    .widthIs(25);
    
    self.lianxirenTextField.sd_layout.leftSpaceToView(lianxiren,0)
    .rightSpaceToView(bottomView,15)
    .centerYEqualToView(lianxiren)
    .heightIs(20);
    
    self.lianxifangshiTextfield.sd_layout.leftSpaceToView(lianxifangshi,0)
    .rightSpaceToView(bottomView,15)
    .centerYEqualToView(lianxifangshi)
    .heightIs(20);
    
    
    line1.alpha = 0.3;
    line2.alpha = 0.3;
    line3.alpha = 0.3;
    
    _lianxirenTextField.placeholder = @"请输入联系人姓名";
    _lianxifangshiTextfield.placeholder = @"请输入联系方式";
    
    _lianxirenTextField.textAlignment = NSTextAlignmentRight;
    _lianxifangshiTextfield.textAlignment = NSTextAlignmentRight;
    
    
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(weituoCancelAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [fanhuiButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [fanhuiButton addTarget:self action:@selector(didClickFanhuiButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [fabuButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [fanhuiButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [fabuButton addTarget:self action:@selector(didClickWeituoFabuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //    self.weituoView = weituoView;
    weituoView.layer.cornerRadius = 10;
    weituoView.layer.masksToBounds = YES;
    self.weituoView = mengbanView;
    //    [self.weituoView setHidden:YES];
    
}

- (void)didClickWeituoFabuAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
    [self postDataToDomainWithPromise:@"承诺"];
    
}
- (void)didClickFanhuiButtonAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
    [self postDataToDomainWithPromise:@"不承诺"];
}
- (void)postDataToDomainWithPromise:(NSString *)promise
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    //    http://apitest.ziyawang.com/v1/test/project/create
    //    http://apitest.ziyawang.com/v1/v2/uploadfile
    NSString *url1= getDataURL;
    //    NSString *url2 = @"/uploadfile?token=";
    NSString *url2 = @"/v2/uploadfile?token=";
    
    NSString *url = [url1 stringByAppendingString:url2];
    NSString *URL = [url stringByAppendingString:token];
    
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",urlStr);
    NSString *fileName = @"lll.wav";
    NSString *urlpath = [urlStr stringByAppendingString:fileName];
    NSURL *urla = [NSURL URLWithString:urlpath];
    
    NSURL *audiourl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.wav",urlStr]];
    
    
    for (NSString *str in self.liangdianArray) {
        self.liangdianStr = [self.liangdianStr stringByAppendingFormat:@",%@",str]
        ;
    }
    NSLog(@"%@",self.liangdianStr);
    self.liangdianStr = [self.liangdianStr substringFromIndex:1];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:promise forKey:@"Promise"];

    [dic setObject:self.liangdianStr forKey:@"ProLabel"];
    
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.shenfenLabel.text forKey:@"Identity"];
    
    [dic setObject:self.diquLabel.text forKey:@"ProArea"];
    [dic setObject:self.shangzhangLabel.text forKey:@"AssetType"];
    
    [dic setObject:self.jineTextField.text forKey:@"Money"];
    [dic setObject:self.yuqiTextField.text forKey:@"Month"];
    [dic setObject:self.textView.text forKey:@"WordDes"];
    
    
    if ([self.susongLabel.text isEqualToString:@"请选择"] == NO) {
        [dic setObject:self.susongLabel.text forKey:@"Law"];
        
    }
    if ([self.feisusongLabel.text isEqualToString:@"请选择"] == NO) {
        [dic setObject:self.feisusongLabel.text forKey:@"UnLaw"];
    }
    [dic setObject:self.qiyexingzhiLabel.text forKey:@"Nature"];
    [dic setObject:self.jingyingzhuangLabel.text forKey:@"Status"];
    [dic setObject:self.pingzhengLabel.text forKey:@"Guaranty"];
    [dic setObject:self.shesuLabel.text forKey:@"State"];
    [dic setObject:self.hangyeLabel.text forKey:@"Industry"];
    [dic setObject:@"18" forKey:@"TypeID"];
    
    
    NSLog(@"%@",dic);
    
    NSMutableArray *imageArray = [[AddImageManager AddManager]getImageArray];
    [[HttpManager httpManager]postDataWithURL:URL ImageArray:imageArray audioURL:audiourl param:dic];
}
- (void)weituoCancelAction2:(UIButton *)button
{
    
    [self.PromiseView removeFromSuperview];
}

- (void)didClickWeituoFabuAction:(UIButton *)button
{
    [self.view endEditing:YES];
    [self weituoFabu];
    
}
- (void)didClickFanhuiButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    [self.weituoView setHidden:YES];
    
}
- (void)weituoCancelAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    [self.weituoView setHidden:YES];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)buttonItem
{
    //    [self.weituoView setHidden:NO];
    [self setWeituoView];
    
}
- (void)weituoFabu
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[WeituoFabuURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"token" forKey:@"access_token"];
    [param setObject:@"22" forKey:@"TypeID"];
    [param setObject:self.lianxirenTextField.text forKey:@"ConnectPerson"];
    [param setObject:self.lianxifangshiTextfield.text forKey:@"ConnectPhone"];
    [param setObject:@"IOS" forKey:@"Channel"];
    
    
    
    [self.manager POST:URL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发布成功");
        
        [self.weituoView setHidden:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发布失败%@",error);
        [self.weituoView setHidden:YES];
    }];
    
}
- (IBAction)sendButtonAction:(id)sender {
    [self setPromiseView];
}

- (void)setViews
{
//    @property (weak, nonatomic) IBOutlet UIView *shenfenView;
//    @property (weak, nonatomic) IBOutlet UIView *shangzhangleixingView;
//    @property (weak, nonatomic) IBOutlet UIView *susongView;
//    @property (weak, nonatomic) IBOutlet UIView *feisusonView;
//    @property (weak, nonatomic) IBOutlet UIView *diquView;
//    @property (weak, nonatomic) IBOutlet UIView *zhaiwufangxingzhiView;
//    @property (weak, nonatomic) IBOutlet UIView *jingyingzhuangView;
//    @property (weak, nonatomic) IBOutlet UIView *pingzhengView;
//    @property (weak, nonatomic) IBOutlet UIView *shesuView;
//    @property (weak, nonatomic) IBOutlet UIView *zhaiwufanghangyeView;
    NSArray *array = @[self.shenfenView,self.shangzhangleixingView,self.susongView,self.feisusonView,self.diquView,self.zhaiwufangxingzhiView,self.jingyingzhuangView,self.pingzhengView,self.shesuView,self.zhaiwufanghangyeView];
    
    
    [self.viewArray addObjectsFromArray:array];
    int i = 0;
    for (UIView *view in self.viewArray)
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
        [view addGestureRecognizer:gesture];
        
        view.tag = i;
        i ++;
    }
    NSArray *array1 = @[@"债权人",@"FA(中介)"];
    NSArray *array2 = @[@"货款",@"工程款",@"违约金",@"其他"];
    
    NSArray *array3 = @[@"10%-20%",@"20%-30%",@"30%-40%",@"%40以上"];
    NSArray *array4 = @[@"10%-20%",@"20%-30%",@"30%-40%",@"%40以上"];
    
    NSArray *array5 = @[@"地区选择"];

    NSArray *array6 = @[@"国企",@"央企",@"民营",@"其他"];
    NSArray *array7 = @[@"正常运营",@"濒临倒闭",@"倒闭",@"其他"];
    NSArray *array8 = @[@"有",@"无"];
    
    NSArray *array9 = @[@"已诉",@"未诉",@"已判决"];
    NSArray *array10 = @[@"IT|通信|电子|互联网",@"金融业",@"房地产|建筑业",@"商业服务",@"贸易|批发|零售|租赁",@"文体教育|工艺美术",@"生产|加工|制造",@"交通|运输|物流|仓储",@"服务业",@"文化|传媒|娱乐|体育",@"能源|矿产|环保",@"政府|非盈利机构",@"农|林|牧|渔|其他"];
    

    
    
    [self.AllArray addObject:array1];
    [self.AllArray addObject:array2];
    [self.AllArray addObject:array3];
    [self.AllArray addObject:array4];
    [self.AllArray addObject:array5];
    [self.AllArray addObject:array6];
    
    [self.AllArray addObject:array7];
    [self.AllArray addObject:array8];
    [self.AllArray addObject:array9];
    [self.AllArray addObject:array10];


    
    //    NSArray *array7 = @[];
    //    NSArray *array8 = @[];
    //
}

- (void)gestureAction:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];

    switch (gesture.view.tag) {
        case 0:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[0]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[0][0];
            
            self.row = 0;
        }
            break;
        case 1:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[1]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[1][0];
            
            self.row = 1;
        }
            break;
        case 2:
        {
            if (self.choose1) {
                [self.chooseImage1 setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"]];
                self.susongLabel.text = @"请选择";
            }
            else
            {
                [self.chooseImage1 setImage:[UIImage imageNamed:@"leixingxuanzhong"]];
                [self.mengbanView setHidden:NO];
                [UIView animateWithDuration:0.5 animations:^{
                    self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
                }];
                self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[2]];
                [self.pickerView reloadAllComponents];
                [self.pickerView selectRow:0 inComponent:0 animated:NO];
                self.selectStr = self.AllArray[2][0];
                
                self.row = 2;
                
            }
            self.choose1 = !self.choose1;
            
        }
            
            break;
        case 3:
        {
            if (self.choose2) {
                [self.chooseImage2 setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"]];
                self.feisusongLabel.text = @"请选择";
            }
            else
            {
                [self.chooseImage2 setImage:[UIImage imageNamed:@"leixingxuanzhong"]];
                [self.mengbanView setHidden:NO];
                [UIView animateWithDuration:0.5 animations:^{
                    self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
                }];
                self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[3]];
                [self.pickerView reloadAllComponents];
                [self.pickerView selectRow:0 inComponent:0 animated:NO];
                self.selectStr = self.AllArray[3][0];
                
                self.row = 3;
            }
            self.choose2 = !self.choose2;
            
        }
            break;
        case 4:
        {
//            [self.mengbanView setHidden:NO];
//            [UIView animateWithDuration:0.5 animations:^{
//                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
//            }];
//            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[4]];
//            [self.pickerView reloadAllComponents];
//            [self.pickerView selectRow:0 inComponent:0 animated:NO];
//            self.selectStr = self.AllArray[4][0];
//
//            self.row = 4;
            {
                ChooseAreaController *chooseVC = [[ChooseAreaController alloc]init];
                chooseVC.type = @"信息";
                [self.navigationController pushViewController:chooseVC animated:YES];
                
                
            }
        }
            break;
        case 5:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[5]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[5][0];

            self.row = 5;
        }
            
            break;
        case 6:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[6]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[6][0];
            
            self.row = 6;
        }
            break;
        case 7:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[7]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[7][0];
            
            self.row = 7;
        }
            break;
        case 8:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[8]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[8][0];
            
            self.row = 8;
        }            break;
        case 9:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[9]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[9][0];
            
            self.row = 9;
        }
            break;
            
        default:
            break;
    }
}
/**
 *  初始化PickerView
 */
- (void)setPickerView
{
    self.mengbanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.mengbanView.backgroundColor = [UIColor blackColor];
    self.mengbanView.alpha = 0.5;
    
    [self.view addSubview:self.mengbanView];
    [self.mengbanView setHidden:YES];
    
    self.pickerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 300)];
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50,self.pickerBackView.bounds.size.width,150)];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource= self;
    
    self.pickerBackView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setFrame:CGRectMake(0, 0, 40, 30)];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [sureButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 0, 40, 30)];
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    
    [cancelButton addTarget:self action:@selector(didClickCancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [sureButton addTarget:self action:@selector(didClickSureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    [self.pickerBackView addSubview:self.pickerView];
    [self.pickerBackView addSubview:cancelButton];
    [self.pickerBackView addSubview:sureButton];
    [self.view addSubview:self.pickerBackView];
    
    
}
#pragma mark----pickerView Button Action
- (void)didClickCancelButtonAction:(UIButton*)sender
{
    [self.mengbanView setHidden:YES];
    if (self.row == 2) {
        [self.chooseImage1 setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"]];
    }
    else if(self.row == 3)
    {
        [self.chooseImage2 setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"]];
        
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height;
    }];
    
    
}
- (void)didClickSureButtonAction:(UIButton *)sender
{
    [self.mengbanView setHidden:YES];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height;
    }];
     NSArray *array = @[self.shenfenView,self.shangzhangleixingView,self.susongView,self.feisusonView,self.diquView,self.zhaiwufangxingzhiView,self.jingyingzhuangView,self.pingzhengView,self.shesuView,self.zhaiwufanghangyeView];
    switch (self.row) {
        case 0:
            self.shenfenLabel.text = self.selectStr;
            break;
        case 1:
            self.shangzhangLabel.text = self.selectStr;
            break;
        case 2:
            self.susongLabel.text = self.selectStr;
            break;
        case 3:
            self.feisusongLabel.text = self.selectStr;
            break;
        case 4:
            self.diquLabel.text = @"地区选择";
            
            break;
        case 5:
            self.qiyexingzhiLabel.text = self.selectStr;
            break;
        case 6:
            self.jingyingzhuangLabel.text = self.selectStr;
            break;
        case 7:
            self.pingzhengLabel.text = self.selectStr;
            break;
        case 8:
            self.shesuLabel.text = self.selectStr;
            break;
        case 9:
            self.hangyeLabel.text = self.selectStr;
            break;
        default:
            break;
    }
    
    
    
    
}
#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.sourceArray.count;
}

#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.sourceArray[row];
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.selectStr = self.sourceArray[row];
    [pickerView reloadComponent:0];
    //    NSLog(@"%@",self.selectStr);
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    
    return 40;
    
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
