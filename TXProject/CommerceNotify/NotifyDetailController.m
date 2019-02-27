//
//  NotifyDetailController.m
//  TXProject
//
//  Created by Sam on 2019/1/15.
//  Copyright © 2019 sam. All rights reserved.
//
#import "WKWebViewJavascriptBridge.h"
#import "NotifyDetailController.h"

@interface NotifyDetailController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *onetitle;
@property (weak, nonatomic) IBOutlet UILabel *twotitle;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) WKWebView* webView;
@end

@implementation NotifyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.onetitle.text = self.notifyDic[@"notification_header"];
    self.twotitle.text = self.notifyDic[@"notification_header2"];
    self.timeLabel.text = [self.notifyDic[@"sending_time"] componentsSeparatedByString:@" "][0];
    self.title = @"通知详情";
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.webContentView.frame.size.width,self.webContentView.frame.size.height)];
    [self.webView setNavigationDelegate:self];
    self.webView.clipsToBounds = YES;
    self.webView.UIDelegate = self;
    [self.webContentView addSubview:self.webView];
    [self.webView loadHTMLString:self.localHtml baseURL:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
