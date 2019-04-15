//
//  Entrepreneurial.h
//  TXProject
//
//  Created by Sam on 2019/1/11.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface Entrepreneurial : UIView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollview;

/**
工商注册
 */
@property (weak, nonatomic) IBOutlet UIView *circlesView;
/**
 知识产品
 */
@property (weak, nonatomic) IBOutlet UIView *knowledgeView;
/**
 法律财税
 */
@property (weak, nonatomic) IBOutlet UIView *lawView;
/**
 财税服务
 */
@property (weak, nonatomic) IBOutlet UIView *moneyView;
/**
 资质办理
 */
@property (weak, nonatomic) IBOutlet UIView *zizhiView;


/**
 查看更多
 */
@property (weak, nonatomic) IBOutlet UIView *moreView;


///点我查看更多
@property (weak, nonatomic) IBOutlet UILabel *clickCheckMoreView;


@end

NS_ASSUME_NONNULL_END
