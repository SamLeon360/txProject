//
//  StuJobSelectView.h
//  TXProject
//
//  Created by Sam on 2019/3/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentJobController.h"
NS_ASSUME_NONNULL_BEGIN

@interface StuJobSelectView : UIView
@property (weak, nonatomic) IBOutlet UITableView *oneTableView;
@property (weak, nonatomic) IBOutlet UITableView *twoTableView;
@property (nonatomic) NSInteger viewType;
@property (nonatomic) NSArray *oneArray;
@property (nonatomic) NSArray *twoArray;
-(void)setupTableView;
@property (nonatomic) StudentJobController *studentVc;
@end

NS_ASSUME_NONNULL_END
