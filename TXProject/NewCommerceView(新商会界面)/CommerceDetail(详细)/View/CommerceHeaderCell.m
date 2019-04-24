//
//  CommerceHeaderCell.m
//  TXProject
//
//  Created by Sam on 2019/4/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CommerceHeaderCell.h"

@implementation CommerceHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CommerceBaseModel *)model{
    [_commerceLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,model.commerce_logo]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [self->_commerceLogo setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    [_commerceLogo makeCorner:_commerceLogo.frame.size.height/2];
    _commerceName.text = model.commerce_name;
    if (self.commerceDetailVC.tableType == 1) {
        [self resetColor];
        self.baseMsgLabel.textColor = [UIColor colorWithRGB:0x3F78BC];
        [self.baseMsgView setBackgroundColor:[UIColor whiteColor]];

    }else if (self.commerceDetailVC.tableType == 2){
        [self resetColor];
        self.eventLabel.textColor = [UIColor colorWithRGB:0x3F78BC];
        [self.eventView setBackgroundColor:[UIColor whiteColor]];

    }else{
        [self resetColor];
        self.masterLabel.textColor = [UIColor colorWithRGB:0x3F78BC];
        [self.masterView setBackgroundColor:[UIColor whiteColor]];
    }
    __block CommerceHeaderCell *blockSelf = self;
    [_baseMsgView bk_whenTapped:^{
        [blockSelf resetColor];
        blockSelf.baseMsgLabel.textColor = [UIColor colorWithRGB:0x3F78BC];
        [blockSelf.baseMsgView setBackgroundColor:[UIColor whiteColor]];
        blockSelf.commerceDetailVC.tableType = 1;
        [blockSelf.commerceDetailVC reloadTableView];
    }];
    [_eventView bk_whenTapped:^{
        [blockSelf resetColor];
        blockSelf.eventLabel.textColor = [UIColor colorWithRGB:0x3F78BC];
        [blockSelf.eventView setBackgroundColor:[UIColor whiteColor]];
        blockSelf.commerceDetailVC.tableType = 2;
        [blockSelf.commerceDetailVC reloadTableView];
    }];
    [_masterView bk_whenTapped:^{
        [blockSelf resetColor];
        blockSelf.masterLabel.textColor = [UIColor colorWithRGB:0x3F78BC];
        [blockSelf.masterView setBackgroundColor:[UIColor whiteColor]];
        blockSelf.commerceDetailVC.tableType = 3;
        [blockSelf.commerceDetailVC reloadTableView];
    }];
}
-(void)resetColor{
    self.baseMsgView.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
    self.baseMsgLabel.textColor = [UIColor colorWithRGB:0x666666];
    self.eventView.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
    self.eventLabel.textColor = [UIColor colorWithRGB:0x666666];
    self.masterView.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
    self.masterLabel.textColor = [UIColor colorWithRGB:0x666666];
    
}
@end
