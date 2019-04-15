//
//  JobListCell.h
//  TXProject
//
//  Created by Sam on 2019/3/29.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JobListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *delLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

NS_ASSUME_NONNULL_END
