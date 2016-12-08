//
//  TestViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/3.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "TestViewController.h"
#import "QuestionsController.h"
#import "ChooseAreaController.h"
@interface TestViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UIView *TypeView;
@property (weak, nonatomic) IBOutlet UIView *personTypeView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;


@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhaiquanTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *PersonTypeLabel;

@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *pickerBackView;

@property (nonatomic,strong) NSString *Type;
@property (nonatomic,strong) NSArray *zhaiquanType;
@property (nonatomic,strong) NSString *selectStr;

@property (nonatomic,strong) NSArray *perSonType;
@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (nonatomic,strong) UIView *mengbanView;


@end

@implementation TestViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.areaLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"债务人所在"];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"债务人所在"] == nil) {
        self.areaLabel.text = @"";
        
    }
    
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"债权风险评估系统";
    [self.startButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    self.zhaiquanType = @[@"企业",@"个人"];
    self.perSonType = @[@"个人债权",@"企业商债"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"债务人所在"];
    UITapGestureRecognizer *getrure1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureForView1:)];
    UITapGestureRecognizer *getrure2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureForView2:)];
    UITapGestureRecognizer *getrure3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureForView3:)];
    
    [self.areaView addGestureRecognizer:getrure1];
    [self.TypeView addGestureRecognizer:getrure3];
    [self.personTypeView addGestureRecognizer:getrure2];
    
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
    
    
    
    self.accountTextField.delegate = self;
    
    
    
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
    
    if ([self.Type isEqualToString:@"0"]) {
        self.PersonTypeLabel.text = @"";
    }
    else
    {
    self.zhaiquanTypeLabel.text = @"";
        
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height;
    }];
    
    
}
- (void)didClickSureButtonAction:(UIButton *)sender
{
    [self.mengbanView setHidden:YES];
    
    if ([self.Type isEqualToString:@"0"]) {
        self.PersonTypeLabel.text = self.selectStr;
    }
    else
    {
        self.zhaiquanTypeLabel.text = self.selectStr;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height;
    }];

    
}


#pragma mark----手势
- (void)gestureForView1:(UITapGestureRecognizer *)gesture
{
    [self.accountTextField resignFirstResponder];
    ChooseAreaController *choosAreaVC =  [[ChooseAreaController alloc]init];
    choosAreaVC.type = @"测试";
    
    [self.navigationController pushViewController:choosAreaVC animated:YES];
    
    
}
- (void)gestureForView2:(UITapGestureRecognizer *)gesture
{
    [self.mengbanView setHidden:NO];
    [self.accountTextField resignFirstResponder];
    
    
[UIView animateWithDuration:0.5 animations:^{
    self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;

}];
    
    self.sourceArray = [NSMutableArray arrayWithArray:self.zhaiquanType];
    self.Type = @"0";
    
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    self.selectStr = @"企业";
    
    
}
- (void)gestureForView3:(UITapGestureRecognizer *)gesture
{    [self.accountTextField resignFirstResponder];

    [self.mengbanView setHidden:NO];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBackView.y = [UIScreen mainScreen].bounds.size.height - 300;

    }];

    
    self.sourceArray = [NSMutableArray arrayWithArray:self.perSonType];
    self.Type = @"1";
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    self.selectStr = @"个人债权";
}
#pragma mark----按钮监听
- (IBAction)startButtonAction:(id)sender {
    [self.accountTextField resignFirstResponder];

    if ([self.accountTextField.text isEqualToString:@""]||[self.areaLabel.text isEqualToString:@""]||[self.zhaiquanTypeLabel.text isEqualToString:@""] ||[self.PersonTypeLabel.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善您的信息后再开始测评" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    else
    {
    QuestionsController *questVC = [[QuestionsController alloc]init];
    questVC.amount = self.accountTextField.text;
    questVC.area = self.areaLabel.text;
    questVC.personType = self.zhaiquanTypeLabel.text;
    questVC.Type = self.PersonTypeLabel.text;
    [self.navigationController pushViewController:questVC animated:YES];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.accountTextField) {
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 7) {
            return NO;
        }
    }
    
    return YES;
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
    NSLog(@"%@",self.selectStr);
    
    
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
