//
//  CommerceDetailViewModel.m
//  TXProject
//
//  Created by Sam on 2019/4/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CommerceDetailViewModel.h"

@implementation CommerceDetailViewModel
- (instancetype)initWithModel:(CommerceBaseModel *)baseModel and: (CommerceEventListModel *)listModel and: (CommerceMasterModel *)masterModel and:(nonnull NSString *)commerceId{
    self = [super init];
    if (!self) return nil;
    self.baseModel = baseModel;
    self.listModel = listModel;
    self.masterModel = masterModel;
    self.commerceId = commerceId;
    return self;
}


- (void)loadDataArrFromNetwork {
    
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //            @weakify(self);
            NSString *url = @"common/load_commerce_detail_by_id";
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            params[@"commerce_id"] = self.commerceId;
            [HTTPREQUEST_SINGLE postWithURLString:url parameters:params withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
                
                if ([responseDic[@"code"] integerValue] == 1) {
                    NSArray *arr =responseDic[@"data"];
                    NSDictionary *dic = arr.firstObject;
                    self.baseModel = [CommerceBaseModel mj_objectWithKeyValues:dic];
                    [subscriber sendNext:self.baseModel];
                    [subscriber sendCompleted];
                    
                }
            } failure:^(NSError *error) {
                
                [subscriber sendError:error];
                
                //[AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
            }];
            NSString *url1 = @"commerce/bigEvents";
            
            NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
            
            params1[@"commerce_id"] = self.commerceId;
            params1[@"event_type"] = @"1";
            [HTTPREQUEST_SINGLE postWithURLString:url1 parameters:params1 withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
                
                if ([responseDic[@"code"] integerValue] == 0) {
                    
                    self.modelArr = [CommerceEventListModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
                    [subscriber sendNext:self.modelArr];
                    [subscriber sendCompleted];
                    
                }
            } failure:^(NSError *error) {
                
                [subscriber sendError:error];
                
                //[AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
            }];
            NSString *url2 = @"commerce/bigEvents";
            
            NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
            
            params2[@"commerce_id"] = self.commerceId;
            params2[@"event_type"] = @"2";
            [HTTPREQUEST_SINGLE postWithURLString:url2 parameters:params2 withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
                
                if ([responseDic[@"code"] integerValue] == 0) {
                    
                    self.masterArr = [CommerceMasterModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
                    [self.vc countMasterNumber];
                    [subscriber sendNext:self.masterArr];
                    [subscriber sendCompleted];
                    
                }
            } failure:^(NSError *error) {
                
                [subscriber sendError:error];
                
                //[AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
            }];
            return nil;
        }];
        
        return signal;
        
    }];
    
    
    
}

@end
