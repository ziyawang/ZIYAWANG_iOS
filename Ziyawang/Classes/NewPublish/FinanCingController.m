//
//  FinanCingController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/21.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FinanCingController.h"

@interface FinanCingController ()<UIPickerViewDataSource,UIPickerViewDelegate>
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

@end

@implementation FinanCingController

- (void)setZhaiquanView
{
    [self.danbaofangshiView setHidden:NO];
    self.danbaoViewHeight.constant = 50;
    
    [self.qixianView setHidden:NO];
    self.qixianViewHeight.constant = 50;
    
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
    
    [self.qiyexianzhuangView setHidden:NO];
    self.qiyexianzhuangHeight.constant = 50;
    [self.suoshuhangyeView setHidden:NO];
    self.suoshuhangyeHeight.constant = 50;
    [self.zijinyongtuView setHidden:NO];
    self.zijinyongtuHeight.constant = 50;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewArray = [NSMutableArray new];
    self.AllArray = [NSMutableArray new];
    self.sourceArray = [NSMutableArray new];
    [self setZhaiquanView];
    [self setPickerView];
    
    [self setViews];
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
