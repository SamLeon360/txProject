//
//  CommerceEventCell.h
//  TXProject
//
//  Created by Sam on 2019/4/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommerceEventListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommerceEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventContent;
@property (nonatomic,strong) CommerceEventListModel *model;
@end

NS_ASSUME_NONNULL_END
