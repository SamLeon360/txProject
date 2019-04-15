//
//  ServerHeader.h
//  TXProject
//
//  Created by Sam on 2019/1/17.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ServerHeader : UIView

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollview;
/**
 融资信贷
 */
@property (weak, nonatomic) IBOutlet UIView *treasureView;
/**
 科技创新
 */
@property (weak, nonatomic) IBOutlet UIView *coachView;
/**
 健康体检
 */
@property (weak, nonatomic) IBOutlet UIView *leaseView;
/**
 活动策划
 */
@property (weak, nonatomic) IBOutlet UIView *facilitiesView;
/**
 高端定制
 */
@property (weak, nonatomic) IBOutlet UIView *circlesView;
/**
 车辆保养
 */
@property (weak, nonatomic) IBOutlet UIView *knowledgeView;
/**
 展会展览
 */
@property (weak, nonatomic) IBOutlet UIView *lawView;
/**
 住宿餐饮
 */
@property (weak, nonatomic) IBOutlet UIView *financingView;
/**
 涉外服务
 */
@property (weak, nonatomic) IBOutlet UIView *adviserView;


/**
 项目申报
 */
@property (weak, nonatomic) IBOutlet UIView *projectView;

@property (weak, nonatomic) IBOutlet UIView *houseView;

@property (weak, nonatomic) IBOutlet UIView *translateView;

@property (weak, nonatomic) IBOutlet UIView *companyView;

@property (weak, nonatomic) IBOutlet UIView *takePhotoView;

@property (weak, nonatomic) IBOutlet UIView *carView;

///点我查看更多
@property (weak, nonatomic) IBOutlet UILabel *clickCheckMoreView;


@end

NS_ASSUME_NONNULL_END
