//
//  TSProjectDetailsViewModel.h
//  EducationMix
//
//  Created by Taosky on 2019/4/9.
//  Copyright © 2019 iTaosky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSProjectDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSProjectDetailsViewModel : NSObject

@property(nonatomic, assign)NSInteger project_id;

@property (nonatomic, strong)TSProjectDetailsModel *model;


- (instancetype)initWithProject_id:(NSInteger)project_id;

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络获取获取信息 */
- (void)loadDataArrFromNetwork;

@end

NS_ASSUME_NONNULL_END
