//
//  ProCompanyListController.h
//  TXProject
//
//  Created by Sam on 2019/4/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectNSDictionaryCallBack)(NSDictionary *dic);
@interface ProCompanyListController : UIViewController
@property (nonatomic) SelectNSDictionaryCallBack selectNSDictionaryCallBack;
@property (nonatomic) BOOL changeDefault;
@end

NS_ASSUME_NONNULL_END
