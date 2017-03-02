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
/*
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
@property (nonatomic,strong) NSString *Corpore;
@property (nonatomic,strong) NSString *Year;
@property (nonatomic,strong) NSString *investType;
@property (nonatomic,strong) NSString *PublishTime;
@property (nonatomic,strong) NSString *ViewCount;
@property (nonatomic,strong) NSString *Price;//信息价格
@property (nonatomic,strong) NSString *PayFlag;//支付状态
@property (nonatomic,strong) NSString *Account;//余额
@property (nonatomic,strong) NSString *CompanyDes;
@property (nonatomic,strong) NSString *Publisher;
*/

@property (nonatomic,strong) NSString *ProjectID      ;
@property (nonatomic,strong) NSString *ServiceID      ;
@property (nonatomic,strong) NSString *ProArea        ;
@property (nonatomic,strong) NSString *WordDes        ;
@property (nonatomic,strong) NSString *VoiceDes       ;
@property (nonatomic,strong) NSString *PictureDes1    ;
@property (nonatomic,strong) NSString *CertifyTime    ;
@property (nonatomic,strong) NSString *PublishTime    ;
@property (nonatomic,strong) NSString *DoneState      ;
@property (nonatomic,strong) NSString *CertifyState   ;
@property (nonatomic,strong) NSString *PublishState   ;
@property (nonatomic,strong) NSString *ViewCount      ;
@property (nonatomic,strong) NSString *CollectionCount;
@property (nonatomic,strong) NSString *DeleteFlag     ;
@property (nonatomic,strong) NSString *ProLabel       ;
@property (nonatomic,strong) NSString *created_at     ;
@property (nonatomic,strong) NSString *updated_at     ;
@property (nonatomic,strong) NSString *UserID         ;
@property (nonatomic,strong) NSString *TypeID         ;
@property (nonatomic,strong) NSString *PictureDes2    ;
@property (nonatomic,strong) NSString *PictureDes3    ;
@property (nonatomic,strong) NSString *PictureDes4    ;
@property (nonatomic,strong) NSString *PictureDes5    ;
@property (nonatomic,strong) NSString *Member         ;
@property (nonatomic,strong) NSString *Price          ;
@property (nonatomic,strong) NSString *CompanyDes     ;
@property (nonatomic,strong) NSString *Publisher      ;
@property (nonatomic,strong) NSString *Channel        ;
@property (nonatomic,strong) NSString *Promise        ;
@property (nonatomic,strong) NSString *ConnectPerson  ;
@property (nonatomic,strong) NSString *ConnectPhone   ;
@property (nonatomic,strong) NSString *TypeName       ;
@property (nonatomic,strong) NSString *Identity       ;
@property (nonatomic,strong) NSString *AssetType      ;
@property (nonatomic,strong) NSString *Type           ;
@property (nonatomic,strong) NSString *Usefor         ;
@property (nonatomic,strong) NSString *Year           ;
@property (nonatomic,strong) NSString *Area           ;
@property (nonatomic,strong) NSString *MarketPrice    ;
@property (nonatomic,strong) NSString *Credentials    ;
@property (nonatomic,strong) NSString *TransferType   ;
@property (nonatomic,strong) NSString *TransferMoney  ;
@property (nonatomic,strong) NSString *Dispute        ;
@property (nonatomic,strong) NSString *Debt           ;
@property (nonatomic,strong) NSString *Guaranty       ;
@property (nonatomic,strong) NSString *Property       ;
@property (nonatomic,strong) NSString *Corpore        ;
@property (nonatomic,strong) NSString *userid         ;
@property (nonatomic,strong) NSString *username       ;
@property (nonatomic,strong) NSString *phonenumber    ;
@property (nonatomic,strong) NSString *truename       ;
@property (nonatomic,strong) NSString *UserPicture    ;
@property (nonatomic,strong) NSString *status         ;
@property (nonatomic,strong) NSString *Status         ;
@property (nonatomic,strong) NSString *companyStatus;


@property (nonatomic,strong) NSString *RushCount      ;
@property (nonatomic,strong) NSString *CollectCount   ;
@property (nonatomic,strong) NSString *CollectFlag    ;
@property (nonatomic,strong) NSString *RushFlag       ;
@property (nonatomic,strong) NSString *PayFlag        ;
@property (nonatomic,strong) NSString *FromWhere      ;
@property (nonatomic,strong) NSString *TotalMoney     ;
@property (nonatomic,strong) NSString *Money          ;
@property (nonatomic,strong) NSString *Rate           ;
@property (nonatomic,strong) NSString *Counts         ;
@property (nonatomic,strong) NSString *Report         ;
@property (nonatomic,strong) NSString *Time           ;
@property (nonatomic,strong) NSString *Pawn           ;
@property (nonatomic,strong) NSString *AssetList      ;
@property (nonatomic,strong) NSString *Belong         ;
@property (nonatomic,strong) NSString *Month          ;
@property (nonatomic,strong) NSString *Nature         ;
@property (nonatomic,strong) NSString *State          ;
@property (nonatomic,strong) NSString *Industry       ;
@property (nonatomic,strong) NSString *DebteeLocation ;
@property (nonatomic,strong) NSString *Connect        ;
@property (nonatomic,strong) NSString *Pay            ;
@property (nonatomic,strong) NSString *Law            ;
@property (nonatomic,strong) NSString *UnLaw          ;
@property (nonatomic,strong) NSString *Court          ;
@property (nonatomic,strong) NSString *Brand          ;
@property (nonatomic,strong) NSString *Title          ;
@property (nonatomic,strong) NSString *ProjectNumber  ;
@property (nonatomic,strong) NSString *ProLabelArr    ;
@property (nonatomic,strong) NSString *CompanyDesPC   ;
@property (nonatomic,strong) NSString *NewsID         ;
@property (nonatomic,strong) NSString *NewsTitle      ;
@property (nonatomic,strong) NSString *NewsContent    ;
@property (nonatomic,strong) NSString *NewsLogo       ;
@property (nonatomic,strong) NSString *NewsThumb      ;
@property (nonatomic,strong) NSString *NewsLabel      ;
@property (nonatomic,strong) NSString *NewsAuthor     ;
@property (nonatomic,strong) NSString *Brief          ;
@property (nonatomic,strong) NSString *ListType       ;
@property (nonatomic,strong) NSString *Account       ;

@property (nonatomic,strong) NSString *Hide;
@property (nonatomic,strong) NSString *right;
@property (nonatomic,strong) NSString *CooperateState;
@end
