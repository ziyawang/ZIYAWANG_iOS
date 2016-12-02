//
//  NewsModel.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/10/31.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic,strong) NSString *NewsTitle;
@property (nonatomic,strong) NSString *NewsContent;
@property (nonatomic,strong) NSString *NewsID;
@property (nonatomic,strong) NSString *NewsLogo;
@property (nonatomic,strong) NSString *NewsAuthor;

@property (nonatomic,strong) NSString *PublishTime;
@property (nonatomic,strong) NSString *ViewCount;
@property (nonatomic,strong) NSString *Brief;

@end
