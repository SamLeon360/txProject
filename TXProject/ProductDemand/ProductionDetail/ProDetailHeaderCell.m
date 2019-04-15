//
//  ProDetailHeaderCell.m
//  TXProject
//
//  Created by Sam on 2019/4/2.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProDetailHeaderCell.h"
@interface ProDetailHeaderCell()<SDCycleScrollViewDelegate>

@end
@implementation ProDetailHeaderCell

-(void)setupsdcycleview{
    self.cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleView.imageURLStringsGroup = self.imageArray;
    self.cycleView.showPageControl = NO;
    [self.cycleView setAutoScrollTimeInterval:5];
    self.cycleView.autoScroll = self.imageArray.count >1?YES:NO;
    self.cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleView.delegate = self;
}

@end
