//
//  PushStartController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/1.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PushStartController.h"
#import "PushStartViewCell.h"
#import "PushChooseController.h"
#import <AVFoundation/AVFoundation.h>
#import "LxGridViewFlowLayout.h"
#import "ChooseAreaController.h"
#import "SuPhotoPicker.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface PushStartController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,AVAudioRecorderDelegate,MBProgressHUDDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}

/**
 *  视图属性
 */
@property (weak, nonatomic) IBOutlet UIView *qingdanView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic,strong) UIButton *recorderbutton;
@property (nonatomic,strong) UIButton *playRecorderButton;
@property (nonatomic,strong) UIButton *rerecorderButton;
@property (nonatomic,strong) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *startPushButton;
@property (nonatomic,strong) NSMutableArray *typeNameArray;
@property (nonatomic,strong) UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic,strong) UIView *backView;
/**
 *  dataSource
 */
@property (nonatomic,strong) NSMutableArray *imagearray;
@property(nonatomic,strong) NSMutableArray *pushDataArray;
@property (nonatomic,strong) NSMutableDictionary *pushDic;
/**
 *  单例
 */
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSUserDefaults *userDefault;
@property (nonatomic,strong) MBProgressHUD *HUD;

/**
 *  录音属性
 */
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) AVPlayer *avPlayer;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) NSURL *aurl;
@property (nonatomic,strong) UIView *recordAnimationView;
@property (nonatomic,assign) BOOL haveVideo;
@property (nonatomic,assign) NSInteger x;
@end

@implementation PushStartController

#pragma mark----视图周期

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [self.defaults objectForKey:@"token"];
    NSLog(@"!!!!!!!!!!!!%@",token);
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    /**
     初始化视图
     
     - returns: NO
     */
    [self initView];
    /**
     *  设置视图数据
     */
    [self setViewData];
    //初始化录音机
    /**
     *  初始化以及设置录音机
     */
    [self setaudio];
    /**
     *  设置录音机按钮以及传图按钮
     */
    [self setVideoAndImageButtons];
    /**
     *  设置录音时的动画提示
     */
    [self setRecordAnimation];
    //    [self.recordButton addTarget:self action:@selector(startRecorder) forControlEvents:UIControlEventTouchDown];
    //    [self.recordButton addTarget:self action:@selector(cancelRecorder) forControlEvents:UIControlEventTouchUpInside];
    //    [self.recordButton addTarget:self action:@selector(dragRecorder) forControlEvents:UIControlEventTouchDragExit];
    //    [self.playButton addTarget:self action:@selector(playRecorder) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark----各种初始化以及设置

/**
 *  初始化视图
 */
- (void)initView
{

    if ([self.typeName isEqualToString:@"资产包转让"]==NO) {
        [self.qingdanView setHidden:YES];
    }
    self.navigationItem.title =self.typeName;
    self.x = 0;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    
    self.manager = [AFHTTPSessionManager manager];
    self.celldic = [NSMutableDictionary dictionary];
    self.imagearray = [NSMutableArray array];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonAction:)];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *buttonimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6, 10, 18)];
    buttonimage.image = [UIImage imageNamed:@"back3"];
    UILabel *buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 30, 20)];
    buttonLabel.text = @"返回";
    buttonLabel.font = [UIFont systemFontOfSize:15];
    
    [leftButton addSubview:buttonimage];
    [leftButton addSubview:buttonLabel];
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    [self.tableView registerClass:[PushStartViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);
    self.contentTextView.text = @"请输入内容";
    self.contentTextView.delegate = self;
    self.contentTextView.textColor = [UIColor lightGrayColor];

}
/**
 *  设置视图数据
 */
- (void)setViewData
{
    NSArray *array1 = @[@"资产包类型",@"来源",@"总金额",@"转让价",@"地区"];
    NSArray *array2 = @[@"类型",@"总金额",@"转让价",@"地区"];
    //    NSArray *array3 = @[@"类型",@"转让价",@"地区"];
    NSArray *array3 = @[@"类型",@"标的物",@"转让价",@"地区"];
    NSArray *array4 = @[@"买方性质",@"合同金额",@"地区"];
    NSArray *array5 = @[@"类型",@"金额",@"地区"];
    NSArray *array6 = @[@"方式",@"金额",@"回报率",@"地区"];
    NSArray *array7 = @[@"类型",@"悬赏金额",@"地区"];
    NSArray *array8 = @[@"类型",@"被调查方",@"目标地区"];
    NSArray *array9 = @[@"类型",@"金额",@"佣金比例",@"状态",@"地区"];
    NSArray *array10 = @[@"类型",@"需求",@"地区"];
    NSArray *array11= @[@"类型",@"求购方",@"地区"];
    NSArray *array12 = @[@"类型",@"金额",@"地区"];
    NSArray *array13 = @[@"投资类型",@"投资方式",@"预期回报率",@"投资期限",@"地区"];
                         
    NSArray *allTypearray = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"典当信息",@"融资需求",@"悬赏信息",@"尽职调查",@"委外催收",@"法律服务",@"资产求购",@"担保信息",@"投资需求"];
    NSString *type1 = allTypearray[0];
    NSString *type2 = allTypearray[1];
    NSString *type3 = allTypearray[2];
    NSString *type4 = allTypearray[3];
    NSString *type5 = allTypearray[4];
    NSString *type6 = allTypearray[5];
    NSString *type7 = allTypearray[6];
    NSString *type8 = allTypearray[7];
    NSString *type9 = allTypearray[8];
    NSString *type10 = allTypearray[9];
    NSString *type11 = allTypearray[10];
    NSString *type12 = allTypearray[11];
    NSString *type13 = allTypearray[12];
    
    self.typeNameArray = [NSMutableArray array];
    if ([self.typeName isEqualToString:type1]) {
        self.typeNameArray = [NSMutableArray arrayWithArray:array1];
    }
    else if ([self.typeName isEqualToString:type2])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array2];
    }
    else if ([self.typeName isEqualToString:type3])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array3];
    }
    else if ([self.typeName isEqualToString:type4])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array4];
    }
    else if ([self.typeName isEqualToString:type5])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array5];
    }
    else if ([self.typeName isEqualToString:type6])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array6];
    }
    else if ([self.typeName isEqualToString:type7])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array7];
    }
    else if ([self.typeName isEqualToString:type8])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array8];
    }
    else if ([self.typeName isEqualToString:type9])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array9];
    }
    else if ([self.typeName isEqualToString:type10])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array10];
    }
    else if ([self.typeName isEqualToString:type11])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array11];
    }
    else if ([self.typeName isEqualToString:type12])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array12];
    }
    else if ([self.typeName isEqualToString:type13])
    {
        self.typeNameArray = [NSMutableArray arrayWithArray:array13];
    }
    
    if (self.typeNameArray.count == 3) {
        
        //        NSLayoutConstraint *height = [NSLayoutConstraint alloc]
        self.tableViewHeight.constant = 120;
    }
    else if (self.typeNameArray.count == 4)
    {
        self.tableViewHeight.constant = 160;
    }
    else
    {
        self.tableViewHeight.constant = 200;
    }

}
/**
 *  设置录音机以及传图按钮
 */
- (void)setVideoAndImageButtons
{
    [self.startPushButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    UIButton *deleteButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [deleteButton setFrame:CGRectMake(self.view.bounds.size.width - 140, 30, 30, 30)];
    //    [deleteButton setTitle:@"撤销" forState:(UIControlStateNormal)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"chexiao"] forState:(UIControlStateNormal)];
    [deleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.addImageView addSubview:deleteButton];
    
    self.addImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addImageButton setFrame:CGRectMake(5, 5, 80, 80)];
    [self.addImageButton setBackgroundImage:[UIImage imageNamed:@"tianjia"] forState:(UIControlStateNormal)];
    UILabel *tianjia = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 80, 20)];
    tianjia.text = @"添加凭证";
    tianjia.textColor = [UIColor colorWithHexString:@"fdd000"];
    tianjia.font = [UIFont systemFontOfSize:11];
    tianjia.textAlignment = NSTextAlignmentCenter;
    [self.addImageButton addSubview:tianjia];
    [self.addImageView addSubview:self.addImageButton];
    //[self.addImageButton setTitle:@"添加" forState:(UIControlStateNormal)];
    [self.addImageButton addTarget:self action:@selector(didClickChooseImage:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    //录音与播放按钮
    self.recorderbutton =[UIButton buttonWithType:(UIButtonTypeSystem)];
    //        [self.recorderbutton setTitle:@"录音" forState:(UIControlStateNormal)];
    [self.recorderbutton setBackgroundImage:[UIImage imageNamed:@"changluyin"] forState:(UIControlStateNormal)];
    
    [self.recorderbutton setFrame:CGRectMake(75, 5, 150, 30)];
    [self.audioView addSubview:self.recorderbutton];
    /**
     *  添加录音按钮的事件
     *
     *  @param startRecorder startRecorder description
     *
     *  @return return value description
     */
    [self.recorderbutton addTarget:self action:@selector(startRecorder) forControlEvents:UIControlEventTouchDown];
    [self.recorderbutton addTarget:self action:@selector(cancelRecorder) forControlEvents:UIControlEventTouchUpInside];
    [self.recorderbutton addTarget:self action:@selector(dragRecorder) forControlEvents:UIControlEventTouchDragExit];
    
    self.playRecorderButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.playRecorderButton setFrame:CGRectMake(75, 5, 120, 30)];
    [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
    [self.playRecorderButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    //    [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
    [self.audioView addSubview:self.playRecorderButton];
    [self.playRecorderButton setBackgroundImage:[UIImage imageNamed:@"yuyinbofang"] forState:(UIControlStateNormal)];
    self.rerecorderButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.rerecorderButton setTitle:@"重录" forState:(UIControlStateNormal)];
    [self.rerecorderButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    self.rerecorderButton.titleLabel.font = [UIFont systemFontOfSize:8];
    
    //    [self.rerecorderButton setTitle:@"重录" forState:(UIControlStateNormal)];
    [self.rerecorderButton setFrame:CGRectMake(85 + self.playRecorderButton.bounds.size.width, 5, 30, 30)];
    ;
    [self.rerecorderButton setBackgroundImage:[UIImage imageNamed:@"rerecord"] forState:(UIControlStateNormal)];
    [self.audioView addSubview:self.rerecorderButton];
    [self.rerecorderButton setHidden:YES];
    [self.playRecorderButton setHidden:YES];
     [self.playRecorderButton addTarget:self action:@selector(playRecorder) forControlEvents:UIControlEventTouchUpInside];
    [self.rerecorderButton addTarget:self action:@selector(didClickRerecorder:) forControlEvents:(UIControlEventTouchUpInside)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-70, 10, 70, 20)];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"(限30秒内)";
    label.font = [UIFont systemFontOfSize:12];
    [self.audioView addSubview:label];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    self.scrollView.delegate = self;
    
}
/**
 *  设置录音中动画提示
 */
- (void)setRecordAnimation
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height/2-114, 100, 100)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 50;
    
    self.recordAnimationView = view;
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.x, self.view.y, 100, 100 )];
    self.recordAnimationView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.recordAnimationView.bounds.size.height/2-10, 80, 20)];
    recordLabel.font = [UIFont systemFontOfSize:15];
    recordLabel.text = @"正在录音...";
    [self.recordAnimationView addSubview:recordLabel];
    recordLabel.textColor = [UIColor whiteColor];
}
/**
 *  初始化提示
 *
 *  @param lableText 提示信息
 *  @param timer     提示时间
 *  @param mode      提示参数
 */
- (void)MBProgressWithString:(NSString *)lableText timer:(NSTimeInterval)timer mode:(MBProgressHUDMode)mode

{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = mode;
    self.HUD.labelText = lableText;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:timer];
}
- (void)didClickSentImageButton:(UIButton *)addimageButton
{
    
    __weak typeof(self) weakSelf = self;
    SuPhotoPicker * picker = [[SuPhotoPicker alloc]init];
    picker.selectedCount = 1;
    picker.preViewCount = 0;
    [picker showInSender:self handle:^(NSArray<UIImage *> *photos) {
        [self showSelectedPhotos:photos];
    }];
}


#pragma mark----按钮监听事件

/**
 *  左右按钮事件
 *
 *  @param barbutton left
 */
- (void)leftBarButtonAction:(UIBarButtonItem *)barbutton
{
    /*
     //    [self.defaults removeObjectForKey:@"0"];
     //    [self.defaults removeObjectForKey:@"1"];
     //    [self.defaults removeObjectForKey:@"2"];
     //    [self.defaults removeObjectForKey:@"3"];
     //    [self.defaults removeObjectForKey:@"4"];
     */
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  pop
 *
 *  @param barbutton pop
 */
- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  选择照片按钮
 *
 *  @param button 选择
 */
- (void)didClickChooseImage:(UIButton *)button
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = NO;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        
    
        
        
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = NO;
        PickerImage.delegate = self;
        
        
        
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"应用相机权限受限,请在设置中启用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            return;
        }
        else
        {
        [self presentViewController:PickerImage animated:YES completion:nil];
        }
    }]];
    
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *  PickerImage完成后的代理方法
 *
 *  @param picker 系统
 *  @param info   字典
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //    self.usericonImageView.image = newPhoto;
    NSMutableArray *sentimage = [NSMutableArray new];
    [sentimage addObject:newPhoto];
    [self showSelectedPhotos:sentimage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  展示选择照片
 *
 *  @param images 选择的图片数组
 */
- (void)showSelectedPhotos:(NSArray *)images
{
    self.x ++;
    NSLog(@"X的值未（（（（（（（（（（（%ld",self.x);
    
    [self.imagearray addObject:images.lastObject];
    if (self.x < 4) {
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(80 * (self.x - 1) + 5 * self.x, 5, 80, 80)];
        iv.image = images[0];
        iv.tag = self.x;
        [self.addImageView addSubview:iv];
        if (self.x == 3) {
            //            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            //            button.backgroundColor = [UIColor whiteColor];
            //            [button setTitle:@"删除" forState:(UIControlStateNormal)];
            //            [button setFrame:CGRectMake(70, 5, 10, 10)];
            //            [iv addSubview:button];
            
            [self.addImageButton setHidden:YES];
            
        }
        if (self.x != 3) {
            [self.addImageButton setFrame:CGRectMake(80 * self.x + 5 * (self.x +1), 5, 80, 80)];
            
        }
    }
}
/**
 *  撤销图片按钮事件
 *
 *  @param deleteButton 撤销按钮
 */
- (void)didClickDeleteButton:(UIButton *)deleteButton
{
    
    NSMutableArray *a = [NSMutableArray array];
    for (UIView *view in self.addImageView.subviews)
    {
        NSString *tag = [NSString stringWithFormat:@"%ld",view.tag];
        
        [a addObject:tag];
    }
    if (a.count == 5)
    {
        [[self.addImageView viewWithTag:3]removeFromSuperview];
        self.x--;
        NSLog(@"X的值$$$$$$$$未%ld",self.x);
        
        [self.addImageButton setFrame:CGRectMake(80 * 2 +5 *2, 5, 80, 80)];
        [self.imagearray removeObject:self.imagearray[2]];
        
        
        [self.addImageButton setHidden:NO];
    }
    else if(a.count == 4)
    {
        
        [[self.addImageView viewWithTag:2]removeFromSuperview];
        [self.addImageButton setFrame:CGRectMake(80+10, 5, 80, 80)];
        [self.imagearray removeObject:self.imagearray[1]];
        
        
        self.x--;
        NSLog(@"X的值@@@@@@@@@@未%ld",self.x);
        
    }
    else if(a.count == 3)
    {
        [[self.addImageView viewWithTag:1]removeFromSuperview];
        [self.addImageButton setFrame:CGRectMake(5 , 5, 80, 80)];
        
        [self.imagearray removeObject:self.imagearray[0]];
        self.x--;
        NSLog(@"X的值###########未%ld",self.x);
    }
}

#pragma mark---点击发布按钮事件，类型判断
/**
 *  点击发布的事件
 */
- (IBAction)didClickSentContent:(id)sender {
    
    [self.view endEditing:YES];
    self.pushDic = [NSMutableDictionary new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *jine = [defaults objectForKey:@"金额"];
    NSString *zhekou = [defaults objectForKey:@"折扣"];
    NSString *ProArea = [defaults objectForKey:@"企业所在"];
    if (ProArea == nil) {
        ProArea = @"请选择";
    }

    for (NSString *str in self.pushDataArray) {
        NSLog(@"!!!!!!!!!!!!!!!!!!%@",str);
    }
    NSLog(@"金额！！！！！！！！！！！%@",jine);
    NSLog(@"折扣！！！！！！！！！！！%@",zhekou);
    if ([self.typeName isEqualToString:@"资产包转让"])
    {
        [self.pushDic setObject:jine forKey:@"TotalMoney"];
        [self.pushDic setObject:zhekou forKey:@"TransferMoney"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.pushDataArray[1] forKey:@"FromWhere"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        NSLog(@"%@",jine);
        NSLog(@"%@",zhekou);
        NSLog(@"%@",_pushDic[@"AssetType"]);
        NSLog(@"%@",_pushDic[@"TotalMoney"]);
        NSLog(@"%@",_pushDic[@"TransferMoney"]);
        NSLog(@"%@",_pushDic[@"ProArea"]);
        NSLog(@"%@",_pushDic[@"FromWhere"]);
        NSLog(@"%@",_pushDic[@"WordDes"]);
        if ([self.pushDic[@"TotalMoney"] isEqualToString:@"请选择"]||[self.pushDic[@"TransferMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"FromWhere"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"]||self.imagearray.count==0)
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
        //照片
        //语音
    }
    
    else if([self.typeName isEqualToString:@"债权转让"])
    {
        
        [self.pushDic setObject:jine forKey:@"TotalMoney"];
        [self.pushDic setObject:zhekou forKey:@"TransferMoney"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        
        if ([self.pushDic[@"TotalMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"TransferMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||self.pushDic[@"ProArea"]==nil||[self.pushDic[@"FromWhere"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"]||self.imagearray.count==0)
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"固产转让"])
    {
        
        [self.pushDic setObject:zhekou forKey:@"TransferMoney"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        
        [self.pushDic setObject:self.pushDataArray[1] forKey:@"Corpore"];
        
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"TransferMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"Corpore"]isEqualToString:@"请选择"]||self.pushDic[@"ProArea"]==nil||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"]||self.imagearray.count==0)
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"商业保理"])
    {
        
        [self.pushDic setObject:jine forKey:@"TotalMoney"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"BuyerNature"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"TotalMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"BuyerNature"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"])
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"典当信息"])
    {
        [self.pushDic setObject:jine forKey:@"TotalMoney"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"TotalMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"]||self.imagearray.count==0)
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"担保信息"])
    {
        [self.pushDic setObject:jine forKey:@"TotalMoney"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"TotalMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"FromWhere"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"]||self.imagearray.count==0)
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"融资需求"])
    {
        
        [self.pushDic setObject:jine forKey:@"TotalMoney"];
        [self.pushDic setObject:zhekou forKey:@"Rate"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"TotalMoney"]isEqualToString:@"请选择"]||self.pushDic[@"Rate"]==nil||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"])
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"悬赏信息"])
    {
        [self.pushDic setObject:jine forKey:@"TotalMoney"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        
        if ([self.pushDic[@"TotalMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"]||self.imagearray.count==0)
        {
            NSLog(@"%@",self.pushDic[@"TotalMoney"]);
            NSLog(@"%@",self.pushDic[@"AssetType"]);
            NSLog(@"%@",self.pushDic[@"ProArea"]);
            NSLog(@"%@",self.pushDic[@"WordDes"]);
            
            
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"尽职调查"])
    {
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.pushDataArray[1] forKey:@"Informant"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"Informant"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"])
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"委外催收"])
    {
        [self.pushDic setObject:jine forKey:@"TotalMoney"];
        [self.pushDic setObject:self.pushDataArray[2] forKey:@"Rate"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:self.pushDataArray[3] forKey:@"Status"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",self.pushDic);
        NSLog(@"%@",self.pushDic[@"TotalMoney"]);
        NSLog(@"%@",self.pushDic[@"Rate"]);
        NSLog(@"%@",self.pushDic[@"AssetType"]);
        NSLog(@"%@",self.pushDic[@"ProArea"]);
        NSLog(@"%@",self.pushDic[@"Status"]);
        NSLog(@"%@",self.pushDic[@"WordDes"]);
        if (self.imagearray.count==0||[self.pushDic[@"TotalMoney"] isEqualToString:@"请选择"]||[self.pushDic[@"Rate"] isEqualToString:@"请选择" ]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"Status"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"])
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"法律服务"])
    {
        [self.pushDic setObject:self.pushDataArray[1] forKey:@"Requirement"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"Requirement"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"]||[self.pushDic[@"AssetType"] isEqualToString:@"请选择"])
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
    }
    else if([self.typeName isEqualToString:@"资产求购"])
    {
        NSLog(@"资产求购：：：：%@",self.pushDataArray[1]);
        NSLog(@"%@",self.pushDataArray[0]);
            [self.pushDic setObject:self.pushDataArray[1] forKey:@"Buyer"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"Buyer"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"] isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"])
        {
            NSLog(@"请完善信息！");
            [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
            
        }
        else
        {
            [self pushDataWithDic:self.pushDic];
        }
        
    }
    else if([self.typeName isEqualToString:@"投资需求"])
    {
        [self.pushDic setObject:zhekou forKey:@"Rate"];
        [self.pushDic setObject:self.pushDataArray[0] forKey:@"AssetType"];
        [self.pushDic setObject:self.pushDataArray[1] forKey:@"InvestType"];
        [self.pushDic setObject:self.pushDataArray[3] forKey:@"Year"];
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        if ([self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||[self.pushDic[@"InvestType"]isEqualToString:@"请选择"]||[self.pushDic[@"Year"]isEqualToString:@"请选择"]||[self.pushDic[@"Rate"]isEqualToString:@"请选择"]||[self.pushDic[@"ProArea"]isEqualToString:@"请选择"]||[self.pushDic[@"WordDes"]isEqualToString:@"请选择"]) {
        [self MBProgressWithString:@"请完善信息资料" timer:1 mode:MBProgressHUDModeText];
        }
        else
        {
        [self pushDataWithDic:self.pushDic];
        }

    }
}

#pragma mark----设置录音机，添加录音事件
/**
 *  初始化录音机
 */
- (void)setaudio
{
    //录音设置
    NSMutableDictionary *setting = [[NSMutableDictionary alloc]init];
    [setting setValue:[NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [setting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    [setting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [setting setValue:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
    [setting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",urlStr);
    NSString *fileName = @"lll.wav";
    NSString *urlpath = [urlStr stringByAppendingString:fileName];
    NSURL *url2 = [NSURL URLWithString:urlpath];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.wav",urlStr]];
    self.aurl = url;
    
    //若想要在真机播放，必须在初始化录音机之前添加这一段代码
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    if(setCategoryError){
        NSLog(@"%@", [setCategoryError description]);
    }
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:nil];
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
}

/**
 *  开始录音
 */
- (void)startRecorder

{
    NSDate *date = [NSDate date];
    NSLog(@"-----------%@",date);
    if(self.recorder.currentTime == 0)
    {
        if ([self.recorder prepareToRecord]) {
            [self.recorder record];
        }
        [self.view addSubview:self.recordAnimationView];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectVoice) userInfo:nil repeats:YES];
    }
    else
    {
        [self playRecorder];
        
    }
}

/**
 *  可以通过此方法以音量设置UI(扩展方法)
 */
- (void)detectVoice
{
    //    NSTimeInterval time = self.timer.timeInterval;
    //    NSString *string = [NSString stringWithFormat:@"%02li:%02li:%02li",
    //                        lround(floor(time / 3600.)) % 100,
    //                        lround(floor(time / 60.)) % 60,
    //                        lround(floor(time)) % 60];
    //    NSLog(@"############%@",string);
    //通过音量设置UI
    //    NSLog(@"通过音量设置UI");
    if (self.recorder.currentTime > 30) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"录音时间不能超过30秒" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.recordAnimationView removeFromSuperview];
         self.haveVideo = YES;
        
        [self.recorderbutton setHidden:YES];
        [self.playRecorderButton setHidden:NO];
        [self.rerecorderButton setHidden:NO];
        
        [self.recorder stop];
        [self.timer invalidate];
    }
}
/**
 *  时间转换方法
 *
 *  @param totalSeconds 时间转换
 *
 *  @return NO
 */
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
}

/**
 *  录音结束
 */
- (void)cancelRecorder
{
    double cTime = self.recorder.currentTime;
    NSLog(@"(((((((((((((((((((((%f",cTime);
    int time = (int)cTime;
    NSLog(@")))))))))))))))))))%d",time);
    NSString *timeStr = [self timeFormatted:time];
    NSLog(@"录音的总时长为：%@",timeStr);
    // 在这个地方铺设新的播放按钮
    if (cTime > 0.5&&cTime<30.0) {
        [self.recordAnimationView removeFromSuperview];
        [self.timer invalidate];
        self.haveVideo = YES;
        [self.recorderbutton setHidden:YES];
        [self.playRecorderButton setHidden:NO];
        [self.rerecorderButton setHidden:NO];
        NSLog(@"可以发送语音");
    }
//    else if (cTime > 30.0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"录音时间不能超过30秒" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        
//        [self.timer invalidate];
//        self.haveVideo = YES;
//        [self.recorderbutton setHidden:YES];
//        [self.playRecorderButton setHidden:NO];
//        [self.rerecorderButton setHidden:NO];
//    }
    else
    {
        [self.recordAnimationView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"录音时间过短" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        //删除记录的
        [self.recorder deleteRecording];
        //删除存储的
    }
    NSDate *date = [NSDate date];
    NSLog(@">>??????????????%@",date);
    [self.recorder stop];
    [self.timer invalidate];
}
/**
 *  拖拽删除录音
 */
- (void)dragRecorder
{
    [self.recorder deleteRecording];
    [self.timer invalidate];
    [self.recorder stop];
    [self.recordAnimationView removeFromSuperview];

}
/**
 *  播放录音
 */
- (void)playRecorder
{
    
    
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
            [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
            return;
        }
    else
    {
        self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:self.aurl error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
        [self.playRecorderButton setTitle:@"正在播放" forState:(UIControlStateNormal)];
        
    }
//    [self.playRecorderButton setTitle:@"正在播放" forState:(UIControlStateNormal)];
//    
//    [self.avPlayer pause];
//    self.avPlayer = [[AVPlayer alloc]initWithURL:self.aurl];
//    [self.avPlayer play];
    
}
/**
 *  AVaudioPlayer代理方法
 *
 *  @param player
 *  @param flag
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
}


#pragma mark---UIAlertViewController
- (void)showSuccessAlertViewController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的信息已提交" preferredStyle:(UIAlertControllerStyleAlert)];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:nil style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
//    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showFieldAlertViewController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息发布失败，请重新发布" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark---上传文件
/**
 *  发布信息请求
 *
 *  @param pushDic 通过判断设置好的请求参数字典
 */
-(void)pushDataWithDic:(NSMutableDictionary *)pushDic
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    /**
     *  设置请求地址
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url1= getDataURL;
    NSString *url2 = @"/uploadfile?token=";
    NSString *url = [url1 stringByAppendingString:url2];
    NSString *URL = [url stringByAppendingString:token];
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",urlStr);
    NSString *fileNameStr = @"/lll.wav";
    NSString *filePath = [urlStr stringByAppendingString:fileNameStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.wav",str];
    NSLog(@"fileName-----:%@",fileName);

    /**
     *  判断图片数量上传
     *
     *  @param self.imagearray.count 图片数量
     *
     *  @return NO
     */
    //一张图片
    if (self.imagearray.count == 0) {
        [self.manager POST:URL parameters:pushDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (self.haveVideo == YES) {
                [formData appendPartWithFileURL:self.aurl name:@"VoiceDes" error:nil];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic[@"status_code"]isEqualToString:@"200"]) {
                [self.HUD removeFromSuperViewOnHide];
                [self.HUD hideAnimated:YES];
                [self showSuccessAlertViewController];
            }
            else
            {
                [self.HUD removeFromSuperViewOnHide];
                [self.HUD hideAnimated:YES];
                [self showFieldAlertViewController];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.HUD removeFromSuperViewOnHide];
            [self.HUD hideAnimated:YES];
            [self showFieldAlertViewController];
            
        }];
    }
    
    if(self.imagearray != 0)
    {
        if (self.imagearray.count == 1) {
            
            if (self.haveVideo == YES) {
            }
            
            [self.manager POST:URL parameters:pushDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
                if (self.haveVideo == YES) {
                    [formData appendPartWithFileURL:self.aurl name:@"VoiceDes" error:nil];
                }
                [formData appendPartWithFileData:imageData1 name:@"PictureDes1"fileName:@"image1.png" mimeType:@"image/jpg/png/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                if ([dic[@"status_code"]isEqualToString:@"200"]) {
                    [self.HUD removeFromSuperViewOnHide];
                    [self.HUD hideAnimated:YES];
                    [self showSuccessAlertViewController];
                }
                else
                {
                    [self.HUD removeFromSuperViewOnHide];
                    [self.HUD hideAnimated:YES];
                    [self showFieldAlertViewController];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.HUD removeFromSuperViewOnHide];
                [self.HUD hideAnimated:YES];
                [self showFieldAlertViewController];
                NSLog(@"**************%@",error);
                NSLog(@"失败");
            }];
        }
        //两张图片
        else if(self.imagearray.count == 2)
        {
            NSData *imageData2 = UIImageJPEGRepresentation(self.imagearray[1], 1.0f);
            NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
            
            [self.manager POST:URL parameters:pushDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (self.haveVideo == YES)
                {
                    [formData appendPartWithFileURL:self.aurl name:@"VoiceDes" error:nil];
                }
                [formData appendPartWithFileData:imageData1 name:@"PictureDes1"fileName:@"image1.png" mimeType:@"image/jpg/png/jpeg"];
                [formData appendPartWithFileData:imageData2 name:@"PictureDes2" fileName:@"image2.png" mimeType:@"image/jpg/png/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"%@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                if ([dic[@"status_code"]isEqualToString:@"200"])
                {
                    [self.HUD removeFromSuperViewOnHide];
                    [self.HUD hideAnimated:YES];
                    [self showSuccessAlertViewController];
                }
                
                else
                {
                    [self.HUD removeFromSuperViewOnHide];
                    [self.HUD hideAnimated:YES];
                    [self showFieldAlertViewController];
                    
                }
                NSLog(@"%@",dic);
                NSLog(@"成功");
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 [self.HUD removeFromSuperViewOnHide];
                 [self.HUD hideAnimated:YES];
                 [self showFieldAlertViewController];
             }];
        }
        
        //三张图片
        else if(self.imagearray.count == 3)
        {
            [self.manager POST:URL parameters:pushDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                if (self.haveVideo == YES) {
                    
                    [formData appendPartWithFileURL:self.aurl name:@"VoiceDes" error:nil];
                    
                }
                NSData *imageData1 = UIImageJPEGRepresentation(self.imagearray[0], 1.0f);
                NSData *imageData2 = UIImageJPEGRepresentation(self.imagearray[1], 1.0f);
                NSData *imageData3 = UIImageJPEGRepresentation(self.imagearray[2], 1.0f);
                [formData appendPartWithFileData:imageData1 name:@"PictureDes1"fileName:@"image1.png" mimeType:@"image/jpg/png/jpeg"];
                [formData appendPartWithFileData:imageData2 name:@"PictureDes2" fileName:@"image2.png" mimeType:@"image/jpg/png/jpeg"];
                [formData appendPartWithFileData:imageData3 name:@"PictureDes3" fileName:@"image3.png" mimeType:@"image/jpg/png/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"%@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dic[@"status_code"]isEqualToString:@"200"]) {
                    [self.HUD removeFromSuperViewOnHide];
                    [self.HUD hideAnimated:YES];
                    [self showSuccessAlertViewController];
                }
                
                else
                {
                    [self.HUD removeFromSuperViewOnHide];
                    [self.HUD hideAnimated:YES];
                    [self showFieldAlertViewController];
                    
                }
                NSLog(@"%@",dic);
                NSLog(@"成功");
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.HUD removeFromSuperViewOnHide];
                [self.HUD hideAnimated:YES];
                [self showFieldAlertViewController];
                [self.navigationController popViewControllerAnimated:YES];
                
                
                NSLog(@"**************%@",error);
                NSLog(@"失败");
            }];
            
        }
        
    }
    
    
}
/**
 *  扩展方法（仅供参考）
 *
 *  @param audioPath 录音存放路径
 */
-(void)uloadImageWithAudioPath:(NSString *)audioPath
{
    NSString *postUrl = @"url";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{@"username":@"aaa"};
    
    [manager POST:postUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"lll" ofType:@"wav"];
        NSLog(@"%@",filePath);
        NSData *audioData = [NSData dataWithContentsOfFile:filePath];
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.wav",str];
        [formData appendPartWithFileData:audioData name:@"file" fileName:fileName mimeType:@"audio/wav"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        /*
         
         //        /上传进度
         //        // @property int64_t totalUnitCount;     需要下载文件的总大小
         //        // @property int64_t completedUnitCount; 当前已经下载的大小
         //        //
         //        // 给Progress添加监听 KVO
         //        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
         //        // 回到主队列刷新UI,用户自定义的进度条
         //        dispatch_async(dispatch_get_main_queue(), ^{
         //            self.progressView.progress = 1.0 *
         //            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
         //        });
         */
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"上传失败");
        
    }];
    
}
/**
 *  获取时间当前时间
 *
 *  @return NO
 */
- (NSString *)getTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM--dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    return date;
}



#pragma mark----视图代理方法，scrollView、textView
/**
 *  scroView代理方法
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isKindOfClass:[UITextView class]]) {
        NSLog(@"滑动的是TextView");
    }
    else
    {
    [self.view endEditing:YES];
    }
    
}
- (void)didClickRerecorder:(UIButton*)rerecorderButton
{
    [self.playRecorderButton setHidden:YES];
    [self.recorderbutton setHidden:NO];
    [self.rerecorderButton setHidden:YES];
    
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"请输入内容"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
//- (void)textViewDidChange:(UITextView *)textView
//{
//    textView.textColor = [UIColor blackColor];
//}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"请输入内容";
    }
}


#pragma mark----tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"+++++++++++++++++++++++++++++++++++++%ld",self.typeNameArray.count);
    return self.typeNameArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PushStartViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[PushStartViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *text1 = [self.defaults objectForKey:@"0"];
    NSString *text2 = [self.defaults objectForKey:@"1"];
    NSString *text3 = [self.defaults objectForKey:@"2"];
    NSString *text4 = [self.defaults objectForKey:@"3"];
    NSString *text5 = [self.defaults objectForKey:@"4"];
    
    if (text1 == nil) {
        text1 = @"请选择";
    }
    if (text2 ==nil) {
        text2 = @"请选择";
    }
    if (text3==nil) {
        text3 = @"请选择";
    }
    if (text4 == nil) {
        text4 = @"请选择";
    }
    if (text5 == nil) {
        text5 = @"请选择";
    }
    NSArray *labelTextArray = @[text1,text2,text3,text4,text5];
    
    self.pushDataArray = [NSMutableArray arrayWithArray:labelTextArray];
    cell.textName = self.typeNameArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selected = NO;
    cell.LableText = labelTextArray[indexPath.row];
    cell.typeName = self.typeName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    cell.contentView.backgroundColor = [UIColor redColor];
    
    NSArray *allTypearray = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"典当信息",@"融资需求",@"悬赏信息",@"尽职调查",@"委外催收",@"法律服务",@"资产求购",@"担保信息",@"投资需求"];
    NSString *type1 = allTypearray[0];
    NSString *type2 = allTypearray[1];
    NSString *type3 = allTypearray[2];
    NSString *type4 = allTypearray[3];
    NSString *type5 = allTypearray[4];
    NSString *type6 = allTypearray[5];
    NSString *type7 = allTypearray[6];
    NSString *type8 = allTypearray[7];
    NSString *type9 = allTypearray[8];
    NSString *type10 = allTypearray[9];
    NSString *type11 = allTypearray[10];
    NSString *type12 = allTypearray[11];
    NSString *type13 = allTypearray[12];

    
    NSArray *array1 = @[@"抵押",@"信用",@"综合类",@"其他"];
    NSArray *array2 = @[@"个人债权",@"企业商账",@"其他"];
    //    NSArray *array3 = @[@"土地",@"房产",@"汽车",@"项目",@"其他"];
    NSArray *array3 = @[@"个人资产",@"企业资产",@"法拍资产"];
    
    NSArray *array4 = @[@"国企",@"民企",@"上市公司",@"其他"];
    
    NSArray *array5 = @[@"典当"];
    NSArray *array6 = @[@"抵押",@"质押",@"租赁",@"过桥",@"信用",@"担保",@"股权",@"其他"];
    
    NSArray *array7 = @[@"找人",@"找财产"];
    NSArray *array8 = @[@"法律",@"财务",@"税务",@"商业",@"其他"];
    
    NSArray *array9 = @[@"个人债权",@"银行贷款",@"企业商账",@"其他"];
    NSArray *array10 = @[@"民事",@"刑事",@"经济",@"公司"];
    NSArray *array11= @[@"土地",@"房产",@"汽车",@"其他"];
    NSArray *array12 = @[@"担保"];
    //投资需求
    NSArray *laiyuanArray = @[@"银行",@"非银行金融机构",@"企业"];
    NSArray *diaochaArray = @[@"企业",@"个人"];
    NSArray *yongjinArray = @[@"5%-15%",@"15%-30%",@"30%－50%",@"50%以上",@"面议"];
    NSArray *zhuangtaiArray = @[@"已诉讼",@"未诉讼"];
    NSArray *xuqiuArray = @[@"咨询",@"诉讼",@"其他"];
    NSArray *qiugouArray = @[@"个人",@"企业"];
    
    NSArray *touzileixingArray = @[@"个人",@"企业",@"机构",@"其他"];
    NSArray *touzifangshiArray = @[@"债权",@"股权",@"其他"];
    NSArray *touziqixianArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    
    NSArray *biaodiArray = @[@"土地",@"房产",@"汽车",@"项目",@"其他"];
    
    UITableViewCell *cell = (PushStartViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.textLabel.text isEqualToString:@"总金额"] || [cell.textLabel.text isEqualToString:@"转让价"] || [cell.textLabel.text isEqualToString:@"金额"] || [cell.textLabel.text isEqualToString:@"合同金额"] || [cell.textLabel.text isEqualToString:@"回报率"])
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
       PushChooseController *chooseVC = [[PushChooseController alloc]init];
       NSArray *allChooseArray = [NSArray array];
    
    if ([cell.textLabel.text isEqualToString:@"地区"] == NO &&[cell.textLabel.text isEqualToString:@"目标地区"] == NO)
    {
        
        if ([self.typeName isEqualToString:type1]) {
            if ([cell.textLabel.text isEqualToString:@"来源"]) {
                allChooseArray =laiyuanArray;
                chooseVC.soucreArray = allChooseArray;
                chooseVC.navigationItem.title = @"来源";
            }
            else
            {
                allChooseArray = array1;
                chooseVC.soucreArray =allChooseArray;
                chooseVC.navigationItem.title = @"类型";
                
            }
            
        }
        
        else if ([self.typeName isEqualToString:type2])
        {
            allChooseArray = array2;
            chooseVC.soucreArray = allChooseArray;
             chooseVC.navigationItem.title = @"类型";
            
        }
        else if ([self.typeName isEqualToString:type3])
        {
            if ([cell.textLabel.text isEqualToString:@"标的物"]) {
                allChooseArray = biaodiArray;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"标的物";
                
            }
            else
            {
                allChooseArray = array3;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"类型";
                
            }
        }
        else if ([self.typeName isEqualToString:type4])
        {
            allChooseArray = array4;
            chooseVC.soucreArray = allChooseArray;
             chooseVC.navigationItem.title = @"类型";
            
        }
        else if ([self.typeName isEqualToString:type5]||[self.typeName isEqualToString:type12])
        {
            
            if ([self.typeName isEqualToString:type5]) {
                allChooseArray = array5;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"类型";
            }
            
            else
            {
                
                allChooseArray = array12;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"类型";
            }
        }
        else if ([self.typeName isEqualToString:type6])
        {
            allChooseArray = array6;
            chooseVC.soucreArray = allChooseArray;
             chooseVC.navigationItem.title = @"方式";
        }
        else if ([self.typeName isEqualToString:type7])
        {
            allChooseArray = array7;
            chooseVC.soucreArray = allChooseArray;
             chooseVC.navigationItem.title = @"类型";
            
            
        }
        else if ([self.typeName isEqualToString:type8])
        {
            if ([cell.textLabel.text isEqualToString:@"被调查方"]) {
                allChooseArray = diaochaArray;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"被调查方";
            }
            else
            {
                allChooseArray = array8;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"类型";
            }
            
        }
        else if ([self.typeName isEqualToString:type9])
        {
            if ([cell.textLabel.text isEqualToString:@"佣金比例"]) {
                chooseVC.soucreArray = yongjinArray;
                 chooseVC.navigationItem.title = @"佣金比例";
            }
            else if([cell.textLabel.text isEqualToString:@"状态"])
            {
                chooseVC.soucreArray = zhuangtaiArray;
                 chooseVC.navigationItem.title = @"状态";
                
            }
            else
            {
                allChooseArray = array9;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"类型";
            }
            
        }
        else if ([self.typeName isEqualToString:type10])
        {
            if ([cell.textLabel.text isEqualToString:@"需求"]) {
                chooseVC.soucreArray = xuqiuArray;
                 chooseVC.navigationItem.title = @"需求";
                
            }
            else
            {
                allChooseArray = array10;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"类型";
            }
            
            
        }
        else if ([self.typeName isEqualToString:type11])
        {
            if ([cell.textLabel.text isEqualToString:@"求购方"]) {
                chooseVC.soucreArray = qiugouArray;
                 chooseVC.navigationItem.title = @"求购方";
                
            }
            else
            {
                allChooseArray = array11;
                chooseVC.soucreArray = allChooseArray;
                 chooseVC.navigationItem.title = @"类型";
            }
        }
        else if ([self.typeName isEqualToString:type13])
        {
            if ([cell.textLabel.text isEqualToString:@"投资类型"]) {
                chooseVC.soucreArray = touzileixingArray;
                 chooseVC.navigationItem.title = @"投资类型";
                
            }
            else if([cell.textLabel.text isEqualToString:@"投资方式"])
            {
                chooseVC.soucreArray = touzifangshiArray;
                 chooseVC.navigationItem.title = @"投资方式";
            }
            else
            {
                chooseVC.touqixian = @"投资期限";
                chooseVC.soucreArray = touziqixianArray;
                 chooseVC.navigationItem.title = @"投资期限";
                
            }
        }
        
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
 
    else
    {
        ChooseAreaController *areaVC = [[ChooseAreaController alloc]init];
        NSString *num = [NSString stringWithFormat:@"%ld",indexPath.row];
        areaVC.selectCell = num;
        areaVC.type = @"信息";
        [self.navigationController pushViewController:areaVC animated:YES];
        
        NSLog(@"跳转到地区选择控制器");
    }
   
    NSString *num = [NSString stringWithFormat:@"%ld",indexPath.row];
    chooseVC.selectCell = num;
    
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
