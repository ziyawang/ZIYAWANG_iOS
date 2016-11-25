//
//  AddImageManager.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddImageManager : NSObject
@property (nonatomic,strong) UIImageView *addImageView;

@property (nonatomic,strong) UIImageView *imageOne;
@property (nonatomic,strong) UIImageView *imageTwo;
@property (nonatomic,strong) UIImageView *imageThree;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) UIViewController *VC;

+ (AddImageManager *)AddManager;

- (void)setAddimageViewWithView:(UIView *)imageBackView target:(id)target;
@end
