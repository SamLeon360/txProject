//
//  ContentCheckMoreCell.m
//  TXProject
//
//  Created by Sam on 2019/4/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ContentCheckMoreCell.h"

@implementation ContentCheckMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    if (self.model == nil) {
        return;
    }
    
    _indexPath = indexPath;
    [self.checkMoreView bk_removeAllBlockObservers];
    __block ContentCheckMoreCell *blockSelf = self;
    if (indexPath.section == 1) {
        self.comMsgLabel.text = self.model.commerce_introduction;
        self.checkMoreLabel.text = !self.vc.commerceCheckMore?@"查看更多":@"收起";
        [self.checkMoreView bk_whenTapped:^{
            if ( indexPath.section == 1) {
                
           
            if (!blockSelf.vc.commerceCheckMore) {
                blockSelf.checkMoreLabel.text = @"收起";
                blockSelf.vc.commerceCheckMore = YES;
            }else{
                blockSelf.checkMoreLabel.text = @"查看更多";
                blockSelf.vc.commerceCheckMore = NO;
            }
            [blockSelf.vc reloadTableView];
            }
        }];
    }else if (indexPath.section == 3){
        self.comMsgLabel.text = self.model.secretariat_introduction;
        self.checkMoreLabel.text = !self.vc.secretariatCheckMore?@"查看更多":@"收起";
        [self.checkMoreView bk_whenTapped:^{
             if ( indexPath.section == 3) {
            if (!blockSelf.vc.secretariatCheckMore) {
                blockSelf.checkMoreLabel.text = @"收起";
                blockSelf.vc.secretariatCheckMore = YES;
            }else{
                blockSelf.checkMoreLabel.text = @"查看更多";
                 blockSelf.vc.secretariatCheckMore = NO;
            }
            [blockSelf.vc reloadTableView];
             }
        }];
    }else if (indexPath.section == 4){
        self.comMsgLabel.text = self.model.membership_conditions;
        self.checkMoreLabel.text = !self.vc.cooditionCheckMore?@"查看更多":@"收起";
        [self.checkMoreView bk_whenTapped:^{
          if ( indexPath.section == 4) {
            if (!blockSelf.vc.cooditionCheckMore) {
                blockSelf.checkMoreLabel.text = @"收起";
                blockSelf.vc.cooditionCheckMore = YES;
            }else{
                blockSelf.checkMoreLabel.text = @"查看更多";
                blockSelf.vc.cooditionCheckMore = NO;
            }
            [blockSelf.vc reloadTableView];
          }
        }];
    }
   
}
@end
