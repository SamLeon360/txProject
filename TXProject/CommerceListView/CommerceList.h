//
//  CommerceList.h
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineCommerceController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommerceList : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic) NSArray *commerceArray;
@property (nonatomic) MineCommerceController *mineVC;
-(void)setupTableView;
@end

NS_ASSUME_NONNULL_END
