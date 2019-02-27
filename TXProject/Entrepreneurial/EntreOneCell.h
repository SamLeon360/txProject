//
//  EntreOneCell.h
//  TXProject
//
//  Created by Sam on 2019/2/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface EntreOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SDCycleScrollView *imagesContentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (nonatomic) NSArray *posterArray;
-(void)setupCycleScrollview;
@end

NS_ASSUME_NONNULL_END
