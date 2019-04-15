//
//  ProductionSelectView.h
//  TXProject
//
//  Created by Sam on 2019/4/2.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectStringCallBack)(NSString *str);
@interface ProductionSelectView : UIView
@property (weak, nonatomic) IBOutlet UILabel *selectArea;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *refreshView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *resetLabel;
@property (weak, nonatomic) IBOutlet UILabel *sureLabel;
@property (nonatomic) NSArray *dataArray ;
@property (weak, nonatomic) IBOutlet UIImageView *closeIcon;
@property (nonatomic) SelectStringCallBack  selectStringCallBack;
-(void)setupCollection;
@end

NS_ASSUME_NONNULL_END
