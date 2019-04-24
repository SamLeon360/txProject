//
//  ComNewsDetailController.m
//  TXProject
//
//  Created by Sam on 2019/1/15.
//  Copyright © 2019 sam. All rights reserved.
//
#import "WKWebViewJavascriptBridge.h"
#import "ComNewsDetailController.h"

@interface ComNewsDetailController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *onetitle;
@property (weak, nonatomic) IBOutlet UILabel *twotitle;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic) WKWebView* webView;
@end

@implementation ComNewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.webContentView.frame.size.width,self.webContentView.frame.size.height)];
//    [self.webView setNavigationDelegate:self];
//    self.webView.clipsToBounds = YES;
//    self.webView.UIDelegate = self;
//    [self.webContentView addSubview:self.webView];
    [self getNewsData];
}

-(void)getNewsData{
    __block ComNewsDetailController *blockSelf = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.notifyDic[@"id"],@"id", nil];
    [HTTPREQUEST_SINGLE allUserHeaderPostWithURLString:SH_DETAIL_NEWS parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            blockSelf.onetitle.text = blockSelf.notifyDic[@"news_headlines"];
            blockSelf.twotitle.text = blockSelf.notifyDic[@"news_headlines2"];
            blockSelf.timeLabel.text = [blockSelf.notifyDic[@"modify_time"] componentsSeparatedByString:@" "][0];
            blockSelf.title = @"社团新闻详情";
            NSArray *arrDic = responseDic[@"data"];
            NSDictionary *dic = arrDic.firstObject;
            blockSelf.contentLabel.text =dic[@"news_text"];
//            [blockSelf.webView loadHTMLString:blockSelf.notifyDic[@"news_text"] baseURL:nil];
        }
    } failure:^(NSError *error) {
        
    }];
   
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
