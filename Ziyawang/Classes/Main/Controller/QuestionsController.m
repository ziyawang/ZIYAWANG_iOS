//
//  QuestionsController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/3.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "QuestionsController.h"
#import "QuestionModel.h"

@interface QuestionsController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) AFHTTPSessionManager *manager;
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


@end

@implementation QuestionsController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        self.quesTitle.text = [[@"第" stringByAppendingString:self.allQuestionArray[self.firstindex][@"Sort"]] stringByAppendingString:@"道题"];
//        self.quesDes.text = self.allQuestionArray[self.firstindex][@"Question"];
        self.quesDetail.text = self.allQuestionArray[self.firstindex][@"Question"];
        self.firstQuestionArray = [NSMutableArray arrayWithArray:quesArray];
        self.tableViewHeight.constant = 50 * self.firstQuestionArray.count;
        self.contentViewHeight.constant = self.tableViewHeight.constant + 340;
        self.inputViewHeight.constant = 0;
        self.tableTopTo.constant = 0;
        
        [self.lastButton setTitle:@"返回" forState:(UIControlStateNormal)];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)scroTapGestureAction:(UITapGestureRecognizer *)gesture
{
    [self.inputTextfield resignFirstResponder];
    
}
- (IBAction)lastButtonAction:(id)sender {
    
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
        [self.navigationController popViewControllerAnimated:YES];
        return;
        
    }
    if (self.firstindex == 1) {
        [self.lastButton setTitle:@"返回" forState:(UIControlStateNormal)];
    }
    else
    {
    [self.lastButton setTitle:@"上一题" forState:(UIControlStateNormal)];
    }
    self.firstindex = self.firstindex - 1;
    if (self.firstindex == 1) {
        if ([self.secondType isEqualToString:@"选择"]==NO) {
            NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
            self.inputTextfield.text = self.AllSelectedDic[key];
        }
    }
    else if(self.firstindex == 2)
    {
        if ([self.thirdType isEqualToString:@"选择"]==NO) {
            NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
            self.inputTextfield.text = self.AllSelectedDic[key];
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
    self.firstQuestionArray = [NSMutableArray arrayWithArray:quesArray];
    self.tableViewHeight.constant = 50 * self.firstQuestionArray.count;
    self.contentViewHeight.constant = self.tableViewHeight.constant + 340;
    
    
    [self.tableView reloadData];
    [self.ScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}
- (IBAction)nextButtonAction:(id)sender {
    
    [self.inputTextfield resignFirstResponder];
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
    self.firstindex = self.firstindex + 1;
    NSInteger count = self.allQuestionArray.count;
    
    if (self.firstindex == 1) {
        if ([self.secondType isEqualToString:@"选择"]==NO) {
            NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
            self.inputTextfield.text = self.AllSelectedDic[key];
        }
    }
    else if(self.firstindex == 2)
    {
        if ([self.thirdType isEqualToString:@"选择"]==NO) {
            NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex +1];
            self.inputTextfield.text = self.AllSelectedDic[key];
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
        
        topLabel.text = @"测评结束！";
        bottomLabel.text = @"请输入电话号码以便为您提供更专业的服务";
        
        self.phoneNumber.placeholder = @"    电话号码";
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
    self.firstQuestionArray = [NSMutableArray arrayWithArray:quesArray];
    self.tableViewHeight.constant = 50 * self.firstQuestionArray.count;
    self.contentViewHeight.constant = self.tableViewHeight.constant + 340;
    [self.tableView reloadData];
    }
    [self.ScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
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
    
   
    if (self.isPhoneNumber == YES) {
        self.resultView = [UIView new];
        self.resultView.backgroundColor = [UIColor blueColor];
        
        UIView *topView = [UIView new];
        UIView *bottomView = [UIView new];
        
        UILabel *jieguoLabel = [UILabel new];
        UILabel *testResult = [UILabel new];
        self.resultDes = [UILabel new];
        UIButton *fabuButton = [UIButton new];
        UIButton *reTestButton = [UIButton new];
        
        [self.contentView addSubview:self.resultView];
        [self.resultView addSubview:topView];
        [self.resultView addSubview:bottomView];
        [topView addSubview:jieguoLabel];
        [topView addSubview:testResult];
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
        topView.backgroundColor = [UIColor redColor];
        
        
        bottomView.sd_layout.leftEqualToView(self.resultView)
        .rightEqualToView(self.resultView)
        .topSpaceToView(topView,10);
        bottomView.backgroundColor = [UIColor redColor];
        
        
        jieguoLabel.sd_layout.centerXEqualToView(topView)
        .topSpaceToView(topView,20)
        .heightIs(20);
        
        jieguoLabel.text = @"测评结果！";
        jieguoLabel.textAlignment = NSTextAlignmentCenter;
        [jieguoLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        testResult.sd_layout.centerXEqualToView(topView)
        .topSpaceToView(jieguoLabel,10)
        .heightIs(20);
        
        testResult.text = @"skdhfshdifhsid";
        
        [testResult setSingleLineAutoResizeWithMaxWidth:500];
        
        
        
        //        self.resultDes.text = @"dsfsdfasdfsfsdfsfsfsdfsdfsdhfksdhfihwiefhiwuehfiuehwoifheoirhoiewhrioewhtoiehwtoihewiothioehtoiewhtiowheiothweiotgeiowgtioewgtioegwiorhioewhoiwehitewiothiowethoiewhtoiwehtiohewiothewoihtioewhtioewhtioewhtiohewiothewoihteiowhtioewhtioewhtioewhtioewhtioewhtiowehtioewhtioewhtioew";
        
        self.resultDes.sd_layout.leftSpaceToView(bottomView,15)
        .rightSpaceToView(bottomView,15)
        .topSpaceToView(bottomView,15)
        .autoHeightRatio(0);
        
        
        
        [bottomView setupAutoHeightWithBottomView:self.resultDes bottomMargin:15];
        
        fabuButton.sd_layout.leftSpaceToView(self.resultView,60)
        .rightSpaceToView(self.resultView,60)
        .topSpaceToView(bottomView,40)
        .heightIs(50);
        [fabuButton setTitle:@"发布债权" forState:(UIControlStateNormal)];
        
        
        reTestButton.sd_layout.leftEqualToView(fabuButton)
        .rightEqualToView(fabuButton)
        .topSpaceToView(fabuButton,20)
        .heightIs(50);
        [reTestButton setTitle:@"重新测评" forState:(UIControlStateNormal)];
        

    }
    

}

- (void)postAnswers
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = TestResultURL;
    if (token != nil) {
        URL = [[TestResultURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"token" forKey:@"access_token"];
    [dic setObject:self.amount forKey:@"Money"];
    [dic setObject:self.area forKey:@"Area"];
    [dic setObject:self.Type forKey:@"AssetType"];
    [dic setObject:self.personType forKey:@"Type"];
    [dic setObject:self.phoneNumber.text forKey:@"PhoneNumber"];
    [dic setObject:self.allSelected forKey:@"Answer"];
    [dic setObject:@"IOS" forKey:@"Channel"];
    
[self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
    NSString *result = resultDic[@"result"];
    self.resultDes.text = result;


} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
}];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputTextfield resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:self.selectIndex];
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    if (self.firstindex == 1) {
        self.secondType = @"填空";
    }
    else if(self.firstindex == 2)
    {
        self.thirdType = @"填空";
        
    }
    self.selectStatu = @"0";
    [self.AllSelectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
    [self.selectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.AllSelectedDic setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
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
    NSString *key = [NSString stringWithFormat:@"%ld",self.firstindex];
    NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row];
//    QuestionModel *model = [[QuestionModel alloc]init];
//    model = self.firstQuestionArray[indexPath.row];
    cell.textLabel.text = self.firstQuestionArray[indexPath.row];
    
    if ([index isEqualToString:self.selectedDic[key]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.inputTextfield resignFirstResponder];
    NSLog(@"%@",self.selectedDic);
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectIndex];
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *willSelectCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *selectStr = [NSString stringWithFormat:@"%ld",self.firstindex];
    
    if (indexPath.row == [self.selectedDic[selectStr] integerValue]) {
        willSelectCell.accessoryType = UITableViewCellAccessoryNone;
        if ([self.selectStatu isEqualToString:@"1"]) {
            willSelectCell.accessoryType = UITableViewCellAccessoryNone;
            self.selectStatu = @"0";
            [self.AllSelectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex + 1]];
            [self.selectedDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
        }
        else
        {
            willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectStatu = @"1";
            self.selectIndex = indexPath;
            
            
            [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            if (self.firstindex == 1 || self.firstindex == 2) {
                
                if (self.firstindex == 1) {
                    self.secondType = @"选择";
                }
                else if(self.firstindex == 2)
                {
                self.thirdType = @"选择";
                    
                }
                
                [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
            }
            self.index = indexPath.row;
            [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
        }
    }
    else
    {
    willSelectCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
        if (self.firstindex == 1 || self.firstindex == 2) {
            if (self.firstindex == 1) {
                self.secondType = @"选择";
            }
            else if(self.firstindex == 2)
            {
                self.thirdType = @"选择";
                
            }
            [self.AllSelectedDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+2] forKey:[NSString stringWithFormat:@"%ld",self.firstindex+1]];
        }
        self.selectStatu = @"1";
        self.selectIndex = indexPath;
        self.index = indexPath.row;
        [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:[NSString stringWithFormat:@"%ld",self.firstindex]];
    }
    
    NSLog(@"!!!!!!!!%@",self.AllSelectedDic);
  self.allSelected = [self dictionaryToJson:self.AllSelectedDic];
    for (NSString *value in [self.AllSelectedDic allValues]) {
        
//        self.allSelected =
    }
    NSLog(@"_____%@",self.allSelected);
    
    self.inputTextfield.text = self.allSelected;
    
    
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
