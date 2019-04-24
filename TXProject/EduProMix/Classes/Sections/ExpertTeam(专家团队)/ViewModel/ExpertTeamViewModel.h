//
//  ExpertTeamViewModel.h
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertTeamModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExpertTeamViewModel : NSObject
@property (nonatomic, strong)ExpertTeamModel *model;

@property (nonatomic, copy)NSArray *modelArr;

- (instancetype)initWithModel:(ExpertTeamModel *)model;

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络获取获取信息 */
- (void)loadDataArrFromNetwork;
@end

NS_ASSUME_NONNULL_END
