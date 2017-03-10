//
//  VideosViewCell.h
//  Ziyawang
//
//  Created by Mr.Xu on 16/8/10.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideosModel.h"
#import "ZXVideo.h"

@protocol playDelegate <NSObject>
- (void)pushToControllerWithZXVideo:(ZXVideo *)zvideo model:(VideosModel *)model;
@end

@interface VideosViewCell : UITableViewCell

@property (nonatomic,assign) id<playDelegate> Mydelegate;


@property (weak, nonatomic) IBOutlet UIImageView *VideoImageView;
@property (weak, nonatomic) IBOutlet UILabel *ViedoDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *VideoCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *pinglunButton;
@property (weak, nonatomic) IBOutlet UILabel *pinglunCountLable;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage;

@property (nonatomic,strong) ZXVideo *zvideo;



@property (nonatomic,strong) VideosModel *model;


@end
