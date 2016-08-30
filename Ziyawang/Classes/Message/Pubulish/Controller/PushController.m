//
//  PushController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/28.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PushController.h"
#import "PushViewCell.h"
@interface PushController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *textArray;

@end

@implementation PushController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [[NSMutableArray alloc]init];
    
//    for (int i = 1; i <= 11; i++)
//    {
//        NSString *name = [NSString stringWithFormat:@"fabu%d.png",i];
//        UIImage *image = [UIImage imageNamed:name];
//        [self.imageArray addObject:image];
//             //NSLog(@"%@",self.imageArray);
//        
//    }
//    NSArray *array = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"典当担保",@"融资借贷",@"悬赏信息",@"尽职调查",@"委外催收",@"法律服务",@"资产求购"];
//    
    
    //创建一个布局类
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
//    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    //设置数据源和代理
//    collectionView.dataSource = self;
//    collectionView.delegate = self;
    
    
    //给view加个背景色
//    collectionView.backgroundColor = [UIColor whiteColor];
    //注册collectionViewcell注册到重用池
    //    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PushViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
        //注册分区头
    //    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    //注册分区尾
    //    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 11;
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PushViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    //indexPath.section indexPath.row;
    //    UIImage *image = self.imageArray[indexPath.row];
    //    cell.image = image;
    //    cell.backgroundColor = [UIColor blueColor];
    //    cell.text = [NSString stringWithFormat:@"s:%ld,item:%ld",indexPath.section,indexPath.item];
    
    NSLog(@"%ld",(long)indexPath.item);
    return cell;
    
}




#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
