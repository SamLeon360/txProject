//
//  HomePageCollectionHeader.m
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "HomePageCollectionHeader.h"

@interface HomePageCollectionHeader()<SDCycleScrollViewDelegate>

@end

@implementation HomePageCollectionHeader



-(void)setupCycleScrollview{
    
    self.advertView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.advertView.imageURLStringsGroup = self.posterArray;
    self.advertView.showPageControl = NO;
    [self.advertView setAutoScrollTimeInterval:5];
    self.advertView.autoScroll = self.posterArray.count >1?YES:NO;
    self.advertView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    
    self.advertView.delegate = self;
    
    
    
}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    OtherWebController *vc = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"OtherWebController"];
//    NSDictionary *dic = self.posterArray[index];
//    NSString *link = dic[@"link"];
//    if (link.length != 0) {
//        vc.url = dic[@"link"];
//        NSString *url = dic[@"link"];
//        if ([url containsString:@"mobi.gdmiaoxun"]) {
//            vc.isShowNav = YES;
//        }else{
//            vc.isShowNav = NO;
//        }
//        vc.webtype = POSETER;
//        [self.homeVC.navigationController pushViewController:vc animated:YES];
//    }
}


@end
