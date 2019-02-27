//
//  HomeServerCell.h
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeServerController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeServerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serverNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSArray *serverArray;
@property (nonatomic) NSInteger typeIndex;
@property (nonatomic) UIViewController *serverVC;
-(void)setupArray;
@end

NS_ASSUME_NONNULL_END
