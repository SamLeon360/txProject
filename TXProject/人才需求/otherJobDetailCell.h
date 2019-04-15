//
//  otherJobDetailCell.h
//  TXProject
//
//  Created by Sam on 2019/3/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface otherJobDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobName;
@property (weak, nonatomic) IBOutlet UILabel *welfare;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

NS_ASSUME_NONNULL_END
