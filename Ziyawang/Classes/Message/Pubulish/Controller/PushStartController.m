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

@interface PushStartController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,AVAudioRecorderDelegate,MBProgressHUDDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{

    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (weak, nonatomic) IBOutlet UIView *qingdanView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
//@property (weak, nonatomic) IBOutlet UIButton *playRecorder;

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
@property (nonatomic,strong) NSMutableArray *imagearray;

@property(nonatomic,strong) NSMutableArray *pushDataArray;

@property (nonatomic,strong) NSMutableDictionary *pushDic;

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSUserDefaults *userDefault;


//录音的属性
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) AVPlayer *avPlayer;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) NSURL *aurl;

@property (nonatomic,assign) BOOL haveVideo;

@property (nonatomic,assign) NSInteger x;

@end

@implementation PushStartController

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.defaults = [NSUserDefaults standardUserDefaults];
    
        NSString *token = [self.defaults objectForKey:@"token"];
    NSLog(@"!!!!!!!!!!!!%@",token);
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"---------------%@",self.lableText);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"######################%@",self.view);
   
}




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
        PickerImage.allowsEditing = YES;
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
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    }
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    self.usericonImageView.image = newPhoto;
    
    NSMutableArray *sentimage = [NSMutableArray new];
    [sentimage addObject:newPhoto];
    [self showSelectedPhotos:sentimage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)showSelectedPhotos:(NSArray *)images
{
        self.x ++;
    NSLog(@"X的值未（（（（（（（（（（（%ld",self.x);

    [self.imagearray addObject:images.lastObject];
    if (self.x < 4) {
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(90 * (self.x - 1) + 10 * self.x, 0, 90, 90)];
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
            [self.addImageButton setFrame:CGRectMake(90 * self.x + 10 * self.x, 0, 90, 90)];

        }
        
    }

}
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
        
        [self.addImageButton setFrame:CGRectMake(90 * 2 +10 *2, 0, 90, 90)];
        [self.imagearray removeObject:self.imagearray[2]];
        
        
        [self.addImageButton setHidden:NO];
    }
    else if(a.count == 4)
    {
    
    [[self.addImageView viewWithTag:2]removeFromSuperview];
        [self.addImageButton setFrame:CGRectMake(90+10, 0, 90, 90)];
        [self.imagearray removeObject:self.imagearray[1]];
        

        self.x--;
        NSLog(@"X的值@@@@@@@@@@未%ld",self.x);

    }
    else if(a.count == 3)
    {
        [[self.addImageView viewWithTag:1]removeFromSuperview];
        [self.addImageButton setFrame:CGRectMake(10 , 0, 90, 90)];

        [self.imagearray removeObject:self.imagearray[0]];
        self.x--;
        NSLog(@"X的值###########未%ld",self.x);


    }
    
    

}


#pragma mark---按钮事件，类型判断
//点击发布的事件
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
   
    
//    NSString *token = @"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjMzLCJpc3MiOiJodHRwOlwvXC9hcGkueml5YS56bGwuc2NpZW5jZVwvdjFcL2F1dGhcL2xvZ2luIiwiaWF0IjoiMTQ3MDMwNzYzNCIsImV4cCI6IjE0NzA5MTI0MzQiLCJuYmYiOiIxNDcwMzA3NjM0IiwianRpIjoiNmNjN2RlZDJiNWJlMGJmZWQxNDk5YThkOTljM2UzYzUifQ.REoP-uvrzmqjHJDZeG3mkoGh-lLc2sUMOj5bqh26a34";
//    
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
        
        
        
        [self.pushDic setObject:ProArea forKey:@"ProArea"];
        [self.pushDic setObject:self.TypeID forKey:@"TypeID"];
        [self.pushDic setObject:self.contentTextView.text forKey:@"WordDes"];
        [self.pushDic setObject:@"token" forKey:@"access_token"];
        //照片
        //语音
        if ([self.pushDic[@"TransferMoney"]isEqualToString:@"请选择"]||[self.pushDic[@"AssetType"]isEqualToString:@"请选择"]||self.pushDic[@"ProArea"]==nil||[self.pushDic[@"WordDes"]isEqualToString:@"请输入内容"]||self.imagearray.count==0)
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
    
   
 
}

#pragma mark---UIAlertViewController
- (void)showSuccessAlertViewController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的信息已提交" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:action1];
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

//发布按钮的点击事件，发布信息
-(void)pushDataWithDic:(NSMutableDictionary *)pushDic
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url1= @"http://api.ziyawang.com/v1";
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

    
//    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain" ,nil];
//    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    self.manager.responseSerializer= [AFJSONResponseSerializer serializer];
//    [self.manager.securityPolicy setAllowInvalidCertificates:YES];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [self.manager POST:URL parameters:pushDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileURL:self.aurl name:@"VoiceDes" error:nil];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"成功");
////        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////        NSLog(@"%@",dic);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败");
//    }];
 
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
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    
    
//         if(self.haveVideo == YES)
//    {
//        
//        //        pushDic setObject:@"" forKey:<#(nonnull id<NSCopying>)#>
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        //设置时间格式
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.wav",str];
//        
//        NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//        NSLog(@"%@",urlStr);
//        NSString *fileNameStr = @"lll.wav";
//        NSString *filePath = [urlStr stringByAppendingString:fileNameStr];
//        [pushDic setObject:fileName forKey:@"VoiceDes"];
//        
//        [self.manager POST:URL parameters:pushDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            
////            NSString *filePath = [[NSBundle mainBundle]pathForResource:@"lll" ofType:@"wav"];
//            NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//            NSLog(@"%@",urlStr);
//            NSString *fileNameStr = @"lll.wav";
//            NSString *filePath = [urlStr stringByAppendingString:fileNameStr];
//            NSLog(@"－－－－－－－－－%@",filePath);
//            
////            NSData *audioData = [NSData dataWithContentsOfFile:filePath];
//            
////            NSLog(@"___________！！！！！音频文件%@",audioData);
////           ，上传文件时，文件不允许被覆盖，文件重名
////             要解决此问题，
////           使用当前的系统事件作为文件名
//     
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            //设置时间格式
//            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *str = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.wav",str];
////            [formData appendPartWithFileData:audioData name:@"VoiceDes" fileName:fileName mimeType:@"audio/wav"];
//            [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:@"VoiceDes" error:nil];
//            
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            NSLog(@"%@",uploadProgress);
//            //        /上传进度
//            //        // @property int64_t totalUnitCount;     需要下载文件的总大小
//            //        // @property int64_t completedUnitCount; 当前已经下载的大小
//            //        //
//            //        // 给Progress添加监听 KVO
//            //        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//            //        // 回到主队列刷新UI,用户自定义的进度条
//            //        dispatch_async(dispatch_get_main_queue(), ^{
//            //            self.progressView.progress = 1.0 *
//            //            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//            //        });
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息发布成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
////            [alert show];
////            [self MBProgressWithString:@"信息发布成功！" timer:1 mode:MBProgressHUDModeText];
//            [self.navigationController popViewControllerAnimated:YES];
//            NSLog(@"上传音频成功_____%@",dic);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息发布失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
////            [alert show];
////            [self MBProgressWithString:@"发布信息失败，请重新发送" timer:1 mode:MBProgressHUDModeText];
//            [self.navigationController popViewControllerAnimated:YES];
//            NSLog(@"!!!!!!!!!!!!错误信息%@",error);
//            NSLog(@"上传音频失败");
//            
//        }];
//    }
    
    }



//- (void)upload
//{
//    
//    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSLog(@"%@",urlStr);
//    NSString *fileName = @"lll.wav";
//    
//    NSString *urlpath = [urlStr stringByAppendingString:fileName];
//    NSURL *Url2 = [NSURL URLWithString:urlpath];
//    NSURL *Url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.wav",urlStr]];
//    
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:Url options:nil];
//    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
//    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
//    
//    NSString *mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/output-%@.wav", [formater stringFromDate:[NSDate date]]];
//    exportSession.outputURL = [NSURL fileURLWithPath:mp4Path];
//    exportSession.outputFileType = AVFileTypeMPEGLayer3;
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        switch ([exportSession status]) {
//            case AVAssetExportSessionStatusFailed:
//            {
//                
//                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误"
//                                                                message:[[exportSession error] localizedDescription]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles: nil];
//                [alert show];
//                break;
//            }
//                
//            case AVAssetExportSessionStatusCancelled:
//                
//                break;
//            case AVAssetExportSessionStatusCompleted:
//            {
//                
//                //text/plain
//                self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//                self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//                [self.manager POST:URL parameters:pushDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                    NSData *videoData = [NSData dataWithContentsOfFile:mp4Path];
//                    [formData appendPartWithFileData:videoData name:@"VoiceDes" fileName:@"video000.mp3" mimeType:@"audio/mpeglayer3"];
//                    
//                } progress:^(NSProgress * _Nonnull uploadProgress) {
//                    
//                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    NSLog(@"上传音频成功！！！！！！");
//                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    NSLog(@"上传音频失败！！！！！！！%@",error);
//                }];
//                
//                break;
//            }
//            default:
//                break;
//        }
//    }];
  
//  */

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
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取信息失败，请检查您的网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"上传失败");
        
    }];
    
}

- (NSString *)getTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM--dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    return date;
    
}

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

//录音
- (void)startRecorder

{
    NSDate *date = [NSDate date];
    NSLog(@"-----------%@",date);
    if(self.recorder.currentTime == 0)
    {
        if ([self.recorder prepareToRecord]) {
            [self.recorder record];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectVoice) userInfo:nil repeats:YES];
    }
    else
    {
        [self playRecorder];
        
    }
}

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
    
    
    
}
//时间转换
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
}

//太短
- (void)cancelRecorder
{
    double cTime = self.recorder.currentTime;
    NSLog(@"(((((((((((((((((((((%f",cTime);
    int time = (int)cTime;
    NSLog(@")))))))))))))))))))%d",time);
    NSString *timeStr = [self timeFormatted:time];
    NSLog(@"录音的总时长为：%@",timeStr);
    // 在这个地方铺设新的播放按钮
  
    
    if (cTime > 0.5) {
        [self.timer invalidate];
        self.haveVideo = YES;
        [self.recorderbutton setHidden:YES];
        [self.playRecorderButton setHidden:NO];
        [self.rerecorderButton setHidden:NO];
        NSLog(@"可以发送语音");
    }else
    {
        //删除记录的
        [self.recorder deleteRecording];
        //删除存储的
    }
    
    NSDate *date = [NSDate date];
    NSLog(@">>??????????????%@",date);
    
    [self.recorder stop];
    [self.timer invalidate];
}
//拖拽删除
- (void)dragRecorder
{
    [self.recorder deleteRecording];
    [self.timer invalidate];
    [self.recorder stop];
    
}
//播放
- (void)playRecorder
{
    
    //    if ([self.audioPlayer isPlaying]) {
    //        [self.audioPlayer stop];
    //        return;
    //
    //    }
    //    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:self.aurl error:nil];
    //    [self.audioPlayer play];
    [self.avPlayer pause];
    self.avPlayer = [[AVPlayer alloc]initWithURL:self.aurl];
    [self.avPlayer play];
    
    }

- (void)leftBarButtonAction:(UIBarButtonItem *)barbutton
{
//    [self.defaults removeObjectForKey:@"0"];
//    [self.defaults removeObjectForKey:@"1"];
//    [self.defaults removeObjectForKey:@"2"];
//    [self.defaults removeObjectForKey:@"3"];
//    [self.defaults removeObjectForKey:@"4"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)popAction:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    if ([self.typeName isEqualToString:@"资产包转让"]==NO) {
        [self.qingdanView setHidden:YES];
    }
    self.navigationItem.title =self.typeName;
    self.x = 0;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popAction:)];
    
    self.manager = [AFHTTPSessionManager manager];
    self.celldic = [NSMutableDictionary dictionary];
    self.imagearray = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonAction:)];
    
    [self.tableView registerClass:[PushStartViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);
    self.contentTextView.text = @"请输入内容";
       self.contentTextView.delegate = self;
    self.contentTextView.textColor = [UIColor lightGrayColor];
    NSArray *array1 = @[@"资产包类型",@"来源",@"总金额",@"转让价",@"地区"];
    NSArray *array2 = @[@"类型",@"总金额",@"转让价",@"地区"];
    
    
    NSArray *array3 = @[@"类型",@"转让价",@"地区"];
    
    
    
    NSArray *array4 = @[@"买方性质",@"合同金额",@"地区"];
    NSArray *array5 = @[@"类型",@"金额",@"地区"];
    NSArray *array6 = @[@"方式",@"金额",@"回报率",@"地区"];
    NSArray *array7 = @[@"类型",@"悬赏金额",@"地区"];
    NSArray *array8 = @[@"类型",@"被调查方",@"目标地区"];
    NSArray *array9 = @[@"类型",@"金额",@"佣金比例",@"状态",@"地区"];
    NSArray *array10 = @[@"类型",@"需求",@"地区"];
    NSArray *array11= @[@"类型",@"求购方",@"地区"];
    NSArray *array12 = @[@"类型",@"金额",@"地区"];

     NSArray *allTypearray = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"典当信息",@"融资需求",@"悬赏信息",@"尽职调查",@"委外催收",@"法律服务",@"资产求购",@"担保信息"];
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
    
    NSLog(@"#################%@",self.typeNameArray);
    //初始化录音机
      [self setaudio];
    
    [self.startPushButton setBackgroundColor:[UIColor colorWithHexString:@"fdd000"]];
    
    
    UIButton *deleteButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [deleteButton setFrame:CGRectMake(90 * 3 + 60, 30, 30, 30)];
//    [deleteButton setTitle:@"撤销" forState:(UIControlStateNormal)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"chexiao"] forState:(UIControlStateNormal)];
    [deleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.addImageView addSubview:deleteButton];
    
    
    self.addImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addImageButton setFrame:CGRectMake(10, 0, 90, 90)];
    [self.addImageButton setBackgroundImage:[UIImage imageNamed:@"tianjia"] forState:(UIControlStateNormal)];
    UILabel *tianjia = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 90, 20)];
    tianjia.text = @"添加图片";
    tianjia.textColor = [UIColor colorWithHexString:@"fdd000"];
    tianjia.font = [UIFont systemFontOfSize:11];
    tianjia.textAlignment = NSTextAlignmentCenter;
    [self.addImageButton addSubview:tianjia];
    
     [self.addImageView addSubview:self.addImageButton];
//    [self.addImageButton setTitle:@"添加" forState:(UIControlStateNormal)];
    [self.addImageButton addTarget:self action:@selector(didClickChooseImage:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //录音与播放按钮
    self.recorderbutton =[UIButton buttonWithType:(UIButtonTypeSystem)];
//        [self.recorderbutton setTitle:@"录音" forState:(UIControlStateNormal)];
    [self.recorderbutton setBackgroundImage:[UIImage imageNamed:@"changluyin"] forState:(UIControlStateNormal)];
    
    [self.recorderbutton setFrame:CGRectMake(75, 5, 100, 30)];
    [self.audioView addSubview:self.recorderbutton];
    
    
    [self.recorderbutton addTarget:self action:@selector(startRecorder) forControlEvents:UIControlEventTouchDown];
    [self.recorderbutton addTarget:self action:@selector(cancelRecorder) forControlEvents:UIControlEventTouchUpInside];
    [self.recorderbutton addTarget:self action:@selector(dragRecorder) forControlEvents:UIControlEventTouchDragExit];
    
    self.playRecorderButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.playRecorderButton setFrame:CGRectMake(75, 5, 100, 30)];
    [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
    [self.playRecorderButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
//    [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
    [self.audioView addSubview:self.playRecorderButton];
    [self.playRecorderButton setBackgroundImage:[UIImage imageNamed:@"yuyinbofang"] forState:(UIControlStateNormal)];
  
    
    self.rerecorderButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    [self.rerecorderButton setTitle:@"重录" forState:(UIControlStateNormal)];
    [self.rerecorderButton setFrame:CGRectMake(85 + self.playRecorderButton.bounds.size.width, 13, 15, 15)];
    ;
    
    
    [self.rerecorderButton setBackgroundImage:[UIImage imageNamed:@"chexiao"] forState:(UIControlStateNormal)];
    
    
    [self.audioView addSubview:self.rerecorderButton];
    [self.rerecorderButton setHidden:YES];
    [self.playRecorderButton setHidden:YES];
    
    
    [self.playRecorderButton addTarget:self action:@selector(playRecorder) forControlEvents:UIControlEventTouchUpInside];

    [self.rerecorderButton addTarget:self action:@selector(didClickRerecorder:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    self.scrollView.delegate = self;
    
//    [self.recordButton addTarget:self action:@selector(startRecorder) forControlEvents:UIControlEventTouchDown];
//    [self.recordButton addTarget:self action:@selector(cancelRecorder) forControlEvents:UIControlEventTouchUpInside];
//    [self.recordButton addTarget:self action:@selector(dragRecorder) forControlEvents:UIControlEventTouchDragExit];
    
//    [self.playButton addTarget:self action:@selector(playRecorder) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];

}
- (void)didClickRerecorder:(UIButton*)rerecorderButton
{
    [self.playRecorderButton setHidden:YES];
    [self.recorderbutton setHidden:NO];
    [self.rerecorderButton setHidden:YES];
    

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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


    

//    if ([text1 isEqualToString:@""]==NO) {
//         UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width - 100, 10, 70, 20)];
//        label.text = text1;
//        NSLog(@"*******************************%@",text1);
//        [cell1.contentView addSubview:label];
//        
//    }
//    if([text2 isEqualToString:@""]==NO)
//    {
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width - 100, 10, 70, 20)];
////        label.text = self.celldic[@"text"];
//        label.text = text2;
//        
//        [cell2.contentView addSubview:label];
//    }
//    if ([text3 isEqualToString:@""] == NO) {
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width - 100, 10, 70, 20)];
//
//        [cell3.contentView addSubview:label];
//    }
//    if ([text4 isEqualToString:@""] == NO) {
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width - 100, 10, 70, 20)];
//        
//        [cell4.contentView addSubview:label];
//    }
//    if ([text5 isEqualToString:@""] == NO) {
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width - 100, 10, 70, 20)];
//        
//        [cell5.contentView addSubview:label];
//    }
   
    cell.textName = self.typeNameArray[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selected = NO;
        cell.LableText = labelTextArray[indexPath.row];
    
        cell.typeName = self.typeName;
//    if ([cell.textLabel.text isEqualToString:@"地区"]||[cell.textLabel.text isEqualToString:@"目标地区"]) {
//        
//        for (UILabel *lable in cell.contentView.subviews) {
//            if ([lable.text isEqualToString:@"请选择"]) {
//                lable.text = self.areaString;
//                NSLog(@"地区～～～～～～～～～～～～～～～%@",lable.text);
//            }
//        }
//
//    }
   
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor redColor];
    
    NSArray *allTypearray = @[@"资产包转让",@"债权转让",@"固产转让",@"商业保理",@"典当信息",@"融资需求",@"悬赏信息",@"尽职调查",@"委外催收",@"法律服务",@"资产求购",@"担保信息"];
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
    
    NSArray *array1 = @[@"抵押",@"信用",@"综合类",@"其他"];
    NSArray *array2 = @[@"个人债权",@"企业商账",@"其他"];
    NSArray *array3 = @[@"土地",@"房产",@"汽车",@"项目",@"其他"];
    
    NSArray *array4 = @[@"国企",@"民企",@"上市公司",@"其他"];
    
    NSArray *array5 = @[@"典当"];
    NSArray *array6 = @[@"抵押",@"质押",@"租赁",@"过桥",@"信用"];
    
    NSArray *array7 = @[@"找人",@"找财产"];
    NSArray *array8 = @[@"法律",@"财务",@"税务",@"商业",@"其他"];
    
    NSArray *array9 = @[@"个人债权",@"银行贷款",@"企业商账"];
    NSArray *array10 = @[@"民事",@"刑事",@"经济",@"公司"];
    NSArray *array11= @[@"土地",@"房产",@"汽车",@"其他"];
    NSArray *array12 = @[@"担保"];
    
    NSArray *laiyuanArray = @[@"银行",@"非银行金融机构",@"企业"];
    NSArray *diaochaArray = @[@"企业",@"个人"];
    NSArray *yongjinArray = @[@"5%-15%",@"15%-30%",@"30%－50%",@"50%以上"];
    NSArray *zhuangtaiArray = @[@"已诉讼",@"未诉讼"];
    NSArray *xuqiuArray = @[@"咨询",@"诉讼",@"其他"];
    NSArray *qiugouArray = @[@"个人",@"企业"];
    
    
    UITableViewCell *cell = (PushStartViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.textLabel.text isEqualToString:@"总金额"] || [cell.textLabel.text isEqualToString:@"转让价"] || [cell.textLabel.text isEqualToString:@"金额"] || [cell.textLabel.text isEqualToString:@"合同金额"] || [cell.textLabel.text isEqualToString:@"回报率"])
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        if (cell.textLabel.text isEqualToString:@"总金额")
//        {
//        
//        }

//        [cell isSelected];
    }
    
    
    
    PushChooseController *chooseVC = [[PushChooseController alloc]init];
    
//    UINavigationController *chooseVC = [[UINavigationController alloc]initWithRootViewController:choosevc];
    
    
    
    NSArray *allChooseArray = [NSArray array];
    
    if ([cell.textLabel.text isEqualToString:@"地区"] == NO &&[cell.textLabel.text isEqualToString:@"目标地区"] == NO)
    {
    
    if ([self.typeName isEqualToString:type1]) {
        if ([cell.textLabel.text isEqualToString:@"来源"]) {
            allChooseArray =laiyuanArray;
            chooseVC.soucreArray = allChooseArray;
        }
        else
        {
            allChooseArray = array1;
            chooseVC.soucreArray =allChooseArray;
            
        }
        
    }
        
    else if ([self.typeName isEqualToString:type2])
    {
        allChooseArray = array2;
        chooseVC.soucreArray = allChooseArray;


    }
    else if ([self.typeName isEqualToString:type3])
    {
        allChooseArray = array3;
        chooseVC.soucreArray = allChooseArray;


    }
    else if ([self.typeName isEqualToString:type4])
    {
        allChooseArray = array4;
        chooseVC.soucreArray = allChooseArray;


    }
    else if ([self.typeName isEqualToString:type5]||[self.typeName isEqualToString:type12])
    {
        
        if ([self.typeName isEqualToString:type5]) {
            allChooseArray = array5;
            chooseVC.soucreArray = allChooseArray;
            
        }
        
        else
        {
        
        allChooseArray = array12;
        chooseVC.soucreArray = allChooseArray;
        }
    }
    else if ([self.typeName isEqualToString:type6])
    {
        allChooseArray = array6;
        chooseVC.soucreArray = allChooseArray;
    }
    else if ([self.typeName isEqualToString:type7])
    {
        allChooseArray = array7;
        chooseVC.soucreArray = allChooseArray;


    }
    else if ([self.typeName isEqualToString:type8])
    {
        if ([cell.textLabel.text isEqualToString:@"被调查方"]) {
            allChooseArray = diaochaArray;
            chooseVC.soucreArray = allChooseArray;
            
        }
        else
        {
        allChooseArray = array8;
        chooseVC.soucreArray = allChooseArray;
        }

    }
    else if ([self.typeName isEqualToString:type9])
    {
        if ([cell.textLabel.text isEqualToString:@"佣金比例"]) {
            chooseVC.soucreArray = yongjinArray;
        }
        else if([cell.textLabel.text isEqualToString:@"状态"])
        {
            chooseVC.soucreArray = zhuangtaiArray;
            
        }
        else
        {
        allChooseArray = array9;
        chooseVC.soucreArray = allChooseArray;
        }

    }
    else if ([self.typeName isEqualToString:type10])
    {
        if ([cell.textLabel.text isEqualToString:@"需求"]) {
            chooseVC.soucreArray = xuqiuArray;
            
        }
        else
        {
        allChooseArray = array10;
        chooseVC.soucreArray = allChooseArray;
        }


    }
    else if ([self.typeName isEqualToString:type11])
    {
        if ([cell.textLabel.text isEqualToString:@"求购方"]) {
            chooseVC.soucreArray = qiugouArray;
            
        }
        else
        {
            allChooseArray = array11;
            chooseVC.soucreArray = allChooseArray;
        }
    }
    [self.navigationController pushViewController:chooseVC animated:YES];
    }
    
//    else if ([self.typeName isEqualToString:type12])
//    {
//        allChooseArray = array12;
//        chooseVC.soucreArray = allChooseArray;
//        }
    
    
    else
    {
        ChooseAreaController *areaVC = [[ChooseAreaController alloc]init];
        NSString *num = [NSString stringWithFormat:@"%d",indexPath.row];
        areaVC.selectCell = num;
        areaVC.type = @"信息";
        [self.navigationController pushViewController:areaVC animated:YES];
        
        NSLog(@"跳转到地区选择控制器");
    }
//
//    NSArray *type = @[@"来源",@"被调查方",@"佣金比例",@"需求",@"求购方",@"状态"];
//    
//    if ([cell.textLabel.text isEqualToString:type[0]]) {
//        allChooseArray =laiyuanArray;
//        chooseVC.soucreArray = allChooseArray;
//    }
//    else if ([cell.textLabel.text isEqualToString:type[1]])
//    {
//        allChooseArray =diaochaArray;
//        chooseVC.soucreArray = allChooseArray;
//    
//    }
//    else if ([cell.textLabel.text isEqualToString:type[2]])
//    {
//        allChooseArray =yongjinArray;
//        chooseVC.soucreArray = allChooseArray;
//    }
//    else if ([cell.textLabel.text isEqualToString:type[3]])
//    {
//        allChooseArray =xuqiuArray;
//        chooseVC.soucreArray = allChooseArray;
//    }
//    else if ([cell.textLabel.text isEqualToString:type[4]])
//    {
//        
//        allChooseArray =qiugouArray;
//        chooseVC.soucreArray = allChooseArray;
//    }
//    else if ([cell.textLabel.text isEqualToString:type[5]])
//    {
//        
//        allChooseArray =zhuangtaiArray;
//        chooseVC.soucreArray = allChooseArray;
//    }
//    
//    
    NSString *num = [NSString stringWithFormat:@"%ld",indexPath.row];
    chooseVC.selectCell = num;
    
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
