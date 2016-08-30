//
//  CommentModel.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/12.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic,strong) NSString *UserName;
@property (nonatomic,strong) NSString *UserPicture;
@property (nonatomic,strong) NSString *Content;
@property (nonatomic,strong) NSString *PubTime;

@end
