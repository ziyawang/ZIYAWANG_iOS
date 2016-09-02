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
    self.navigationItem.title = @"找视频";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSegment];
    [self initFlipTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"PushToMovieDentailControllerNotification" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
