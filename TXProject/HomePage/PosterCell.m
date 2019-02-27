//
//  PosterCell.m
//  TXProject
//
//  Created by Sam on 2019/2/12.
//  Copyright © 2019 sam. All rights reserved.
//

#import "PosterCell.h"
@interface PosterCell()<SDCycleScrollViewDelegate>
@end
@implementation PosterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupCycleScrollview{
    
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:0];
//    for (NSDictionary *dic in self.posterArray) {
//        [urlArray addObject:dic[@"cover"]];
//    }
    self.cycleScrollView.imageURLStringsGroup = self.posterArray;
    self.cycleScrollView.showPageControl = YES;
    [self.cycleScrollView setAutoScrollTimeInterval:5];
    self.cycleScrollView.autoScroll = self.posterArray.count >1?YES:NO;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.delegate = self;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
