//
//  EntreOneCell.m
//  TXProject
//
//  Created by Sam on 2019/2/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EntreOneCell.h"

@implementation EntreOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupCycleScrollview{
    
    self.imagesContentView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:0];
        for (NSString *url in self.posterArray) {
            [urlArray addObject:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,url]];
        }
    self.posterArray = urlArray;
    self.imagesContentView.imageURLStringsGroup = self.posterArray;
    self.imagesContentView.showPageControl = YES;
    [self.imagesContentView setAutoScrollTimeInterval:5];
    self.imagesContentView.autoScroll = self.posterArray.count >1?YES:NO;
    self.imagesContentView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//    self.imagesContentView.delegate = self;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
