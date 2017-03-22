//
//  PushViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/1.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PushViewController.h"
#import "PushViewCell.h"
#import "PushStartController.h"
#import "LoginController.h"
#import "UserInfoModel.h"


#import "CarFapaiController.h"
#import "PersonalDebtsController.h"
#import "ProDuctController.h"
#import "BusinessAccountController.h"
#import "FinanCingController.h"
#import "AssetPackController.h"


#import "MyidentifiController.h"
@interface PushViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UserInfoModel *userModel;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation PushViewController

- (void)setUpNav
{
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_left_jt"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
//    [backItem setBackgroundImage:[UIImage imageNamed:@"icon_left_jt"] forState:(UIControlStateNormal) barMetrics:UIBarMetricsDefault];
    
//    self.navigationItem.leftBarButtonItem = backItem;
    
self.navigationItem.title = @"发布";
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
    
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton addTarget:self action:@selector(pop) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *buttonimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6, 10, 18)];
    buttonimage.image = [UIImage imageNamed:@"back3"];
    UILabel *buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 45, 20)];
    buttonLabel.text = @"返回";
    buttonLabel.font = [UIFont systemFontOfSize:15];
    
    [leftButton addSubview:buttonimage];
    [leftButton addSubview:buttonLabel];
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(pop)];
    
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    
}


- (void)pop
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setUpNav];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.userModel = [[UserInfoModel alloc]init];
    [self getUserInfoFromDomin];

    
    self.imageArray = [NSMutableArray array];
    NSArray *imageNameArray = [NSArray new];
    imageNameArray = @[@"bao",@"rong",@"gu",@"qiye",@"fapai",@"gerenzhaiquan"];
   
        for (int i = 1; i < 7; i++)
        {
            NSString *name = [NSString stringWithFormat:@"%d",i];
            
//        NSString *name = @"fabu2";
            UIImage *image = [UIImage imageNamed:imageNameArray[i-1]];
            
//            UIImage *image = [UIImage imageNamed:name];
            [self.imageArray addObject:image];
            NSLog(@"********************************%@",self.imageArray);
                 //NSLog(@"%@",self.imageArray);
        }

        NSArray *array = @[@"资产包",@"融资信息",@"固定资产",@"企业商账",@"法拍资产",@"个人债权"];
    self.nameArray = [NSMutableArray arrayWithArray:array];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置itemSize
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width - 80)/3, (self.view.bounds.size.width - 80)/3);
    //最小的行间距
    // flowLayout.minimumLineSpacing = 20;
    //item间距
    //  flowLayout.minimumInteritemSpacing = 20;
    //滚动方向
    // flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //分区头
    //    flowLayout.headerReferenceSize = CGSizeMake(40,40);
    //    flowLayout.footerReferenceSize = CGSizeMake(60, 60);
    //设置分区编剧
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    //创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    //设置数据源和代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    //给view加个背景色
    collectionView.backgroundColor = [UIColor whiteColor];
    //注册collectionViewcell注册到重用池
    //    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    [collectionView registerNib:[UINib nibWithNibName:@"PushViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    //注册分区头
    //    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    //注册分区尾
    //    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    [self.view addSubview:collectionView];
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
            NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",dic);
            [self.userModel setValuesForKeysWithDictionary:dic[@"user"]];
            [self.userModel setValuesForKeysWithDictionary:dic[@"service"]];
            NSLog(@"%@",dic[@"role"]);
            //            self.role =dic[@"role"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"获取用户信息失败");
        }];
    }
}


//分区数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个分区的item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nameArray.count;
    
}
//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PushViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSLog(@"%ld",(long)indexPath.item);
    cell.typeNameLable.text = self.nameArray[indexPath.row];
    cell.imageVeiw.image = self.imageArray[indexPath.row];
    [cell.imageVeiw setContentScaleFactor:[[UIScreen mainScreen] scale]];
    cell.imageVeiw.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageVeiw.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSFileManager *fieManager = [NSFileManager defaultManager];
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",urlStr);
    NSString *fileName = @"lll.wav";
    NSString *urlpath = [urlStr stringByAppendingPathComponent:fileName];
    BOOL ifHave = [[NSFileManager defaultManager]fileExistsAtPath:urlpath];
    if (!ifHave) {
        NSLog(@"不存在语音");
    }
    else
    {
        NSLog(@"存在语音");
        BOOL blDele= [fieManager removeItemAtPath:urlpath error:nil];
        if (blDele) {
            NSLog(@"删除语音成功");
        }else {
            NSLog(@"删除语音失败");
        }
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"0"];
    [defaults removeObjectForKey:@"1"];
    [defaults removeObjectForKey:@"2"];
    [defaults removeObjectForKey:@"3"];
    [defaults removeObjectForKey:@"4"];
    [defaults removeObjectForKey:@"企业所在"];
    
    [defaults setObject:@"请选择" forKey:@"金额"];
    [defaults setObject:@"请选择" forKey:@"折扣"];
    NSString *isLogin = [defaults objectForKey:@"登录状态"];
    NSLog(@"***************登录状态：%@",isLogin);
    NSLog(@"选中 section:%ld,item:%ld",indexPath.section,indexPath.item);
    PushStartController *PusVc = [[UIStoryboard storyboardWithName:@"Publish" bundle:nil] instantiateViewControllerWithIdentifier:@"PushStartController"];
//    NSArray *infonmationType = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"固产求购",@"融资借贷",@"法律服务",@"悬赏信息",@"尽职调查",@"委外催收",@"典当担保"];
//    NSArray *level = @[@"VIP1"];
    CarFapaiController *carVC = [[CarFapaiController alloc]init];
    PersonalDebtsController *PersonVC = [[PersonalDebtsController alloc]init];
    ProDuctController *proVC = [[ProDuctController alloc]init];
    BusinessAccountController *busVC = [[BusinessAccountController alloc]init];
    FinanCingController *finaVC = [[FinanCingController alloc]init];
    AssetPackController *asetVC = [[AssetPackController alloc]init];
    
    
    
    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
    
    NSArray *TypeID = @[@"01",@"14",@"12",@"04",@"13",@"06",@"03",@"09",@"10",@"02",@"15"];
    
    switch (indexPath.row) {
        case 0:
//            PusVc.typeName = @"资产包转让";
//            PusVc.TypeID = TypeID[0];
            if ([isLogin isEqualToString:@"已登录"]) {
                //        [self.navigationController pushViewController:PusVc animated:YES];
                [self.navigationController pushViewController:asetVC animated:YES];
                
            }
            else
            {
                LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                [self presentViewController:loginVC animated:YES completion:nil];
            }

            
            break;
        case 1:
//            PusVc.typeName = @"债权转让";
//            PusVc.TypeID = TypeID[1];
            if ([isLogin isEqualToString:@"已登录"]) {
                //        [self.navigationController pushViewController:PusVc animated:YES];
                [self.navigationController pushViewController:finaVC animated:YES];
                
            }
            else
            {
                LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                [self presentViewController:loginVC animated:YES completion:nil];
            }


            break;
        case 2:
//            PusVc.typeName = @"固产转让";
//            PusVc.TypeID = TypeID[2];
            if ([isLogin isEqualToString:@"已登录"]) {
                //        [self.navigationController pushViewController:PusVc animated:YES];
                [self.navigationController pushViewController:proVC animated:YES];
                
            }
            else
            {
                LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                [self presentViewController:loginVC animated:YES completion:nil];
            }


            break;
        case 3:
//            PusVc.typeName = @"商业保理";
//            PusVc.TypeID = TypeID[3];
            if ([isLogin isEqualToString:@"已登录"]) {
                //        [self.navigationController pushViewController:PusVc animated:YES];
                [self.navigationController pushViewController:busVC animated:YES];
                
            }
            else
            {
                LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                [self presentViewController:loginVC animated:YES completion:nil];
            }


            break;
        case 4:
        {
            if ([isLogin isEqualToString:@"已登录"]) {
                //        [self.navigationController pushViewController:PusVc animated:YES];
                [self.navigationController pushViewController:carVC animated:YES];
                
            }
            else
            {
                LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                [self presentViewController:loginVC animated:YES completion:nil];
            }

        }
            
            break;
        case 5:
//            PusVc.typeName = @"融资需求";
//            PusVc.TypeID = TypeID[5];
            if ([isLogin isEqualToString:@"已登录"]) {
                //        [self.navigationController pushViewController:PusVc animated:YES];
                [self.navigationController pushViewController:PersonVC animated:YES];
                
            }
            else
            {
                LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            break;
        default:
            break;
    }
   
//    
//    if ([isLogin isEqualToString:@"已登录"]) {
////        [self.navigationController pushViewController:PusVc animated:YES];
//        [self.navigationController pushViewController:asetVC animated:YES];
//        
//    }
//    else
//    {
//        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
//        [self presentViewController:loginVC animated:YES completion:nil];
//    }
    
//    [self presentViewController:PusVc animated:YES completion:nil];
}

- (void)ShowAlertViewController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要先通过服务方认证才可以发布此类信息" preferredStyle:UIAlertControllerStyleAlert];
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
        NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
        identifiVC.role = role;
        [self.navigationController pushViewController:identifiVC animated:YES];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
    
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
