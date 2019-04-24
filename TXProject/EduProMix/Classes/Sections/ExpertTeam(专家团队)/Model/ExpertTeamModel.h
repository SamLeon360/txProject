//
//  ExpertTeamModel.h
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpertTeamModel : NSObject
@property (nonatomic, strong)NSString *team_name;
@property (nonatomic, strong)NSString *team_leaders_name;
@property (nonatomic, strong)NSString *responsible_jobtitle;
@property (nonatomic, strong)NSString *research_direction;
@property (nonatomic, strong)NSString *unit_name;
@property (nonatomic, strong)NSString *team_photo;
@property (nonatomic, strong)NSString *formation_date;
@property (nonatomic, assign)NSInteger professional_field;
@property (nonatomic, assign)NSInteger team_id;
@property (nonatomic, assign)NSInteger member_id;
@end

NS_ASSUME_NONNULL_END
