//
//  LBTabBar.h
//  XianYu
//
//  Created by Mr.Xu on 16/5/28.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBTabBar;

@protocol LBTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar;
@end


@interface LBTabBar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<LBTabBarDelegate> myDelegate ;

@end
