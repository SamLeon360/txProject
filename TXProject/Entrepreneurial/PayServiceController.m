
//
//  PayServiceController.m
//  TXProject
//
//  Created by Sam on 2019/2/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import "PayServiceController.h"
#import "PayServiceView.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <CommonCrypto/CommonDigest.h>
@interface PayServiceController ()<WXApiDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectPayView;
@property (weak, nonatomic) IBOutlet UIButton *finishPayBtn;
@property (nonatomic) NSDictionary *orderParam;
@property (nonatomic) PayServiceView *payWayView;
@end

@implementation PayServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"service_type"],@"pay_type",nil];
    __block PayServiceController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_PRICE_PAY parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            NSDictionary *dic = responseDic[@"data"][0];
            blockSelf.titleLabel.text = dic[@"desc"];
            blockSelf.priceLabel.text = [NSString stringWithFormat:@"¥%@",dic[@"price"]];
            blockSelf.getMoneyLabel.text = @"天寻商会";
            blockSelf.goodsLabel.text = dic[@"desc"];
        }
        NSLog(@"%@",responseDic);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
   
    [self.view addSubview:self.payWayView];
    [self.selectPayView bk_whenTapped:^{
        self.payWayView.hidden = NO;
      
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadData) name:@"uploadDatga" object:nil];
}
-(void)wxpayFouction:(NSDictionary *)dic{
    [HTTPREQUEST_SINGLE postWithURLString:SH_CREAT_ORDER parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
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
-(void)alipayFouction:(NSDictionary *)dic{
    [HTTPREQUEST_SINGLE postWithURLString:SH_CREAT_ORDER parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
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
    __block PayServiceController *blockSelf = self;
    [[AlipaySDK defaultService] payOrder:payString fromScheme:@"alipay" callback:^(NSDictionary *resultDic) { // 网页版
        NSLog(@"支付宝支付结果 reslut = %@", resultDic);
        
        // 返回结果需要通过 resultStatus 以及 result 字段的值来综合判断并确定支付结果。 在 resultStatus=9000,并且 success="true"以及 sign="xxx"校验通过的情况下,证明支付成功。其它情况归为失败。较低安全级别的场合,也可以只通过检查 resultStatus 以及 success="true"来判定支付结果
        
//        if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
//            [blockSelf uploadData];
//            
//        } else {
//            
//            // 发通知带出支付失败结果
//            //                [ZLNotificationCenter postNotificationName:QTXAliReturnFailedPayNotification object:resultDic];
//        }
    }];
}
    
-(void)wxPay{
    self.orderParam = [[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"pay_method",self.dataDic[@"service_type"],@"pay_type",@"4",@"pay_using_type", nil];
    [self wxpayFouction:self.orderParam];
   
}
-(void)aliPay{
    self.orderParam = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"pay_method",self.dataDic[@"service_type"],@"pay_type",@"3",@"pay_using_type", nil];
    [self alipayFouction:self.orderParam];
}
-(NSString *)getRandomNumber{
    NSString *stringA = @"appid=1513195601";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeTemp = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    NSString *randomNumber = [NSString stringWithFormat:@"%@%@",stringA,timeTemp];
    randomNumber = [self md5:randomNumber];
    return randomNumber;
}
-(void)uploadData {
    [HTTPREQUEST_SINGLE uploadImageArrayWithUrlStr:[self.typeString isEqualToString:@"创业宝典"]?SH_UPLOAD_SERVICE:SH_UPLOAD_ZONGHE parameters:self.paramDic withHub:YES constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *imgName = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
        NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", @"commerce", imgName];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.uploadIamge, 0.6) name:@"service_img[]" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(double progress) {
        [SVProgressHUD showProgress:progress];
    } success:^(NSDictionary *responseDic) {
        NSLog(@"%@",responseDic);
        if ([responseDic[@"code"] integerValue] == -1002) {
            [AlertView showYMAlertView:self.view andtitle:@"申请成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getDataArrayByRefresh" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *vcArray = self.navigationController.childViewControllers;
                UIViewController *tempVC = vcArray[2];
                [self.navigationController popToViewController:tempVC animated:YES];
            });
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"资料填写错误"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

#pragma mark -  微信支付本地签名
-(NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key
{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@",@"txcc6cba83a6f173c8a1e2bb452ea1tx"];
    NSString *result = [self md5:contentString];
    return result;
    
}//创建发起支付时的sige签名
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"这里添加SecretKey"];
    
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}
-(PayServiceView *)payWayView{
    if (_payWayView == nil) {
        _payWayView = [[NSBundle mainBundle] loadNibNamed:@"Entrepreneurial" owner:self options:nil][2];
        _payWayView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        [_payWayView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        __block PayServiceController *blockSelf = self;
        _payWayView.hidden = YES;
        [_payWayView.wxView bk_whenTapped:^{
            [blockSelf wxPay];
        }];
        [_payWayView.alipayView bk_whenTapped:^{
            [blockSelf aliPay];
        }];
        [_payWayView.closeView bk_whenTapped:^{
            blockSelf.payWayView.hidden = YES;
        }];
        _payWayView.sureBtn.hidden = YES;
    }
    return _payWayView;
}
@end
