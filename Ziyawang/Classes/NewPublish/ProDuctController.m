//
//  ProDuctController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ProDuctController.h"

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

@end

@implementation ProDuctController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.AllArray = [NSMutableArray new];
    self.sourceArray = [NSMutableArray new];
    
    [self feiFangchanViews];
    
    [self setPickerView];
    [self addGesturesForViews];
    [self setAllArray];
    
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
