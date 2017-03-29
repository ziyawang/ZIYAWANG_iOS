//
//  ProDuctController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ProDuctController.h"
#import "RecordManager.h"
#import "AddImageManager.h"
#import "HttpManager.h"
#import "ChooseAreaController.h"
#import "SkyerCityPicker.h"

@interface ProDuctController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *shenfengView;
@property (weak, nonatomic) IBOutlet UIView *diquView;
@property (weak, nonatomic) IBOutlet UIView *biaodiwuView;
@property (weak, nonatomic) IBOutlet UIView *leixingView;
@property (weak, nonatomic) IBOutlet UIView *guihuaView;
@property (weak, nonatomic) IBOutlet UIView *zhuanrangfangshiView;
@property (weak, nonatomic) IBOutlet UIView *zhengjianView;
@property (weak, nonatomic) IBOutlet UIView *jiufenView;
@property (weak, nonatomic) IBOutlet UIView *fuzhaiView;
@property (weak, nonatomic) IBOutlet UIView *danbaoView;
@property (weak, nonatomic) IBOutlet UIView *quanbucaichanView;




@property (weak, nonatomic) IBOutlet UILabel *shenfenLabel;
@property (weak, nonatomic) IBOutlet UILabel *diquLabel;
@property (weak, nonatomic) IBOutlet UILabel *biaodiwuLabel;
@property (weak, nonatomic) IBOutlet UILabel *leixingLabel;
@property (weak, nonatomic) IBOutlet UILabel *guihuaLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuanrangfangshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhengjianLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiufenLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuzhaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *danbaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *caichanLabel;

@property (weak, nonatomic) IBOutlet UITextField *mianjiTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *shichangjiageTextField;
@property (weak, nonatomic) IBOutlet UITextField *zhuanrangjiageTextField;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


@property (weak, nonatomic) IBOutlet UIView *danjiaView1;
@property (weak, nonatomic) IBOutlet UILabel *danjiaLabel1;
@property (weak, nonatomic) IBOutlet UILabel *danjiaLabel2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *danjiaHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *danjiaHeight2;



@property (weak, nonatomic) IBOutlet UIView *mianjiView;
@property (weak, nonatomic) IBOutlet UIView *tudimianjiView;
@property (weak, nonatomic) IBOutlet UIView *jianzhumianjiView;
@property (weak, nonatomic) IBOutlet UIView *rongjiView;
@property (weak, nonatomic) IBOutlet UIView *zhuanrangjiaView;
@property (weak, nonatomic) IBOutlet UIView *zhuanrangdanjiaView;



@property (weak, nonatomic) IBOutlet UITextField *tudimianjiTextField;
@property (weak, nonatomic) IBOutlet UITextField *jianzhumianjiTextField;
@property (weak, nonatomic) IBOutlet UITextField *rongjiTextField;
@property (weak, nonatomic) IBOutlet UITextField *cankaoshijiaTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guihuaHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianjiHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tudimianjiHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jianzhumianjiHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rongjiHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shichangdanjiaHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yixiangzhuanrangjiaHeight;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leixingHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shichangjiageHeight;
@property (weak, nonatomic) IBOutlet UIView *shichangjiageView;


@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *pickerBackView;
@property (nonatomic,strong) UIView *DatepickerBackView;

@property (nonatomic,strong) UIView *mengbanView;
@property (nonatomic,strong) NSString *selectStr;

@property (nonatomic,strong) NSMutableArray *AllArray;
@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (nonatomic,assign) NSInteger row;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *ImageBackView;
@property (weak, nonatomic) IBOutlet UIView *ContentView;


@property (nonatomic,strong) NSMutableArray *SelectedButtonsArray;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) UIView *weituoView;

@property (nonatomic,strong) UITextField *lianxirenTextField;
@property (nonatomic,strong) UITextField *lianxifangshiTextfield;

@property (nonatomic,strong) NSMutableArray *liangdianArray;
@property (nonatomic,strong) NSString *liangdianStr;
@property (nonatomic,assign) BOOL isHave;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic,strong) UIView *PromiseView;
@property (nonatomic,assign)   BOOL isHaveDian;

@property (nonatomic,strong) SkyerCityPicker *cityPicker;
@property (weak, nonatomic) IBOutlet UIView *miaoshuView;

@end

@implementation ProDuctController
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
- (void)viewGestureAction:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *viewGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewGestureAction:)];
    UITapGestureRecognizer *viewGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewGestureAction:)];
    UITapGestureRecognizer *viewGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewGestureAction:)];
    
    [self.recordView addGestureRecognizer:viewGesture1];
    [self.ImageBackView addGestureRecognizer:viewGesture2];
    [self.miaoshuView addGestureRecognizer:viewGesture3];

    self.shichangjiageTextField.delegate = self;
    self.zhuanrangjiageTextField.delegate = self;
    
    self.mianjiTextField.delegate = self;
    self.cankaoshijiaTextField.delegate = self;
    
    self.scrollView.delegate = self;
    self.sendButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];

    self.navigationItem.title = @"固定资产";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"委托发布" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
    self.SelectedButtonsArray = [NSMutableArray new];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    self.AllArray = [NSMutableArray new];
    self.sourceArray = [NSMutableArray new];
    
    [self feiFangchanViews];
    
    [self setPickerView];
    [self addGesturesForViews];
    [self setAllArray];
    

    
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
    [self.button1 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button2 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button3 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button4 addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];

    self.textView.text = @"请输入文字描述";
    self.textView.textColor = [UIColor grayColor];
    self.textView.delegate = self;
    self.cityPicker = [[SkyerCityPicker alloc]init];

    [self.cityPicker cityPikerGetSelectCity:^(NSMutableDictionary *dicSelectCity)
     {
         [self.mengbanView setHidden:YES];
         NSLog(@"%@",dicSelectCity);
         self.diquLabel.text = [[dicSelectCity[@"Province"] stringByAppendingString:@"-"]stringByAppendingString:dicSelectCity[@"City"]];
         
     }];
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
    .heightIs(500 * kHeightScale);
    
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
    if ([self.lianxirenTextField.text isEqualToString:@""]||self.lianxifangshiTextfield.text == nil || [self.lianxifangshiTextfield.text isEqualToString:@""]||self.lianxifangshiTextfield.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您填写的信息不完整，请重新填写" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    else
    {
        [self weituoFabu];
        
    }
    
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
- (void)postDataToDomainWithPromise:(NSString *)promise
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    //    http://apitest.ziyawang.com/v1/test/project/create
    //    http://apitest.ziyawang.com/v1/uploadfile
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

//    [dic setObject:self.liangdianStr forKey:@"ProLabel"];
  
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.shenfenLabel.text forKey:@"Identity"];
    
    [dic setObject:self.diquLabel.text forKey:@"ProArea"];
    [dic setObject:self.biaodiwuLabel.text forKey:@"AssetType"];
    [dic setObject:self.zhuanrangjiageTextField.text forKey:@"TransferMoney"];
    [dic setObject:@"IOS" forKey:@"Channel"];
    [dic setObject:self.textView.text forKey:@"WordDes"];
    [dic setObject:self.nameTextField.text forKey:@"ConnectPerson"];
    [dic setObject:self.phoneTextField.text forKey:@"ConnectPhone"];
 
    if ([self.biaodiwuLabel.text isEqualToString:@"房产"])
    {
        [dic setObject:self.cankaoshijiaTextField.text forKey:@"MarketPrice"];
        [dic setObject:self.mianjiTextField.text forKey:@"Area"];
        [dic setObject:self.leixingLabel.text forKey:@"Type"];
        [dic setObject:@"12" forKey:@"TypeID"];
    }
    else
    {
        [dic setObject:self.guihuaLabel.text forKey:@"Usefor"];
        [dic setObject:self.tudimianjiTextField.text forKey:@"Area"];
        [dic setObject:self.jianzhumianjiTextField.text forKey:@"BuildArea"];
        [dic setObject:self.rongjiTextField.text forKey:@"FloorRatio"];
        [dic setObject:@"16" forKey:@"TypeID"];
    }

//    if ([self.zhengjianLabel.text isEqualToString:@"请选择"] == NO) {
//        [dic setObject:self.zhengjianLabel.text forKey:@"Credentials"];
//
//    }
//    if ([self.jiufenLabel.text isEqualToString:@"请选择"] == NO) {
//        [dic setObject:self.jiufenLabel.text forKey:@"Dispute"];
//
//    }
//    if ([self.fuzhaiLabel.text isEqualToString:@"请选择"] == NO) {
//        [dic setObject:self.fuzhaiLabel.text forKey:@"Debt"];
//
//    }
//    if ([self.danbaoLabel.text isEqualToString:@"请选择"] == NO) {
//        [dic setObject:self.danbaoLabel.text forKey:@"Guaranty"];
//
//    }
//    if ([self.caichanLabel.text isEqualToString:@"请选择"] == NO) {
//        [dic setObject:self.caichanLabel.text forKey:@"Property"];
//
//    }
//    
    
    
    

    
    
    
    
    //    [dic setObject:self.zichanLabel.text forKey:@"AssetType"];
    //    [dic setObject:self.qipaijiaTextField.text forKey:@"Money"];
    //    [dic setObject:self.paimaididianLabel.text forKey:@"ProArea"];
    //    [dic setObject:self.paimaishijianLabel.text forKey:@"Year"];
    //    [dic setObject:self.paimaijieduanLabel.text forKey:@"State"];
    //    [dic setObject:self.chuzhidanweiTextField.text forKey:@"Court"];
    //    [dic setObject:self.connectPersonTextField.text forKey:@"ConnectPerson"];
    //    [dic setObject:self.phoneTextField.text forKey:@"ConnectPhone"];
    //    [dic setObject:self.textView.text forKey:@"WordDes"];
    
    
    
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
    
    if ([self.shenfenLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择您的身份" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([self.biaodiwuLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择标的物类型" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([self.diquLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择地区" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
  
    
    if ([self.biaodiwuLabel.text isEqualToString:@"房产"]) {
        if ([self.leixingLabel.text isEqualToString:@"请选择"]) {
            [MyMBHud MBProgressWithString:@"请选择房产类型" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
    }
    if ([self.biaodiwuLabel.text isEqualToString:@"土地"]) {
        if ([self.guihuaLabel.text isEqualToString:@"请选择"]) {
            [MyMBHud MBProgressWithString:@"请选择规划用途" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
    }
    if ([self.biaodiwuLabel.text isEqualToString:@"房产"]) {

    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.mianjiTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入面积" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    }
//    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.yearTextField] == NO) {
//        [MyMBHud MBProgressWithString:@"请输入剩余使用年限" timer:1 mode:(MBProgressHUDModeText) target:self];
//        return;
//    }
    
//    if ([self.zhuanrangfangshiLabel.text isEqualToString:@"请选择"]) {
//        [MyMBHud MBProgressWithString:@"请选择转让方式" timer:1 mode:(MBProgressHUDModeText) target:self];
//        return;
//    }
    if ([self.biaodiwuLabel.text isEqualToString:@"房产"]) {
        if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.cankaoshijiaTextField] == NO) {
            [MyMBHud MBProgressWithString:@"请输入参考市价" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
    }
    if ([self.biaodiwuLabel.text isEqualToString:@"土地"]) {
        if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.tudimianjiTextField] == NO) {
            [MyMBHud MBProgressWithString:@"请输入土地面积" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
        if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.jianzhumianjiTextField] == NO) {
            [MyMBHud MBProgressWithString:@"请输入建筑面积" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
        if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.rongjiTextField] == NO) {
            [MyMBHud MBProgressWithString:@"请输入容积率" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }

    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.zhuanrangjiageTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入意向转让价" timer:1 mode:(MBProgressHUDModeText) target:self];
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
- (void)weituoFabu
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[WeituoFabuURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"token" forKey:@"access_token"];
    [param setObject:@"16" forKey:@"TypeID"];
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



- (void)setAllArray
{
    NSArray *array1 = @[@"项目持有者",@"FA(中介)"];
    NSArray *array2 = @[@"",@""];
    NSArray *array3 = @[@"土地",@"房产"];
    NSArray *array4 = @[@"住宅",@"商业",@"厂房",@"其他"];
    NSArray *array5 = @[@"工业",@"商业",@"住宅",@"其他"];
    NSArray *array6 = @[@"产权转让",@"股权转让"];
    NSArray *array7 = @[@"有",@"无"];
    NSArray *array8 = @[@"是",@"否"];

    
    [self.AllArray addObject:array1];
    [self.AllArray addObject:array2];
    [self.AllArray addObject:array3];
    [self.AllArray addObject:array4];
    [self.AllArray addObject:array5];
    [self.AllArray addObject:array6];
    [self.AllArray addObject:array7];
    [self.AllArray addObject:array8];
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
    
    
    
    [self.pickerBackView addSubview:self.pickerView];
    [self.pickerBackView addSubview:cancelButton];
    [self.pickerBackView addSubview:sureButton];
    [self.view addSubview:self.pickerBackView];
    
    
    
}
/**
 *  添加手势
 */

- (void)addGesturesForViews
{
    
//    @property (weak, nonatomic) IBOutlet UIView *shenfengView;
//    @property (weak, nonatomic) IBOutlet UIView *diquView;
//    @property (weak, nonatomic) IBOutlet UIView *biaodiwuView;
//    @property (weak, nonatomic) IBOutlet UIView *leixingView;
//    @property (weak, nonatomic) IBOutlet UIView *guihuaView;
//    @property (weak, nonatomic) IBOutlet UIView *zhuanrangfangshiView;
//    @property (weak, nonatomic) IBOutlet UIView *zhengjianView;
//    @property (weak, nonatomic) IBOutlet UIView *jiufenView;
//    @property (weak, nonatomic) IBOutlet UIView *fuzhaiView;
//    @property (weak, nonatomic) IBOutlet UIView *danbaoView;
//    @property (weak, nonatomic) IBOutlet UIView *quanbucaichanView;

    NSArray *viewArray = @[self.shenfengView,self.diquView,self.biaodiwuView,self.leixingView,self.guihuaView];


    //    for (int i = 0; i < viewArray.count; i++) {
    //        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    //        viewArray
    //    }
    int i = 0;
    for (UIView *view in viewArray) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
        [view addGestureRecognizer:gesture];
        view.tag = i;
        i++;
    }
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
            self.row = 0;
            self.selectStr = self.AllArray[0][0];

            
        }
            break;
        case 1:
        {
            //地区选择
//            [self.mengbanView setHidden:NO];
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
//            }];
//            
//            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[1]];
//            [self.pickerView reloadAllComponents];
//            [self.pickerView selectRow:0 inComponent:0 animated:NO];
//            self.row = 1;
//            self.selectStr = self.AllArray[1][0];
            {
//                ChooseAreaController *chooseVC = [[ChooseAreaController alloc]init];
//                chooseVC.type = @"信息";
//                [self.navigationController pushViewController:chooseVC animated:YES];
                [self.view addSubview:self.cityPicker];

                
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
            self.row = 2;
            self.selectStr = self.AllArray[2][0];

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
            self.row = 3;
            self.selectStr = self.AllArray[3][0];

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
            self.selectStr = self.AllArray[4][0];

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
            self.selectStr = self.AllArray[5][0];

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
            self.row = 6;
            self.selectStr = self.AllArray[6][0];

        }
            break;
        case 7:
        {
            [self.mengbanView setHidden:NO];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[6]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.row = 7;
            self.selectStr = self.AllArray[6][0];

            
        }
            break;
        case 8:
        {
            [self.mengbanView setHidden:NO];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[6]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.row = 8;
            self.selectStr = self.AllArray[6][0];

        }
            break;
        case 9:
        {
            [self.mengbanView setHidden:NO];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[6]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.row = 9;
            self.selectStr = self.AllArray[6][0];

        }
            break;
        case 10:
        {
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[7]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.row = 10;
            self.selectStr = self.AllArray[7][0];
        }
            break;
            
        default:
            break;
    }
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
    switch (self.row) {
        case 0:
            self.shenfenLabel.text = self.selectStr;
            break;
        case 1:
            //地区
            break;
        case 2:
            self.biaodiwuLabel.text = self.selectStr;
            if ([self.biaodiwuLabel.text isEqualToString:@"房产"]) {
                [self fangchanViews];
            }
            else
            {
                [self feiFangchanViews];
            }
            break;
        case 3:
            self.leixingLabel.text = self.selectStr;
            break;
        case 4:
            self.guihuaLabel.text = self.selectStr;
            break;
        case 5:
            self.zhuanrangfangshiLabel.text = self.selectStr;
            break;
        case 6:
            self.zhengjianLabel.text = self.selectStr;
            
            break;
        case 7:
            self.jiufenLabel.text = self.selectStr;
            break;
        case 8:
            self.fuzhaiLabel.text = self.selectStr;
            break;
        case 9:
            self.danbaoLabel.text = self.selectStr;
            break;
        case 10:
            self.caichanLabel.text = self.selectStr;
            break;
            
            
        default:
            break;
    }
    
    
    
}


- (void)feiFangchanViews
{
    
    [self.leixingView setHidden:YES];
    self.leixingHeight.constant = 0;
    [self.mianjiView setHidden:YES];
    self.mianjiHeight.constant = 0;
    [self.shichangjiageView setHidden:YES];
    self.shichangjiageHeight.constant = 0;
    [self.danjiaView1 setHidden:YES];
    self.shichangdanjiaHeight.constant = 0;
    [self.zhuanrangdanjiaView setHidden:YES];
    self.yixiangzhuanrangjiaHeight.constant = 0;
    
    [self.guihuaView setHidden:NO];
    [self.tudimianjiView setHidden:NO];
    [self.jianzhumianjiView setHidden:NO];
    [self.rongjiView setHidden:NO];
    self.guihuaHeight.constant = 50;
    self.tudimianjiHeight.constant = 50;
    self.jianzhumianjiHeight.constant = 50;
    self.rongjiHeight.constant = 50;
    
    
   
    
}

- (void)fangchanViews
{
    [self.leixingView setHidden:NO];
    self.leixingHeight.constant = 50;
    [self.mianjiView setHidden:NO];
    self.mianjiHeight.constant = 50;
    [self.shichangjiageView setHidden:NO];
    self.shichangjiageHeight.constant = 50;
    [self.danjiaView1 setHidden:NO];
    self.shichangdanjiaHeight.constant = 50;
    [self.zhuanrangdanjiaView setHidden:NO];
    self.yixiangzhuanrangjiaHeight.constant = 50;
    
    [self.guihuaView setHidden:YES];
    [self.tudimianjiView setHidden:YES];
    [self.jianzhumianjiView setHidden:YES];
    [self.rongjiView setHidden:YES];
    self.guihuaHeight.constant = 0;
    self.tudimianjiHeight.constant = 0;
    self.jianzhumianjiHeight.constant = 0;
    self.rongjiHeight.constant = 0;
}

#pragma mark - UITextField delegate
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
    if (textField == self.cankaoshijiaTextField || textField == self.mianjiTextField) {
        if (self.mianjiTextField.text.integerValue == 0||[self.mianjiTextField.text isEqualToString:@""]) {
            
        }
        else
        {
            NSLog(@"%@",_cankaoshijiaTextField.text);
            self.danjiaLabel1.text = [[NSString stringWithFormat:@"%.2f",self.cankaoshijiaTextField.text.floatValue/self.mianjiTextField.text.floatValue] stringByAppendingString:@"万元/平米"];
        }
    }
    if (textField == self.zhuanrangjiageTextField || textField == self.mianjiTextField) {
        if (self.mianjiTextField.text.integerValue == 0) {
            
        }
        else
        {
            self.danjiaLabel2.text = [[NSString stringWithFormat:@"%.2f",self.zhuanrangjiageTextField.text.floatValue/self.mianjiTextField.text.floatValue]stringByAppendingString:@"万元/平米"];
        }
    }

    if (textField.tag == 11 || textField.tag == 12) {
        [TextFieldViewAnimate textFieldAnimateWithView:[[textField superview] superview] up:NO];
    }
}
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",string);
    
   
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
