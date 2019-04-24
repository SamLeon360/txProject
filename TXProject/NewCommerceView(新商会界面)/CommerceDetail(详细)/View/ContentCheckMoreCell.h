//
//  ContentCheckMoreCell.h
//  TXProject
//
//  Created by Sam on 2019/4/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommerceBaseModel.h"
#import "NewCommerceDetailController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContentCheckMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *comMsgLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellAutoHeight;
@property (weak, nonatomic) IBOutlet UIView *checkMoreView;
@property (weak, nonatomic) IBOutlet UILabel *checkMoreLabel;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) CommerceBaseModel *model;
@property (nonatomic,strong) NewCommerceDetailController *vc;
@end

NS_ASSUME_NONNULL_END
