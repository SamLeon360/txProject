//
//  ContentTextCell.h
//  TXProject
//
//  Created by Sam on 2019/4/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommerceBaseModel.h"
#import "CommerceMasterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContentTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellIcon;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) CommerceBaseModel *model;
@property (nonatomic,strong) CommerceMasterModel *masterModel;
@end

NS_ASSUME_NONNULL_END
