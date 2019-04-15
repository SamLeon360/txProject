//
//  SmallWXController.m
//  TXProject
//
//  Created by Sam on 2019/3/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import "SmallWXController.h"
#import "WKWebViewJavascriptBridge.h"
@interface SmallWXController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (nonatomic) UIButton *popBtn;
@property (nonatomic) UIButton *reloadBtn;
@end

@implementation SmallWXController
{
    WKWebView* webView;
    WKWebViewJavascriptBridge *wkwebJsBrideg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.webContentView.frame.size.width, self.webContentView.frame.size.height)];
    [webView setNavigationDelegate:self];
    webView.clipsToBounds = YES;
    webView.UIDelegate = self;
    [self.webContentView addSubview:webView];
    wkwebJsBrideg = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    [wkwebJsBrideg setWebViewDelegate:self];
    self.title = @"免费制作小程序";
    [webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEB_HOST_URL,@"member/wxsmall_list/1"]]]];
    [wkwebJsBrideg registerHandler:@"getwxmoney" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    self.reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    [self.reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    self.reloadBtn.center = CGPointMake(self.view.center.x - 90, self.view.center.y);
    [self.reloadBtn setBackgroundColor:[UIColor colorWithRGB:0x3e85fb] forState:UIControlStateNormal];
    [self.reloadBtn bk_whenTapped:^{
        [webView reload];
    }];
    self.popBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    [self.popBtn setTitle:@"返回上个界面" forState:UIControlStateNormal];
    self.popBtn.center = CGPointMake(self.view.center.x + 90, self.view.center.y);
    __block SmallWXController *blockSelf = self;
    [self.popBtn bk_whenTapped:^{
        [blockSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.popBtn setBackgroundColor:[UIColor colorWithRGB:0x3e85fb] forState:UIControlStateNormal];
    [self.view addSubview:self.reloadBtn];
    [self.view addSubview:self.popBtn];
    [SVProgressHUD dismiss];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    self.reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    [self.reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    self.reloadBtn.center = CGPointMake(self.view.center.x - 90, self.view.center.y);
    [self.reloadBtn setBackgroundColor:[UIColor colorWithRGB:0x3e85fb] forState:UIControlStateNormal];
    [self.reloadBtn bk_whenTapped:^{
        [webView reload];
    }];
    self.popBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    [self.popBtn setTitle:@"返回上个界面" forState:UIControlStateNormal];
    self.popBtn.center = CGPointMake(self.view.center.x + 90, self.view.center.y);
    __block SmallWXController *blockSelf = self;
    [self.popBtn bk_whenTapped:^{
        [blockSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.popBtn setBackgroundColor:[UIColor colorWithRGB:0x3e85fb] forState:UIControlStateNormal];
    [self.view addSubview:self.reloadBtn];
    [self.view addSubview:self.popBtn];
    [SVProgressHUD dismiss];
}

@end
