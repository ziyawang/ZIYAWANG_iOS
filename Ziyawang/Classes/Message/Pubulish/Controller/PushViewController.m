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
@interface PushViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) NSMutableArray *imageArray;


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
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(pop)];
    
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
    
    
    self.imageArray = [NSMutableArray array];
    NSArray *imageNameArray = [NSArray new];
    imageNameArray = @[@"1",@"2",@"3",@"4",@"11",@"6",@"10",@"7",@"9",@"8",@"13"];
    
        for (int i = 1; i < 12; i++)
        {
            NSString *name = [NSString stringWithFormat:@"%d",i];
            
//        NSString *name = @"fabu2";
            UIImage *image = [UIImage imageNamed:imageNameArray[i-1]];
            
//            UIImage *image = [UIImage imageNamed:name];
            [self.imageArray addObject:image];
            NSLog(@"********************************%@",self.imageArray);
                 //NSLog(@"%@",self.imageArray);
        }

        NSArray *array = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"资产求购",@"融资需求",@"法律服务",@"悬赏信息",@"尽职调查",@"委外催收",@"投资需求"];
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
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"选中 section:%ld,item:%ld",indexPath.section,indexPath.item);
    PushStartController *PusVc = [[UIStoryboard storyboardWithName:@"Publish" bundle:nil] instantiateViewControllerWithIdentifier:@"PushStartController"];
//    NSArray *infonmationType = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"固产求购",@"融资借贷",@"法律服务",@"悬赏信息",@"尽职调查",@"委外催收",@"典当担保"];
//    NSArray *level = @[@"VIP1"];
    
    NSArray *TypeID = @[@"01",@"14",@"12",@"04",@"13",@"06",@"03",@"09",@"10",@"02",@"15"];
    switch (indexPath.row) {
        case 0:
            PusVc.typeName = @"资产包转让";
            PusVc.TypeID = TypeID[0];
            
            break;
        case 1:
            PusVc.typeName = @"债权转让";
            PusVc.TypeID = TypeID[1];

            break;
        case 2:
            PusVc.typeName = @"固产转让";
            PusVc.TypeID = TypeID[2];

            break;
        case 3:
            PusVc.typeName = @"商业保理";
            PusVc.TypeID = TypeID[3];

            break;
        case 4:
            PusVc.typeName = @"资产求购";
            PusVc.TypeID = TypeID[4];

            break;
        case 5:
            PusVc.typeName = @"融资需求";
            PusVc.TypeID = TypeID[5];

            break;
        case 6:
            PusVc.typeName = @"法律服务";
            PusVc.TypeID = TypeID[6];

            break;
        case 7:
            PusVc.typeName = @"悬赏信息";
            PusVc.TypeID = TypeID[7];

            break;
        case 8:
            PusVc.typeName = @"尽职调查";
            PusVc.TypeID = TypeID[8];

            break;
        case 9:
            PusVc.typeName = @"委外催收";
            PusVc.TypeID = TypeID[9];

            break;
        case 10:
        {
            PusVc.typeName = @"投资需求";
            NSLog(@"---------------%@",PusVc.typeName);
        }
            PusVc.TypeID = TypeID[10];

            break;
 
        default:
            break;
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
    
    if ([isLogin isEqualToString:@"已登录"]) {
        [self.navigationController pushViewController:PusVc animated:YES];
    }
    else
    {
        LoginController *loginVC = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil].instantiateInitialViewController;
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }
    
//    [self presentViewController:PusVc animated:YES completion:nil];
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
