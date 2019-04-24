//
//  CommerceEventListModel.h
//  TXProject
//
//  Created by Sam on 2019/4/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommerceEventListModel : NSObject
@property (nonatomic,assign) NSInteger commerce_id;
@property (nonatomic,strong) NSString *commerce_name;
@property (nonatomic,strong) NSString *commerce_logo;
@property (nonatomic,assign) NSInteger year;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,assign) NSInteger markdown_id;
@property (nonatomic,assign) NSInteger publisher_id;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *publisher_name;
@property (nonatomic,strong) NSString *create_time;
@end

NS_ASSUME_NONNULL_END
