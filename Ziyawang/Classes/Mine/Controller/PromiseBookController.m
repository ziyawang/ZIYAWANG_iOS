//
//  PromiseBookController.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/23.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "PromiseBookController.h"
#import "AddImageManager.h"
#import "HttpManager.h"
@interface PromiseBookController ()<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *promiseImage;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) UIDocumentInteractionController *documentController;

@end

@implementation PromiseBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"承诺书认证";
    
    UIColor *color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    
    self.imageBackView.tag = 1001;
    [[AddImageManager AddManager]setAddimageViewWithView:self.imageBackView target:self];
    self.postButton.layer.borderWidth = 1.5;
    self.postButton.layer.borderColor = [UIColor colorWithHexString:@"fdd000"].CGColor;
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
}
- (IBAction)downLoadPromiseBookButtonAction:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://images.ziyawang.com/star/ziya.doc"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [filePath stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"filePath:%@",path);
        self.path = path;
        
        
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"filePath:%@",filePath);
        [AlertView showAlertWithMessage:@"下载完毕，请在下列应用中选择一个打开文件" target:self];
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.path]];
        self.documentController.delegate = self;
        self.documentController.UTI = @"com.microsoft.word.doc";
        [self.documentController presentOpenInMenuFromRect:CGRectMake(760, 20, 100, 100) inView:self.view animated:YES];
    }];
    [downloadTask resume];
    
}
- (IBAction)postPromiseBookButtonAction:(id)sender {
    if ([[AddImageManager AddManager] getImageArray].count == 0) {
        [AlertView showAlertWithMessage:@"请先添加承诺书照片" target:self];
        return;
        
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *URL = [[UploadStarImagesURL stringByAppendingString:@"?token="]stringByAppendingString:token];

    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"token" forKey:@"access_token"];
    [param setObject:@"4" forKey:@"StarID"];
    [param setObject:@"承诺书认证" forKey:@"PayName"];
    
    [[HttpManager httpManager]postDataWithURL:URL ImageArray:[[AddImageManager AddManager] getImageArray] audioURL:nil param:param];
    [HttpManager httpManager].ifpop = ^(NSString *statu)
    {
        [self.navigationController popViewControllerAnimated:YES];
    };

//    [self.manager POST:URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *imageData1 = UIImageJPEGRepresentation(self.promiseImage.image, 1.0f);
//        [formData appendPartWithFileData:imageData1 name:@"PictureDes1"fileName:@"image1.png" mimeType:@"image/jpg/png/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"上传成功");
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"上传失败");
//
//    }];
    
 
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
