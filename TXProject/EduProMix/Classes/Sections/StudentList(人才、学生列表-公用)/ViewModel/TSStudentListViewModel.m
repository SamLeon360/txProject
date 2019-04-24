//
//  TSStudentListViewModel.m
//  EducationMix
//
//  Created by Taosky on 2019/4/1.
//  Copyright © 2019 iTaosky. All rights reserved.
//

#import "TSStudentListViewModel.h"

@implementation TSStudentListViewModel


- (instancetype)initWithModel:(TSStudentListModel *)model {
    
    if(!self) {
        self = [super init];
        _model = model;
    }
    return self;
    
}

- (void)loadDataArrFromNetwork {
    
    
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSString *url = [NSString stringWithFormat:@"%@%@",TX_HOST_URL,@"student/list_student"];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            params[@"page"] = @1;
            params[@"education"] = @"";
            params[@"sex"] = @"";
            params[@"affiliated_area"] = @"";
            params[@"major"] = @"";
            params[@"student_name"] = @"";
            params[@"graduation_time"] = @"";
            
            //            {"page":1,"education":"","sex":"","affiliated_area":"","major":"","student_name":"","graduation_time":""}
            
            [TSRequestTool POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject[@"code"] integerValue] == 1) {
                    
                    self.modelArr = [TSStudentListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                    [subscriber sendNext:self.modelArr];
                    
                } else {
                    
                    [TSProgressHUD showError:responseObject[@"msg"]];
                    
                }
                
                [subscriber sendCompleted];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendError:error];
                [subscriber sendCompleted];
                
            }];
            
            
            return nil;
            
        }];
        
        
        return signal;
    }];
    
    
}

@end
