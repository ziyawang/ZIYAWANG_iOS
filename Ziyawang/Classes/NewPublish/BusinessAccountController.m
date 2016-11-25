//
//  BusinessAccountController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "BusinessAccountController.h"

@interface BusinessAccountController ()<UIPickerViewDelegate,UIPickerViewDataSource>
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



@end

@implementation BusinessAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewArray = [NSMutableArray new];
    self.AllArray = [NSMutableArray new];
    self.sourceArray = [NSMutableArray new];
    
    [self setPickerView];
    
    [self setViews];
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
            [self.mengbanView setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;
            }];
            self.sourceArray = [NSMutableArray arrayWithArray:self.AllArray[4]];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            self.selectStr = self.AllArray[4][0];

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
