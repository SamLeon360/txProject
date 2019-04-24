//
//  ProListSearchController.h
//  TXProject
//
//  Created by Sam on 2019/4/17.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectStringCallBack)(NSString *str);
NS_ASSUME_NONNULL_BEGIN

@interface ProListSearchController : UIViewController
@property (nonatomic) SelectStringCallBack  selectStringCallBack;
@end

NS_ASSUME_NONNULL_END
