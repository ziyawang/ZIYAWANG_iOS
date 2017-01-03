//
//  DetailOfInfoController.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/26.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOfInfoController : UIViewController

typedef void(^httprequest)();
@property (nonatomic, copy) httprequest httpRequestBlock;


@property (nonatomic,strong) NSString *Type;
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *ProjectID;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *targetID;
@property (nonatomic,strong) NSString *TypeID;



@end
