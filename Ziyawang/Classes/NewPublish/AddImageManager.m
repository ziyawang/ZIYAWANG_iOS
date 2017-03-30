//
//  AddImageManager.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "AddImageManager.h"
#import "UIView+Extension.h"
#import <AVFoundation/AVFoundation.h>

@interface AddImageManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,assign) NSInteger tag;
@end

@implementation AddImageManager
+(AddImageManager *)AddManager
{
    static AddImageManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[AddImageManager alloc]init];
    });
    return defaultManager;
}
- (void)setAddimageViewWithView:(UIView *)imageBackView target:(id)target
{
    self.tag = imageBackView.tag;
    
    self.VC = target;
    
    self.imageArray = [NSMutableArray new];
    
    self.imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 90)];
    self.imageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(10 * 2 + 90, 10, 90, 90)];
    self.imageThree = [[UIImageView alloc]initWithFrame:CGRectMake(10 * 3 + 90 * 2, 10, 90, 90)];
    
    [self.imageTwo setHidden:YES];
    [self.imageThree setHidden:YES];
    
    
    UIButton *deleteButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [deleteButton setFrame:CGRectMake(10*3 + 90*3 +10, 30, 30, 30)];
    
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
    
    
    //[deleteButton setTitle:@"撤销" forState:(UIControlStateNormal)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"chexiao"] forState:(UIControlStateNormal)];
    [deleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    deleteButton.centerY = self.imageOne.centerY;
    
    [imageBackView addSubview:deleteButton];
    
//    self.imageOne.backgroundColor = [UIColor redColor];
//    self.imageTwo.backgroundColor = [UIColor redColor];
//    self.imageThree.backgroundColor = [UIColor redColor];
    
    self.imageOne.userInteractionEnabled = YES;
    self.imageTwo.userInteractionEnabled = YES;
    self.imageThree.userInteractionEnabled = YES;

    self.imageOne.image = [UIImage imageNamed:@"camera"];
    self.imageTwo.image = [UIImage imageNamed:@"camera"];
    self.imageThree.image = [UIImage imageNamed:@"camera"];

   
    [imageBackView addSubview:self.imageOne];
    [imageBackView addSubview:self.imageTwo];
    [imageBackView addSubview:self.imageThree];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
    
    [self.imageOne addGestureRecognizer:gesture1];
    [self.imageTwo addGestureRecognizer:gesture2];
    [self.imageThree addGestureRecognizer:gesture3];
    
//    for (int i = 0; i < 3; i ++) {
//        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10 * (i+1) + 90 * i, 10, 90, 90)];
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
//        [imageV addGestureRecognizer:gesture];
//        imageV.backgroundColor = [UIColor redColor];
//        [imageBackView addSubview:imageV];
//    }
    
}
- (void)tapImageAction:(UITapGestureRecognizer *)gesture
{
    self.addImageView = (UIImageView *)gesture.view;
    
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
//        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self.VC presentViewController:PickerImage animated:YES completion:nil];
        
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
//        PickerImage.allowsEditing = YES;
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
            [self.VC presentViewController:PickerImage animated:YES completion:nil];
        }
    }]];
    
    
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.VC presentViewController:alert animated:YES completion:nil];
}

- (void)didClickDeleteButton:(UIButton *)deleteButton
{
    if (self.imageArray.count == 0) {
    }
    else if(self.imageArray.count == 1)
    {
        self.imageOne.image = [UIImage imageNamed:@"camera"];
        [self.imageTwo setHidden:YES];
        [self.imageArray removeObjectAtIndex:0];
    }
    else if(self.imageArray.count == 2)
    {
        self.imageTwo.image = [UIImage imageNamed:@"camera"];
        [self.imageThree setHidden:YES];
        [self.imageArray removeObjectAtIndex:1];
        
    }
  
    else if(self.imageArray.count == 3)
    {
        self.imageThree.image = [UIImage imageNamed:@"camera"];
        [self.imageArray removeObjectAtIndex:2];
    }
}

#pragma mark - 实现代理方法
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _addImageView.image = newPhoto;
    
    [self.imageArray addObject:_addImageView.image];
    
    if (self.tag != 1001) {
        if (self.imageArray.count == 1) {
            [self.imageTwo setHidden:NO];
        }
        if (self.imageArray.count == 2) {
            [self.imageThree setHidden:NO];
        }
    }
    
    [self.VC dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)getImageArray
{
    return self.imageArray;
}


@end
