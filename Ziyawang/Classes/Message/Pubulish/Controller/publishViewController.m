//
//  publishViewController.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "publishViewController.h"
#import "SuPhotoPicker.h"
@interface publishViewController ()

@end

@implementation publishViewController
- (IBAction)fabu:(id)sender {
    SuPhotoPicker *picker = [[SuPhotoPicker alloc]init];
    picker.selectedCount = 12;
    picker.preViewCount = 15;
    __weak typeof(self) weakSelf = self;
    [picker showInSender:self handle:^(NSArray<UIImage *> *photos) {
        [weakSelf showSelectedPhotos:photos];
    }];
}

- (void)showSelectedPhotos:(NSArray *)images
{
    for (int i = 0; i < images.count; i ++) {
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(50 * i, 200, 50, 50)];
        iv.image = images[i];
        [self.view addSubview:iv];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
