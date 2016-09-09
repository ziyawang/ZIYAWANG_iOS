//
//  PublishModel.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/7/23.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishModel : NSObject
//ProArea
//FromWhere
//AssetType
//TotalMoney
//TransferMoney
//Status
//Rate
//Requirement
//BuyerNature
//Informant
//Buyer

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
@property (nonatomic,strong) NSString *ProjectID;
@property (nonatomic,strong) NSString *ProjectNumber;

@property (nonatomic,strong) NSString *PhoneNumber;
@property (nonatomic,strong) NSString *PictureDes1;

@property (nonatomic,strong) NSString *PictureDes2;
@property (nonatomic,strong) NSString *PictureDes3;


@property (nonatomic,strong) NSString *WordDes;
@property (nonatomic,strong) NSString *UserPicture;
@property (nonatomic,strong) NSString *UserID;

@property (nonatomic,strong) NSString *CollectFlag;
@property (nonatomic,strong) NSString *RushFlag;
@property (nonatomic,strong) NSString *VoiceDes;
@property (nonatomic,strong) NSString *Member;

@property (nonatomic,strong) NSString *PublishState;

@property (nonatomic,strong) NSString *CertifyState;

@property (nonatomic,strong) NSString *role;

@property (nonatomic,strong) NSString *Year;
@property (nonatomic,strong) NSString *investType;


@end
