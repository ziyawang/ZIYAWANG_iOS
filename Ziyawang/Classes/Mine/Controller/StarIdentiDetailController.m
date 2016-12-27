//
//  StarIdentiDetailController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/22.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "StarIdentiDetailController.h"
#import "ZXVideoPlayerController.h"
#import "ZXVideo.h"
#import "AppDelegate.h"
@interface StarIdentiDetailController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *starima1;
@property (weak, nonatomic) IBOutlet UIImageView *starima2;
@property (weak, nonatomic) IBOutlet UIImageView *starima3;
@property (weak, nonatomic) IBOutlet UIImageView *starima4;
@property (weak, nonatomic) IBOutlet UIImageView *starima5;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineheight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineheight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineheight3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineheight4;



@property (weak, nonatomic) IBOutlet UIImageView *promiseBookImage;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage1;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage2;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage3;

@property (weak, nonatomic) IBOutlet UIImageView *threeBookImage1;
@property (weak, nonatomic) IBOutlet UIImageView *threeBookImage2;
@property (weak, nonatomic) IBOutlet UIImageView *threeBookImage3;


@property (weak, nonatomic) IBOutlet UIView *baozhengjinView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baozhengjinViewHeight;
@property (weak, nonatomic) IBOutlet UIView *chengnuoshuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chengnuoViewHeight;
@property (weak, nonatomic) IBOutlet UIView *shipinTopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shipinTopViewHeight;

@property (weak, nonatomic) IBOutlet UIView *shidiView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shipinViewHight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shidiViewHeight;

@property (weak, nonatomic) IBOutlet UIView *sanzhengView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sanzhengViewHeight;

@property (nonatomic,assign) NSInteger height1;
@property (nonatomic,assign) NSInteger height2;
@property (nonatomic,assign) NSInteger height3;
@property (nonatomic,assign) NSInteger height4;
@property (nonatomic,assign) NSInteger height5;


@property (weak, nonatomic) IBOutlet UIView *shipinView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) ZXVideoPlayerController *videoController;
@property (nonatomic, strong, readwrite) ZXVideo *video;
@property (nonatomic,strong) NSString *isFull;

@end

@implementation StarIdentiDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置允许横屏竖屏
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 1;
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 0;
    self.navigationController.navigationBar.hidden = NO;
    
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
}

- (void)fullScreen
{
//    self.scrollView.scrollEnabled = NO;

    self.baozhengjinViewHeight.constant = 0;
    self.chengnuoViewHeight.constant = 0;
    self.shipinTopViewHeight.constant = 0;
    
//    self.shidiViewHeight.constant = 0;
//    self.sanzhengViewHeight.constant = 0;
    
    self.lineheight1.constant = 0;
    self.lineheight2.constant = 0;
    self.lineheight3.constant = 0;
    self.lineheight4.constant = 0;

    [self.baozhengjinView setHidden:YES];
    [self.chengnuoshuView setHidden:YES];
    [self.shipinTopView setHidden:YES];
    [self.shidiView setHidden:YES];
    [self.sanzhengView setHidden:YES];
    [self.line1 setHidden:YES];
    [self.line2 setHidden:YES];
    [self.line3 setHidden:YES];
    [self.line4 setHidden:YES];
    self.shipinView.center = self.view.center;
    
}
- (void)smallScreen
{
//    self.scrollView.scrollEnabled = YES;
    self.baozhengjinViewHeight.constant = 44;
    self.chengnuoViewHeight.constant = self.height2;
    self.shipinTopViewHeight.constant = 44;
    
    [self.baozhengjinView setHidden:NO];
    [self.chengnuoshuView setHidden:NO];
    [self.shipinTopView setHidden:NO];
    [self.shidiView setHidden:NO];
    [self.sanzhengView setHidden:NO];

    [self.line1 setHidden:NO];
    [self.line2 setHidden:NO];
    [self.line3 setHidden:NO];
    [self.line4 setHidden:NO];
    
    self.lineheight1.constant = 10;
    self.lineheight2.constant = 10;
    self.lineheight3.constant = 10;
    self.lineheight4.constant = 10;
}

- (void)popAction:(UIBarButtonItem *)buttonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
    [self.videoController stop];
    self.videoController = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.height1 = 44;
    self.height2 = 130;
    self.height3 = 44;
    
 self.navigationItem.title = @"星级认证详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    
    
    self.video = [[ZXVideo alloc]init];
    
    self.video.playUrl = self.VideoURL;
    NSLog(@"%@",self.VideoURL);
    
    self.video.title = @"认证视频";
    [self setViews];
    
    
 }
- (void)setViews
{
    
    
    
    NSDictionary *starDic = self.sholevelDic;
    NSMutableDictionary *starArray = [NSMutableDictionary dictionaryWithDictionary:starDic];
    
    starArray[@"1"] = [NSString stringWithFormat:@"%@",starArray[@"1"]];
    starArray[@"2"] = [NSString stringWithFormat:@"%@",starArray[@"2"]];
    starArray[@"3"] = [NSString stringWithFormat:@"%@",starArray[@"4"]];
    starArray[@"4"] = [NSString stringWithFormat:@"%@",starArray[@"4"]];
    starArray[@"5"] = [NSString stringWithFormat:@"%@",starArray[@"5"]];
    
    
    if ([starArray[@"1"] isEqualToString:@"2"]) {
        self.starima1.image = [UIImage imageNamed:@"baozhengjin"];
        self.label1.textColor = [UIColor redColor];
        self.label1.text = @"已认证";
        
        
    }
   
    if ([starArray[@"2"] isEqualToString:@"2"]) {
        self.starima4.image = [UIImage imageNamed:@"shi"];
        self.label4.textColor = [UIColor redColor];
        self.label4.text = @"已认证";
        switch (self.areaArr.count) {
            case 1:
                [self.locationImage1 sd_setImageWithURL:[NSURL URLWithString:self.areaArr[0]]];
                
                break;
            case 2:
                [self.locationImage1 sd_setImageWithURL:[NSURL URLWithString:self.areaArr[0]]];
                [self.locationImage2 sd_setImageWithURL:[NSURL URLWithString:self.areaArr[1]]];

                break;
            case 3:
                [self.locationImage1 sd_setImageWithURL:[NSURL URLWithString:self.areaArr[0]]];
                [self.locationImage2 sd_setImageWithURL:[NSURL URLWithString:self.areaArr[1]]];
                [self.locationImage3 sd_setImageWithURL:[NSURL URLWithString:self.areaArr[2]]];

                break;
            default:
                break;
        }
    }
    else
    {
        self.shidiViewHeight.constant = 44;
        
    }
     if ([starArray[@"3"] isEqualToString:@"2"]) {
        self.starima3.image = [UIImage imageNamed:@"shipin"];
        self.label3.textColor = [UIColor redColor];
        self.label3.text = @"已认证";
        [self playVideo];
         self.shipinViewHight.constant = kZXVideoPlayerOriginalHeight;
    }
    else
    {
        self.shipinViewHight.constant = 0;
        
    }
    if ([starArray[@"4"] isEqualToString:@"2"]) {
        NSLog(@"%@",starArray[@"4"]);
        self.starima2.image = [UIImage imageNamed:@"nuo"];
        self.label2.textColor = [UIColor redColor];
        self.label2.text = @"已认证";
        [self.promiseBookImage sd_setImageWithURL:[NSURL URLWithString:self.promiseBookURL]];
        
    }
    else
    {
        self.chengnuoViewHeight.constant = 44;
        self.height2 = 44;
    }
    if ([starArray[@"5"] isEqualToString:@"2"]) {
        self.starima5.image = [UIImage imageNamed:@"zheng"];
        self.label5.textColor = [UIColor redColor];
        self.label5.text = @"已认证";
        switch (self.threeBookArr.count) {
            case 1:
                [self.threeBookImage1 sd_setImageWithURL:[NSURL URLWithString:self.threeBookArr[0]]];
                
                break;
            case 2:
                [self.threeBookImage1 sd_setImageWithURL:[NSURL URLWithString:self.threeBookArr[0]]];
                [self.threeBookImage2 sd_setImageWithURL:[NSURL URLWithString:self.threeBookArr[1]]];

                break;
            case 3:
                [self.threeBookImage1 sd_setImageWithURL:[NSURL URLWithString:self.threeBookArr[0]]];
                [self.threeBookImage2 sd_setImageWithURL:[NSURL URLWithString:self.threeBookArr[1]]];
                [self.threeBookImage3 sd_setImageWithURL:[NSURL URLWithString:self.threeBookArr[2]]];

                break;
                
            default:
                break;
        }
    }
    else
    {
        self.sanzhengViewHeight.constant = 44;
    }

}
- (void)playVideo
{
    UIView *playBackView = [UIView new];
    [self.contentView addSubview:playBackView];
    
    playBackView.sd_layout.topSpaceToView(self.shipinTopView,0)
    .leftEqualToView(self.shipinTopView)
    .rightEqualToView(self.shipinTopView)
    .heightIs(kZXVideoPlayerOriginalHeight);
    
    
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:
                                CGRectMake(0, 0, kZXVideoPlayerOriginalWidth,
                                           kZXVideoPlayerOriginalHeight)];
        __weak typeof(self) weakSelf = self;
        self.videoController.videoPlayerGoBackBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
//            [strongSelf.navigationController popViewControllerAnimated:YES];
            [playBackView removeFromSuperview];
            [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
            
            strongSelf.videoController = nil;
            
            
        };
        
        
//        self.videoController.videoPlayerGoBackBlock = ^()
//        {
//            
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//            
//        };
        
        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
            NSLog(@"切换为竖屏模式");
         
            self.isFull = @"two";

            
            playBackView.sd_layout.topSpaceToView(self.contentView,0)
                        .leftEqualToView(self.shipinTopView)
                        .rightEqualToView(self.shipinTopView)
                        .heightIs(kZXVideoPlayerOriginalHeight);
//            [self smallScreen];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
          
            if (self.isFull == nil) {
            [self.scrollView setContentOffset:CGPointMake(0,44+10+self.chengnuoViewHeight.constant+10+44)];
                self.isFull = @"one";
            }
            else
            {
                [self.scrollView setContentOffset:CGPointMake(0, 0 )];

            }

            
            
            playBackView.sd_layout.topSpaceToView(self.shipinTopView,0)
            .leftSpaceToView(self.contentView,0)
            .rightSpaceToView(self.contentView,0)
            .heightIs([UIScreen mainScreen].bounds.size.height);

//            self.shipinView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//            [self fullScreen];
            
            [self.navigationController setNavigationBarHidden:YES animated:NO];
//            [self.videoController showInView:self.view];

        };
        [self.videoController showInView:playBackView];

    }
    self.videoController.video = self.video;
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
            
            NSLog(@"%@",dic);
            
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"user"][@"right"] forKey:@"right"];
            
            
            NSDictionary *starDic = dic[@"service"][@"showlevelarr"];
            NSMutableDictionary *starArray = [NSMutableDictionary dictionaryWithDictionary:starDic];
            
            starArray[@"1"] = [NSString stringWithFormat:@"%@",starArray[@"1"]];
            starArray[@"2"] = [NSString stringWithFormat:@"%@",starArray[@"2"]];
            starArray[@"3"] = [NSString stringWithFormat:@"%@",starArray[@"4"]];
            starArray[@"4"] = [NSString stringWithFormat:@"%@",starArray[@"4"]];
            starArray[@"5"] = [NSString stringWithFormat:@"%@",starArray[@"5"]];
            
            
            if ([starArray[@"1"] isEqualToString:@"2"]) {
                self.starima1.image = [UIImage imageNamed:@"baozhengjin"];
            }
            if ([starArray[@"2"] isEqualToString:@"2"]) {
                self.starima2.image = [UIImage imageNamed:@"shi"];
            }
            
            if ([starArray[@"3"] isEqualToString:@"2"]) {
                self.starima3.image = [UIImage imageNamed:@"shipin"];
            }
            if ([starArray[@"4"] isEqualToString:@"2"]) {
                self.starima4.image = [UIImage imageNamed:@"nuo"];
            }
            if ([starArray[@"5"] isEqualToString:@"2"]) {
                self.starima5.image = [UIImage imageNamed:@"zheng"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
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
