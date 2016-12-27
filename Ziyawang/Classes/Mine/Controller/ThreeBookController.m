//
//  ThreeBookController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/23.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ThreeBookController.h"
#import "HttpManager.h"
#import "AddImageManager.h"
@interface ThreeBookController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;

@end

@implementation ThreeBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"三证认证";
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    
    [[AddImageManager AddManager]setAddimageViewWithView:self.imageBackView target:self];
    
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagesGestureAction:)];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagesGestureAction:)];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagesGestureAction:)];

    [self.imageView1 addGestureRecognizer:gesture1];
    [self.imageView2 addGestureRecognizer:gesture2];
    [self.imageView3 addGestureRecognizer:gesture3];
    
    self.imageView1.userInteractionEnabled = YES;
    self.imageView2.userInteractionEnabled = YES;
    self.imageView3.userInteractionEnabled = YES;
    
}
- (void)imagesGestureAction:(UITapGestureRecognizer *)gesture
{

}

- (IBAction)upLoadButtonAction:(id)sender {
    if ([[AddImageManager AddManager] getImageArray].count == 0) {
        [AlertView showAlertWithMessage:@"请先添加至少一张图片" target:self];
        return;
    }
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[UploadStarImagesURL stringByAppendingString:@"?token="]stringByAppendingString:token];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"token" forKey:@"access_token"];
    [param setObject:@"5" forKey:@"StarID"];
    [param setObject:@"三证认证" forKey:@"PayName"];
    
    [[HttpManager httpManager]postDataWithURL:URL ImageArray:[[AddImageManager AddManager] getImageArray] audioURL:nil param:param];
    
    [HttpManager httpManager].ifpop = ^(NSString *statu)
    {
        [self.navigationController popViewControllerAnimated:YES];
    };
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
