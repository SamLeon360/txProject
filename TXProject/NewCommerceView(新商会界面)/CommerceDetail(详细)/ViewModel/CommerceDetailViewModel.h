//
//  CommerceDetailViewModel.h
//  TXProject
//
//  Created by Sam on 2019/4/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommerceBaseModel.h"
#import "CommerceEventListModel.h"
#import "CommerceMasterModel.h"
#import "NewCommerceDetailController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommerceDetailViewModel : NSObject
@property (nonatomic, strong) CommerceBaseModel *baseModel;
@property (nonatomic, strong) CommerceEventListModel *listModel;
@property (nonatomic, strong) CommerceMasterModel* masterModel;
@property (nonatomic) NSArray *modelArr;
@property (nonatomic) NSArray *masterArr;
@property (nonatomic,strong) NSString *commerceId;
- (instancetype)initWithModel:(CommerceBaseModel *)baseModel and: (CommerceEventListModel *)listModel and: (CommerceMasterModel *)masterModel and:(NSString *)commerceId;

@property (nonatomic,strong) NewCommerceDetailController *vc;
/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络获取获取信息 */
- (void)loadDataArrFromNetwork;

@end

NS_ASSUME_NONNULL_END
