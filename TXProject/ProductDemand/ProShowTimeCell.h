//
//  ProShowTimeCell.h
//  TXProject
//
//  Created by Sam on 2019/4/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProShowTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UIView *startTimeView;
@property (weak, nonatomic) IBOutlet UIView *endTimeView;

@end

NS_ASSUME_NONNULL_END
