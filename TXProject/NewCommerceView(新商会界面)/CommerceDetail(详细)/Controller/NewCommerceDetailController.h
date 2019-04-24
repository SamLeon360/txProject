//
//  NewCommerceDetailController.h
//  TXProject
//
//  Created by Sam on 2019/4/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewCommerceDetailController : UIViewController
@property (nonatomic,strong) NSString *commerceId;
@property (nonatomic,assign) NSInteger tableType;
@property(nonatomic,assign) BOOL commerceCheckMore;
@property (nonatomic,assign) BOOL secretariatCheckMore;
@property (nonatomic,assign) BOOL cooditionCheckMore;
-(void)reloadTableView;
-(void)reloadCommerceCell;
-(void)reloadSecretCell;
-(void)reloadConditionCell;
-(void)countMasterNumber;
@end

NS_ASSUME_NONNULL_END
