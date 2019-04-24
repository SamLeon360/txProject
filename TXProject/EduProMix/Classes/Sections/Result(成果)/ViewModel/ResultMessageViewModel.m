//
//  ResultMessageViewModel.m
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ResultMessageViewModel.h"

@implementation ResultMessageViewModel

- (instancetype)initWithModel:(ResultMessageModel *)model {
    
    self = [super init];
    if (!self) return nil;
    self.model = model;
    return self;
}


- (void)loadDataArrFromNetwork {
    
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //            @weakify(self);
            NSString *url = @"results/list_results";
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            params[@"page"] = @1;
            params[@"apply_id"] = @"";
            params[@"domain"] = @"";
            params[@"region"] = @"";
            params[@"research_level"] = @"";
            params[@"results_name"] = @"";
            [HTTPREQUEST_SINGLE postWithURLString:url parameters:params withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
                
                if ([responseDic[@"code"] integerValue] == 1) {
                    
                    self.modelArr = [ResultMessageModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
                    [subscriber sendNext:self.modelArr];
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
