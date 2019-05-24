//
//  EditCommerceDataController.h
//  TXProject
//
//  Created by Sam on 2019/5/13.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditCommerceDataController : UIViewController
@property (nonatomic , strong) NSString *commerceId;
@property (nonatomic , strong) NSMutableDictionary *modelDic;
-(void)reloadTableView;
@end

NS_ASSUME_NONNULL_END
