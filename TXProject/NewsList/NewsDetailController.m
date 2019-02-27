//
//  NewsDetailController.m
//  TXProject
//
//  Created by Sam on 2019/2/14.
//  Copyright © 2019 sam. All rights reserved.
//

#import "NewsDetailController.h"
#import "WKWebViewJavascriptBridge.h"
@interface NewsDetailController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;


@end

@implementation NewsDetailController
{
    WKWebView* webView;
    WKWebViewJavascriptBridge *wkwebJsBrideg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新政新规详情";
     webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 90, ScreenW, ScreenH-90)];
    [webView setNavigationDelegate:self];
    webView.clipsToBounds = YES;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    wkwebJsBrideg = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    [wkwebJsBrideg setWebViewDelegate:self];
    [self getWebData];
}
-(void)getWebData{
    __block NewsDetailController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"first",self.newsId,@"id",@"3",@"jump_flag", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_GET_NEWS_DETAIL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            NSArray *arr = responseDic[@"data"];
            NSDictionary *dic = arr.firstObject;
            blockSelf.titleLabel.text = dic[@"headlines"];
            blockSelf.otherLabel.text = dic[@"headlines2"];
            [self->webView loadHTMLString:dic[@"news_text"] baseURL:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"%@",URL);
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
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
