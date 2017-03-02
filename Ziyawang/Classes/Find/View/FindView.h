//
//  FindView.h
//  Ziyawang
//
//  Created by Mr.Xu on 2017/2/20.
//  Copyright © 2017年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindButton.h"

@interface FindView : UIView
typedef void(^strBlock)(NSString *);
typedef void(^strBlock2)(NSString *a,NSString *b);

@property (nonatomic,copy) strBlock strblock1;
@property (nonatomic,copy) strBlock strblock2;
@property (nonatomic,copy) strBlock2 strblock3;
@property (nonatomic,strong) NSArray *sourArrayOne;
@property (nonatomic,strong) NSArray *sourArrayTwo;
@property (nonatomic,strong) NSArray *sourArrayThree;
@property (nonatomic,strong) NSArray *titleArray;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray;

@end
