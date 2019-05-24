//
//  EditComViewModel.h
//  TXProject
//
//  Created by Sam on 2019/5/13.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommerceDataModel.h"
#import "EditCommerceDataController.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditComViewModel : NSObject
@property (nonatomic , strong) CommerceDataModel *model;
@property (nonatomic , strong) NSString *commerceId;
- (instancetype)initWithModel:(NSString *)commerceId;

@property (nonatomic,strong) EditCommerceDataController *vc;
/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络获取获取信息 */
- (void)loadDataArrFromNetwork;
@end

NS_ASSUME_NONNULL_END
