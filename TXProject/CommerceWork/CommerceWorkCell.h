//
//  CommerceWorkCell.h
//  TXProject
//
//  Created by Sam on 2019/1/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommerceWorkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serverNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSArray *serverArray;
@property (nonatomic) NSInteger typeIndex;
@property (nonatomic) UIViewController *serverVC;
-(void)setupArray;
@end

NS_ASSUME_NONNULL_END
