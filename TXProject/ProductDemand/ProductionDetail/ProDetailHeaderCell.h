//
//  ProDetailHeaderCell.h
//  TXProject
//
//  Created by Sam on 2019/4/2.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleView;
@property (weak, nonatomic) IBOutlet UILabel *productionNamew;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *seeNumber;
@property (nonatomic) NSArray *imageArray;

@end

NS_ASSUME_NONNULL_END
