//
//  SmallWxPayMoneyController.m
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import "SmallWxPayMoneyController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <CommonCrypto/CommonDigest.h>
@interface SmallWxPayMoneyController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UIView *wxPayView;
@property (weak, nonatomic) IBOutlet UIButton *surePay;
@property (weak, nonatomic) IBOutlet UIImageView *alipayIcon;
@property (weak, nonatomic) IBOutlet UIImageView *wxPayIcon;
@property (nonatomic) NSInteger payType;
@end

@implementation SmallWxPayMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block SmallWxPayMoneyController *blockSelf = self;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.payMoney];
    self.descLabel.text = self.payDesc;
    self.payType = 0;
    [self.alipayView bk_whenTapped:^{
        [blockSelf.alipayIcon setImage:[UIImage imageNamed:@"pro_sel_icon"]];
        [blockSelf.wxPayIcon setImage:[UIImage imageNamed:@"none"]];
        blockSelf.payType = 1;
    }];
    [self.wxPayView bk_whenTapped:^{
        [blockSelf.wxPayIcon setImage:[UIImage imageNamed:@"pro_sel_icon"]];
        [blockSelf.alipayIcon setImage:[UIImage imageNamed:@"none"]];
        blockSelf.payType = 2;
    }];
    self.title = @"支付";
    [self.surePay makeCorner:5];
    [self.surePay bk_whenTapped:^{
        [[NSUserDefaults standardUserDefaults] setObject:@"xcx" forKey:@"payType"];
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"classify",USER_SINGLE.member_id,@"member",[NSString stringWithFormat:@"%ld",self.payType],@"pay_method",@"",@"pay_synthesis",@"",@"pay_type",@"4",@"pay_using_type",[NSString stringWithFormat:@"%.2f",self.payMoney],@"xcx_price", nil];
        if (blockSelf.payType == 1) {
            [blockSelf alipayFouction:param];
        }else{
            [blockSelf wxpayFouction:param];
        }
        
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPay) name:@"xcxPay" object:nil];
}
-(void)finishPay{
    [AlertView showYMAlertView:self.view andtitle:@"您已购买小程序服务,请等待客服联系"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)wxpayFouction:(NSDictionary *)dic{
    [HTTPREQUEST_SINGLE postWithURLString:@"price/xcxCreateOrderPay" parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            NSDictionary *dic = responseDic[@"data"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *timeTemp = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
            //            NSString *randomString = [self getRandomNumber];
            UInt32 timeStamp = [timeTemp intValue];
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = @"1513195601";
            req.prepayId            = dic[@"query_str"][@"prepayid"];
            req.nonceStr            = dic[@"query_str"][@"noncestr"];
            req.timeStamp           = [dic[@"query_str"][@"timestamp"] intValue];
            req.package             = @"Sign=WXPay";
            req.sign                = dic[@"query_str"][@"sign"];
            [WXApi sendReq:req];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode)
        {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [self finishPay];
                break;
            case WXErrCodeUserCancel:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                //交易取消
              
                break;
            default:
                NSLog(@"支付失败， retcode=%d",resp.errCode);
             
                break;
        }
    }
}
-(void)alipayFouction:(NSDictionary *)dic{
    [HTTPREQUEST_SINGLE postWithURLString:@"price/xcxCreateOrderPay" parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            NSDictionary *dic = responseDic[@"data"];
            //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //            formatter.dateFormat = @"yyyyMMddHHmmss";
            //            NSString *timeTemp = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
            [self payWithAppScheme:dic[@"query_str"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)payWithAppScheme:(NSString *)payString{
    [[AlipaySDK defaultService] payOrder:payString fromScheme:@"txalipay" callback:^(NSDictionary *resultDic) { // 网页版
        NSLog(@"%@",resultDic);
    }];
}



@end
