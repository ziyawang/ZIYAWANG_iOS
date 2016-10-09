//
//  FontLayout.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/30.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "FontLayout.h"
#import "SDVersion.h"
#import "SDiOSVersion.h"



@implementation FontLayout

- (void)setFontForLable:(NSMutableArray *)LableArray
{
    //    self.messageLable.text = DeviceVersionNames[[SDiOSVersion deviceVersion]];
   
   
   if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        for (UILabel *lable in LableArray) {
            lable.font = [UIFont systemFontOfSize:14];
            
        }
    }
    else
    {
        for (UILabel *lable in LableArray) {
            lable.font = [UIFont systemFontOfSize:12];
            
        }
    
    }
}

- (void)setFontForButton:(NSMutableArray *)ButtonArray
{

    if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        for (UIButton *button in ButtonArray) {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    else
    {
        for (UIButton *button in ButtonArray) {
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            
        }
        
    }
}


@end
