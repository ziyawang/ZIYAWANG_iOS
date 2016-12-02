//
//  ChuzhiCell.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/12/1.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "ChuzhiCell.h"

@interface ChuzhiCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLalbe;


@end

@implementation ChuzhiCell
- (void)setModel:(PublishModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
        [self setCell];
    }
}
- (void)setCell
{
    NSString *htmlString = self.model.Brief;
    htmlString = [@"<style>body{color:#6d6d6d;font-size:12px;}</style>" stringByAppendingString:htmlString];
    
    
    NSMutableAttributedString * attrStr =  [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *str = [NSString stringWithFormat:@"%@",attrStr];
     NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0.5f];
    self.desLabel.attributedText = attrStr;
    
    self.titleLabel.text = self.model.NewsTitle;
    self.fromLabel.text = [@"来源：" stringByAppendingString:self.model.NewsAuthor];
    NSArray *timearr = [self.model.PublishTime componentsSeparatedByString:@" "];
    self.timeLalbe.text = timearr[0];
    NSString *imgeurl = [getImageURL stringByAppendingString:self.model.NewsLogo];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:imgeurl]];
    
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
