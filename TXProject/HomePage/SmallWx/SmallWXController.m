//
//  SmallWXController.m
//  TXProject
//
//  Created by Sam on 2019/3/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import "SmallWXController.h"
#import "WKWebViewJavascriptBridge.h"
#import "PayServiceController.h"
#import "SmallWxPayMoneyController.h"
@interface SmallWXController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (nonatomic) UIButton *popBtn;
@property (nonatomic) UIButton *reloadBtn;
@property (nonatomic) NSDictionary *payDic;
@end

@implementation SmallWXController
{
    WKWebView* webView;
    WKWebViewJavascriptBridge *wkwebJsBrideg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, (self.webContentView.frame.size.height + 20)*kScale)];
    [webView setNavigationDelegate:self];
    webView.clipsToBounds = YES;
    webView.UIDelegate = self;
    [self.webContentView addSubview:webView];
    wkwebJsBrideg = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    [wkwebJsBrideg setWebViewDelegate:self];
    self.title = @"免费制作小程序";
    [webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEB_HOST_URL,@"member/wxsmall_list/1"]]]];
    [wkwebJsBrideg registerHandler:@"getwxmoney" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = data;
        self.payDic = dic;
        if ([dic[@"money"] doubleValue] == 0  ) {
            self.moneyLabel.text = @"面议";
            self.buyLabel.text = @"联系客服";
           
        }else{
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"money"] doubleValue]];
          
        }
        
    }];
    [self.buyLabel bk_whenTapped:^{
        if ([self.moneyLabel.text isEqualToString:@"面议"]) {
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0760-88587021"];
            UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }else{
            SmallWxPayMoneyController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"SmallWxPayMoneyController"];
            vc.payMoney = [self.payDic[@"money"] doubleValue];
            vc.payDesc = @"购买小程序服务";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    
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
