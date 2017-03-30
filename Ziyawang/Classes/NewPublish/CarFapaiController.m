//
//  CarFapaiController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CarFapaiController.h"
#import "chooseView.h"
#import "RecordManager.h"
#import "AddImageManager.h"
#import "HttpManager.h"
#import "ChooseAreaController.h"
#import "SkyerCityPicker.h"

@interface CarFapaiController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *zichanView;
@property (weak, nonatomic) IBOutlet UIView *pinpaiView;

@property (weak, nonatomic) IBOutlet UIView *mianjiView;
@property (weak, nonatomic) IBOutlet UIView *xingzhiView;
@property (weak, nonatomic) IBOutlet UIView *qipaijiaView;
@property (weak, nonatomic) IBOutlet UIView *paimaididianView;
@property (weak, nonatomic) IBOutlet UIView *paimaishijianView;
@property (weak, nonatomic) IBOutlet UIView *paimaijieduanView;

@property (weak, nonatomic) IBOutlet UITextField *pinpaiTextField;

@property (weak, nonatomic) IBOutlet UITextField *mianjiTextField;
@property (weak, nonatomic) IBOutlet UITextField *chuzhidanweiTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *connectPersonTextField;
@property (weak, nonatomic) IBOutlet UITextField *qipaijiaTextField;


@property (weak, nonatomic) IBOutlet UILabel *zichanLabel;
@property (weak, nonatomic) IBOutlet UILabel *xingzhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *paimaididianLabel;
@property (weak, nonatomic) IBOutlet UILabel *paimaishijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *paimaijieduanLabel;



@property (weak, nonatomic) IBOutlet UIButton *VideoButton;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;




@property (weak, nonatomic) IBOutlet UIView *ContentView;





@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) NSMutableArray *array1;
@property (nonatomic,strong) NSMutableArray *array2;
@property (nonatomic,strong) NSMutableArray *array3;

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UILabel *label3;
@property (nonatomic,strong) UILabel *label4;

@property (nonatomic,strong) UITextField *textfield1;
@property (nonatomic,strong) UITextField *textfield2;

@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *pickerBackView;
@property (nonatomic,strong) UIView *DatepickerBackView;

@property (nonatomic,strong) UIView *mengbanView;
@property (nonatomic,strong) NSString *selectStr;


@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) NSMutableArray *AllArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinpaiViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianjiViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xingzhiViewHeight;

@property (nonatomic,strong) NSString *Type;

@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *ImageBackView;


@property (nonatomic,strong) UIView *weituoView;
@property (nonatomic,strong) UITextField *lianxirenTextField;
@property (nonatomic,strong) UITextField *lianxifangshiTextfield;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSMutableArray *SelectedButtonsArray;

@property (nonatomic,strong) UIView *PromiseView;
@property (nonatomic,assign) CGFloat scrollY;

@property (nonatomic,assign)   BOOL isHaveDian;
@property (nonatomic,strong) SkyerCityPicker *cityPicker;
@property (weak, nonatomic) IBOutlet UIView *miaoshuView;

@end

@implementation CarFapaiController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    NSString *suozai = [[NSUserDefaults standardUserDefaults]objectForKey:@"企业所在"];
    if (suozai == nil) {
        
    }
    else
    {
     self.paimaididianLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"企业所在"];
    }
    
    
}
- (void)viewGestureAction:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = 25;
    UITapGestureRecognizer *viewGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewGestureAction:)];
    UITapGestureRecognizer *viewGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewGestureAction:)];
    UITapGestureRecognizer *viewGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewGestureAction:)];
    
    [self.recordView addGestureRecognizer:viewGesture1];
    [self.ImageBackView addGestureRecognizer:viewGesture2];
    [self.miaoshuView addGestureRecognizer:viewGesture3];

    self.isHaveDian = NO;
    
    self.scrollView.delegate = self;

    self.sendButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"企业所在"];
    
    self.navigationItem.title = @"法拍资产";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"委托发布" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
    
    self.SelectedButtonsArray = [NSMutableArray new];
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    self.textView.text = @"请输入文字描述";
    self.textView.textColor = [UIColor grayColor];
    self.textView.delegate = self;

    self.AllArray = [NSMutableArray new];
    self.mianjiViewHeight.constant = 0;
    self.xingzhiViewHeight.constant = 0;
    self.pinpaiViewHeight.constant = 50;
    [self.mianjiView setHidden:YES];
    [self.xingzhiView setHidden:YES];
    [self.pinpaiView setHidden:NO];
    
    self.qipaijiaTextField.delegate = self;
    
    
    [self setPickerView];
    [self addGesturesForViews];
    [self setAllArray];
//    [self setWeituoView];
    
//    [self setPromiseView];
    
    
    
    [[RecordManager recordManager] setaudioWithView:self.view recordView:self.recordView];
//    [[AddImageManager AddManager] setAddimageViewWithView:self.ImageBackView];
    [[AddImageManager AddManager]setAddimageViewWithView:self.ImageBackView target:self];
    self.cityPicker = [[SkyerCityPicker alloc]init];

    [self.cityPicker cityPikerGetSelectCity:^(NSMutableDictionary *dicSelectCity)
     {
        [self.mengbanView setHidden:YES];
         NSLog(@"%@",dicSelectCity);
        self.paimaididianLabel.text = [[dicSelectCity[@"Province"] stringByAppendingString:@"-"]stringByAppendingString:dicSelectCity[@"City"]];
     }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollY = scrollView.contentOffset.y;
    [self.view endEditing:YES];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入文字描述"]) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
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
    
    
//    [weituoView setupAutoHeightWithBottomView:bottomView bottomMargin:20];
    
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
//    [self.view endEditing:YES];
    [_lianxirenTextField resignFirstResponder];
    [_lianxifangshiTextfield resignFirstResponder];
    
    [self.weituoView removeFromSuperview];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)buttonItem
{
    //    [self.weituoView setHidden:NO];
    [self setWeituoView];
    
}







- (void)setAllArray
{
    NSArray *array1 = @[@"土地",@"房产",@"汽车"];
    NSArray *array2 = @[@"工业",@"商业",@"住宅",@"其他"];

    NSArray *array3 = @[@"一拍",@"二拍",@"三拍"];
    
    [self.AllArray addObject:array1];
    [self.AllArray addObject:array2];
    [self.AllArray addObject:array3];

    self.DatepickerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 300)];
    self.DatepickerBackView.backgroundColor = [UIColor whiteColor];
    
  self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50,self.DatepickerBackView.bounds.size.width,150)];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *minDate = [[NSDate alloc]initWithTimeIntervalSinceNow:(NSTimeIntervalSince1970)];
    NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:(978307200.0 * 10)];
    
    
//    NSDate* minDate = [[NSDate alloc]initWithString:@"1900-01-01 00:00:00 -0500"];
//    NSDate* maxDate = [[NSDate alloc]initWithString:@"2099-01-01 00:00:00 -0500"];
    
//    datePicker.minimumDate = minDate;
//    datePicker.maximumDate = maxDate;
    [self.datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:(UIControlEventValueChanged)];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setFrame:CGRectMake(0, 0, 40, 30)];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [sureButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 0, 40, 30)];
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [cancelButton addTarget:self action:@selector(didClickCancelDateButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [sureButton addTarget:self action:@selector(didClickSureDateButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.DatepickerBackView addSubview:self.datePicker];
    [self.DatepickerBackView addSubview:cancelButton];
    [self.DatepickerBackView addSubview:sureButton];
    [self.view addSubview:self.DatepickerBackView];
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

- (void)weituoFabu
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[WeituoFabuURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"token" forKey:@"access_token"];
    
    
    [param setObject:@"20" forKey:@"TypeID"];
    
    [param setObject:self.lianxirenTextField.text forKey:@"ConnectPerson"];
    [param setObject:self.lianxifangshiTextfield.text forKey:@"ConnectPhone"];
    [param setObject:@"IOS" forKey:@"Channel"];
    
    
    
[self.manager POST:URL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSLog(@"发布成功");
    
    [self.weituoView removeFromSuperview];
    [self MBProgressWithString:@"发布成功，请耐心等待客服人员与您联系" timer:2 mode:MBProgressHUDModeText];

    [self.navigationController popViewControllerAnimated:YES];
    
    
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"发布失败%@",error);
    [self.weituoView removeFromSuperview];
    [self MBProgressWithString:@"发布失败，请稍后重试" timer:2 mode:MBProgressHUDModeText];

    
}];
    
}
//显示菊花
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication]keyWindow] animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
}


- (void)setWeituoSuccessView
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
    label1.text = @"信息已提交";
    
    label2.sd_layout.leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15)
    .topSpaceToView(label1,15)
    .autoHeightRatio(0);
    
    label2.text = @"请耐心等待资芽网客服人员进行确认";
    
    
    
    
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






- (void)datePickerAction:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:sender.date];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    
    self.paimaishijianLabel.text = [[[[[dateArr[0]stringByAppendingString:@"年"]stringByAppendingString:dateArr[1]]stringByAppendingString:@"月"]stringByAppendingString:dateArr[2]]stringByAppendingString:@"日"];
}
- (NSString *)getFormatDateWithDatePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:self.datePicker.date];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    NSString *time = [[[[[dateArr[0]stringByAppendingString:@"年"]stringByAppendingString:dateArr[1]]stringByAppendingString:@"月"]stringByAppendingString:dateArr[2]]stringByAppendingString:@"日"];
    return time;
    
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
           
            self.zichanLabel.text = self.selectStr;

            if ([self.zichanLabel.text isEqualToString:@"土地"]) {
                self.Type = @"土地";
                self.mianjiViewHeight.constant = 50;
                self.xingzhiViewHeight.constant = 50;
                self.pinpaiViewHeight.constant = 0;
                [self.mianjiView setHidden:NO];
                [self.xingzhiView setHidden:NO];
                [self.pinpaiView setHidden:YES];
            }
            else if([self.zichanLabel.text isEqualToString:@"房产"])
            {
                self.mianjiViewHeight.constant = 50;
                self.xingzhiViewHeight.constant = 50;
                self.pinpaiViewHeight.constant = 0;
                [self.mianjiView setHidden:NO];
                [self.xingzhiView setHidden:NO];
                [self.pinpaiView setHidden:YES];
            }
            else
            {
                self.mianjiViewHeight.constant = 0;
                self.xingzhiViewHeight.constant = 0;
                self.pinpaiViewHeight.constant = 50;
                [self.mianjiView setHidden:YES];
                [self.xingzhiView setHidden:YES];
                [self.pinpaiView setHidden:NO];
            
            }
              break;
        case 1:
            self.xingzhiLabel.text = self.selectStr;
                 break;
        case 2:
            self.paimaijieduanLabel.text = self.selectStr;

            break;
            
        default:
            break;
    }
    
    
}

#pragma mark----时间确定和取消按钮
- (void)didClickCancelDateButtonAction:(UIButton*)sender
{
    [self.mengbanView setHidden:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.DatepickerBackView.y = [UIScreen mainScreen].bounds.size.height;
    }];
    
}
- (void)didClickSureDateButtonAction:(UIButton *)sender
{
    self.paimaishijianLabel.text = [self getFormatDateWithDatePicker];

    [self.mengbanView setHidden:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.DatepickerBackView.y = [UIScreen mainScreen].bounds.size.height;
    }];    
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
    
    self.Type = @"汽车";
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:promise forKey:@"Promise"];
    [dic setObject:@"token" forKey:@"access_token"];
    
    if ([self.zichanLabel.text isEqualToString:@"汽车"]) {
        [dic setObject:@"22" forKey:@"TypeID"];

    }
    else if ([self.zichanLabel.text isEqualToString:@"土地"])
    {
        [dic setObject:@"21" forKey:@"TypeID"];
    }
    else
    {
        [dic setObject:@"20" forKey:@"TypeID"];
    }
    [dic setObject:self.zichanLabel.text forKey:@"AssetType"];
    [dic setObject:self.qipaijiaTextField.text forKey:@"Money"];
    [dic setObject:self.paimaididianLabel.text forKey:@"ProArea"];
    [dic setObject:self.paimaishijianLabel.text forKey:@"Year"];
    [dic setObject:self.paimaijieduanLabel.text forKey:@"State"];
    [dic setObject:self.chuzhidanweiTextField.text forKey:@"Court"];
    [dic setObject:self.connectPersonTextField.text forKey:@"ConnectPerson"];
    [dic setObject:self.phoneTextField.text forKey:@"ConnectPhone"];
    [dic setObject:self.textView.text forKey:@"WordDes"];
    [dic setObject:@"IOS" forKey:@"Channel"];
    
    if ([self.zichanLabel.text isEqualToString:@"汽车"])
    {
        [dic setObject:self.pinpaiTextField.text forKey:@"Brand"];
    }
    else
    {
        [dic setObject:self.mianjiTextField.text forKey:@"Area"];
        [dic setObject:self.xingzhiLabel.text forKey:@"Nature"];
    }
    NSLog(@"%@",dic);
    NSMutableArray *imageArray = [[AddImageManager AddManager]getImageArray];
    [[HttpManager httpManager]postDataWithURL:URL ImageArray:imageArray audioURL:audiourl param:dic];
    
     [HttpManager httpManager].ifpop = ^(NSString *statu)
    {
        [self.navigationController popViewControllerAnimated:YES];
    };
}
- (IBAction)sendButtonAction:(id)sender
{
    [self.view endEditing:YES];
    if ([self.zichanLabel.text isEqualToString:@"请选择"]) {
        [MyMBHud MBProgressWithString:@"请选择资产类型" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    else if([self.zichanLabel.text isEqualToString:@"汽车"])
    {
    if([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.pinpaiTextField] == NO)
    {
        [MyMBHud MBProgressWithString:@"请输入品牌型号" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    }
    else
    {
        if([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.mianjiTextField] == NO)
        {
            [MyMBHud MBProgressWithString:@"请输入面积" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
        if([self.xingzhiLabel.text isEqualToString:@"请选择"])
        {
            [MyMBHud MBProgressWithString:@"请选择性质" timer:1 mode:(MBProgressHUDModeText) target:self];
            return;
        }
    }
    
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.qipaijiaTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入起拍价" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if([self.paimaididianLabel.text isEqualToString:@"请选择"])
    {
        [MyMBHud MBProgressWithString:@"请选择拍卖地点" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if([self.paimaishijianLabel.text isEqualToString:@"请选择"])
    {
        [MyMBHud MBProgressWithString:@"请选择拍卖时间" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if([self.paimaijieduanLabel.text isEqualToString:@"请选择"])
    {
        [MyMBHud MBProgressWithString:@"请选择拍卖阶段" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:_chuzhidanweiTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入处置单位" timer:1 mode:(MBProgressHUDModeText) target:self];
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
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.connectPersonTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入联系人姓名" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    if ([CheckTextFieldAndLabelText checkTextFieldTextWithTextField:self.phoneTextField] == NO) {
        [MyMBHud MBProgressWithString:@"请输入联系方式" timer:1 mode:(MBProgressHUDModeText) target:self];
        return;
    }
    
    [self setPromiseView];
}


/**
 *  添加手势
 */

- (void)addGesturesForViews
{
    NSArray *viewArray = @[self.zichanView,self.xingzhiView,self.paimaijieduanView,self.paimaididianView,self.paimaishijianView];
    
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
//            ChooseAreaController *chooseVC = [[ChooseAreaController alloc]init];
//            chooseVC.type = @"信息";
//            [self.navigationController pushViewController:chooseVC animated:YES];
            [self.view addSubview:self.cityPicker];
  
        
        }
            break;
        case 4:
           
            //时间
        {
            [self.mengbanView setHidden:NO];

            [UIView animateWithDuration:0.5 animations:^{
                self.DatepickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            
        }

            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
            
        default:
            break;
    }
    
    
    

//    self.selectStr = @"企业";

}
- (void)setHouseView
{
//    chooseView *view1 = [[chooseView alloc]init];
//    chooseView *view2 = [[chooseView alloc]init];
//    chooseView *view3 = [[chooseView alloc]init];
//    chooseView *view4 = [[chooseView alloc]init];
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    

   chooseView *view1 = [chooseView initViewWithStringOne:@"资产类型---" Label:self.label1];
    [backView addSubview:view1];
    view1.backgroundColor = [UIColor whiteColor];
    
    backView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    
    
    view1.sd_layout.topSpaceToView(backView,0)
    .leftSpaceToView(backView,0)
    .rightSpaceToView(backView,0)
    .heightIs(50);
 
}

#pragma mark - UITextField delegate


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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
