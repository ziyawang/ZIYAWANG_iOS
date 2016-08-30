//
//  ScrollHeadView.h
//  customScrollView
//
//  Created by mac on 16/8/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scrollHeadViewDelegate <NSObject>

- (void)didTapScrollHeadView;

@end

@interface ScrollHeadView : UIView

-(instancetype)initWithFrame:(CGRect)frame arraySource:(NSMutableArray *)arraySource;
@property (nonatomic,assign) id<scrollHeadViewDelegate> Mydelegate;
@end
