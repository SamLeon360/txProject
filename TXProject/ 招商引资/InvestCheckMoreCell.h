//
//  InvestCheckMoreCell.h
//  TXProject
//
//  Created by Sam on 2019/3/5.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
NS_ASSUME_NONNULL_BEGIN

@interface InvestCheckMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *checkMoreLabel;

@end

NS_ASSUME_NONNULL_END
