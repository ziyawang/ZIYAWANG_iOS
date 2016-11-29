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
@interface ProDuctController ()<UIPickerViewDelegate,UIPickerViewDataSource>
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

@end

@implementation ProDuctController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"固产转让";
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
    
    [self setWeituoView];

    
    [[RecordManager recordManager] setaudioWithView:self.view recordView:self.recordView];
    //    [[AddImageManager AddManager] setAddimageViewWithView:self.ImageBackView];
    [[AddImageManager AddManager]setAddimageViewWithView:self.ImageBackView target:self];

}
- (void)rightBarButtonItemAction:(UIBarButtonItem *)buttonItem
{
    [self.weituoView setHidden:NO];
    
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
    
    
    
    [self.ContentView addSubview:mengbanView];
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
    
    
    mengbanView.sd_layout.leftSpaceToView(self.ContentView,0)
    .rightSpaceToView(self.ContentView,0)
    .topSpaceToView(self.ContentView,0)
    .bottomSpaceToView(self.ContentView,0);
    
    
    weituoView.sd_layout.centerXEqualToView(mengbanView)
    .centerYEqualToView(self.view)
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
    [self.weituoView setHidden:YES];
    
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
- (IBAction)sendButtonAction:(id)sender {
    
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
    
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.shenfenLabel.text forKey:@"Identity"];
    
    [dic setObject:self.diquLabel.text forKey:@"ProArea"];
    [dic setObject:self.biaodiwuLabel.text forKey:@"AssetType"];
    [dic setObject:self.guihuaLabel.text forKey:@"Usefor"];
    [dic setObject:self.mianjiTextField.text forKey:@"Area"];
    [dic setObject:self.yearTextField.text forKey:@"Year"];
    [dic setObject:self.zhuanrangfangshiLabel.text forKey:@"TransferType"];
    [dic setObject:self.zhuanrangjiageTextField.text forKey:@"TransferMoney"];
    [dic setObject:self.zhengjianLabel.text forKey:@"Credentials"];
    [dic setObject:self.jiufenLabel.text forKey:@"Dispute"];
    [dic setObject:self.fuzhaiLabel.text forKey:@"Debt"];
    [dic setObject:self.danbaoLabel.text forKey:@"Guaranty"];
    [dic setObject:self.caichanLabel.text forKey:@"Property"];
    [dic setObject:self.textView.text forKey:@"WordDes"];


    if ([self.biaodiwuLabel.text isEqualToString:@"土地"])
    {
        [dic setObject:self.shichangjiageTextField.text forKey:@"MarketPrice"];

        [dic setObject:self.caichanLabel.text forKey:@"Property"];
        [dic setObject:@"16" forKey:@"TypeID"];
    }
    else
    {
        [dic setObject:self.leixingLabel.text forKey:@"Type"];

        [dic setObject:@"12" forKey:@"TypeID"];
    }
    
    
    
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



- (void)setAllArray
{
    NSArray *array1 = @[@"项目持有者",@"FA(中介)"];
    NSArray *array2 = @[@"",@""];
    NSArray *array3 = @[@"土地",@"房产"];
    NSArray *array4 = @[@"住宅",@"商业",@"厂房",@"其他"];
    NSArray *array5 = @[@"工业",@"商业",@"住宅",@"其他"];
    NSArray *array6 = @[@"产权转让",@"股权转让"];
    NSArray *array7 = @[@"有",@"无"];
    
    [self.AllArray addObject:array1];
    [self.AllArray addObject:array2];
    [self.AllArray addObject:array3];
    [self.AllArray addObject:array4];
    [self.AllArray addObject:array5];
    [self.AllArray addObject:array6];
    [self.AllArray addObject:array7];
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

    NSArray *viewArray = @[self.shenfengView,self.diquView,self.biaodiwuView,self.leixingView,self.guihuaView,self.zhuanrangfangshiView,self.zhengjianView,self.jiufenView,self.fuzhaiView,self.danbaoView,self.quanbucaichanView];


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
            [self.mengbanView setHidden:NO];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[1]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.row = 1;
            self.selectStr = self.AllArray[1][0];

            
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
            
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[6]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.row = 10;
            self.selectStr = self.AllArray[6][0];

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
    [self.leixingView setHidden:NO];
    self.leixingHeight.constant = 50;
    [self.shichangjiageView setHidden:NO];
    self.shichangjiageHeight.constant = 50;
}

- (void)fangchanViews
{
    [self.leixingView setHidden:YES];
    self.leixingHeight.constant = 0;
    [self.shichangjiageView setHidden:YES];
    self.shichangjiageHeight.constant = 0;

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
