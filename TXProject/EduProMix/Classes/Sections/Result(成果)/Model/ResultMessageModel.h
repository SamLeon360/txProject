//
//  ResultMessageModel.h
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultMessageModel : NSObject
@property (nonatomic, strong)NSString *apply_name;
@property (nonatomic, strong)NSString *results_name;
@property (nonatomic, strong)NSString *own_name;
@property (nonatomic, strong)NSString *complete_time;
@property (nonatomic, strong)NSString *unit_name;
@property (nonatomic, assign)NSInteger domain;
@property (nonatomic, strong)NSString *complete_unit;
@property (nonatomic, strong)NSString *research_pictures;
@property (nonatomic, assign)NSInteger research_level;
@property (nonatomic, assign)NSInteger apply_id;
@property (nonatomic, assign)NSInteger results_id;
@end

NS_ASSUME_NONNULL_END
