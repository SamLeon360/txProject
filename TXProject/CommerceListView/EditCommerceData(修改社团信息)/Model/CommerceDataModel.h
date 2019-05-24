//
//  CommerceDataModel.h
//  TXProject
//
//  Created by Sam on 2019/5/13.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommerceDataModel : NSObject
@property (nonatomic , strong) NSString *commerce_id;
@property (nonatomic , strong) NSString *commerce_name;
@property (nonatomic , strong) NSString *commerce_logo;
@property (nonatomic , strong) NSString *examination_grade;
@property (nonatomic , strong) NSString *commerce_belong_membership;
@property (nonatomic , strong) NSString *commerce_level;
@property (nonatomic , strong) NSString *commerce_type;
@property (nonatomic , strong) NSString *commerce_location;
@property (nonatomic , strong) NSString *commerce_introduction;
@property (nonatomic , strong) NSString *commerce_constitution;
@property (nonatomic , strong) NSString *organizational_structure;
@property (nonatomic , strong) NSString *commerce_president;
@property (nonatomic , strong) NSString *commerce_secretary_general;
@property (nonatomic , strong) NSString *commerce_phone;
@property (nonatomic , strong) NSString *commerce_fax;
@property (nonatomic , strong) NSString *contact;
@property (nonatomic , strong) NSString *contact_phone;
@property (nonatomic , strong) NSString *office_address;

@property (nonatomic , strong) NSString *email;
@property (nonatomic , strong) NSString *site;
@property (nonatomic , strong) NSString *wechat_subscription;
@property (nonatomic , strong) NSString *membership_conditions;
@property (nonatomic , strong) NSString *membership_dues;

@property (nonatomic , strong) NSString *secretariat_introduction;
@property (nonatomic , strong) NSString *executive_president;
@property (nonatomic , strong) NSString *executive_vice_president;
@property (nonatomic , strong) NSString *supervisor;
@property (nonatomic , strong) NSString *commerce_location_real;
@property (nonatomic , strong) NSString *commerce_belong_membership_real;
@property (nonatomic , strong) NSString *u_recycle_img;
@end

NS_ASSUME_NONNULL_END
