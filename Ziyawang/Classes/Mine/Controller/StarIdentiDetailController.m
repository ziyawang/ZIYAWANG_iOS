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

#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"
@interface StarIdentiDetailController ()<KNPhotoBrowerDelegate>
{
    
    BOOL     _ApplicationStatusIsHidden;
    
}
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

@property (weak, nonatomic) IBOutlet UIButton *playButton;


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

@property (nonatomic,strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) KNPhotoBrower *photoBrower;

@property (nonatomic,strong) NSMutableArray *imageViewArray;
@property (nonatomic,strong) NSMutableArray *imageUrlArray;

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
    
    
    self.itemsArray = [NSMutableArray new];
    self.photoBrower = [[KNPhotoBrower alloc]init];
    self.imageViewArray = [NSMutableArray new];
    self.imageUrlArray = [NSMutableArray new];
    
    self.video = [[ZXVideo alloc]init];
    
    self.video.playUrl = self.VideoURL;
    NSLog(@"%@",self.VideoURL);
    
    self.video.title = @"认证视频";
    [self setImageViewsWithImageView:self.promiseBookImage];
    [self setImageViewsWithImageView:self.locationImage1];
    [self setImageViewsWithImageView:self.locationImage2];
    [self setImageViewsWithImageView:self.locationImage3];

    [self setImageViewsWithImageView:self.threeBookImage1];
    [self setImageViewsWithImageView:self.threeBookImage2];
    [self setImageViewsWithImageView:self.threeBookImage3];
    
    
    
    
    [self lookImageViews];
    [self setViews];
    
    
 }

- (void)lookImageViews
{
    
    self.promiseBookImage.userInteractionEnabled = YES;
    self.locationImage1.userInteractionEnabled = YES;
    self.locationImage2.userInteractionEnabled = YES;
    self.locationImage3.userInteractionEnabled = YES;

    self.threeBookImage1.userInteractionEnabled = YES;
    self.threeBookImage2.userInteractionEnabled = YES;
    self.threeBookImage3.userInteractionEnabled = YES;

    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    UITapGestureRecognizer *gesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    UITapGestureRecognizer *gesture5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    UITapGestureRecognizer *gesture6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
    UITapGestureRecognizer *gesture7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];

    [self.promiseBookImage addGestureRecognizer:gesture1];
    [self.locationImage1 addGestureRecognizer:gesture2];
    [self.locationImage2 addGestureRecognizer:gesture3];
    [self.locationImage3 addGestureRecognizer:gesture4];
    [self.threeBookImage1 addGestureRecognizer:gesture5];
    [self.threeBookImage2 addGestureRecognizer:gesture6];
    [self.threeBookImage3 addGestureRecognizer:gesture7];

    self.promiseBookImage.tag = 0;
    self.locationImage1.tag = 1;
    self.locationImage2.tag = 2;
    self.locationImage3.tag = 3;

    self.threeBookImage1.tag = 4;
    self.threeBookImage2.tag = 5;
    self.threeBookImage3.tag = 6;

    
    KNPhotoItems *items1 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items2 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items3 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items4 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items5 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items6 = [[KNPhotoItems alloc] init];
    KNPhotoItems *items7 = [[KNPhotoItems alloc] init];
    
    
    NSString *imageURL1 = @"1";
    NSString *imageURL2 = @"2";
    NSString *imageURL3 = @"3";
    NSString *imageURL4 = @"4";
    NSString *imageURL5 = @"5";
    NSString *imageURL6 = @"6";
    NSString *imageURL7 = @"7";
    
    if (self.promiseBookURL != nil && [self.promiseBookURL isEqualToString:@""] == NO) {
        imageURL1 = self.promiseBookURL;
        [self.imageViewArray addObject:self.promiseBookImage];
        [self.imageUrlArray addObject:self.promiseBookURL];
        
//        items1.url = imageURL1;
//        items1.sourceView =self.promiseBookImage;
//        [self.itemsArray addObject:items1];
        
    }
    
    
    switch (self.areaArr.count) {
        case 0:
            
            break;
        case 1:
    
//            imageURL2 = self.areaArr[0];
//            items2.url = imageURL2;
//            items2.sourceView =self.locationImage1;
//            [self.itemsArray addObject:items2];
            [self.imageUrlArray addObject:self.areaArr[0]];
            [self.imageViewArray addObject:self.locationImage1];
            break;
        case 2:
//            imageURL2 = self.areaArr[0];
//            items2.url = imageURL2;
//            items2.sourceView =self.locationImage2;
//            [self.itemsArray addObject:items2];
//            
//            imageURL3 = self.areaArr[1];
//            items3.url = imageURL3;
//            items3.sourceView =self.locationImage3;
//            [self.itemsArray addObject:items3];
            [self.imageUrlArray addObject:self.areaArr[0]];
            [self.imageViewArray addObject:self.locationImage1];
            [self.imageUrlArray addObject:self.areaArr[1]];
            [self.imageViewArray addObject:self.locationImage2];
            
            break;
        case 3:
//            imageURL2 = self.areaArr[0];
//            items2.url = imageURL2;
//            items2.sourceView =self.locationImage1;
//            [self.itemsArray addObject:items2];
//            
//            imageURL3 = self.areaArr[1];
//            items3.url = imageURL3;
//            items3.sourceView =self.locationImage2;
//            [self.itemsArray addObject:items3];
//            
//            imageURL4 = self.areaArr[2];
//            items4.url = imageURL4;
//            items4.sourceView =self.locationImage3;
//            [self.itemsArray addObject:items4];
//            imageURL3 = self.areaArr[2];
            [self.imageUrlArray addObject:self.areaArr[0]];
            [self.imageViewArray addObject:self.locationImage1];
            [self.imageUrlArray addObject:self.areaArr[1]];
            [self.imageViewArray addObject:self.locationImage2];
            [self.imageUrlArray addObject:self.areaArr[2]];
            [self.imageViewArray addObject:self.locationImage3];
            break;
        default:
            break;
    }
    switch (self.threeBookArr.count) {
        case 0:
            
            break;
        case 1:
//            imageURL5 = self.threeBookArr[0];
//            items5.url = imageURL5;
//            items5.sourceView =self.threeBookImage1;
//            [self.itemsArray addObject:items5];
            [self.imageUrlArray addObject:self.threeBookArr[0]];
            [self.imageViewArray addObject:self.threeBookImage1];
            break;
        case 2:
//            imageURL5 = self.threeBookArr[0];
//            items5.url = imageURL5;
//            items5.sourceView =self.threeBookImage1;
//            [self.itemsArray addObject:items5];
//            
//            imageURL6 = self.threeBookArr[1];
//            items6.url = imageURL6;
//            items6.sourceView =self.threeBookImage2;
//            [self.itemsArray addObject:items6];
//
            [self.imageUrlArray addObject:self.threeBookArr[0]];
            [self.imageViewArray addObject:self.threeBookImage1];[self.imageUrlArray addObject:self.threeBookArr[1]];
            [self.imageViewArray addObject:self.threeBookImage2];
            break;
        case 3:
//            imageURL5 = self.threeBookArr[0];
//            items5.url = imageURL5;
//            items5.sourceView =self.threeBookImage1;
//            [self.itemsArray addObject:items5];
//            

//            
//            imageURL7 = self.threeBookArr[2];
//            items7.url = imageURL7;
//            items7.sourceView =self.threeBookImage3;
//            [self.itemsArray addObject:items7];
            [self.imageUrlArray addObject:self.threeBookArr[0]];
            [self.imageViewArray addObject:self.threeBookImage1];
            [self.imageUrlArray addObject:self.threeBookArr[1]];
            [self.imageViewArray addObject:self.threeBookImage2];
            [self.imageUrlArray addObject:self.threeBookArr[2]];
            [self.imageViewArray addObject:self.threeBookImage3];
            
            break;
        default:
            break;
    }
    
    for (int i = 0; i < self.imageViewArray.count; i ++) {
        
        KNPhotoItems *item = [[KNPhotoItems alloc] init];
        UIImageView *imageview = self.imageViewArray[i];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGestureAction:)];
        [imageview addGestureRecognizer:gesture];
        imageview.tag = i;
        
        item.url = self.imageUrlArray[i];
        
        item.sourceView = imageview;
        [self.itemsArray addObject:item];
        
        //            imageURL6 = self.threeBookArr[1];
        //            items6.url = imageURL6;
        //            items6.sourceView =self.threeBookImage2;
        //            [self.itemsArray addObject:items6];
    }

}

- (void)setImageViewsWithImageView:(UIImageView *)imageView
{
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds = YES;
}
- (void)setViews
{
    NSDictionary *starDic = self.sholevelDic;
    NSMutableDictionary *starArray = [NSMutableDictionary dictionaryWithDictionary:starDic];
    
    starArray[@"1"] = [NSString stringWithFormat:@"%@",starArray[@"1"]];
    starArray[@"2"] = [NSString stringWithFormat:@"%@",starArray[@"2"]];
    starArray[@"3"] = [NSString stringWithFormat:@"%@",starArray[@"3"]];
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
         self.shipinViewHight.constant = kZXVideoPlayerOriginalHeight;
    }
    else
    {
        self.shipinViewHight.constant = 0;
        
        [self.playButton setHidden:YES];
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
- (IBAction)videoPlayButtonAction:(id)sender {
    [self playVideo];
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

            self.lineheight1.constant = 10;
            self.lineheight2.constant = 10;
            playBackView.sd_layout.topSpaceToView(self.shipinTopView,0)
                        .leftEqualToView(self.shipinTopView)
                        .rightEqualToView(self.shipinTopView)
                        .heightIs(kZXVideoPlayerOriginalHeight);
//            [self smallScreen];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
          
//            if (self.isFull == nil) {
//            
////            [ self.scrollView setContentOffset:CGPointMake(0,44+10+self.shidiViewHeight.constant+10+44)];
////                self.isFull = @"one";
//            }
//            else
//            {
//            }

            self.lineheight1.constant = 0;
            self.lineheight2.constant = 0;
            playBackView.sd_layout.topSpaceToView(self.contentView,-20)
            .leftSpaceToView(self.contentView,0)
            .rightSpaceToView(self.contentView,0)
            .heightIs([UIScreen mainScreen].bounds.size.height);
            
            [self.scrollView setContentOffset:CGPointMake(0, 0)];

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

#pragma mark----查看图片手势方法以及代理
- (void)imageTapGestureAction:(UITapGestureRecognizer *)imageTapGesture
{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = self.itemsArray;
    photoBrower.currentIndex = imageTapGesture.view.tag;
    // 如果设置了 photoBrower中的 actionSheetArr 属性. 那么 isNeedRightTopBtn 就应该是默认 YES, 如果设置成NO, 这个actionSheetArr 属性就没有意义了
    //    photoBrower.actionSheetArr = [self.actionSheetArray mutableCopy];
    
    [photoBrower present];
    
    _photoBrower = photoBrower;
    
    // 设置代理方法 --->可不写
    [photoBrower setDelegate:self];
    
    // 这里是 设置 状态栏的 隐藏 ---> 可不写
    _ApplicationStatusIsHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}
// 下面方法 是让 '状态栏' 在 PhotoBrower 显示的时候 消失, 消失的时候 显示 ---> 根据项目需求而定
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    if(_ApplicationStatusIsHidden){
        return YES;
    }
    return NO;
}

/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss{
    NSLog(@"Will Dismiss");
    _ApplicationStatusIsHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
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
