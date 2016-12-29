//
//  NewsController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/10/31.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "NewsController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"

#import "ZixunController.h"
#import "JiangtangController.h"
#import "YanjiuController.h"

#import "ScrollHeadView.h"
#import "LunboModel.h"
#import "NewsDetailController.h"

#import "QuestionsController.h"
#import "TestViewController.h"

#define ScreeFrame [UIScreen mainScreen].bounds

@interface NewsController ()<SegmentTapViewDelegate,FlipTableViewDelegate,scrollHeadViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@property (strong, nonatomic) NSMutableArray *controllsArray;
@property (nonatomic,strong) ScrollHeadView *scrollHeadView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) MBProgressHUD *HUD;
/**
 *  数据请求轮播图接收数组
 */
@property (nonatomic,strong) NSArray *imageDataArray;

/**
 *  轮播图数据源
 */
@property (nonatomic,strong) NSMutableArray *imageSourceArray;


@end

@implementation NewsController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger unreadcount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    NSString *unreadStr = [NSString stringWithFormat:@"%ld",unreadcount];
    
    
    if (unreadcount == 99 || unreadcount>99) {
        unreadStr = @"99+";
    }
    if (unreadcount == 0 || unreadcount < 0) {
        unreadStr = nil;
        
    }
    [[[[[self tabBarController]tabBar]items]objectAtIndex:3]setBadgeValue:unreadStr];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan2"] forBarMetrics:0];
    UIColor *color = [UIColor blackColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:@"NewsControllerpush" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资讯";
    self.imageDataArray = [NSArray array];
    self.imageSourceArray = [NSMutableArray array];
//    [self getLunbotu];
//    [self setScroHeadView];
    [self initSegment];
    [self initFlipTableView];
    
    // Do any additional setup after loading the view.
}
- (void)notificationAction:(NSNotification *)sender
{
    NewsDetailController *detailVC = [[NewsDetailController alloc]init];
    detailVC.NewsID = sender.userInfo[@"NewsID"];
    detailVC.NewsTime = sender.userInfo[@"NewsTime"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 *  获取轮播图
 */
- (void)getLunbotu
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *accesstoken = @"token";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    [dic setObject:accesstoken forKey:@"access_token"];
    //    NSString *getbannerURL = [getDataURL stringByAppendingString:@"/app/banner?access_token=token"];
    NSString *getbannerURL = [getDataURL stringByAppendingString:@"/app/twobanner?access_token=token"];
    //    http://api.ziyawang.com/v1/app/twobanner?access_token=token
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //    })
    
    // @" http://api.ziyawang.com/v1/app/banner?access_token=token"
    [self.manager GET:getbannerURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"!!!!!!!!%@",responseObject);
         self.imageDataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"111111111111111%@",self.imageDataArray);
         for (NSDictionary *dic in self.imageDataArray) {
             LunboModel *model = [[LunboModel alloc]init];
             [model setValuesForKeysWithDictionary:dic];
             [self.imageSourceArray addObject:model.BannerLink];
         }
         NSLog(@"%@",self.imageSourceArray);
         [self setScroHeadView];
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"请求轮播图失败");
         
         
     }];
    
    
}


/**
 设置轮播图
 */
- (void)setScroHeadView
{
    
    //最上方轮播图
    NSString *path = [[NSBundle mainBundle]pathForResource:@"lunbotu1@2x" ofType:@"png"];
    
    NSString *url2 = path;
    NSString *url3 = path;
    NSString *url4 = path;
    NSString *url5 = path;
    /**
     *  为0
     */
    if (self.imageSourceArray.count == 0) {
        url2 = path;
        url3 = path;
        url4 = path;
        url5 = path;
    }
    else
    {
        url2 = [getImageURL stringByAppendingString:self.imageSourceArray[0]];
        url3 = [getImageURL stringByAppendingString:self.imageSourceArray[1]];
        url4 = [getImageURL stringByAppendingString:self.imageSourceArray[2]];
        url5 = [getImageURL stringByAppendingString:self.imageSourceArray[3]];
        
    }
    NSArray *imagearray = @[url5,url2,url3,url4,url5,url2];
    
    NSMutableArray *imageMuarray = [NSMutableArray arrayWithArray:imagearray];
    self.scrollHeadView = [[ScrollHeadView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, [self getImageViewHight]) arraySource:imageMuarray];
    self.scrollHeadView.Mydelegate = self;
    
    //    [self.headView addSubview:imageview];
    [self.view addSubview:self.scrollHeadView];

    
}

/**
 *  不同机型轮播图的高度
 *
 *  @return 图片高度
 */
- (CGFloat )getImageViewHight
{
    
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        
        return 150;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return 160;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return 176;
        
    }
    
    return 150;
    
}


-(void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, ScreeFrame.size.width, 40) withDataArray:[NSArray arrayWithObjects:@"行业资讯",@"资芽讲堂",@"行业研究",nil] withFont:14];
    
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}
-(void)initFlipTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    ZixunController *v1 = [[ZixunController alloc]init];
//    //    UINavigationController *tuijianVC = [[UINavigationController alloc]initWithRootViewController:v1];
//    
    JiangtangController *v2 = [[JiangtangController alloc]init];
//    //    UINavigationController *hangyeVC = [[UINavigationController alloc]initWithRootViewController:v2];
//    
//    
    YanjiuController *v3 = [[YanjiuController alloc]init];
//    //    UINavigationController *hahaVC = [[UINavigationController alloc]initWithRootViewController:v3];
//    
//    
//    YifenzhongController *v4 = [[YifenzhongController alloc]init];
//    //    UINavigationController *yifenzhongVC = [[UINavigationController alloc]initWithRootViewController:v4];
    [self.controllsArray addObject:v1];
    [self.controllsArray addObject:v2];
    [self.controllsArray addObject:v3];
//    [self.controllsArray addObject:v4];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, ScreeFrame.size.width, self.view.frame.size.height - 40) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}

- (void)didTapScrollHeadView
{
//    QuestionsController *QuesVC = [[QuestionsController alloc]init];
//    [self.navigationController pushViewController:QuesVC animated:YES];
    
    TestViewController *TestVC = [[TestViewController alloc]init];
    [self.navigationController pushViewController:TestVC animated:YES];
}
#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    NSLog(@"%ld",index);

    
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
    [self.segment selectIndex:index];
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
