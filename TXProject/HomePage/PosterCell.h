//
//  PosterCell.h
//  TXProject
//
//  Created by Sam on 2019/2/12.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
#import "NewHomePageController.h"
NS_ASSUME_NONNULL_BEGIN

@interface PosterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (nonatomic) UIViewController *vController;
@property (nonatomic) NSArray *posterArray;
@property (nonatomic) NSArray *scrollArray;
-(void)setupCycleScrollview;
@end

NS_ASSUME_NONNULL_END
