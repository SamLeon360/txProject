//
//  HomePageCollectionHeader.h
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
NS_ASSUME_NONNULL_BEGIN

@interface HomePageCollectionHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *advertView;
@property (nonatomic) NSArray *posterArray;
-(void)setupCycleScrollview;
@end

NS_ASSUME_NONNULL_END
