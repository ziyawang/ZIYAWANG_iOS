//
//  VideosListController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/10.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "VideosListController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "TuijianvideoController.h"
#import "HangyeVideoController.h"
#import "HahaController.h"
#import "YifenzhongController.h"
#import "VideosModel.h"
#import "ZXVideo.h"
#import "VideoPlayViewController.h"
#define ScreeFrame [UIScreen mainScreen].bounds

@interface VideosListController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (strong, nonatomic) NSMutableArray *controllsArray;
@end

@implementation VideosListController

- (BOOL)shouldAutorotate
{
    return YES;
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSegment];
    [self initFlipTableView];
    [self getVideoStatu];
}
- (void)setupTitle {
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
    //    self.view.backgroundColor = [UIColor blueColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"找视频";
    title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = title;
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0 / 255.0 green:58.0 / 255.0 blue:59.0 / 255.0 alpha:1.0]];
    // 设置状态栏为白色 你看着自己整体设置 我不给你加了；
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"PushToMovieDentailControllerNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)getVideoStatu
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URL =getVideoListURL;
    NSString *accesstoken = @"token";
    //    NSString *pagecount = @"10";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:accesstoken forKey:@"access_token"];
    
    //    [dic setObject:pagecount forKey:@"pagecount"];
    [self.manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取信息成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *dataArray = dic[@"data"];
        NSString  *VideoID = dataArray.firstObject[@"VideoID"];
        NSString *videoid = [[NSUserDefaults standardUserDefaults]objectForKey:@"videostatu"];
        if ([VideoID isEqualToString:videoid]==NO) {
            [[NSUserDefaults standardUserDefaults]setObject:VideoID forKey:@"videostatu"];
        }
        NSLog(@"%@",VideoID);
        //        for (NSDictionary *dic in dataArray) {
        //            VideosModel *model = [[VideosModel alloc]init];
        //            [model setValuesForKeysWithDictionary:dic];
        //            [self.sourceArray addObject:model];
        //        }
        //        self.startPage ++;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取信息失败");
        NSLog(@"%@",error);
        
    }];
    
    
}

// 通知监听事件

- (void)notificationAction:(NSNotification *)sender {
    
    
    ZXVideo *zvideo = sender.userInfo[@"zvideoModel"];
    VideosModel *model = sender.userInfo[@"model"];
    
//    VideosModel *model = [[VideosModel alloc]init];
//    model = self.sourceArray[indexPath.row];
//     NSString *headURL = @"http://videos.ziyawang.com";
    zvideo.title = model.VideoTitle;
    
    if (!model.VideoLink) {
        zvideo.playUrl = [videoPlayerURL stringByAppendingString:model.VideoLink2];
    }
    else
    {
    zvideo.playUrl = [videoPlayerURL stringByAppendingString:model.VideoLink];
    }
    VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc]init];
    videoPlayVC.videoTitle = model.VideoTitle;
    videoPlayVC.videoDes = model.VideoDes;
    videoPlayVC.viewCount = [NSString stringWithFormat:@"%@",model.ViewCount];
    videoPlayVC.commentTime = model.PublishTime;
    videoPlayVC.videoID = [NSString stringWithFormat:@"%@",model.VideoID];
    videoPlayVC.video = zvideo;
//    NSLog(@"222222%@",self.navigationController);
    
    [self.navigationController pushViewController:videoPlayVC animated:YES];
    
}

-(void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, ScreeFrame.size.width, 40) withDataArray:[NSArray arrayWithObjects:@"推荐",@"行业说",@"资芽哈哈哈",@"资芽一分钟",nil] withFont:14];
    
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}
-(void)initFlipTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    TuijianvideoController *v1 = [[TuijianvideoController alloc]init];
//    UINavigationController *tuijianVC = [[UINavigationController alloc]initWithRootViewController:v1];
    
    HangyeVideoController *v2 = [[HangyeVideoController alloc]init];
//    UINavigationController *hangyeVC = [[UINavigationController alloc]initWithRootViewController:v2];

    
    HahaController *v3 = [[HahaController alloc]init];
//    UINavigationController *hahaVC = [[UINavigationController alloc]initWithRootViewController:v3];

    
    YifenzhongController *v4 = [[YifenzhongController alloc]init];
//    UINavigationController *yifenzhongVC = [[UINavigationController alloc]initWithRootViewController:v4];
    [self.controllsArray addObject:v1];
    [self.controllsArray addObject:v2];
    [self.controllsArray addObject:v3];
    [self.controllsArray addObject:v4];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, ScreeFrame.size.width, self.view.frame.size.height - 40) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
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
