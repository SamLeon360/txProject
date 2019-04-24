//
//  CommerceMasterModel.h
//  TXProject
//
//  Created by Sam on 2019/4/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommerceMasterModel : NSObject

@property (nonatomic,strong) NSString *commerce_name;
@property (nonatomic,strong) NSString *member_name;
@property (nonatomic,strong) NSString *league_post;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *end_time;
@property (nonatomic,strong) NSString *publisher_name;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,assign) NSInteger commerce_id;
@property (nonatomic,assign) NSInteger constitute_id;
@property (nonatomic,assign) NSInteger post_type;
@property (nonatomic,assign) NSInteger post_count;
@property (nonatomic,assign) NSInteger member_id;
@property (nonatomic,assign) NSInteger sorting;
@property (nonatomic,assign) NSInteger publisher_id;
@property (nonatomic,assign) NSInteger so_far;
@end

NS_ASSUME_NONNULL_END
