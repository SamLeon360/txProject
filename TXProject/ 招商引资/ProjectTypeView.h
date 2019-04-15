//
//  ProjectTypeView.h
//  TXProject
//
//  Created by Sam on 2019/3/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestmentListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectTypeView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *typeArray;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (nonatomic) InvestmentListController *listVc;
@property (nonatomic) NSString *functionName;
-(void)setupTableview;
@end

NS_ASSUME_NONNULL_END
