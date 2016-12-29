//
//  FindInfoController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/5.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//
#import "FindInfoController.h"

#import "InfoDetailsController.h"
#import "MoreMenuView.h"
#import "AFNetWorking.h"
#import "MBProgressHUD.h"
#import "PublishCell.h"
#import "NewPublishCell.h"
#import "PublishModel.h"
#import "FindModel.h"
#import "MJRefresh.h"
#import "SDVersion.h"
#import "SDiOSVersion.h"
#import "CLDropDownMenu.h"


#import "LoginController.h"
#import "UserInfoModel.h"
#import "MyidentifiController.h"
#import "RechargeController.h"

#import "DetailOfInfoController.h"
#import "ChuzhiCell.h"
#import "ChuzhiDetailController.h"
#import "VipViewController.h"
#define kWidthScale ([UIScreen mainScreen].bounds.size.width/375)
#define kHeightScale ([UIScreen mainScreen].bounds.size.height/667)
@interface FindInfoController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    UINib *nib;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) NSString *TypeID;
@property (nonatomic,strong) NSMutableArray *shengArray;

@property (nonatomic,strong) NSMutableArray *shiArray;


@property (nonatomic,strong) NSMutableArray *allshiArray;

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) PublishModel *model;

@property (nonatomic,strong) NSMutableDictionary *dataDic;

@property (nonatomic,assign) NSInteger startpage;

@property (nonatomic,strong) NSString *lastChoose;
@property (nonatomic,strong) CLDropDownMenu *dropMenu;
@property (nonatomic,assign) BOOL isInView;



@property (nonatomic,strong) UIView *alertView1;
@property (nonatomic,strong) UIView *alertView2;
@property (nonatomic,strong) UIView *blackBackView1;
@property (nonatomic,strong) UIView *blackBackView2;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *AccountLabel1;
@property (nonatomic,strong) UILabel *AccountLabel2;
@property (nonatomic,strong) UILabel *buzuLabel;

@property (nonatomic,strong) MoreMenuView *menuView;
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) UserInfoModel *userModel;
@property (nonatomic,strong) NSString *USERID;

@property (nonatomic,strong) DetailOfInfoController *infoDetailsVC;
@property (nonatomic,strong) PublishModel *pubModel;
@property (nonatomic,strong) UIView *PromiseView;

@property (nonatomic,strong) NSString *selectTypeName;
@property (nonatomic,strong) NSString *vipStr;
@property (nonatomic,strong) NSString *right;
@end

@implementation FindInfoController

- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//显示菊花
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
}
- (void)rightButtonAction:(UIButton *)sender
{
    if (self.isInView == NO) {
//        CLDropDownMenu *dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:((UIButton *)sender).frame Pressed:^(NSInteger index) {
//            NSLog(@"点击了第%ld个btn",index+1);
//        }];
         self.dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:((UIButton *)sender).frame Pressed:^(NSInteger index) {
            NSLog(@"点击了第%ld个btn",index+1);
             if (index  == 0) {
                 [self.dataDic setObject:@"" forKey:@"Vip"];
                 [self findInfomationsWithDic:self.dataDic];
                  self.isInView = NO;
                 self.vipStr = @"";
             }
             else if(index == 1)
             {
                 [self.dataDic setObject:@"0" forKey:@"Vip"];
                  [self findInfomationsWithDic:self.dataDic];
                 self.isInView = NO;
                 self.vipStr = @"0";
             }
             else if(index == 2)
             {
                 [self.dataDic setObject:@"1" forKey:@"Vip"];
                 [self findInfomationsWithDic:self.dataDic];
                 self.isInView = NO;
                 self.vipStr = @"1";
             }
             else if (index == 3)
             {
                 [self.dataDic setObject:@"2" forKey:@"Vip"];
                 [self findInfomationsWithDic:self.dataDic];
                 self.isInView = NO;
                 self.vipStr = @"2";
             }
        }];
        self.dropMenu.direction = CLDirectionTypeBottom;
        self.dropMenu.titleList = @[@"全部",@"普通",@"VIP",@"收费"];
        
        [self.view addSubview:self.dropMenu];
        self.isInView = YES;
    }
   else if(self.isInView == YES)
    {
        [self.dropMenu removeFromSuperview];
        self.isInView = NO;
    }
   }
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userModel = [[UserInfoModel alloc]init];
    [self getUserInfoFromDomin];
    
    self.right = [[NSUserDefaults standardUserDefaults]objectForKey:@"right"];
    
    
    
}

- (void)getUserInfoFromDomin
{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    //    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    if (token != nil) {
        NSString *URL = [[getUserInfoURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"token" forKey:@"access_token"];
        [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.account = dic[@"user"][@"Account"];
            self.role = dic[@"role"];
            self.USERID = dic[@"user"][@"userid"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"user"][@"right"] forKey:@"right"];

            [self.userModel setValuesForKeysWithDictionary:dic[@"user"]];
            [self.userModel setValuesForKeysWithDictionary:dic[@"service"]];
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         

        }];        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.isInView = NO;
    self.vipStr = @"";
    self.navigationItem.title = @"找信息";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
//    [self.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"icon_left_jt"] forState:(UIControlStateNormal) barMetrics:UIBarMetricsDefault];
   
    CGRect backframe = CGRectMake(0,0,30,30);
    UIButton* backButton= [[UIButton alloc] initWithFrame:backframe];
    [backButton setTitle:@"筛选" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
//    backButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [backButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
     self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, self.view.bounds.size.height)];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPublishCell" bundle:nil] forCellReuseIdentifier:@"NewPublishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChuzhiCell" bundle:nil] forCellReuseIdentifier:@"ChuzhiCell"];

    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

    self.tableView.contentInset = UIEdgeInsetsMake(0,0,94,0);
    self.tableView.separatorStyle = NO;
    //self.tableView.mj_footer.hidden = YES;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    self.sourceArray = [NSMutableArray array];
    self.manager = [AFHTTPSessionManager manager];
    [self setHeadView];
    self.dataDic = [NSMutableDictionary new];
    [self loadNewData];
   }
- (void)loadNewData
{
    self.startpage = 1;
    [self findInfomationsWithDic:self.dataDic];
 }
- (void)loadMoreData
{
    [self InfomationsWithDic:self.dataDic];
}

- (void)createNewMoreMenuViewWithArray:(NSArray *)array
{
  
self.menuView = [[MoreMenuView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 45) titles:array];
    self.menuView.cornerMarkLocationType = CornerMarkLocationTypeRight;
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    self.shengArray = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        NSLog(@"%@",dic[@"state"]);
        [self.shengArray addObject:dic[@"state"]];
    }
    NSLog(@"%@",self.shengArray);
    self.allshiArray = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        self.shiArray = [NSMutableArray array];
        for (NSDictionary *dic2 in dic[@"cities"]) {
            [self.shiArray addObject:dic2[@"city"]];
        }
        [self.allshiArray addObject:self.shiArray];
    }
    NSArray *infonmationType = @[@"资产包",@"融资信息",@"固定资产",@"企业商账",@"法拍资产",@"个人债权",@"处置公告"];
    
    NSArray *informationTypeID = @[@"1",@"rzxx",@"gdzc",@"18",@"fpzc",@"19",@"czgg"];
    
    
    
    
     NSArray *level = @[@""];
    //资产包
    NSArray *typearray1 = @[@"类型",@"来源"];
    //融资信息
    NSArray *typearray2 = @[@"融资方式"];
    //固定资产
    NSArray *typearray3 = @[@"标的物类型"];
    //企业商账
    NSArray *typearray4 = @[@"处置方式"];
    //法拍资产
    NSArray *typearray5 = @[@"资产类型"];
    //个人债权
    NSArray *typearray6 = @[@"处置方式"];
    
    //处置公告
    NSArray *typearray7 = @[@"类型",@"需求"];
    NSArray *typearray8 = @[@"类型"];
    NSArray *typearray9 = @[@"类型",@"被调查方"];
    NSArray *typearray10 = @[@"类型",@"佣金比例",@"状态"];
    NSArray *typearray11 = @[@"类型"];
    //投资需求
    NSArray *typearray12 = @[@"投资类型",@"投资方式",@"投资期限"];
    
    
    //资产包
    NSArray *Stypearray1 = @[@"抵押",@"信用",@"综合类",@"其他"];
    NSArray *Stypearray2 = @[@"银行",@"非银行机构",@"企业",@"其他"];
    NSMutableArray *zichan = [NSMutableArray new];
    [zichan addObject:Stypearray1];
    [zichan addObject:Stypearray2];
    //融资信息
    NSArray *Stypearray3 = @[@"债权融资",@"股权融资"];
    NSMutableArray *zhaiquan = [NSMutableArray new];
    [zhaiquan addObject:Stypearray3];
    
    //固定资产
    NSArray *Stypearray4 = @[@"土地",@"房产"];
    NSMutableArray *guchan = [NSMutableArray new];
    [guchan addObject:Stypearray4];
    
    //企业商账
    NSArray *Stypearray5 = @[@"诉讼催收",@"非诉讼催收"];
    NSMutableArray *shangye = [NSMutableArray new];
    [shangye addObject:Stypearray5];
    
    //法拍资产
    NSArray *Stypearray6 = @[@"土地",@"房产",@"汽车"];
    NSMutableArray *qiugou = [NSMutableArray new];
    [qiugou addObject:Stypearray6];
    
    //个人债权
    NSArray *Stypearray8 = @[@"诉讼催收",@"非诉讼催收"];
    NSMutableArray *rongzi = [NSMutableArray new];
    [rongzi addObject:Stypearray8];
    
    
    //不需要的删除的。。。。。。。。。。。。。。。。。。。。。。。、、、、、、///////////////
    //法律服务
    NSArray *Stypearray9 = @[@"民事",@"刑事",@"经济",@"公司"];
    NSArray *Stypearray10 = @[@"咨询",@"诉讼",@"其他"];
    NSMutableArray *falv = [NSMutableArray new];
    [falv addObject:Stypearray9];
    [falv addObject:Stypearray10];
    
    //选上信息
    NSArray *Stypearray11 = @[@"找人",@"找财产"];
    NSMutableArray *xuanshang = [NSMutableArray new];
    [xuanshang addObject:Stypearray11];
    
    //进制调查
    NSArray *Stypearray12 = @[@"法律",@"财务",@"税务",@"商业",@"其他"];
    NSArray *Stypearray13 = @[@"企业",@"个人"];
    NSMutableArray *jinzhi = [NSMutableArray new];
    [jinzhi addObject: Stypearray12];
    [jinzhi addObject:Stypearray13];
    //委外催收
    NSArray *Stypearray14 = @[@"个人债权",@"银行贷款",@"企业商账",@"其他"];
    NSArray *Stypearray15 = @[@"5%-15%",@"15%-%30",@"30%-35%",@"50%以上",@"面议"];
    NSArray *Stypearray16 = @[@"已诉",@"未诉"];
    NSMutableArray *weiwai = [NSMutableArray new];
    [weiwai addObject:Stypearray14];
    [weiwai addObject:Stypearray15];
    [weiwai addObject:Stypearray16];
    
    //典当担保
    
    NSArray *Stypearray17 = @[@"典当",@"担保"];
    NSMutableArray *diandang = [NSMutableArray new];
    [diandang addObject:Stypearray17];
    
    //投资需求
    NSArray *Stypearray18 = @[@"个人",@"企业",@"机构",@"其他"];
    NSArray *Stypearray19 = @[@"债权",@"股权",@"其他"];
    NSArray *Stypearray20 = @[@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年"];
    NSMutableArray *touzi = [NSMutableArray new];
    [touzi addObject:Stypearray18];
    [touzi addObject:Stypearray19];
    [touzi addObject:Stypearray20];
    
    NSMutableArray *allTypeArray = [NSMutableArray new];
    
    [allTypeArray addObject:zichan];
    [allTypeArray addObject:zhaiquan];
    [allTypeArray addObject:guchan];
    [allTypeArray addObject:shangye];
    [allTypeArray addObject:qiugou];
    [allTypeArray addObject:rongzi];
    [allTypeArray addObject:falv];
    [allTypeArray addObject:xuanshang];
    [allTypeArray addObject:jinzhi];
    [allTypeArray addObject:weiwai];
    [allTypeArray addObject:diandang];
    [allTypeArray addObject:touzi];
    
    
    self.menuView.indexsOneFist = infonmationType;
    self.menuView.indexsTwoFist = self.shengArray;
    //    menuView.indexsTwoSecond = self.allshiArray;
    self.menuView.indexsThirFist = level;
    //    self.dataDic = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    self.menuView.selectedIndex = ^(NSString *string){
        for (NSString *str in weakSelf.shengArray) {
            if ([str isEqualToString:string]) {
                [weakSelf.dataDic setObject:string forKey:@"ProArea"];
                NSLog(@"得到的数据为%@",string);
                [weakSelf findInfomationsWithDic:weakSelf.dataDic];
            }
        }
        
        //        for (NSArray *arr1 in allTypeArray) {
        //            for (NSArray arr3 in arr1) {
        //                for (NSString *str in arr3) {
        //                    if ([str isEqualToString:string]) {
        //                        [self.dataDic setObject:string forKey:@""];
        //                    }
        //                }
        //            }
        //        }
        //
        //资产包转让
        
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!%@",self.lastChoose);
        if ([self.lastChoose isEqualToString:informationTypeID[0]]) {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
            NSString *substr = [string substringToIndex:2];
            if ([substr isEqualToString:@"类型"]) {
                [self.dataDic removeObjectForKey:@"FromWhere"];
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];
            }
            else if([substr isEqualToString:@"来源"])
            {
                [self.dataDic removeObjectForKey:@"AssetType"];
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"FromWhere"];
                [self findInfomationsWithDic:self.dataDic];
                
            }
        }
        //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[1]])
        {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
            NSString *substr = [string substringFromIndex:2];
            if ([substr isEqualToString:@"方式"])
            {
                NSString *findValue = [string substringFromIndex:2];
                if ([findValue isEqualToString:@"债权"]) {
                    [self.dataDic setObject:@"17" forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                }
                else
                {
                    [self.dataDic setObject:@"6" forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                }
                
            }
            
            
        }
        
        //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[2]])
        {              NSString *substr = [string substringToIndex:2];
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
            
            if ([substr isEqualToString:@"标的"]) {
                
                NSString *findValue = [string substringFromIndex:2];
                if ([findValue isEqualToString:@"土地"]) {
                    [self.dataDic setObject:@"16" forKey:@"TypeID"];
                    
                }
                else
                {
                    [self.dataDic setObject:@"12" forKey:@"TypeID"];
                }
                
                [self findInfomationsWithDic:self.dataDic];
                
            }
            
            
        }
        //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[3]])
        {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
            
            NSString *substr = [string substringToIndex:2];
            if ([substr isEqualToString:@"处置方式"])
            {
                NSString *findValue = [string substringToIndex:2];
                if ([findValue isEqualToString:@"诉讼"]) {
                    [self.dataDic removeObjectForKey:@"UnLaw"];
                    [self.dataDic setObject:@"1" forKey:@"Law"];
                    [self findInfomationsWithDic:self.dataDic];

                }
                else
                {
                    [self.dataDic removeObjectForKey:@"Law"];
                    [self.dataDic setObject:@"1" forKey:@"UnLaw"];
                    [self findInfomationsWithDic:self.dataDic];

                }
            }
            
            
        }
        //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[4]])
        {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
            
            NSString *substr = [string substringToIndex:2];
            if ([substr isEqualToString:@"资产"]) {
                NSString *findValue = [string substringToIndex:2];
                
                if ([findValue isEqualToString:@"土地"]) {
                    [self.dataDic setObject:@"21" forKey:@"TypeID"];
                }
                else if ([findValue isEqualToString:@"房产"])
                {
                    [self.dataDic setObject:@"20" forKey:@"TypeID"];
                }
                else
                {
                    [self.dataDic setObject:@"22" forKey:@"TypeID"];
                }
                [self findInfomationsWithDic:self.dataDic];
            }
            
            
        }
        //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[5]])
        {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
            //类型 求购方
            NSString *substr = [string substringToIndex:4];
            if ([substr isEqualToString:@"处置方式"])
            {
                NSString *findValue = [string substringToIndex:2];
                if ([findValue isEqualToString:@"诉讼"]) {
                    [self.dataDic removeObjectForKey:@"UnLaw"];
                    [self.dataDic setObject:@"1" forKey:@"Law"];
                    [self findInfomationsWithDic:self.dataDic];

                    
                }
                else
                {
                    [self.dataDic removeObjectForKey:@"Law"];
                    [self.dataDic setObject:@"1" forKey:@"UnLaw"];
                    [self findInfomationsWithDic:self.dataDic];

                    
                }
            }
            
        }
        
        //---------------
        for (NSString *sstr in infonmationType) {
            if ([sstr isEqualToString:string]) {
                
                if ([sstr isEqualToString:infonmationType[0]]) {
                    self.dataDic = [NSMutableDictionary new];
                    [self.dataDic setObject:informationTypeID[0] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    NSArray *array = @[infonmationType[0],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray1;
                    self.menuView.indexsThirSecond = zichan;
                    self.lastChoose = informationTypeID[0];
                }
                else if([sstr isEqualToString:infonmationType[1]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    [self.dataDic setObject:informationTypeID[1] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[1],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray2;
                    self.menuView.indexsThirSecond = zhaiquan;
                    self.lastChoose = informationTypeID[1];
                    
                }
                else if([sstr isEqualToString:infonmationType[2]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    
                    [self.dataDic setObject:informationTypeID[2] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[2],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray3;
                    self.menuView.indexsThirSecond = guchan;
                    self.lastChoose = informationTypeID[2];
                }
                else if([sstr isEqualToString:infonmationType[3]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    
                    [self.dataDic setObject:informationTypeID[3] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[3],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray4;
                    self.menuView.indexsThirSecond = shangye;
                    self.lastChoose = informationTypeID[3];
                }
                else if([sstr isEqualToString:infonmationType[4]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    
                    [self.dataDic setObject:informationTypeID[4] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[4],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray5;
                    self.menuView.indexsThirSecond = qiugou;
                    self.lastChoose = informationTypeID[4];
                }
                else if([sstr isEqualToString:infonmationType[5]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    
                    [self.dataDic setObject:informationTypeID[5] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[5],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray6;
                    self.menuView.indexsThirSecond = rongzi;
                    self.lastChoose = informationTypeID[5];
                }
                else if([sstr isEqualToString:infonmationType[6]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    
                    [self.dataDic setObject:informationTypeID[6] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[6],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray7;
                    self.menuView.indexsThirSecond = falv;
                    self.lastChoose = informationTypeID[6];
                }
                else if([sstr isEqualToString:infonmationType[7]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    
                    [self.dataDic setObject:informationTypeID[7] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[7],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray8;
                    self.menuView.indexsThirSecond = xuanshang;
                    self.lastChoose = informationTypeID[7];
                }
                else if([sstr isEqualToString:infonmationType[8]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    
                    [self.dataDic setObject:informationTypeID[8] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[8],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray9;
                    self.menuView.indexsThirSecond = jinzhi;
                    self.lastChoose = informationTypeID[8];
                }
                else if([sstr isEqualToString:infonmationType[9]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    
                    [self.dataDic setObject:informationTypeID[9] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                    NSArray *array = @[infonmationType[9],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray10;
                    self.menuView.indexsThirSecond = weiwai;
                    self.lastChoose = informationTypeID[9];
                }
                //                else if([sstr isEqualToString:infonmationType[10]])
                //                {
                //                    self.dataDic = [NSMutableDictionary new];
                //                    [self.dataDic setObject:informationTypeID[10] forKey:@"TypeID"];
                //                    [self findInfomationsWithDic:self.dataDic];
                //                    NSArray *array = @[infonmationType[10],@"地区",@"更多"];
                //                    [self createNewMoreMenuViewWithArray:array];
                //                    [self.view addSubview:self.menuView];
                //                    self.menuView.indexsThirFist = typearray11;
                //                    self.menuView.indexsThirSecond = diandang;
                //                    self.lastChoose = informationTypeID[10];
                //                }
                else if([sstr isEqualToString:infonmationType[10]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    [self.dataDic setObject:informationTypeID[10] forKey:@"TypeID"];
                    
                    [self findInfomationsWithDic:self.dataDic];
                    NSArray *array = @[infonmationType[10],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray12;
                    self.menuView.indexsThirSecond = touzi;
                    self.lastChoose = informationTypeID[10];
                }
                NSLog(@"得到的数据为%@",string);
                //                [weakSelf findInfomationsWithDic:self.dataDic];
            }
        }
        
        
    };
    
    
}

- (void)setHeadView
{
    NSArray *titles = @[@"信息类型",@"地区",@"更多"];
    MoreMenuView *menuView = [[MoreMenuView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 35) titles:titles];
    menuView.cornerMarkLocationType = CornerMarkLocationTypeRight;
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    self.shengArray = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        NSLog(@"%@",dic[@"state"]);
        [self.shengArray addObject:dic[@"state"]];
    }
    
    NSLog(@"%@",self.shengArray);
    self.allshiArray = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        self.shiArray = [NSMutableArray array];
        
        for (NSDictionary *dic2 in dic[@"cities"]) {
            
            [self.shiArray addObject:dic2[@"city"]];
        }
        [self.allshiArray addObject:self.shiArray];
    }
    
    NSArray *level = @[@""];
    //资产包
    NSArray *typearray1 = @[@"类型",@"来源"];
    //融资信息
    NSArray *typearray2 = @[@"融资方式"];
    //固定资产
    NSArray *typearray3 = @[@"标的物类型"];
    //企业商账
    NSArray *typearray4 = @[@"企业商账"];
    //法拍资产
    NSArray *typearray5 = @[@"资产类型"];
    //个人债权
    NSArray *typearray6 = @[@"处置方式"];
    
    //处置公告
    NSArray *typearray7 = @[@"类型",@"需求"];
    NSArray *typearray8 = @[@"类型"];
    NSArray *typearray9 = @[@"类型",@"被调查方"];
    NSArray *typearray10 = @[@"类型",@"佣金比例",@"状态"];
    NSArray *typearray11 = @[@"类型"];
    //投资需求
    NSArray *typearray12 = @[@"投资类型",@"投资方式",@"投资期限"];
    
    
    //资产包
    NSArray *Stypearray1 = @[@"抵押",@"信用",@"综合类",@"其他"];
    NSArray *Stypearray2 = @[@"银行",@"非银行机构",@"企业",@"其他"];
    NSMutableArray *zichan = [NSMutableArray new];
    [zichan addObject:Stypearray1];
    [zichan addObject:Stypearray2];
    //融资信息
    NSArray *Stypearray3 = @[@"债权融资",@"股权融资"];
    NSMutableArray *zhaiquan = [NSMutableArray new];
    [zhaiquan addObject:Stypearray3];
    
    //固定资产
    NSArray *Stypearray4 = @[@"土地",@"房产"];
    NSMutableArray *guchan = [NSMutableArray new];
    [guchan addObject:Stypearray4];
    
    //企业商账
    NSArray *Stypearray5 = @[@"诉讼催收",@"非诉讼催收"];
    NSMutableArray *shangye = [NSMutableArray new];
    [shangye addObject:Stypearray5];
    
    //法拍资产
    NSArray *Stypearray6 = @[@"土地",@"房产",@"汽车"];
    NSMutableArray *qiugou = [NSMutableArray new];
    [qiugou addObject:Stypearray6];
    
    //个人债权
    NSArray *Stypearray8 = @[@"诉讼催收",@"非诉讼催收"];
    NSMutableArray *rongzi = [NSMutableArray new];
    [rongzi addObject:Stypearray8];
    
    
    //不需要的删除的。。。。。。。。。。。。。。。。。。。。。。。、、、、、、///////////////
    //法律服务
    NSArray *Stypearray9 = @[@"民事",@"刑事",@"经济",@"公司"];
    NSArray *Stypearray10 = @[@"咨询",@"诉讼",@"其他"];
    NSMutableArray *falv = [NSMutableArray new];
    [falv addObject:Stypearray9];
    [falv addObject:Stypearray10];
    
    //选上信息
    NSArray *Stypearray11 = @[@"找人",@"找财产"];
    NSMutableArray *xuanshang = [NSMutableArray new];
    [xuanshang addObject:Stypearray11];
    
    //进制调查
    NSArray *Stypearray12 = @[@"法律",@"财务",@"税务",@"商业",@"其他"];
    NSArray *Stypearray13 = @[@"企业",@"个人"];
    NSMutableArray *jinzhi = [NSMutableArray new];
    [jinzhi addObject: Stypearray12];
    [jinzhi addObject:Stypearray13];
    //委外催收
    NSArray *Stypearray14 = @[@"个人债权",@"银行贷款",@"企业商账",@"其他"];
    NSArray *Stypearray15 = @[@"5%-15%",@"15%-%30",@"30%-35%",@"50%以上",@"面议"];
    NSArray *Stypearray16 = @[@"已诉",@"未诉"];
    NSMutableArray *weiwai = [NSMutableArray new];
    [weiwai addObject:Stypearray14];
    [weiwai addObject:Stypearray15];
    [weiwai addObject:Stypearray16];
    
    //典当担保
    
    NSArray *Stypearray17 = @[@"典当",@"担保"];
    NSMutableArray *diandang = [NSMutableArray new];
    [diandang addObject:Stypearray17];
    
    //投资需求
    NSArray *Stypearray18 = @[@"个人",@"企业",@"机构",@"其他"];
    NSArray *Stypearray19 = @[@"债权",@"股权",@"其他"];
    NSArray *Stypearray20 = @[@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年"];
    
    NSMutableArray *touzi = [NSMutableArray new];
    [touzi addObject:Stypearray18];
    [touzi addObject:Stypearray19];
    [touzi addObject:Stypearray20];
    
    NSMutableArray *allTypeArray = [NSMutableArray new];
    [allTypeArray addObject:zichan];
    [allTypeArray addObject:zhaiquan];
    [allTypeArray addObject:guchan];
    [allTypeArray addObject:shangye];
    [allTypeArray addObject:qiugou];
    [allTypeArray addObject:rongzi];
    [allTypeArray addObject:falv];
    [allTypeArray addObject:xuanshang];
    [allTypeArray addObject:jinzhi];
    [allTypeArray addObject:weiwai];
    [allTypeArray addObject:diandang];
     //投资需求
    [allTypeArray addObject:touzi];
//
//
//    menuView.indexsOneFist = infonmationType;
//    menuView.indexsTwoFist = self.shengArray;
//    //    menuView.indexsTwoSecond = self.allshiArray;
//    menuView.indexsThirFist = level;
    
    NSArray *array = @[@"信息类型",@"地区",@"更多"];
    [self createNewMoreMenuViewWithArray:array];
        [self.view addSubview:self.menuView];
    
    /*
    __weak typeof(self) weakSelf = self;
    
    
    
    //    self.headView = menuView;
    
    self.menuView.selectedIndex = ^(NSString *string){
        for (NSString *str in weakSelf.shengArray) {
            if ([str isEqualToString:string]) {
                [weakSelf.dataDic setObject:string forKey:@"ProArea"];
                NSLog(@"得到的数据为%@",string);
                [weakSelf findInfomationsWithDic:self.dataDic];
                
            }
        }
        //        for (NSArray *arr1 in allTypeArray) {
//            for (NSArray arr3 in arr1) {
//                for (NSString *str in arr3) {
//                    if ([str isEqualToString:string]) {
//                        [self.dataDic setObject:string forKey:@""];
//                    }
//                }
//            }
//        }
//
        //资产包转让
       
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!%@",self.lastChoose);
        if ([self.lastChoose isEqualToString:informationTypeID[0]]) {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
            [self findInfomationsWithDic:self.dataDic];
                    NSString *substr = [string substringToIndex:2];
                if ([substr isEqualToString:@"类型"]) {
                    NSString *findValue = [string substringFromIndex:2];
                    [self.dataDic setObject:findValue forKey:@"AssetType"];
                    [self findInfomationsWithDic:self.dataDic];
                }
                else if([substr isEqualToString:@"资产"]&&[string isEqualToString:@"资产包转让"]==NO)
                {
                    NSString *findValue = [string substringFromIndex:5];
                    [self.dataDic setObject:findValue forKey:@"FromWhere"];
                    [self findInfomationsWithDic:self.dataDic];
                    
                }
        }
        //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[1]])
        {
            NSString *substr = [string substringToIndex:2];

            if ([substr isEqualToString:@"类型"]) {
                [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];
            }
          }
        
         //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[2]])
        {              NSString *substr = [string substringToIndex:2];

            if ([substr isEqualToString:@"类型"]) {
                [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];
            }
            }
         //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[3]])
        {
            NSString *substr = [string substringToIndex:2];
            if ([substr isEqualToString:@"买方"])
            {
                [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
                NSString *findValue = [string substringFromIndex:4];
                [self.dataDic setObject:findValue forKey:@"BuyerNature"];
                [self findInfomationsWithDic:self.dataDic];
            }
        }
         //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[4]])
        {
            NSString *substr = [string substringToIndex:2];
            if ([substr isEqualToString:@"类型"]) {
                [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];
            }
           
        }
         //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[5]])
        {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];

            //类型 求购方
            NSString *Str = [string substringToIndex:2];
            if ([Str isEqualToString:@"类型"]) {
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];

            }
            else if([Str isEqualToString:@"求购"])
            {
                NSString *findValue = [string substringFromIndex:3];
                [self.dataDic setObject:findValue forKey:@"Buyer"];
                [self findInfomationsWithDic:self.dataDic];

            }
        
            
        }
         //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[6]])
        {
            NSString *Str = [string substringToIndex:2];
            if ([Str isEqualToString:@"方式"]) {
                [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];
                
            }
                    }
         //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[7]])
        {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
            NSString *Str = [string substringToIndex:2];
            if ([Str isEqualToString:@"类型"]) {
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];

            }
            else if([Str isEqualToString:@"需求"])
            {
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"Requirement"];
                [self findInfomationsWithDic:self.dataDic];

            }
        
        }
                 //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[8]])
        {
            NSString *Str = [string substringToIndex:2];

            if ([Str isEqualToString:@"类型"]) {
                [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
                [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];
            }
      
        }
         //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[9]])
        {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];

            NSString *Str = [string substringToIndex:2];
            if ([Str isEqualToString:@"类型"]) {
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];

            }
            else if([string isEqualToString:@"被调"])
            {
                NSString *findValue = [string substringFromIndex:4];
                [self.dataDic setObject:findValue forKey:@"Informant"];
                [self findInfomationsWithDic:self.dataDic];

            }
        }
         //---------------
        else if([self.lastChoose isEqualToString:informationTypeID[10]])
        {
            [self.dataDic setObject:self.lastChoose forKey:@"TypeID"];

            NSString *Str = [string substringToIndex:2];
            if ([Str isEqualToString:@"类型"]) {
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"AssetType"];
                [self findInfomationsWithDic:self.dataDic];

            }
            else if([Str isEqualToString:@"佣金"])
            {
                NSString *findValue = [string substringFromIndex:4];
                [self.dataDic setObject:findValue forKey:@"Rate"];
                [self findInfomationsWithDic:self.dataDic];

            }
            else if([Str isEqualToString:@"状态"])
            {
                NSString *findValue = [string substringFromIndex:2];
                [self.dataDic setObject:findValue forKey:@"Status"];
                [self findInfomationsWithDic:self.dataDic];

            }
        }
         for (NSString *sstr in infonmationType) {
            if ([sstr isEqualToString:string]) {
                
                if ([sstr isEqualToString:infonmationType[0]]) {
                    self.dataDic = [NSMutableDictionary new];
                    [self.dataDic setObject:informationTypeID[0] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    NSArray *array = @[infonmationType[0],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray1;
                    self,menuView.indexsThirSecond = zichan;
                    

                    self.lastChoose = informationTypeID[0];
                }
                else if([sstr isEqualToString:infonmationType[1]])
                {
                    self.dataDic = [NSMutableDictionary new];
                    [self.dataDic setObject:informationTypeID[1] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[1],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray2;
                    self.menuView.indexsThirSecond = zhaiquan;
                    self.lastChoose = informationTypeID[1];
                    
                }
                else if([sstr isEqualToString:infonmationType[2]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[2] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[2],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray3;
                    self.menuView.indexsThirSecond = guchan;
                    self.lastChoose = informationTypeID[2];
                }
                else if([sstr isEqualToString:infonmationType[3]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[3] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[3],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray4;
                    self.menuView.indexsThirSecond = shangye;
                    self.lastChoose = informationTypeID[3];
                }
                else if([sstr isEqualToString:infonmationType[4]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[4] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[4],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray5;
                    self.menuView.indexsThirSecond = qiugou;
                    self.lastChoose = informationTypeID[4];
                }
                else if([sstr isEqualToString:infonmationType[5]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[5] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[5],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray6;
                    self.menuView.indexsThirSecond = rongzi;
                    self.lastChoose = informationTypeID[5];
                }
                else if([sstr isEqualToString:infonmationType[6]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[6] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[6],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray7;
                    self.menuView.indexsThirSecond = falv;
                    self.lastChoose = informationTypeID[6];
                }
                else if([sstr isEqualToString:infonmationType[7]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[7] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[7],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray8;
                    self.menuView.indexsThirSecond = xuanshang;
                    self.lastChoose = informationTypeID[7];
                }
                else if([sstr isEqualToString:infonmationType[8]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[8] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[8],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray9;
                    self.menuView.indexsThirSecond = jinzhi;
                    self.lastChoose = informationTypeID[8];
                }
                else if([sstr isEqualToString:infonmationType[9]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[9] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];

                    NSArray *array = @[infonmationType[9],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray10;
                    self.menuView.indexsThirSecond = weiwai;
                    self.lastChoose = informationTypeID[9];
                }
                else if([sstr isEqualToString:infonmationType[10]])
                {
                    self.dataDic = [NSMutableDictionary new];

                    [self.dataDic setObject:informationTypeID[10] forKey:@"TypeID"];
                    [self findInfomationsWithDic:self.dataDic];
                    NSArray *array = @[infonmationType[10],@"地区",@"更多"];
                    [self createNewMoreMenuViewWithArray:array];
                    [self.view addSubview:self.menuView];
                    self.menuView.indexsThirFist = typearray11;
                    self.menuView.indexsThirSecond = diandang;
                    self.lastChoose = informationTypeID[10];
                }
                NSLog(@"得到的数据为%@",string);
//                [weakSelf findInfomationsWithDic:self.dataDic];
            }
        }
        
        
    };
    */
    
}
- (void)findInfomationsWithDic:(NSMutableDictionary *)dataDic
{
    if (self.dataDic[@"Vip"] == nil)
    {
        [self.dataDic setObject:self.vipStr forKey:@"Vip"];
    }
    if ([dataDic[@"TypeID"] isEqualToString:@"czgg"])
    {
        self.dataDic[@"Vip"] = @"";
        
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    self.startpage = 1;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    self.HUD.delegate = self;
    //    self.HUD.mode = MBProgressHUDModeIndeterminate;
//    if (self.sourceArray != nil)
//    {
//        [self.sourceArray removeAllObjects];
//    }
    self.sourceArray = [NSMutableArray new];
    //    NSString *getURL = @"http://api.ziyawang.com/v1/project/list?access_token=token";
    //    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    //    getdic = self.dataDic;
    //
    //    NSString *access_token = @"token";
    //
    //    [getdic setObject:access_token forKey:@"access_token"];
    //    NSString *starPage = [NSString stringWithFormat:@"%ld",self.startpage];
    NSString *getURL = FindInformationURL;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token != nil) {
        getURL = [[getURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    }
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    getdic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
    NSString *access_token = @"token";
    NSString *startPage = [NSString stringWithFormat:@"%ld",self.startpage];
    [getdic setObject:startPage forKey:@"startpage"];
    
    [getdic setObject:access_token forKey:@"access_token"];
    NSLog(@"------getdic%@",getdic[@"AssetType"]);
    NSLog(@"!!!!!!!!!%@",getdic);
    //    [getdic setObject:@"5" forKey:@"pagecount"];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"--------%@",dic);
        
        NSArray *array = dic[@"data"];
        for (NSDictionary *dic in array) {
            self.model = [[PublishModel alloc]init];
            [self.model setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:self.model];
        }
        if (self.sourceArray.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
        //判断count=0告诉用户没有相关信息
        self.startpage ++;
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        //        [self.HUD removeFromSuperViewOnHide];
        //        [self.HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        [HUD hideAnimated:YES];
        
        //        [self.HUD removeFromSuperViewOnHide];
        //        [self.HUD hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求信息失败，请检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [HUD removeFromSuperViewOnHide];
        [HUD hideAnimated:YES];
        //        [self.HUD removeFromSuperViewOnHide];
        //        [self.HUD hideAnimated:YES];
        
    }];
}


- (void)InfomationsWithDic:(NSMutableDictionary *)dataDic
{
    
    NSString *getURL =FindInformationURL;
                       
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];

    if (token != nil) {
        getURL = [[getURL stringByAppendingString:@"?token="]stringByAppendingString:token];
        
    }

    NSLog(@"%@",getURL);
    
    NSMutableDictionary *getdic = [NSMutableDictionary dictionary];
    getdic = self.dataDic;
    NSString *access_token = @"token";
    [getdic setObject:access_token forKey:@"access_token"];
    NSString *starPage = [NSString stringWithFormat:@"%ld",self.startpage];
    [getdic setObject:starPage forKey:@"startpage"];
//    [getdic setObject:@"5" forKey:@"pagecount"];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.manager GET:getURL parameters:getdic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.startpage ++;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *array = [NSMutableArray new];

        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *sourceArray = dic[@"data"];
        for (NSDictionary *dic in sourceArray) {
            
            PublishModel *model = [[PublishModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [array addObject:model];
        }
        
        if (array.count == 0) {
//            [self.tableView.mj_footer resetNoMoreData];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer endRefreshing];

        }
      
        else
        {
        [self.sourceArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//这两个代理方法必须同时存在才起作用
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
//    self.headView.backgroundColor = [UIColor whiteColor];
//    
//    return self.headView;
//    
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishModel *model = [[PublishModel alloc]init];
    
    model = self.sourceArray[indexPath.row];
    model.TypeID = [NSString stringWithFormat:@"%@",model.TypeID];

//    if ([model.TypeID isEqualToString:@"1"]||[model.TypeID isEqualToString:@"12"]) {
//        return 135;
//    }
//    
//    else
//    {
//        return 115;
//    }

    
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 125;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 115;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 115;
    }
    
    return 115;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PublishModel *model = [[PublishModel alloc]init];
    model = self.sourceArray[indexPath.row];
    model.TypeID = [NSString stringWithFormat:@"%@",model.TypeID];
    if ([model.TypeID isEqualToString:@"99"]) {
        ChuzhiCell *cell2 = [self.tableView dequeueReusableCellWithIdentifier:@"ChuzhiCell" forIndexPath:indexPath];

        cell2.model = self.sourceArray[indexPath.row];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell2;
    }
    
    else
    {
       NewPublishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewPublishCell" forIndexPath:indexPath];

         cell.model = self.sourceArray[indexPath.row];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

//    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailOfInfoController *infoDetailsVC = [[DetailOfInfoController alloc]init];
    
    ChuzhiDetailController *chuzhiVC = [[ChuzhiDetailController alloc]init];
    PublishModel *model = [[PublishModel alloc]init];
    model = self.sourceArray[indexPath.row];
    
    infoDetailsVC.ProjectID = model.ProjectID;
    infoDetailsVC.userid = [NSString stringWithFormat:@"%@",model.UserID];
    NSLog(@"!!!!!!!!!!!!!!!!!!!!USErid:%@",model.UserID);
    infoDetailsVC.targetID = [NSString stringWithFormat:@"%@",model.UserID];
    infoDetailsVC.typeName = model.TypeName;
    
    self.selectTypeName = model.TypeName;
    
    
    self.infoDetailsVC = infoDetailsVC;

    
    
   NSArray *TypeIDArray = [self.right componentsSeparatedByString:@","];
    for (NSString *typeID in TypeIDArray) {
        if ([model.TypeID isEqualToString:typeID]) {
            [self.navigationController pushViewController:infoDetailsVC animated:YES];
            return;
        }
    }
    
    model.Hide = [NSString stringWithFormat:@"%@",model.Hide];
    
if ([model.Member isEqualToString:@"1"] && [model.Hide isEqualToString:@"0"]) {
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token == nil) {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }
        else if ([self.role isEqualToString:@"1"])
        {
            [self setPromiseView];
        }
        else
        {
            [self ShowAlertViewControllerWithMessage:@"您需要先通过服务方认证才可查看VIP类信息"];
        }
    }
    else
    {
        
        
        
    if ([model.TypeID isEqualToString:@"99"]) {
        [self.navigationController pushViewController:chuzhiVC animated:YES];
        chuzhiVC.NewsID = model.NewsID;
    }
    else
    {
    self.pubModel = model;
        
      
    model.Member = [NSString stringWithFormat:@"%@",model.Member];
    
    if ([self.USERID isEqualToString:model.UserID])
    {
        [self.navigationController pushViewController:infoDetailsVC animated:YES];
        return;
    }
    
    if ([model.Member isEqualToString:@"2"] == NO)
    {
        [self.navigationController pushViewController:infoDetailsVC animated:YES];
    }
    else
    {
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        if (token == nil)
        {
            NSLog(@"未登录,提示登录");
            LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
            [self presentViewController:loginVC animated:YES completion:nil];
        }
        else if([self.role isEqualToString:@"1"])
        {
            self.pubModel.PayFlag = [NSString stringWithFormat:@"%@",self.pubModel.PayFlag];
            if ([self.pubModel.Member isEqualToString:@"2"] == NO )
            {
                //                    if([self.pubModel.PayFlag isEqualToString:@"1"]== NO)
                //                    {
                //                        [self payForMessage];
                //                    }
                [self.navigationController pushViewController:infoDetailsVC animated:YES];
            }
            else
            {
                NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
                NSString *URL = IfHadPayMessageURL;
                if (token != nil) {
                    URL = [[URL stringByAppendingString:@"?token="]stringByAppendingString:token];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:@"token" forKey:@"access_token"];
                    [dic setObject:self.pubModel.ProjectID forKey:@"ProjectID"];
                    
                    [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                        if ([dic[@"status_code"] isEqualToString:@"200"]) {
                            self.pubModel.PayFlag = dic[@"PayFlag"];
                            self.pubModel.PayFlag = [NSString stringWithFormat:@"%@",self.pubModel.PayFlag];
                            
                            
                            if ([self.pubModel.PayFlag isEqualToString:@"1"] == NO)
                            {
                                [self createViewForLessMoney];
                            }
                            else
                            {
                                [self.navigationController pushViewController:infoDetailsVC animated:YES];
                            }
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络状况" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                    }];
                    
                }
                
                
                
                
            }
        }
        
        
        
        else if([self.role isEqualToString:@"0"]||[self.role isEqualToString:@"2"])
        {
            if([self.pubModel.TypeName isEqualToString:@"投资需求"] || [self.pubModel.TypeName isEqualToString:@"资产求购"])
            {
                [self.navigationController pushViewController:infoDetailsVC animated:YES];
                
            }
            else
            {
                [self ShowAlertViewControllerWithMessage:@"您需要先通过服务方认证才可查看收费类信息"];
            }
        }
        
        
    }
    
    }
    }
    
   
}

- (void)payForMessage
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    [dataDic setObject:@"token" forKey:@"access_token"];
    [dataDic setObject:self.pubModel.ProjectID forKey:@"ProjectID"];
    NSString *URL = [[paidURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSLog(@"-----%@",URL);
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager POST:URL parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSString *status_code = dic[@"status_code"];
         if ([status_code isEqualToString:@"417"]) {
             NSLog(@"已支付");
         }
         else if ([status_code isEqualToString:@"418"])
         {
             NSLog(@"余额不足");
             [self MBProgressWithString:@"余额不足，请充值！" timer:2 mode:MBProgressHUDModeText];
         }
         else if ([status_code isEqualToString:@"416"])
         {
             NSLog(@"非收费信息");
         }
         else if ([status_code isEqualToString:@"200"])
         {
             [self.blackBackView1 removeFromSuperview];
             [self.alertView1 removeFromSuperview];
             [self.blackBackView2 removeFromSuperview];
             [self.alertView2 removeFromSuperview];
             
             NSLog(@"支付成功");
             self.pubModel.PayFlag = @"1";
             
             [self.navigationController pushViewController:self.infoDetailsVC animated:YES];
     
           
             //             [self.connectButton setTitle:@"已约谈" forState:(UIControlStateNormal)];
             [self.blackBackView2 removeFromSuperview];
             [self.alertView2 removeFromSuperview];
         }
         [self.HUD removeFromSuperViewOnHide];
         [self.HUD hideAnimated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         
     }];
    
}


- (void)ShowAlertViewControllerWithMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        MyidentifiController *identifiVC = [[MyidentifiController alloc]init];
        identifiVC.ConnectPhone = self.userModel.ConnectPhone;
        identifiVC.ServiceName = self.userModel.ServiceName;
        identifiVC.ServiceLocation = self.userModel.ServiceLocation;
        identifiVC.ServiceType = self.userModel.ServiceType;
        identifiVC.ServiceIntroduction = self.userModel.ServiceIntroduction;
        identifiVC.ConnectPerson = self.userModel.ConnectPerson;
        identifiVC.ServiceArea = self.userModel.ServiceArea;
        identifiVC.ConfirmationP1 = self.userModel.ConfirmationP1;
        identifiVC.ConfirmationP2 = self.userModel.ConfirmationP2;
        identifiVC.ConfirmationP3 = self.userModel.ConfirmationP3;
        identifiVC.ViewType = @"服务";
        identifiVC.RegTime = self.userModel.RegTime;
        identifiVC.Founds = self.userModel.Founds;
        identifiVC.Size = self.userModel.Size;
        
        identifiVC.role = self.role;
        [self.navigationController pushViewController:identifiVC animated:YES];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)createViewForLessMoney
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 30, self.view.bounds.size.width - 40, 70)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIView *blackBackview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [blackBackview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    UITapGestureRecognizer *blackBackViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackBackTapAction1:)];
    [blackBackview addGestureRecognizer:blackBackViewTapGesture];
    
    UIView *alertView  = [[UIView alloc]initWithFrame:CGRectMake(44 * kWidthScale, 69 * kHeightScale, 288 * kWidthScale , 400 * kHeightScale)];
    [alertView setBackgroundColor:[UIColor whiteColor]];
    
    
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertView.bounds.size.width, alertView.bounds.size.height/2)];
    yellowView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    [alertView addSubview:yellowView];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(30, 24*kHeightScale, 98 * kWidthScale, 98 * kWidthScale)];
    CGRect frame = imageview.frame;
    frame.size = CGSizeMake(98 * kWidthScale, 98 * kWidthScale);
    imageview.frame = frame;
    CGPoint center = imageview.center;
    center.x = alertView.frame.size.width/2;
    imageview.center = center;
    
    //           imageview.centerX = self.view.bounds.size.width/2;
    imageview.image = [UIImage imageNamed:@"yuetan-popup-logo"];
    [yellowView addSubview:imageview];
    
    UILabel *resourceType = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*kHeightScale + 98 * kWidthScale + 20  *kHeightScale, alertView.bounds.size.width, 20)];
    resourceType.text = @"该信息为收费资源";
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*kHeightScale + 98 * kWidthScale + 20 *kHeightScale +25 * kHeightScale, alertView.bounds.size.width, 20)];
    textLabel.text = @"消耗芽币可查看详细信息";
    resourceType.font = [UIFont systemFontOfSize:20];
    textLabel.font = [UIFont systemFontOfSize:15];
    resourceType.textAlignment = NSTextAlignmentCenter;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [yellowView addSubview:resourceType];
    [yellowView addSubview:textLabel];
    
    CGFloat Height = yellowView.bounds.size.height;
    UIImageView *smallImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(30*kWidthScale, Height + 20*kHeightScale, 20, 20)];
    smallImage1.image = [UIImage imageNamed:@"yuetan-goldcoin"];
    
    UILabel *xiaohaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + 20, 150, 100, 20)];
    CGSize labelSize1 = [@"消耗：" sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    xiaohaoLabel.frame = CGRectMake(30*kWidthScale + 36*kWidthScale, Height + 20*kHeightScale, labelSize1.width,20);
    xiaohaoLabel.text = @"消耗：";
    
    CGSize labelSize2 = [self.pubModel.Price sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width,Height + 20*kHeightScale,labelSize2.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label1.numberOfLines = 0;
    label1.text = self.pubModel.Price;
    label1.font = [UIFont systemFontOfSize:20];
    label1.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    UILabel *yabiLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize1.width + labelSize2.width, Height + 20*kHeightScale, 40, 20)];
    yabiLabel1.text = @"芽币";
    
    UIImageView *smallImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(30*kWidthScale, Height + 20*kHeightScale + 32 * kHeightScale, 20, 20)];
    smallImage2.image = [UIImage imageNamed:@"yuetan-goldcoin"];
    
    UILabel *xiaohaoLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + 20 , 150+32, 100, 20)];
    CGSize labelSize11 = [@"余额：" sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    
    xiaohaoLabel2.frame = CGRectMake(30*kWidthScale + 36*kWidthScale, Height + 20*kHeightScale + 32* kHeightScale, labelSize1.width,20);
    xiaohaoLabel2.text = @"余额：";
    CGSize labelSize22 = [self.account sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width,Height + 20*kHeightScale + 32* kHeightScale,labelSize22.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    label2.numberOfLines = 0;
    label2.text = self.account;
    label2.font = [UIFont systemFontOfSize:20];
    
    label2.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    //   self.AccountLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width,Height + 20*kHeightScale + 32* kHeightScale,labelSize22.width,20)];//这个frame是初设的，没关系，后面还会重新设置其size。
    //    self.AccountLabel1.numberOfLines = 0;
    //    self.AccountLabel1.text = self.model.Account;
    //    self.AccountLabel1.font = [UIFont systemFontOfSize:20];
    //
    //    self.AccountLabel1.textColor = [UIColor colorWithHexString:@"#ff9000"];
    
    
    UILabel *yabiLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width + labelSize22.width, Height + 20*kHeightScale+32* kHeightScale, 40, 20)];
    
    
    yabiLabel2.text = @"芽币";
    
    UILabel *buzuLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*kWidthScale + 36*kWidthScale + labelSize11.width + labelSize22.width + 40,  Height + 20*kHeightScale+32* kHeightScale, 100, 20)];
    if (self.account.integerValue < self.pubModel.Price.integerValue)
    {
        buzuLabel.text = @"(余额不足)";
    }
    buzuLabel.font = [UIFont systemFontOfSize:11];
    
    self.buzuLabel = buzuLabel;
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setFrame:CGRectMake(alertView.bounds.size.width - 30 * kWidthScale, 10 *kWidthScale, 20 * kWidthScale, 20 * kWidthScale)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    cancelButton.tag = 1;
    [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [sureButton setFrame:CGRectMake(26*kWidthScale, Height + 20*kHeightScale+32* kHeightScale + 20*kHeightScale + 20 * kHeightScale, alertView.bounds.size.width - 52 * kWidthScale, 40 * kHeightScale)];
    [sureButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    sureButton.tag = 3;
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *rechargeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rechargeButton setFrame:CGRectMake(26*kWidthScale, Height + 20*kHeightScale+32* kHeightScale + 20*kHeightScale+12*kHeightScale+40*kHeightScale+ 20 * kHeightScale, alertView.bounds.size.width - 52 * kWidthScale, 40 * kHeightScale)];
    [rechargeButton setBackgroundColor:[UIColor whiteColor]];
    [rechargeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [rechargeButton setTitle:@"充值" forState:(UIControlStateNormal)];
    
    rechargeButton.layer.borderWidth = 2.5;
    rechargeButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    [rechargeButton addTarget:self action:@selector(rechareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [alertView addSubview:smallImage1];
    [alertView addSubview:xiaohaoLabel];
    [alertView addSubview:label1];
    [alertView addSubview:yabiLabel1];
    [alertView addSubview:smallImage2];
    [alertView addSubview:xiaohaoLabel2];
    [alertView addSubview:label2];
    [alertView addSubview:yabiLabel2];
    [alertView addSubview:buzuLabel];
    [alertView addSubview:cancelButton];
    [alertView addSubview:sureButton];
    [alertView addSubview:rechargeButton];
    
    self.blackBackView1 = blackBackview;
    self.alertView1 = alertView;
    self.alertView1 = alertView;
    [self.view addSubview:self.blackBackView1];
    [self.view addSubview:self.alertView1];
    
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
    .heightIs(360 * kHeightScale);
    
    
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
    label1.text = @"温馨提示";
    
    label2.sd_layout.leftSpaceToView(bottomView,15)
    .rightSpaceToView(bottomView,15)
    .topSpaceToView(label1,15)
    .autoHeightRatio(0);
    
    label2.text = [[@"本条VIP信息只针对"stringByAppendingString:self.selectTypeName]stringByAppendingString:@"类型会员免费开放，详情请咨询会员专线：010-56052557"];

//    label2.text = @"本条VIP信息只针对本类型会员免费开放，开通相应类型会员后即可查看";
    label2.font = [UIFont systemFontOfSize:13];
    
    fabuButton.sd_layout.leftEqualToView(label2)
    .rightEqualToView(label2)
    .topSpaceToView(label2,30*kHeightScale)
    .heightIs(40*kHeightScale);
    [fabuButton setTitle:@"去开通" forState:(UIControlStateNormal)];
    fabuButton.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    
    UIButton *kaitongButton = [UIButton new];
    [bottomView addSubview:kaitongButton];
    [kaitongButton setTitle:@"取消" forState:(UIControlStateNormal)];
    kaitongButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    kaitongButton.backgroundColor = [UIColor whiteColor];
    kaitongButton.layer.borderWidth = 1;
    kaitongButton.sd_layout.leftEqualToView(fabuButton)
    .rightEqualToView(fabuButton)
    .topSpaceToView(fabuButton,20*kHeightScale)
    .heightIs(40*kHeightScale);
    [kaitongButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [kaitongButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [kaitongButton addTarget:self action:@selector(didClickfabuFabuAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    //    fanhuiButton.sd_layout.leftEqualToView(label2)
    //    .rightEqualToView(label2)
    //    .topSpaceToView(fabuButton,20)
    //    .heightIs(40*kHeightScale);
    //    fanhuiButton.layer.borderWidth = 1.5;
    //    fanhuiButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    
    
    cancelButton.sd_layout.rightSpaceToView(imageBackView,10)
    .topSpaceToView(imageBackView,10)
    .heightIs(25)
    .widthIs(25);
    
    
    
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"popup-cuowu"] forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(CancelAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //    [fanhuiButton setTitle:@"不承诺" forState:(UIControlStateNormal)];
    //    [fanhuiButton addTarget:self action:@selector(didClickFanhuiButtonAction2:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [fabuButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [fanhuiButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [fabuButton addTarget:self action:@selector(kaitongButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //    self.weituoView = weituoView;
    weituoView.layer.cornerRadius = 10;
    weituoView.layer.masksToBounds = YES;
    self.PromiseView = mengbanView;
    //    [self.PromiseView setHidden:YES];
    
    
}
- (void)kaitongButtonAction:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
    VipViewController *vipRVC = [[VipViewController alloc]init];
    
    [self.navigationController pushViewController:vipRVC animated:YES];
    
    
}
- (void)CancelAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
}

- (void)didClickfabuFabuAction2:(UIButton *)button
{
    [self.PromiseView removeFromSuperview];
    
}

- (void)blackBackTapAction1:(UITapGestureRecognizer *)gesture
{
    [self.alertView1 removeFromSuperview];
    [self.blackBackView1 removeFromSuperview];
}
- (void)blackBackTapAction2:(UITapGestureRecognizer *)gesture
{
    [self.alertView2 removeFromSuperview];
    [self.blackBackView2 removeFromSuperview];
}
- (void)didClickCancelButton:(UIButton *)button
{
    if (button.tag == 1) {
        [self.alertView1 removeFromSuperview];
        [self.blackBackView1 removeFromSuperview];
    }
    else
    {
        [self.alertView2 removeFromSuperview];
        [self.blackBackView2 removeFromSuperview];
    }
    
}
- (void)sureButtonAction:(UIButton *)button
{
    if(self.pubModel.Price.integerValue > self.account.integerValue)
    {
        [self MBProgressWithString:@"余额不足，请充值！" timer:2 mode:MBProgressHUDModeText];
    }
    else
    {
        
        [self payForMessage];
    }
    
}
- (void)rechareButtonAction:(UIButton *)button
{
    //    MyYabiController *yabiVC = [[MyYabiController alloc]init];
    RechargeController *rechargeVC = [[RechargeController alloc]init];
    
    [self.blackBackView1 removeFromSuperview];
    [self.alertView1 removeFromSuperview];
    [self.blackBackView2 removeFromSuperview];
    [self.alertView2 removeFromSuperview];
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
}

@end
