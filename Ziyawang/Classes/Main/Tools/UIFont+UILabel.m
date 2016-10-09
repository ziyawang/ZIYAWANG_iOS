//
//  UIFont+UILabel.m
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/14.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "UIFont+UILabel.h"

@implementation UIFont (UILabel)

//+(UIFont *)fontWithLabel:(UILabel *)label
//{
//   
//}
+ (UIFont *)FontForLabel
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return [UIFont systemFontOfSize:10];
        
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return [UIFont systemFontOfSize:12];;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return [UIFont systemFontOfSize:12];;
        
    }
else
{
   return [UIFont systemFontOfSize:12];;
}
}

+ (UIFont *)FontForVideoDesLabel
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return [UIFont systemFontOfSize:12];
        
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return [UIFont systemFontOfSize:12];;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return [UIFont systemFontOfSize:12];;
        
    }
    else
    {
        return [UIFont systemFontOfSize:12];;
    }
}
+ (UIFont *)FontForBigLabel
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return [UIFont systemFontOfSize:12];
        
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return [UIFont systemFontOfSize:12];;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return [UIFont systemFontOfSize:15];;
    }
    else
    {
        return [UIFont systemFontOfSize:12];;
    }
}

+ (UIFont *)FontForSmallLabel
{
    if([SDiOSVersion deviceVersion] == iPhone4||[SDiOSVersion deviceVersion] == iPhone5 || [SDiOSVersion deviceVersion] == iPhone5C || [SDiOSVersion deviceVersion] == iPhone5S || [SDiOSVersion deviceVersion] == iPhoneSE)
    {
        return [UIFont systemFontOfSize:8];
        
    }
    else if([SDiOSVersion deviceVersion] == iPhone6 || [SDiOSVersion deviceVersion] == iPhone6S || [SDiOSVersion deviceVersion] == iPhone7 )
    {
        return [UIFont systemFontOfSize:10];;
    }
    else if([SDiOSVersion deviceVersion] == iPhone6Plus || [SDiOSVersion deviceVersion] == iPhone6SPlus || [SDiOSVersion deviceVersion] == iPhone7Plus)
    {
        return [UIFont systemFontOfSize:12];;
        
    }
    else
    {
        return [UIFont systemFontOfSize:12];;
    }
}
@end
