//
//  ProTypeView.h
//  TXProject
//
//  Created by Sam on 2019/4/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProTypeView : UIView
typedef void (^SelectStringCallBack)(NSString *str);
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) SelectStringCallBack selectStringCallBack;
@property (nonatomic) NSArray *dataArray;
-(void)setupCollectionView;
@end

NS_ASSUME_NONNULL_END
