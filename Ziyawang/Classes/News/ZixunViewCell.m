//
//  ZixunViewCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/10/31.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ZixunViewCell.h"

@interface ZixunViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;


@end

@implementation ZixunViewCell
- (void)setModel:(NewsModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setViews];
    }
}
- (void)setViews
{
    NSString *imgeurl = [getImageURL stringByAppendingString:self.model.NewsLogo];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:imgeurl]];
    [self.imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.imageview.clipsToBounds = YES;

    self.titleLabel.text = self.model.NewsTitle;
        NSString *htmlString = self.model.Brief;
        NSAttributedString * attrStr =  [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *str = [NSString stringWithFormat:@"%@",attrStr];
    self.contentLabel.text = str;
    NSLog(@"%@",self.contentLabel.text);
    self.timeLabel.text = [ZixunViewCell getDateWithString:self.model.PublishTime];
    self.viewCountLabel.text = self.model.ViewCount;
    
}
+ (NSString *)getDateWithString:(NSString *)date
{
   NSArray *dateArray = [date componentsSeparatedByString:@" "];
    NSString *str1 = dateArray[0];
    NSString *str2 = dateArray[1];
    NSArray *dateArray2 = [str1 componentsSeparatedByString:@"-"];
    NSArray *dateArray3 = [str2 componentsSeparatedByString:@":"];
    
    NSString *day = [[dateArray2[1] stringByAppendingString:@"-"]stringByAppendingString:dateArray2[2]];
    NSString *hour = [[dateArray3[0] stringByAppendingString:@":"]stringByAppendingString:dateArray3[1]];
    NSString *Date = [[day stringByAppendingString:@"/"]stringByAppendingString:hour];
    return Date;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
