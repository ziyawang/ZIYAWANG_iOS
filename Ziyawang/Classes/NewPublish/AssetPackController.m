//
//  AssetPackController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "AssetPackController.h"

@interface AssetPackController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *shenfenView;
@property (weak, nonatomic) IBOutlet UIView *zichanleixingView;
@property (weak, nonatomic) IBOutlet UIView *laiyuanView;
@property (weak, nonatomic) IBOutlet UIView *diquView;
@property (weak, nonatomic) IBOutlet UIView *baogaoView;
@property (weak, nonatomic) IBOutlet UIView *shijianView;
@property (weak, nonatomic) IBOutlet UIView *diyawuleixingView;

@property (weak, nonatomic) IBOutlet UILabel *shenfenLabel;
@property (weak, nonatomic) IBOutlet UILabel *zichanleixingLabel;
@property (weak, nonatomic) IBOutlet UILabel *laiyuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *diquLabel;
@property (weak, nonatomic) IBOutlet UILabel *baogaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *shijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *diyawuleixingLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *pickerBackView;
@property (nonatomic,strong) UIView *DatepickerBackView;

@property (nonatomic,strong) UIView *mengbanView;
@property (nonatomic,strong) NSString *selectStr;


@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) NSMutableArray *AllArray;

@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) NSMutableArray *viewArray;



@end

@implementation AssetPackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewArray = [NSMutableArray new];
    self.AllArray = [NSMutableArray new];
    self.sourceArray = [NSMutableArray new];
    
    [self setPickerView];
    [self addGesturesForViews];
    [self setAllArray];
}

- (void)setAllArray
{
    NSArray *array1 = @[@"项目持有者",@"FA(中介)"];
    NSArray *array2 = @[@"抵押",@"信用",@"综合",@"其他"];
    NSArray *array3 = @[@"银行",@"非银行机构",@"企业",@"其他"];
    
    NSArray *array4 = @[@"抵押",@"信用",@"综合",@"其他"];
    NSArray *array5 = @[@"有",@"无"];
    
    NSArray *array6 = @[@"抵押",@"信用",@"综合",@"其他"];

    NSArray *array7 = @[@"土地",@"住宅",@"商业",@"厂房",@"设备",@"其他"];

    
    
    [self.AllArray addObject:array1];
    [self.AllArray addObject:array2];
    [self.AllArray addObject:array3];
    [self.AllArray addObject:array4];

    [self.AllArray addObject:array5];

    [self.AllArray addObject:array6];

    [self.AllArray addObject:array7];

    
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
    
    [cancelButton addTarget:self action:@selector(didClickCancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [sureButton addTarget:self action:@selector(didClickSureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    [self.pickerBackView addSubview:self.pickerView];
    [self.pickerBackView addSubview:cancelButton];
    [self.pickerBackView addSubview:sureButton];
    [self.view addSubview:self.pickerBackView];
    
}

- (void)datePickerAction:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:sender.date];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    
    self.shijianLabel.text = [[[[[dateArr[0]stringByAppendingString:@"年"]stringByAppendingString:dateArr[1]]stringByAppendingString:@"月"]stringByAppendingString:dateArr[2]]stringByAppendingString:@"日"];
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
            self.zichanleixingLabel.text = self.selectStr;
            break;
        case 2:
            self.laiyuanLabel.text = self.selectStr;
            break;
        case 3:
            //地区
            break;
        case 4:
            self.baogaoLabel.text = self.selectStr;
            break;
        case 5:
            //时间
            break;
        case 6:
            self.diyawuleixingLabel.text = self.selectStr;
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
    [self.mengbanView setHidden:YES];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.DatepickerBackView.y = [UIScreen mainScreen].bounds.size.height;
    }];
}



/**
 *  添加手势
 */

- (void)addGesturesForViews
{
//    @property (weak, nonatomic) IBOutlet UIView *shenfenView;
//    @property (weak, nonatomic) IBOutlet UIView *zichanleixingView;
//    @property (weak, nonatomic) IBOutlet UIView *laiyuanView;
//    @property (weak, nonatomic) IBOutlet UIView *diquView;
//    @property (weak, nonatomic) IBOutlet UIView *baogaoView;
//    @property (weak, nonatomic) IBOutlet UIView *shijianView;
//    @property (weak, nonatomic) IBOutlet UIView *diyawuleixingView;
    NSArray *viewArray = @[self.shenfenView,self.zichanleixingView,self.laiyuanView,self.diquView,self.baogaoView,self.shijianView,self.diyawuleixingView];
    
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
//            [self.mengbanView setHidden:NO];
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
//            }];
//            
//            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[5]];
//            [self.pickerView reloadAllComponents];
//            [self.pickerView selectRow:0 inComponent:0 animated:NO];
//            self.row = 5;
//            self.selectStr = self.AllArray[5][0];
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.DatepickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];

            
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
                    
        default:
            break;
    }
       //    self.selectStr = @"企业";
    
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
