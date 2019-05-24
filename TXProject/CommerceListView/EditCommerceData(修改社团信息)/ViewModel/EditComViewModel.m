//
//  EditComViewModel.m
//  TXProject
//
//  Created by Sam on 2019/5/13.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EditComViewModel.h"

@implementation EditComViewModel
- (instancetype)initWithModel:(nonnull NSString *)commerceId{
    self = [super init];
    if (!self) return nil;
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
                    self.model = [CommerceDataModel mj_objectWithKeyValues:dic];
                    self.vc.modelDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [self.vc reloadTableView];
                    [subscriber sendNext:self.model];
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
