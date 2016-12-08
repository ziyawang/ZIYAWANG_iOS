//
//  PersonalDebtsController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PersonalDebtsController.h"
#import "RecordManager.h"
#import "AddImageManager.h"
#import "HttpManager.h"
#import "ChooseAreaController.h"

@interface PersonalDebtsController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *chooseShenfenView;
@property (weak, nonatomic) IBOutlet UIView *zhaquanrenView;
@property (weak, nonatomic) IBOutlet UIView *zhaiwurenView;

@property (weak, nonatomic) IBOutlet UIView *susongView;
@property (weak, nonatomic) IBOutlet UIView *feisusongView;

@property (weak, nonatomic) IBOutlet UIView *danbaoView;
@property (weak, nonatomic) IBOutlet UIView *diyaView;
@property (weak, nonatomic) IBOutlet UIView *shilianView;
@property (weak, nonatomic) IBOutlet UIView *changhuanView;
@property (weak, nonatomic) IBOutlet UIView *pingzhengView;

@property (weak, nonatomic) IBOutlet UIButton *falvButton;
@property (weak, nonatomic) IBOutlet UIButton *yongjinButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *chooseShenfenLabel;

@property (weak, nonatomic) IBOutlet UITextField *zongjineTextField;
@property (weak, nonatomic) IBOutlet UITextField *yuqiTextField;
@property (weak, nonatomic) IBOutlet UITextField *chuzifangshiTextfeld;

@property (weak, nonatomic) IBOutlet UILabel *susongLabel;
@property (weak, nonatomic) IBOutlet UILabel *feisusongLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhaiquanrenLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhaiwurenLabel;
@property (weak, nonatomic) IBOutlet UILabel *danbaoLAbel;
@property (weak, nonatomic) IBOutlet UILabel *diyaLabel;
@property (weak, nonatomic) IBOutlet UILabel *shilianLabel;
@property (weak, nonatomic) IBOutlet UILabel *changhuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingzhengLabel;
@property (weak, nonatomic) IBOutlet UIView *ContentView;

@property (weak, nonatomic) IBOutlet UITextField *connectPersong;
@property (weak, nonatomic) IBOutlet UITextField *connectPhone;


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
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UIView *weituoView;

@property (nonatomic,strong) UITextField *lianxirenTextField;
@property (nonatomic,strong) UITextField *lianxifangshiTextfield;


@property (nonatomic,strong) NSMutableArray *SelectedButtonsArray;

@property (nonatomic,strong) NSMutableArray *liangdianArray;
@property (nonatomic,strong) NSString *liangdianStr;
@property (nonatomic,assign) BOOL isHave;

@property (nonatomic,strong) UIView *PromiseView;

@property (nonatomic,assign)   BOOL isHaveDian;

@property (nonatomic,strong) UILabel *yongjinLabel;
@end

@implementation PersonalDebtsController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *suozai = [[NSUserDefaults standardUserDefaults]objectForKey:@"企业所在"];
    if (suozai == nil) {
        
    }
    else
    {
        self.zhaiquanrenLabel.text = suozai;
    }
    
    NSString *suozai1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"企业所在1"];
    
    if (suozai1 == nil) {
        
    }
    else
    {
        self.zhaiwurenLabel.text = suozai1;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];

    self.scrollView.delegate = self;

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"企业所在"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"企业所在1"];

    self.navigationItem.title = @"个人债权";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"委托发布" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
    
    
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

//    [self setWeituoView];
    
    
    self.falvButton.tag = 1;
    self.yongjinButton.tag = 2;
    
   
    self.SelectedButtonsArray = [NSMutableArray new];
    UIButton *button = [UIButton new];
    button.tag = 3;
    [self.SelectedButtonsArray addObject:button];
    self.liangdianArray = [NSMutableArray new];
    self.liangdianStr = [NSString string];
    
    [self setstatuForButtonsWithType:@"0" button:self.falvButton];
    [self setstatuForButtonsWithType:@"0" button:self.yongjinButton];
    [self.falvButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.yongjinButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.textView.text = @"请输入文字描述";
    self.textView.textColor = [UIColor grayColor];
    self.textView.delegate = self;

    self.zongjineTextField.delegate = self;
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入文字描述"]) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
    }
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
    pleaseLabel.text = @"请留下姓名及联系方式以便资芽网客服人员与您联系，帮您发布。";
    
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
    
    _lianxirenTextField.tag = 11;
    _lianxifangshiTextfield.tag = 12;
    
    _lianxifangshiTextfield.delegate = self;
    _lianxirenTextField.delegate = self;

    
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
    [self.weituoView removeFromSuperview];
}
- (void)weituoCancelAction:(UIButton *)button
{
    [_lianxirenTextField resignFirstResponder];
    [_lianxifangshiTextfield resignFirstResponder];
    [self.weituoView removeFromSuperview];
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
    [param setObject:@"19" forKey:@"TypeID"];
    [param setObject:self.lianxirenTextField.text forKey:@"ConnectPerson"];
    [param setObject:self.lianxifangshiTextfield.text forKey:@"ConnectPhone"];
    [param setObject:@"IOS" forKey:@"Channel"];
    
    
    
    [self.manager POST:URL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发布成功");
        
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.weituoView removeFromSuperview];
        [MyMBHud MBProgressWithString:@"发布成功，请耐心等待客服人员与您联系" timer:2 mode:(MBProgressHUDModeText) target:self];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发布失败%@",error);
        [self.navigationController popViewControllerAnimated:YES];
        
        [MyMBHud MBProgressWithString:@"发布失败，请稍后重试" timer:2 mode:(MBProgressHUDModeText) target:self];
        
        [self.weituoView removeFromSuperview];
        
    }];
    
}

- (void)postDataToDomainWithPromise:(NSString *)promise
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    //    http://apitest.ziyawang.com/v1/test/project/create
    //    http://apitest.ziyawang.com/v1/v2/uploadfile
    NSString *url1= getDataURL;
    //    NSString *url2 = @"/uploadfile?token=";
    NSString *url2 = @"/uploadfile?token=";
    
    NSString *url = [url1 stringByAppendingString:url2];
    NSString *URL = [url stringByAppendingString:token];
    
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",urlStr);
    NSString *fileName = @"lll.wav";
    NSString *urlpath = [urlStr stringByAppendingString:fileName];
    NSURL *urla = [NSURL URLWithString:urlpath];
    
    NSURL *audiourl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.wav",urlStr]];
    
    
    if (self.liangdianArray.count != 0) {
        for (NSString *str in self.liangdianArray) {
            self.liangdianStr = [self.liangdianStr stringByAppendingFormat:@",%@",str]
            ;
        }
        
        self.liangdianStr = [self.liangdianStr substringFromIndex:1];
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:promise forKey:@"Promise"];

    [dic setObject:self.liangdianStr forKey:@"ProLabel"];
    
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:@"19" forKey:@"TypeID"];
    
    
    
    //
    
    
    
    [dic setObject:self.chooseShenfenLabel.text forKey:@"Identity"];
    [dic setObject:self.zongjineTextField.text forKey:@"TotalMoney"];
    [dic setObject:self.yuqiTextField.text forKey:@"Month"];
    if ([self.susongLabel.text isEqualToString:@"请选择"]==NO) {
        [dic setObject:self.susongLabel.text forKey:@"Law"];
        
    }
    if ([self.feisusongLabel.text isEqualToString:@"请选择"]==NO) {
        [dic setObject:self.feisusongLabel.text forKey:@"UnLaw"];
    }
    
    [dic setObject:self.zhaiquanrenLabel.text forKey:@"DebteeLocation"];
    [dic setObject:self.zhaiwurenLabel.text forKey:@"ProArea"];
    
    if ([self.danbaoLAbel.text isEqualToString:@"请选择"] == NO) {
        [dic setObject:self.danbaoLAbel.text forKey:@"Guaranty"];

    }
    if ([self.diyaLabel.text isEqualToString:@"请选择"] == NO) {
        [dic setObject:self.diyaLabel.text forKey:@"Property"];

    }
    if ([self.shilianLabel.text isEqualToString:@"请选择"] == NO) {
        [dic setObject:self.shilianLabel.text forKey:@"Connect"];

    }
    if ([self.changhuanLabel.text isEqualToString:@"请选择"] == NO) {
        [dic setObject:self.changhuanLabel.text forKey:@"Pay"];

    }
    if ([self.pingzhengLabel.text isEqualToString:@"请选择"] == NO) {
        [dic setObject:self.pingzhengLabel.text forKey:@"Credentials"];

    }
    
    //    [dic setObject:self.qipaijiaTextField.text forKey:@"Money"];
    //    [dic setObject:self.paimaididianLabel.text forKey:@"ProArea"];
    //    [dic setObject:self.paimaishijianLabel.text forKey:@"Year"];
    //    [dic setObject:self.paimaijieduanLabel.text forKey:@"State"];
    //    [dic setObject:self.chuzhidanweiTextField.text forKey:@"Court"];
    [dic setObject:self.connectPersong.text forKey:@"ConnectPerson"];
    [dic setObject:self.connectPhone.text forKey:@"ConnectPhone"];
    [dic setObject:self.textView.text forKey:@"WordDes"];
    
    
    [dic setObject:@"IOS" forKey:@"Channel"];
    
    NSLog(@"%@",dic);
    NSMutableArray *imageArray = [[AddImageManager AddManager]getImageArray];
    [[HttpManager httpManager]postDataWithURL:URL ImageArray:imageArray audioURL:audiourl param:dic];
    [HttpManager httpManager].ifpop = ^(NSString *statu)
    {
        [self.navigationController popViewControllerAnimated:YES];
    };

}
- (IBAction)sendButtonAction:(id)sender {
    [self.view endEditing:YES];
    if ([self.chooseShenfenLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择您的身份" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:_zongjineTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入总金额" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:_yuqiTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入逾期时间" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([self.susongLabel.text isEqualToString:@"请选择"] && [_feisusongLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择诉讼方式" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([self.zhaiquanrenLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择债权人所在地" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([self.zhaiwurenLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择债务人所在地" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if (self.textView.text == nil || [self.textView.text isEqualToString:@"请输入文字描述"] ||[self.textView.text isEqualToString:@""]) {
        [MyMBHud MBProgressWithString:@"请输入文字描述" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([[AddImageManager AddManager]getImageArray].count == 0) {
        [MyMBHud MBProgressWithString:@"请上传至少一张图片" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.connectPersong] == NO) {
        [MyMBHud MBProgressWithString:@"请输入联系人姓名" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.connectPhone] == NO) {
        [MyMBHud MBProgressWithString:@"请输入联系方式" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    [self setPromiseView];
}
- (void)setViews
{
    NSArray *array = @[self.chooseShenfenView,self.susongView,self.feisusongView,self.zhaquanrenView,self.zhaiwurenView,self.danbaoView,self.diyaView,self.shilianView,self.changhuanView,self.pingzhengView];
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
    NSArray *array2 = @[@"10%-20%",@"20%-30%",@"30%-40%",@"40%以上"];
    
    NSArray *array3 = @[@"10%-20%",@"20%-30%",@"30%-40%",@"40%以上"];
    NSArray *array4 = @[];
    
    NSArray *array5 = @[];
    NSArray *array6 = @[@"是",@"否"];
    
    
    [self.AllArray addObject:array1];
    [self.AllArray addObject:array2];
    [self.AllArray addObject:array3];
    [self.AllArray addObject:array4];
    [self.AllArray addObject:array5];
    [self.AllArray addObject:array6];
    
//    NSArray *array7 = @[];
//    NSArray *array8 = @[];
//    
}

- (void)gestureAction:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    [_yongjinLabel setHidden:YES];
    
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
            
            if (self.choose1) {
                [self.chooseImage1 setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"]];
                self.susongLabel.text = @"请选择";
            }
            else
            {
                [_yongjinLabel setHidden:NO];

            [self.chooseImage1 setImage:[UIImage imageNamed:@"leixingxuanzhong"]];
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
            self.choose1 = !self.choose1;

        }
            
            break;
        case 2:
        {
            
            if (self.choose2) {
                [self.chooseImage2 setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"]];
                self.feisusongLabel.text = @"请选择";
            }
            else
            {
                [_yongjinLabel setHidden:NO];

                [self.chooseImage2 setImage:[UIImage imageNamed:@"leixingxuanzhong"]];
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
            self.choose2 = !self.choose2;

        }
            break;
        case 3:
        {
//            [self.mengbanView setHidden:NO];
//            [UIView animateWithDuration:0.5 animations:^{
//                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
//            }];
//            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[3]];
//            [self.pickerView reloadAllComponents];
//            [self.pickerView selectRow:0 inComponent:0 animated:NO];
//            self.row = 3;
            
            {
                ChooseAreaController *chooseVC = [[ChooseAreaController alloc]init];
                chooseVC.type = @"信息";
                [self.navigationController pushViewController:chooseVC animated:YES];
                
                
            }

        }
            break;
        case 4:
        {
            {
                ChooseAreaController *chooseVC = [[ChooseAreaController alloc]init];
                chooseVC.type = @"信息1";
                [self.navigationController pushViewController:chooseVC animated:YES];
                
                
            }
//            [self.mengbanView setHidden:NO];
//            [UIView animateWithDuration:0.5 animations:^{
//                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
//            }];
//            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[4]];
//            [self.pickerView reloadAllComponents];
//            [self.pickerView selectRow:0 inComponent:0 animated:NO];
//            self.row = 4;
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
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[5]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[5][0];

            self.row = 6;
        }
            break;
        case 7:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[5]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[5][0];

            self.row = 7;
        }            break;
        case 8:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[5]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[5][0];

            self.row = 8;
        }
            
        break;
        case 9:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[5]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[5][0];
            
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
    
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [cancelButton addTarget:self action:@selector(didClickCancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [sureButton addTarget:self action:@selector(didClickSureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    _yongjinLabel = [UILabel new];
    [self.pickerBackView addSubview:_yongjinLabel];
    _yongjinLabel.text = @"佣金比例";
    _yongjinLabel.textColor = [UIColor grayColor];
    
    _yongjinLabel.sd_layout.centerXEqualToView(self.pickerBackView)
    .topSpaceToView(self.pickerBackView,10)
    .heightIs(20);
    [_yongjinLabel setSingleLineAutoResizeWithMaxWidth:200];
    [_yongjinLabel setHidden:YES];
    
    
    [self.pickerBackView addSubview:self.pickerView];
    [self.pickerBackView addSubview:cancelButton];
    [self.pickerBackView addSubview:sureButton];
    [self.view addSubview:self.pickerBackView];
    
    
}
#pragma mark----pickerView Button Action
- (void)didClickCancelButtonAction:(UIButton*)sender
{
    [self.mengbanView setHidden:YES];
    if (self.row == 1) {
        [self.chooseImage1 setImage:[UIImage imageNamed:@"leixingxuanweixuanzhong"]];
    }
    else if(self.row == 2)
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
    
    switch (self.row) {
        case 0:
            self.chooseShenfenLabel.text = self.selectStr;
            break;
        case 1:
            self.susongLabel.text = self.selectStr;
            break;
        case 2:
            self.feisusongLabel.text = self.selectStr;
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            self.danbaoLAbel.text = self.selectStr;
            break;
        case 6:
            self.diyaLabel.text = self.selectStr;
            break;
        case 7:
            self.shilianLabel.text = self.selectStr;
            break;
        case 8:
            self.changhuanLabel.text = self.selectStr;
            break;
        case 9:
            self.pingzhengLabel.text = self.selectStr;
            break;
        default:
            break;
    }
    
    
    
    
}

#pragma mark - UITextField delegate
//textField.text 输入之前的值 string 输入的字符
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 11 || textField.tag == 12) {
        [TextFieldViewAnimate textFieldAnimateWithView:[[textField superview] superview] up:YES];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 11 || textField.tag == 12) {
        [TextFieldViewAnimate textFieldAnimateWithView:[[textField superview] superview] up:NO];
    }
}
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag != 11 && textField.tag != 12)
    {
        NSInteger value = [textField.text integerValue];
        if (value > 999999.9) {
            textField.text = [textField.text substringToIndex:6];
            //            [self showError:@"您输入的位数过多"];
        }
        
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            self.isHaveDian = NO;
        }
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [self showError:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0') {
                        [self showError:@"亲，第一个数字不能为0"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                //输入的字符是否是小数点
                if (single == '.') {
                    if(self.isHaveDian==NO)//text中还没有小数点
                    {
                        self.isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [self showError:@"亲，您已经输入过小数点了"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (self.isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            //                        [self showError:@"亲，您最多输入两位小数"];
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [self showError:@"亲，您输入的格式不正确"];
                NSLog(@"%lu",(unsigned long)range.length);
                if (range.length != 0) {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                }
                return NO;
            }
        }
        else
        {
            return YES;
        }
        
    }
    return YES;
    
}

- (void)showError:(NSString *)errorString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
    //    [(AppDelegate *)[UIApplication sharedApplication].delegate showErrorView:errorString];
    //    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeErrorView2) userInfo:nil repeats:NO];
    
    //    [self.moneyTf resignFirstResponder];
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
