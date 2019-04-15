//
//  ProductionImageCell.h
//  TXProject
//
//  Created by Sam on 2019/3/27.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadProductionController.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectArrayCallBack)(NSArray *imageArray);
@interface ProductionImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *imageArray;
@property (nonatomic) UploadProductionController *uploadVC;
@property (nonatomic) SelectArrayCallBack selectArrayCallBack;
-(void)setupCollection;
@end

NS_ASSUME_NONNULL_END
