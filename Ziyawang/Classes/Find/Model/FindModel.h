//
//  FindModel.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/4.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject
@property (nonatomic,strong) NSString *TypeName;//需求名字类型
@property (nonatomic,strong) NSString *ProArea;//地区
@property (nonatomic,strong) NSString *FromWhere;//来源
@property (nonatomic,strong) NSString *AssetType;//类型

@property (nonatomic,strong) NSString *TotalMoney;//金额
@property (nonatomic,strong) NSString *TransferMoney;//转让价
@property (nonatomic,strong) NSString *Status;//状态
@property (nonatomic,strong) NSString *Rate;//佣金比例
@property (nonatomic,strong) NSString *Requirement;//需求
@property (nonatomic,strong) NSString *BuyerNature;//买方性质
@property (nonatomic,strong) NSString *Informant;//被调查方
@property (nonatomic,strong) NSString *Buyer;//求购方
@property (nonatomic,strong) NSString *TypeID;



@end
