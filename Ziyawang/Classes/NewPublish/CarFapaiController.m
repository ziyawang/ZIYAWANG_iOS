//
//  CarFapaiController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "CarFapaiController.h"
#import "chooseView.h"
@interface CarFapaiController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *zichanView;
@property (weak, nonatomic) IBOutlet UIView *pinpaiView;
@property (weak, nonatomic) IBOutlet UITextField *pinpaiTextField;

@property (weak, nonatomic) IBOutlet UIView *mianjiView;
@property (weak, nonatomic) IBOutlet UIView *xingzhiView;
@property (weak, nonatomic) IBOutlet UIView *qipaijiaView;
@property (weak, nonatomic) IBOutlet UIView *paimaididianView;
@property (weak, nonatomic) IBOutlet UIView *paimaishijianView;
@property (weak, nonatomic) IBOutlet UIView *paimaijieduanView;
@property (weak, nonatomic) IBOutlet UITextField *mianjiTextField;

@property (weak, nonatomic) IBOutlet UITextField *chuzhidanweiTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *VideoButton;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (weak, nonatomic) IBOutlet UILabel *zichanLabel;
@property (weak, nonatomic) IBOutlet UILabel *xingzhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *paimaididianLabel;
@property (weak, nonatomic) IBOutlet UILabel *paimaishijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *paimaijieduanLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;




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


@end

@implementation CarFapaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.AllArray = [NSMutableArray new];
    self.mianjiViewHeight.constant = 0;
    self.xingzhiViewHeight.constant = 0;
    self.pinpaiViewHeight.constant = 50;
    [self.mianjiView setHidden:YES];
    [self.xingzhiView setHidden:YES];
    [self.pinpaiView setHidden:NO];
    
    [self setPickerView];
    [self addGesturesForViews];
    [self setAllArray];
    
    
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
    
    self.paimaishijianLabel.text = [[[[[dateArr[0]stringByAppendingString:@"年"]stringByAppendingString:dateArr[1]]stringByAppendingString:@"月"]stringByAppendingString:dateArr[2]]stringByAppendingString:@"日"];
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
            if (self.selectStr == nil) {
                self.zichanLabel.text = @"土地";
            }
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
            if (self.selectStr == nil) {
                self.xingzhiLabel.text = @"工业";
            }
            
            
            
            break;
        case 2:
            self.paimaijieduanLabel.text = self.selectStr;
            if (self.selectStr == nil) {
                self.paimaijieduanLabel.text = @"一拍";
            }
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
        }
            break;
        case 3:
            
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
