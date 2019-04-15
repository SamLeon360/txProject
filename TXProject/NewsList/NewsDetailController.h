//
//  NewsDetailController.h
//  TXProject
//
//  Created by Sam on 2019/2/14.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailController : UIViewController
@property (nonatomic) NSString *newsId;
@property (nonatomic) NSDictionary *newsDic;
@property (nonatomic) NSInteger typeIndex;
@end

NS_ASSUME_NONNULL_END
