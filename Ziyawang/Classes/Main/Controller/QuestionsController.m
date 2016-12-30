//
//  QuestionsController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/3.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "QuestionsController.h"
#import "QuestionModel.h"
#import "PushViewController.h"
#import "PersonalDebtsController.h"

@interface QuestionsController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *quesTitle;
@property (weak, nonatomic) IBOutlet UILabel *quesDes;
@property (weak, nonatomic) IBOutlet UILabel *quesDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopTo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttonBackView;

@property (nonatomic,strong) NSMutableArray *allQuestionArray;
@property (nonatomic,strong) NSMutableArray *firstQuestionArray;
@property (nonatomic,strong) NSMutableArray *firstQuestionArray2;

@property (nonatomic,strong) NSMutableArray *lastQuestionArray;
@property (nonatomic,assign) NSInteger firstindex;
@property (nonatomic,strong) QuestionModel *model;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSIndexPath *selectIndex;
@property (nonatomic,strong) NSMutableDictionary *selectedDic;
@property (nonatomic,strong) NSString *selectStatu;

@property (nonatomic,strong) NSMutableDictionary *AllSelectedDic;
@property (nonatomic,strong) NSString *allSelected;

@property (nonatomic,strong) UIView *resultView;
@property (nonatomic,strong) UILabel *resultDes;
@property (nonatomic,strong) UITextField *phoneNumber;

@property (nonatomic,assign) BOOL isPhoneNumber;

@property (nonatomic,strong) NSString *secondType;
@property (nonatomic,strong) NSString *thirdType;


@property (nonatomic,strong) NSString *questionType;

@property (nonatomic,strong) NSMutableArray *manyChooseArray;

@property (nonatomic,strong) NSMutableDictionary *indexPathDic;

@property (nonatomic,strong) NSMutableArray *selectArray;

@property (nonatomic,strong) UILabel *testResult;

@property (nonatomic,assign) BOOL ifFinishAnswer;


//@property (nonatomic,strong) 

@end

@implementation QuestionsController

- (void)popAction:(UIButton *)button
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的测评还未完成，确定要退出吗?" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self postAnswers2];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    if (_ifFinishAnswer == YES)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
    [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"债权风险评估系统";

    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton addTarget:self action:@selector(popAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *buttonimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6, 10, 18)];
    buttonimage.image = [UIImage imageNamed:@"back3"];
    UILabel *buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 45, 20)];
    buttonLabel.text = @"返回";
    buttonLabel.font = [UIFont systemFontOfSize:15];
    
    [leftButton addSubview:buttonimage];
    [leftButton addSubview:buttonLabel];
    
    
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbutton;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.ScrollView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.buttonBackView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];


    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    self.allQuestionArray = [NSMutableArray new];
    self.firstQuestionArray = [NSMutableArray new];
    self.lastQuestionArray = [NSMutableArray new];
    self.selectedDic = [NSMutableDictionary new];
    self.AllSelectedDic = [NSMutableDictionary new];
    self.manyChooseArray = [NSMutableArray new];
    self.indexPathDic = [NSMutableDictionary new];
    self.selectArray = [NSMutableArray new];
    
    
    
    
    [self.lastButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [self.nextButton                                                                                                                                                                                                                                                                                                                    setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];

    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.model = [[QuestionModel alloc]init];
    self.inputTextfield.delegate = self;
    self.ScrollView.delegate = self;
    
    
    UITapGestureRecognizer *scroTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scroTapGestureAction:)];

    [self.buttonBackView addGestureRecognizer:scroTapgesture];
    
    self.firstindex = 0;
    
    
   
    [self getQuestionData];
    
    
}

- (void)getQuestionData
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
NSString *URL = TestQuestionURL;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    
    if ([self.Type isEqualToString:@"个人"]) {
        [dic setObject:@"1" forKey:@"Paper"];
    }
    else
    {
        [dic setObject:@"2" forKey:@"Paper"];
    }
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        self.allQuestionArray = [NSMutableArray arrayWithArray:dataArray];
        [self.model setValuesForKeysWithDictionary:self.allQuestionArray[self.firstindex]];
        
        NSArray *quesArray = self.allQuestionArray[self.firstindex][@"Choices"];
        NSArray *quesArray2 = self.allQuestionArray[self.firstindex][@"Choicesno"];
    
     
        self.quesTitle.text = [[@"第" stringByAppendingString:self.allQuestionArray[self.firstindex][@"Sort"]] stringByAppendingString:@"道题"];
//        self.quesDes.text = self.allQuestionArray[self.firstindex][@"Question"];
        self.quesDetail.text = self.allQuestionArray[self.firstindex][@"Question"];
        
        self.questionType = self.allQuestionArray[self.firstindex][@"Type"];
        self.firstQuestionArray = [NSMutableArray arrayWithArray:quesArray];
        self.firstQuestionArray2 = [NSMutableArray arrayWithArray:quesArray2];
        
        self.tableViewHeight.constant = 50 * self.firstQuestionArray.count;
        self.contentViewHeight.constant = self.tableViewHeight.constant + 370;
        self.inputViewHeight.constant = 0;
        self.tableTopTo.constant = 0;
        
        [self.lastButton setTitle:@"返回" forState:(UIControlStateNormal)];
        [self setButtonWithButton:self.lastButton value:@"0"];
        
        [self.tableView reloadData];
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD hideAnimated:YES];
        NSLog(@"%@",error);
//        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取数据失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];
    
}

- (void)scroTapGestureAction:(UITapGestureRecognizer *)gesture
{
    [self.inputTextfield resignFirstResponder];
    
}

- (IBAction)lastButtonAction:(id)sender {
    
    self.selectArray = [NSMutableArray new];
    [self.inputTextfield resignFirstResponder];
    if (self.firstindex == 1) {
        self.inputTextfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if(self.firstindex == 0)
    {
        self.inputTextfield.keyboardType = UIKeyboardTypeDefault;
    }
    self.selectStatu = @"0";

    if (self.firstindex == 0) {
//        UIAlertView *alertVC = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前为第1道题" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertVC show];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的测评还未完成，确定要退出吗?" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [self postAnswers2];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        if (_ifFinishAnswer == YES)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        return;
        
    }
    if (self.firstindex == 1) {
        [self.lastButton setTitle:@"返回" forState:(UIControlStateNormal)];
        
        [self setButtonWithButton:self.lastButton value:@"0"];
        
    }
    
    NSInteger count = self.allQuestionArray.count;

    if (self.firstindex != count) {
        [self.nextButton setTitle:@"下一题" forState:(UIControlStateNormal)];
        
    }
    else
    {
    [self.lastButton setTitle:@"上一题" forState:(UIControlStateNormal)];
        [self setButtonWithButton:self.lastButton value:@"1"];
        
    }
    self.firstindex = self.firstindex - 1;
    
    if ([self.Type isEqualToString:@"个人"]) {
        if (self.firstindex == 1) {
            if ([self.secondType isEqualToString:@"选择"]==NO) {
                NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
                self.inputTextfield.text = self.AllSelectedDic[key][0];
            }
        }
        else if(self.firstindex == 2)
        {
            if ([self.thirdType isEqualToString:@"选择"]==NO) {
                NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
                self.inputTextfield.text = self.AllSelectedDic[key][0];
            }
        }
 
    }
    else
    {
        if (self.firstindex == 1) {
            if ([self.secondType isEqualToString:@"选择"]==NO) {
                NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
                self.inputTextfield.text = self.AllSelectedDic[key][0];
            }
        }
    }
    

    [self.model setValuesForKeysWithDictionary:self.allQuestionArray[self.firstindex]];
    
    NSString *type = self.allQuestionArray[self.firstindex][@"Type"];
    if ([type isEqualToString:@"1"]) {
        self.inputViewHeight.constant = 50;
        self.tableTopTo.constant = 1;
        self.inputTextfield.placeholder = self.model.Input;

    }
    else
    {
        self.inputViewHeight.constant = 0;
        self.tableTopTo.constant = 0;
    }
    
  
    NSArray *quesArray = self.allQuestionArray[self.firstindex][@"Choices"];
    self.quesTitle.text = [[@"第" stringByAppendingString:self.allQuestionArray[self.firstindex][@"Sort"]] stringByAppendingString:@"道题"];
    self.quesDetail.text = self.allQuestionArray[self.firstindex][@"Question"];
    self.questionType = self.allQuestionArray[self.firstindex][@"Type"];

    self.firstQuestionArray = [NSMutableArray arrayWithArray:quesArray];
    
    NSArray *quesArray2 = self.allQuestionArray[self.firstindex][@"Choicesno"];
    self.firstQuestionArray2 = [NSMutableArray arrayWithArray:quesArray2];
    
    self.tableViewHeight.constant = 50 * self.firstQuestionArray.count;
    self.contentViewHeight.constant = self.tableViewHeight.constant + 370;
    
    
    [self.tableView reloadData];
    [self.ScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}
- (void)setButtonWithButton:(UIButton *)button value:(NSString *)value
{
    if ([value isEqualToString:@"0"]) {
        button.layer.borderWidth = 1.5;
        button.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
        button.backgroundColor = [UIColor whiteColor];
        
    }
    else
    {
        button.layer.borderWidth = 0;
        button.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
        
    }
}
- (IBAction)nextButtonAction:(id)sender {
    self.selectArray = [NSMutableArray new];
    
    [self.inputTextfield resignFirstResponder];

    NSArray *selectArray = self.AllSelectedDic[[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
    if (selectArray == nil) {
        [self showAlertViewWithString:@"请先完成当前题目再进行下一题"];
        return;
        
    }
    
    if (self.firstindex == 1) {
        self.inputTextfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if(self.firstindex == 0)
    {
        self.inputTextfield.keyboardType = UIKeyboardTypeDefault;
    }
   
     self.inputTextfield.text = @"";
    
    self.selectStatu = @"0";

    [self.lastButton setTitle:@"上一题" forState:(UIControlStateNormal)];
    [self setButtonWithButton:self.lastButton value:@"1"];
    
    self.firstindex = self.firstindex + 1;
    NSInteger count = self.allQuestionArray.count;
    
    if ([self.Type isEqualToString:@"个人"]) {
        if (self.firstindex == 1) {
            if ([self.secondType isEqualToString:@"选择"]==NO) {
                NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
                self.inputTextfield.text = self.AllSelectedDic[key][0];
            }
        }
        else if(self.firstindex == 2)
        {
            if ([self.thirdType isEqualToString:@"选择"]==NO) {
                NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
                self.inputTextfield.text = self.AllSelectedDic[key][0];
            }
        }
        
    }
   
    else
    {
        if (self.firstindex == 1) {
            if ([self.secondType isEqualToString:@"选择"]==NO) {
                NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
                self.inputTextfield.text = self.AllSelectedDic[key][0];
            }
        }
    }
    
    if (self.firstindex == count - 1) {
        [self.nextButton setTitle:@"提交" forState:(UIControlStateNormal)];
        
    }
    else
    {
     [self.nextButton setTitle:@"下一题" forState:(UIControlStateNormal)];
    }
    
    if (self.firstindex == count) {
        
        
        UIView *inputPhoneView = [UIView new];
        inputPhoneView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        UIView *backView1 = [UIView new];
    
        
        
        UILabel *topLabel = [UILabel new];
        UILabel *bottomLabel = [UILabel new];
        self.phoneNumber = [UITextField new];
        UIButton *surePhoneButton = [UIButton new];
        
        self.phoneNumber.textAlignment = NSTextAlignmentCenter;
        
        
        [self.contentView addSubview:inputPhoneView];
        [inputPhoneView addSubview:backView1];
        [inputPhoneView addSubview:self.phoneNumber];
        [inputPhoneView addSubview:surePhoneButton];
        
        [backView1 addSubview:topLabel];
        [backView1 addSubview:bottomLabel];
        
        
        inputPhoneView.sd_layout.topSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0);
        
        
        backView1.sd_layout.topSpaceToView(inputPhoneView,0)
        .leftSpaceToView(inputPhoneView,0)
        .rightSpaceToView(inputPhoneView,0)
        .heightIs(100);
        backView1.backgroundColor = [UIColor whiteColor];
        
        
        
        topLabel.sd_layout.topSpaceToView(backView1,20)
        .centerXEqualToView(backView1)
        .heightIs(20);
        
        
        bottomLabel.sd_layout.topSpaceToView(topLabel,20)
        .centerXEqualToView(backView1)
        .heightIs(20);
        
        [topLabel setSingleLineAutoResizeWithMaxWidth:200];
        topLabel.font = [UIFont systemFontOfSize:15];
        
        [bottomLabel setSingleLineAutoResizeWithMaxWidth:500];
        bottomLabel.font = [UIFont systemFontOfSize:15];
        
        
        
        self.phoneNumber.sd_layout.topSpaceToView(backView1,10)
        .leftSpaceToView(inputPhoneView,0)
        .rightSpaceToView(inputPhoneView,0)
        .heightIs(50);
        
        self.phoneNumber.backgroundColor = [UIColor whiteColor];
        
        
        surePhoneButton.sd_layout.topSpaceToView(self.phoneNumber,80)
        .leftSpaceToView(inputPhoneView,60)
        .rightSpaceToView(inputPhoneView,60)
        .heightIs(50);
        
        
        [surePhoneButton addTarget:self action:@selector(didClickSurePhoneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        topLabel.text = @"评估结束！";
        bottomLabel.text = @"请输入电话号码以便查询评估结果";
        self.phoneNumber.placeholder = @"电话号码";
        [surePhoneButton setTitle:@"确认" forState:(UIControlStateNormal)];
        [surePhoneButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
        [surePhoneButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
    }
    else
    {
    [self.model setValuesForKeysWithDictionary:self.allQuestionArray[self.firstindex]];
    NSString *type = self.allQuestionArray[self.firstindex][@"Type"];

    if ([type isEqualToString:@"1"]) {
        self.inputViewHeight.constant = 50;
        self.tableTopTo.constant = 1;
        self.inputTextfield.placeholder = self.model.Input;
        
    }
    else
    {
        self.inputViewHeight.constant = 0;
        self.tableTopTo.constant = 0;
    }
    NSArray *quesArray = self.allQuestionArray[self.firstindex][@"Choices"];
    self.quesTitle.text = [[@"第" stringByAppendingString:self.allQuestionArray[self.firstindex][@"Sort"]] stringByAppendingString:@"道题"];
    self.quesDetail.text = self.allQuestionArray[self.firstindex][@"Question"];
        self.questionType = self.allQuestionArray[self.firstindex][@"Type"];

    self.firstQuestionArray = [NSMutableArray arrayWithArray:quesArray];
        
    NSArray *quesArray2 = self.allQuestionArray[self.firstindex][@"Choicesno"];
    self.firstQuestionArray2 = [NSMutableArray arrayWithArray:quesArray2];
    self.tableViewHeight.constant = 50 * self.firstQuestionArray.count;
    self.contentViewHeight.constant = self.tableViewHeight.constant + 370;
    [self.tableView reloadData];
    }
    [self.ScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    NSLog(@"%@",self.AllSelectedDic);
    
    
}
//正则判断
- (void)checkMobilePhoneNumber:(NSString *)mobile{
    if (mobile.length < 11)
    {
        [self showAlertViewWithString:@"请输入正确的手机号"];
        _isPhoneNumber = NO;
        return;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (!(isMatch1 || isMatch2 || isMatch3)) {
            _isPhoneNumber = NO;
            [self showAlertViewWithString:@"请输入正确的手机号"];
            return;
            
        } else {
            _isPhoneNumber = YES;
        }
    }
}
- (void)showAlertViewWithString:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


- (void)didClickSurePhoneButtonAction:(UIButton *)button
{
    
    
    
    [self checkMobilePhoneNumber:self.phoneNumber.text];
    [self.view endEditing:YES];
    
    if (self.isPhoneNumber == YES) {
        
        _ifFinishAnswer = YES;
        [self postAnswers];
            }
    

}
- (void)didClickFabuButtonAction:(UIButton *)button
{
    
    PersonalDebtsController *pushVC = [[PersonalDebtsController alloc]init];
    [self.navigationController pushViewController:pushVC animated:YES];
    
}
- (void)didClickRetestButtonAction:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)postAnswers
{
//    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//     self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
//    self.allSelected = [self dictionaryToJson:self.AllSelectedDic];
    
//    self.allSelected = [QuestionsController JsonModel:self.AllSelectedDic];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSArray *array = @[@"sdfs"];
    
    NSDictionary * Dic= @{@"2":array,@"3":array};
    
    NSString *str = [QuestionsController JsonModel:Dic];
    NSLog(@"%@",Dic);
    NSLog(@"%@",str);
    
    
    self.allSelected = [QuestionsController JsonModel:self.AllSelectedDic];
    NSLog(@"%@",self.allSelected);

    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = TestResultURL;
    if (token != nil) {
        URL = [[TestResultURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.amount forKey:@"Money"];
    [dic setObject:self.area forKey:@"Area"];
    [dic setObject:self.personType forKey:@"AssetType"];
    [dic setObject:self.Type forKey:@"Type"];
    if (_ifFinishAnswer == YES) {
        [dic setObject:self.phoneNumber.text forKey:@"PhoneNumber"];
    }
    
//    [dic setObject:self.allSelected forKey:@"Answer"];
    
    [dic setObject:self.allSelected forKey:@"Answer"];
    [dic setObject:@"IOS" forKey:@"Channel"];
    
[self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    [self setResultViews];
    NSString *result = resultDic[@"result"];
    
    NSString *Score = [NSString stringWithFormat:@"%@",resultDic[@"score"]];
    
    self.resultDes.text = result;
    self.testResult.text = [Score stringByAppendingString:@"分"];
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"%@",error);
    [self.HUD removeFromSuperViewOnHide];
    [self.HUD hideAnimated:YES];
    [self showAlertViewWithString:@"提交失败，请稍后重试"];
}];
  
}

- (void)postAnswers2
{
    //    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //     self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //    self.allSelected = [self dictionaryToJson:self.AllSelectedDic];
    
    //    self.allSelected = [QuestionsController JsonModel:self.AllSelectedDic];

    NSArray *array = @[@"sdfs"];
    
    NSDictionary * Dic= @{@"2":array,@"3":array};
    
    NSString *str = [QuestionsController JsonModel:Dic];
    NSLog(@"%@",Dic);
    NSLog(@"%@",str);
    
    
    self.allSelected = [QuestionsController JsonModel:self.AllSelectedDic];
    NSLog(@"%@",self.allSelected);
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = TestResultURL;
    if (token != nil) {
        URL = [[TestResultURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.amount forKey:@"Money"];
    [dic setObject:self.area forKey:@"Area"];
    [dic setObject:self.personType forKey:@"AssetType"];
    [dic setObject:self.Type forKey:@"Type"];
    [dic setObject:self.allSelected forKey:@"Answer"];
    [dic setObject:@"IOS" forKey:@"Channel"];
    
    
    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self setResultViews];
        NSString *result = resultDic[@"result"];
        
        NSString *Score = [NSString stringWithFormat:@"%@",resultDic[@"score"]];
        
//        self.resultDes.text = result;
//        self.testResult.text = Score;
//        [self.HUD removeFromSuperViewOnHide];
//        [self.HUD hideAnimated:YES];
//        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
//        [self.HUD removeFromSuperViewOnHide];
//        [self.HUD hideAnimated:YES];
//        [self showAlertViewWithString:@"提交失败，请稍后重试"];
    }];
    
}
- (void)setResultViews
{

    self.resultView = [UIView new];
    self.resultView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    UIView *topView = [UIView new];
    UIView *bottomView = [UIView new];
    
    UILabel *jieguoLabel = [UILabel new];
    self.testResult = [UILabel new];
    
    self.resultDes = [UILabel new];
    UIButton *fabuButton = [UIButton new];
    UIButton *reTestButton = [UIButton new];
    
    
    [self.contentView addSubview:self.resultView];
    [self.resultView addSubview:topView];
    [self.resultView addSubview:bottomView];
    [topView addSubview:jieguoLabel];
    [topView addSubview:self.testResult];
    [bottomView addSubview:self.resultDes];
    [self.resultView addSubview:fabuButton];
    [self.resultView addSubview:reTestButton];
    
    
    
    self.resultView.sd_layout.leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,0);
    
    topView.sd_layout.leftEqualToView(self.resultView)
    .rightEqualToView(self.resultView)
    .heightIs(90)
    .topSpaceToView(self.resultView,0);
    topView.backgroundColor = [UIColor whiteColor];
    
    
    bottomView.sd_layout.leftEqualToView(self.resultView)
    .rightEqualToView(self.resultView)
    .topSpaceToView(topView,10);
    bottomView.backgroundColor = [UIColor whiteColor];
    
    
    jieguoLabel.sd_layout.centerXEqualToView(topView)
    .topSpaceToView(topView,20)
    .heightIs(20);
    
    jieguoLabel.text = @"测评结果!";
    jieguoLabel.textAlignment = NSTextAlignmentCenter;
    [jieguoLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    
    self.testResult.sd_layout.centerXEqualToView(jieguoLabel)
    .topSpaceToView(jieguoLabel,10)
    .heightIs(20);
    
    
    [self.testResult setSingleLineAutoResizeWithMaxWidth:100];
    
    
    
    //        self.resultDes.text = @"dsfsdfasdfsfsdfsfsfsdfsdfsdhfksdhfihwiefhiwuehfiuehwoifheoirhoiewhrioewhtoiehwtoihewiothioehtoiewhtiowheiothweiotgeiowgtioewgtioegwiorhioewhoiwehitewiothiowethoiewhtoiwehtiohewiothewoihtioewhtioewhtioewhtiohewiothewoihteiowhtioewhtioewhtioewhtioewhtioewhtiowehtioewhtioewhtioew";
    
    self.resultDes.sd_layout.leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15)
    .topSpaceToView(bottomView,15)
    .autoHeightRatio(0);
    
    self.resultDes.text = @"dfsihfiuhsuifguwgeufguywegfugeiugeuirgiuertertueht";
    
    
    [bottomView setupAutoHeightWithBottomView:self.resultDes bottomMargin:15];
    
    fabuButton.sd_layout.leftSpaceToView(self.resultView,60)
    .rightSpaceToView(self.resultView,60)
    .topSpaceToView(bottomView,40)
    .heightIs(50);
    [fabuButton setTitle:@"发布债权" forState:(UIControlStateNormal)];
    
    [fabuButton addTarget:self action:@selector(didClickFabuButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [fabuButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [fabuButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    
    
    reTestButton.sd_layout.leftEqualToView(fabuButton)
    .rightEqualToView(fabuButton)
    .topSpaceToView(fabuButton,20)
    .heightIs(50);
    
    [reTestButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [reTestButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    
    [reTestButton addTarget:self action:@selector(didClickRetestButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [reTestButton setTitle:@"退出测评" forState:(UIControlStateNormal)];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputTextfield resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString *firstKey = [NSString stringWithFormat:@"%ld",self.firstindex + 1];
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:self.indexPathDic[firstKey][0]];
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    if (self.firstindex == 1) {
        self.secondType = @"填空";
    }
    else if(self.firstindex == 2)
    {
        self.thirdType = @"填空";
    }
    self.selectStatu = @"0";
//    [self.AllSelectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
//    [self.selectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
    NSArray *array = self.AllSelectedDic[firstKey];
    
    if (array.count != 0) {
        [self.AllSelectedDic[firstKey] removeObjectAtIndex:0];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *firstKey = [NSString stringWithFormat:@"%ld",self.firstindex + 1];

//    [self.AllSelectedDic setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
    if (self.selectArray.count != 0)
    {
        [self.selectArray replaceObjectAtIndex:0 withObject:textField.text];
    }
    else
    {
        [self.selectArray addObject:textField.text];
    }
    
    [self.AllSelectedDic setObject:self.selectArray forKey:firstKey];
    
    
    [self.selectedDic removeAllObjects];
//    if ([self.Type isEqualToString:@"个人"]) {
//        if (self.firstindex == 1 || self.firstindex == 2) {
//            
//            
//        }
//    }
//    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.inputTextfield resignFirstResponder];
}
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.firstQuestionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex + 1];
    NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row];
//    QuestionModel *model = [[QuestionModel alloc]init];
//    model = self.firstQuestionArray[indexPath.row];
    cell.textLabel.text = self.firstQuestionArray2[indexPath.row];
    
    if ([self.Type isEqualToString:@"个人"] ) {
        if (self.firstindex == 1 || self.firstindex == 2) {
            cell.textLabel.text = self.firstQuestionArray2[indexPath.row + 1];
        }
    }
    else
    {
        if (self.firstindex == 1) {
            cell.textLabel.text = self.firstQuestionArray2[indexPath.row + 1];
        }
    }
    for (NSIndexPath *indexP in self.indexPathDic[key])
    {
        if (indexPath == indexP) {
            
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.imageView.image = [UIImage imageNamed:@"leixingxuanzhong"];
            
        }
        else
        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.imageView.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];

        }
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.imageView.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];


    }
    if (!self.indexPathDic[key]) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];

    }
    
      return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *firstKey = [NSString stringWithFormat:@"%ld",self.firstindex + 1];
    NSMutableArray *indexArray = [NSMutableArray new];

    
    [self.inputTextfield resignFirstResponder];
    if ([self.questionType isEqualToString:@"2"] == NO) {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.indexPathDic[firstKey][0]];
//        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        selectedCell.imageView.image = [UIImage imageNamed:@"leixingxuanweixuanzhong"];
        
        UITableViewCell *willSelectCell = [tableView cellForRowAtIndexPath:indexPath];
//        willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
        willSelectCell.imageView.image = [UIImage imageNamed:@"leixingxuanzhong"];
        [indexArray addObject:indexPath];
        [self.indexPathDic setObject:indexArray forKey:firstKey];
        
        if (self.firstindex == 1 || self.firstindex == 2) {
            if (self.firstindex == 1) {
                self.secondType = @"选择";
            }
            else if(self.firstindex == 2)
            {
                self.thirdType = @"选择";
            }
        }
        
        if ([self.Type isEqualToString:@"个人"]) {
            if (self.firstindex == 1 || self.firstindex == 2) {
                NSMutableArray *array = [NSMutableArray new];
//                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
                [array addObject:self.firstQuestionArray[indexPath.row]];
                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            }
        }
        else
        {
            if (self.firstindex == 1) {
                NSMutableArray *array = [NSMutableArray new];
//                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
                [array addObject:self.firstQuestionArray[indexPath.row]];
                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            }
        }
        
        
        
        
        
//        NSMutableArray *array = [NSMutableArray new];
//        NSString *indStr = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        NSString *indStr = self.firstQuestionArray[indexPath.row];
        
        if (self.selectArray.count != 0)
        {
        [self.selectArray replaceObjectAtIndex:0 withObject:indStr];
        }
        else
        {
            [self.selectArray addObject:indStr];
        }
        [self.AllSelectedDic setObject:self.selectArray forKey:firstKey];
        
        
        
        NSLog(@"%@",self.AllSelectedDic);
    }
    else
    {
        UITableViewCell *willSelectCell = [tableView cellForRowAtIndexPath:indexPath];
//        willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
        willSelectCell.imageView.image = [UIImage imageNamed:@"leixingxuanzhong"];

        [indexArray addObject:indexPath];
        [self.indexPathDic setObject:indexArray forKey:firstKey];
        
//        NSMutableArray *array = [NSMutableArray new];
//        NSString *indStr = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        NSString *indStr = self.firstQuestionArray[indexPath.row];
        [self.selectArray addObject:indStr];
        [self.AllSelectedDic setObject:self.selectArray forKey:firstKey];
        NSLog(@"%@",self.AllSelectedDic);
    }

}


/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectRow = [NSString stringWithFormat:@"%ld",indexPath.row];

        [self.inputTextfield resignFirstResponder];
 
    if ([self.questionType isEqualToString:@"2"] == NO) {
        NSLog(@"%@",self.selectedDic);

        
        NSArray *lastSelectArray = self.AllSelectedDic[[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectIndex];
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        UITableViewCell *willSelectCell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSString *selectStr = [NSString stringWithFormat:@"%ld",self.firstindex + 1];
        NSArray *selectArray = self.AllSelectedDic[[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
        if (selectArray == nil ) {
            
            willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
            //            [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            NSMutableArray *array = [NSMutableArray new];
            [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
            [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            
            
            if (self.firstindex == 1 || self.firstindex == 2) {
                if (self.firstindex == 1) {
                    self.secondType = @"选择";
                }
                else if(self.firstindex == 2)
                {
                    self.thirdType = @"选择";
                    
                }
                
                //                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                NSMutableArray *array = [NSMutableArray new];
                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            }
            self.selectStatu = @"1";
            self.selectIndex = indexPath;
            self.index = indexPath.row;
            [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
            
        }
        
        for (NSString *str in selectArray)
        
        {
            if ([str isEqualToString:selectRow])
            {
                willSelectCell.accessoryType = UITableViewCellAccessoryNone;
                if ([self.selectStatu isEqualToString:@"1"])
                {
                    willSelectCell.accessoryType = UITableViewCellAccessoryNone;
                    self.selectStatu = @"0";
                    
                    [self.AllSelectedDic[selectStr] removeObject:str];
                    
//                    [self.AllSelectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
//                    [self.selectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
                }
                else
                {
                    willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    self.selectStatu = @"1";
                    self.selectIndex = indexPath;
                    
                    //                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                    NSMutableArray *array = [NSMutableArray new];
                    [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
                    [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                    
                    
                    if (self.firstindex == 1 || self.firstindex == 2) {
                        
                        if (self.firstindex == 1) {
                            self.secondType = @"选择";
                        }
                        else if(self.firstindex == 2)
                        {
                            self.thirdType = @"选择";
                            
                        }
                        
                        //                    [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                        NSMutableArray *array = [NSMutableArray new];
                        [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
                        [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                    }
                    //                self.index = indexPath.row;
                    //                [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
                }

                
            }
            else
            {
         
            willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
            //            [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            NSMutableArray *array = [NSMutableArray new];
            [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
            [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            
            
            if (self.firstindex == 1 || self.firstindex == 2) {
                if (self.firstindex == 1) {
                    self.secondType = @"选择";
                }
                else if(self.firstindex == 2)
                {
                    self.thirdType = @"选择";
                    
                }
                
                //                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                NSMutableArray *array = [NSMutableArray new];
                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            }
            self.selectStatu = @"1";
            self.selectIndex = indexPath;
            self.index = indexPath.row;
            [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
        }
        }
        
        NSLog(@"!!!!!!!!%@",self.AllSelectedDic);
        self.allSelected = [self dictionaryToJson:self.AllSelectedDic];

        }
        
//        
//        if (indexPath.row == [self.AllSelectedDic[selectStr] integerValue]) {
//            willSelectCell.accessoryType = UITableViewCellAccessoryNone;
//            if ([self.selectStatu isEqualToString:@"1"]) {
//                willSelectCell.accessoryType = UITableViewCellAccessoryNone;
//                self.selectStatu = @"0";
//                [self.AllSelectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
//                [self.selectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
//            }
//            else
//            {
//                willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
//                self.selectStatu = @"1";
//                self.selectIndex = indexPath;
//                
//                
////                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//                NSMutableArray *array = [NSMutableArray new];
//                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
//                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//                
//                
//                if (self.firstindex == 1 || self.firstindex == 2) {
//                    
//                    if (self.firstindex == 1) {
//                        self.secondType = @"选择";
//                    }
//                    else if(self.firstindex == 2)
//                    {
//                        self.thirdType = @"选择";
//                        
//                    }
//                    
////                    [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//                    NSMutableArray *array = [NSMutableArray new];
//                    [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
//                    [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//                }
////                self.index = indexPath.row;
////                [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
//            }
//        }
//        else
//        {
//            willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
//       //            [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//            NSMutableArray *array = [NSMutableArray new];
//            [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
//            [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//            
//            
//            if (self.firstindex == 1 || self.firstindex == 2) {
//                if (self.firstindex == 1) {
//                    self.secondType = @"选择";
//                }
//                else if(self.firstindex == 2)
//                {
//                    self.thirdType = @"选择";
//                    
//                }
//                
////                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//                NSMutableArray *array = [NSMutableArray new];
//                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
//                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//            }
//            self.selectStatu = @"1";
//            self.selectIndex = indexPath;
//            self.index = indexPath.row;
//            [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
//        }
//        
//        NSLog(@"!!!!!!!!%@",self.AllSelectedDic);
//        self.allSelected = [self dictionaryToJson:self.AllSelectedDic];
//        
//        
//        for (NSString *value in [self.AllSelectedDic allValues]) {
//            
//            //        self.allSelected =
//        }
//        NSLog(@"_____%@",self.allSelected);
//        
//        self.inputTextfield.text = self.allSelected;
//
//    }
    else
    {
//        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectIndex];
//        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        UITableViewCell *willSelectCell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *selectStr = [NSString stringWithFormat:@"%ld",self.firstindex + 1];
        NSArray *selectArray = self.AllSelectedDic[[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
        if (selectArray == nil ) {
            willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
            //            [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            NSMutableArray *array = [NSMutableArray new];
            [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
            [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            
            
//            if (self.firstindex == 1 || self.firstindex == 2) {
//                if (self.firstindex == 1) {
//                    self.secondType = @"选择";
//                }
//                else if(self.firstindex == 2)
//                {
//                    self.thirdType = @"选择";
//                    
//                }
            
                //                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//                NSMutableArray *array = [NSMutableArray new];
//                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
//                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//            }
            
            
            self.selectStatu = @"1";
            self.selectIndex = indexPath;
            self.index = indexPath.row;
            [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
            return;
            
        }
    
        for (NSString *str in selectArray)
        {
            if ([str isEqualToString:selectRow])
            {
                willSelectCell.accessoryType = UITableViewCellAccessoryNone;
                if ([self.selectStatu isEqualToString:@"1"])
                {
                    
                    willSelectCell.accessoryType = UITableViewCellAccessoryNone;
                    self.selectStatu = @"0";
                    
                    [self.AllSelectedDic[selectStr] removeObject:str];
                    
                    //                    [self.AllSelectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
                    //                    [self.selectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
                }
                else
                {
                    willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    self.selectStatu = @"1";
                    self.selectIndex = indexPath;
                    
                    //                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                    NSMutableArray *array = [NSMutableArray new];
                    [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
                    [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                    
                    
                    if (self.firstindex == 1 || self.firstindex == 2) {
                        
                        if (self.firstindex == 1) {
                            self.secondType = @"选择";
                        }
                        else if(self.firstindex == 2)
                        {
                            self.thirdType = @"选择";
                            
                        }
                        
                        //                    [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                        NSMutableArray *array = [NSMutableArray new];
                        [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
                        [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                    }
                    //                self.index = indexPath.row;
                    //                [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
                }
                
                
            }
            else
            {
                
                willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
                //            [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                NSMutableArray *array = [NSMutableArray new];
                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                
                
                if (self.firstindex == 1 || self.firstindex == 2) {
                    if (self.firstindex == 1) {
                        self.secondType = @"选择";
                    }
                    else if(self.firstindex == 2)
                    {
                        self.thirdType = @"选择";
                    }
                    
                    //                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                    NSMutableArray *array = [NSMutableArray new];
                    [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
                    [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
                    
                }
                self.selectStatu = @"1";
                self.selectIndex = indexPath;
                self.index = indexPath.row;
                [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
            }
        }
        
        NSLog(@"!!!!!!!!%@",self.AllSelectedDic);
        self.allSelected = [self dictionaryToJson:self.AllSelectedDic];

        
//        NSString *selectStr = [NSString stringWithFormat:@"%ld",self.firstindex];
//        
//        
//        
//        
//        if (indexPath.row == [self.selectedDic[selectStr] integerValue]) {
//            willSelectCell.accessoryType = UITableViewCellAccessoryNone;
//            if ([self.selectStatu isEqualToString:@"1"]) {
//                willSelectCell.accessoryType = UITableViewCellAccessoryNone;
//                self.selectStatu = @"0";
//                [self.AllSelectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
//                [self.selectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
//            }
//            else
//            {
//                willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
//                self.selectStatu = @"1";
////                self.selectIndex = indexPath;
////                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
////                self.index = indexPath.row;
////                [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
//               
//                
//                NSMutableArray *array = [NSMutableArray new];
//                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
//                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//                
//            }
//        }
//        else
//        {
//            willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
//            
//            NSMutableArray *array = [NSMutableArray new];
//            [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
//            [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
////            [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//            
//            
//            if (self.firstindex == 1 || self.firstindex == 2)
//            {
//                if (self.firstindex == 1)
//                {
//                    self.secondType = @"选择";
//                }
//                else if(self.firstindex == 2)
//                {
//                    self.thirdType = @"选择";
//                }
//                
//                NSMutableArray *array = [NSMutableArray new];
//                [array addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
//                [self.AllSelectedDic setObject:array forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
//            }
//            self.selectStatu = @"1";
//            
//            
////            self.selectIndex = indexPath;
////            self.index = indexPath.row;
////            [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
//            
//        }
//        
//        NSLog(@"!!!!!!!!%@",self.AllSelectedDic);
//        self.allSelected = [self dictionaryToJson:self.AllSelectedDic];
//        for (NSString *value in [self.AllSelectedDic allValues]) {
//            
//            //        self.allSelected =
//        }

        
    
    }
    
    
    
}

*/


+(NSString *)JsonModel:(NSDictionary *)dictModel
{
    if ([NSJSONSerialization isValidJSONObject:dictModel])
    {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictModel options:nil error:nil];
        NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        return jsonStr;
    }
    return nil;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
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
