//
//  ResultMessageViewModel.h
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ResultMessageViewModel : NSObject
@property (nonatomic, strong) ResultMessageModel * model;

@property (nonatomic, copy)NSArray *modelArr;

- (instancetype)initWithModel:(ResultMessageModel *)model;

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络获取获取信息 */
- (void)loadDataArrFromNetwork;
@end

NS_ASSUME_NONNULL_END
