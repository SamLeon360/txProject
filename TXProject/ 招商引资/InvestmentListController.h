//
//  InvestmentListController.h
//  TXProject
//
//  Created by Sam on 2019/3/1.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvestmentListController : UIViewController
-(void)getinvestmentArrayByRefresh;
@property (nonatomic) NSInteger nPage;
@property (nonatomic) NSInteger selectTypeIndex;
@end

NS_ASSUME_NONNULL_END
