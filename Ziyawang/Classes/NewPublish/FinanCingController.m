//
//  FinanCingController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FinanCingController.h"
#import "RecordManager.h"
#import "AddImageManager.h"
#import "HttpManager.h"
#import "ChooseAreaController.h"
@interface FinanCingController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *shenfenView;
@property (weak, nonatomic) IBOutlet UIView *suozaidiView;
@property (weak, nonatomic) IBOutlet UIView *rongzifangshiView;
@property (weak, nonatomic) IBOutlet UIView *danbaofangshiView;
@property (weak, nonatomic) IBOutlet UIView *qiyexianzhuangView;
@property (weak, nonatomic) IBOutlet UIView *suoshuhangyeView;
@property (weak, nonatomic) IBOutlet UIView *zijinyongtuView;
@property (weak, nonatomic) IBOutlet UIView *liangdianView1;
@property (weak, nonatomic) IBOutlet UIView *liangdianView2;

@property (weak, nonatomic) IBOutlet UILabel *shenfenLabel;
@property (weak, nonatomic) IBOutlet UILabel *suozaidLabel;
@property (weak, nonatomic) IBOutlet UILabel *rongzifangshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *danbaofangshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *xianzhaungLabel;
@property (weak, nonatomic) IBOutlet UILabel *hangyeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zijinyongtuLabel;

@property (weak, nonatomic) IBOutlet UITextField *jineTextField;
@property (weak, nonatomic) IBOutlet UITextField *qixianTextField;
@property (weak, nonatomic) IBOutlet UITextField *guquanbiliTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;



@property (nonatomic,strong) NSMutableArray *viewArray;

@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *pickerBackView;
@property (nonatomic,strong) UIView *DatepickerBackView;

@property (nonatomic,strong) UIView *mengbanView;
@property (nonatomic,strong) NSString *selectStr;
@property (nonatomic,assign) NSInteger row;

@property (nonatomic,strong) NSMutableArray *AllArray;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (weak, nonatomic) IBOutlet UIView *qixianView;
@property (weak, nonatomic) IBOutlet UIView *guquanbiliView;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *danbaoViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qixianViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guquanbiliHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qiyexianzhuangHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suoshuhangyeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zijinyongtuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liangdianHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liangdianHeight2;

@property (weak, nonatomic) IBOutlet UIView *recordView;

@property (weak, nonatomic) IBOutlet UIView *ImageBackView;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;


@property (nonatomic,strong) NSMutableArray *SelectedButtonsArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UIView *weituoView;

@property (nonatomic,strong) UITextField *lianxirenTextField;
@property (nonatomic,strong) UITextField *lianxifangshiTextfield;
@property (weak, nonatomic) IBOutlet UIView *ContentView;

@property (nonatomic,strong) NSMutableArray *liangdianArray;
@property (nonatomic,strong) NSString *liangdianStr;
@property (nonatomic,assign) BOOL isHave;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic,strong) UIView *PromiseView;

@property (nonatomic,assign)   BOOL isHaveDian;

@end

@implementation FinanCingController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *suozai = [[NSUserDefaults standardUserDefaults]objectForKey:@"企业所在"];
    if (suozai == nil) {
        
    }
    else
    {
        self.suozaidLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"企业所在"];
    }
    
    
}
- (void)setZhaiquanView
{
    [self.danbaofangshiView setHidden:NO];
    self.danbaoViewHeight.constant = 50;
    
    [self.qixianView setHidden:NO];
    self.qixianViewHeight.constant = 50;
    
    [self.liangdianView2 setHidden:YES];
    self.liangdianHeight2.constant = 0;
    
    [self.liangdianView1 setHidden:NO];
    self.liangdianHeight1.constant = 110;
    
    
    [self.guquanbiliView setHidden:YES];
    self.guquanbiliHeight.constant = 0;
    
    
    [self.qiyexianzhuangView setHidden:YES];
    self.qiyexianzhuangHeight.constant = 0;
    [self.suoshuhangyeView setHidden:YES];
    self.suoshuhangyeHeight.constant = 0;
    [self.zijinyongtuView setHidden:YES];
    self.zijinyongtuHeight.constant = 0;
    
    
}
- (void)setGuquanView
{
    [self.danbaofangshiView setHidden:YES];
    self.danbaoViewHeight.constant = 0;
    
    [self.qixianView setHidden:YES];
    self.qixianViewHeight.constant = 0;
    
    [self.guquanbiliView setHidden:NO];
    self.guquanbiliHeight.constant = 50;
    
    [self.liangdianView2 setHidden:NO];
    self.liangdianHeight2.constant = 110;
    
    [self.liangdianView1 setHidden:YES];
    self.liangdianHeight1.constant = 0;
    

    
    
    [self.qiyexianzhuangView setHidden:NO];
    self.qiyexianzhuangHeight.constant = 50;
    [self.suoshuhangyeView setHidden:NO];
    self.suoshuhangyeHeight.constant = 50;
    [self.zijinyongtuView setHidden:NO];
    self.zijinyongtuHeight.constant = 50;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.delegate = self;
    self.jineTextField.delegate = self;
    
    self.sendButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];

    self.navigationItem.title = @"融资信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"委托发布" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
    self.SelectedButtonsArray = [NSMutableArray new];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
    self.viewArray = [NSMutableArray new];
    self.AllArray = [NSMutableArray new];
    self.sourceArray = [NSMutableArray new];
    [self setZhaiquanView];
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
    [self setstatuForButtonsWithType:@"0" button:self.button3];
    [self setstatuForButtonsWithType:@"0" button:self.button4];
    [self setstatuForButtonsWithType:@"0" button:self.button5];
    [self setstatuForButtonsWithType:@"0" button:self.button6];
    [self setstatuForButtonsWithType:@"0" button:self.button7];
    [self.button1 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button2 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button3 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button4 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button5 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button6 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button7 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
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
    [dic setObject:self.shenfenLabel.text forKey:@"Identity"];
    
    [dic setObject:self.suozaidLabel.text forKey:@"ProArea"];
    [dic setObject:self.rongzifangshiLabel.text forKey:@"AssetType"];
    [dic setObject:@"IOS" forKey:@"Channel"];
    [dic setObject:self.textView.text forKey:@"WordDes"];
    
    [dic setObject:self.nameTextField.text forKey:@"ConnectPerson"];
    [dic setObject:self.phoneTextField.text forKey:@"ConnectPhone"];
    
    if ([self.rongzifangshiLabel.text isEqualToString:@"债权融资"]) {
        [dic setObject:self.jineTextField.text forKey:@"Money"];
        [dic setObject:self.danbaofangshiLabel.text forKey:@"Type"];
        [dic setObject:self.qixianTextField.text forKey:@"Month"];
        [dic setObject:@"17" forKey:@"TypeID"];
        
        
    }
    else
    {
        [dic setObject:self.jineTextField.text forKey:@"TotalMoney"];
        [dic setObject:self.guquanbiliTextField.text forKey:@"Rate"];
        [dic setObject:self.xianzhaungLabel.text forKey:@"Status"];
        [dic setObject:self.hangyeLabel.text forKey:@"Belong"];
        [dic setObject:self.zijinyongtuLabel.text forKey:@"Userfor"];
        [dic setObject:@"6" forKey:@"TypeID"];
        
    }
    
    
    NSLog(@"%@",dic);
    
    NSMutableArray *imageArray = [[AddImageManager AddManager]getImageArray];
    [[HttpManager httpManager]postDataWithURL:URL ImageArray:imageArray audioURL:audiourl param:dic];
    [HttpManager httpManager].ifpop = ^(NSString *statu)
    {
        [self.navigationController popViewControllerAnimated:YES];
    };
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
    [param setObject:@"22" forKey:@"TypeID"];
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
        
        [self.weituoView removeFromSuperview];    }];
    
}
- (IBAction)sendButtonAction:(id)sender {
    [self.view endEditing:YES];

    if ([self.shenfenLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择身份" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([self.suozaidLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择地区" timer:1 mode:(MBProgressHUDModeText) target:self];
         return;
    }
    if ([self.rongzifangshiLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择融资方式" timer:1 mode:(MBProgressHUDModeText) target:self];
         return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:_jineTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入融资金额" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
        
    }
    if ([self.rongzifangshiLabel.text isEqualToString:@"债权融资"]) {
        if ([self.danbaofangshiLabel.text isEqualToString:@"请选择"]) {
            [MyMBHud MBProgressWithString:@"请选择身份" timer:1 mode:(MBProgressHUDModeText) target:self];
             return;
        }
        if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:_qixianTextField] == NO) {
            [MyMBHud MBProgressWithString:@"请输入使用期限" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
    }
    if ([self.rongzifangshiLabel.text isEqualToString:@"股权融资"]) {
        if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:_guquanbiliTextField] == NO) {
            [MyMBHud MBProgressWithString:@"请输入出让股权比例" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
        if ([self.xianzhaungLabel.text isEqualToString:@"请选择"]) {
            [MyMBHud MBProgressWithString:@"请选择企业现状" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
        if ([self.hangyeLabel.text isEqualToString:@"请选择"]) {
            [MyMBHud MBProgressWithString:@"请选择所属行业" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
        if ([self.zijinyongtuLabel.text isEqualToString:@"请选择"]) {
            [MyMBHud MBProgressWithString:@"请选择资金用途" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
    }
    
    if (self.textView.text == nil || [self.textView.text isEqualToString:@"请输入文字描述"] ||[self.textView.text isEqualToString:@""]) {
        [MyMBHud MBProgressWithString:@"请输入文字描述" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([[AddImageManager AddManager]getImageArray].count == 0) {
        [MyMBHud MBProgressWithString:@"请上传至少一张图片" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.nameTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入联系人姓名" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.phoneTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入联系方式" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    [self setPromiseView];
    
    }


- (void)setViews
{
//    @property (weak, nonatomic) IBOutlet UIView *shenfenView;
//    @property (weak, nonatomic) IBOutlet UIView *suozaidiView;
//    @property (weak, nonatomic) IBOutlet UIView *rongzifangshiView;
//    @property (weak, nonatomic) IBOutlet UIView *danbaofangshiView;
//    @property (weak, nonatomic) IBOutlet UIView *qiyexianzhuangView;
//    @property (weak, nonatomic) IBOutlet UIView *suoshuhangyeView;
//    @property (weak, nonatomic) IBOutlet UIView *zijinyongtuView;
//    @property (weak, nonatomic) IBOutlet UIView *liangdianView1;
//    @property (weak, nonatomic) IBOutlet UIView *liangdianView2;
    NSArray *array = @[self.shenfenView,self.suozaidiView,self.rongzifangshiView,self.danbaofangshiView,self.qiyexianzhuangView,self.suoshuhangyeView,self.zijinyongtuView];
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
    
    NSArray *array3 = @[@"债权融资",@"股权融资"];
    NSArray *array4 = @[@"抵押",@"质押",@"担保人",@"其他"];
    
    NSArray *array5 = @[@"初创期",@"成长期",@"其他"];
    
    NSArray *array6 = @[@"IT|通信|电子|互联网",@"金融业",@"房地产|建筑业",@"商业服务",@"贸易|批发|零售|租赁",@"文体教育|工艺美术",@"生产|加工|制造",@"交通|运输|物流|仓储",@"服务业",@"文化|传媒|娱乐|体育",@"能源|矿产|环保",@"政府|非盈利机构",@"农|林|牧|渔|其他"];
    NSArray *array7 = @[@"经营",@"扩张",@"其他"];
    
//    NSArray *array8 = @[@"已诉",@"未诉",@"已判决"];
//    NSArray *array9 = @[@"IT|通信|电子|互联网",@"金融业",@"房地产|建筑业",@"商业服务",@"贸易|批发|零售|租赁",@"文体教育|工艺美术",@"生产|加工|制造",@"交通|运输|物流|仓储",@"服务业",@"文化|传媒|娱乐|体育",@"能源|矿产|环保",@"政府|非盈利机构",@"农|林|牧|渔|其他"];
//    
//    
    [self.AllArray addObject:array1];
    [self.AllArray addObject:array2];
    [self.AllArray addObject:array3];
    [self.AllArray addObject:array4];
    [self.AllArray addObject:array5];
    [self.AllArray addObject:array6];
    [self.AllArray addObject:array7];

      
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
//            [self.mengbanView setHidden:NO];
//            [UIView animateWithDuration:0.5 animations:^{
//                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
//            }];
//            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[1]];
//            [self.pickerView reloadAllComponents];
//            [self.pickerView selectRow:0 inComponent:0 animated:NO];
//            self.selectStr = self.AllArray[1][0];
//            
//            self.row = 1;
            {
                ChooseAreaController *chooseVC = [[ChooseAreaController alloc]init];
                chooseVC.type = @"信息";
                [self.navigationController pushViewController:chooseVC animated:YES];
                
                
            }
        }
            break;
            
        case 2:
        {
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
            
            break;
        case 3:
        {
            
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
            break;
        case 4:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[4]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.row = 4;
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
    NSArray *array = @[self.shenfenView,self.suozaidiView,self.rongzifangshiView,self.danbaofangshiView,self.qiyexianzhuangView,self.suoshuhangyeView,self.zijinyongtuView];
    

    
    switch (self.row) {
        case 0:
            self.shenfenLabel.text = self.selectStr;
            break;
        case 1:
            self.suozaidLabel.text = @"地区选择";
            break;
        case 2:
            self.rongzifangshiLabel.text = self.selectStr;
            if ([self.rongzifangshiLabel.text isEqualToString:@"债权融资"]) {
                [self setZhaiquanView];
            }
            else
            {
                [self setGuquanView];
            }
            break;
        case 3:
            self.danbaofangshiLabel.text = self.selectStr;
            break;
        case 4:
            self.xianzhaungLabel.text = self.selectStr;
            break;
        case 5:
            self.hangyeLabel.text = self.selectStr;
            break;
        case 6:
            self.zijinyongtuLabel.text = self.selectStr;
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
