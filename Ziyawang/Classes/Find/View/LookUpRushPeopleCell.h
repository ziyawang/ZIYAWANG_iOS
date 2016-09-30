//
//  LookUpRushPeopleCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/8.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RushPeopleModel.h"

@protocol pushDelegate <NSObject>
- (void)pushToControllerWithModel:(RushPeopleModel *)model;
- (void)connectServiceWithTel:(NSString *)tel;
@end

@interface LookUpRushPeopleCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *usericonImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;

@property (nonatomic,strong)RushPeopleModel *model;
@property (nonatomic,strong) NSString *ProjectID;
@property (nonatomic,assign) id<pushDelegate> Mydelegate;
@property (nonatomic,strong) NSString *PublishState;



@end
