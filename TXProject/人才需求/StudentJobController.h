//
//  StudentJobController.h
//  TXProject
//
//  Created by Sam on 2019/3/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentJobController : UIViewController
-(void)GetNetData;
@property (nonatomic) NSString *jobTypeString;
@property (nonatomic) NSString *educationString;
@property (nonatomic) NSString *jobTimeString;
@end

NS_ASSUME_NONNULL_END
