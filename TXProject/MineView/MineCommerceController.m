//
//  MineCommerceController.m
//  TXProject
//
//  Created by Sam on 2019/2/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "MineCommerceController.h"
#import <SDCycleScrollView.h>
#import "CommerceDetailController.h"
#import "MemberListController.h"
#import "CommerceNotifyController.h"
#import "CommerceList.h"
#import "CommerceNewsController.h"
@interface MineCommerceController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoHeight;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *commerceName;
@property (weak, nonatomic) IBOutlet UILabel *memberJob;
@property (weak, nonatomic) IBOutlet UILabel *changeCommerce;
@property (weak, nonatomic) IBOutlet UIView *introduceView;
@property (weak, nonatomic) IBOutlet UIView *memberView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIView *newsView;
@property (weak, nonatomic) IBOutlet UIView *commerceView;
@property (nonatomic) CommerceList *commerceList ;
@end

@implementation MineCommerceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的社团";
    
    [self getCommerceListData];
    [self setupClickAction];
}
-(void)updateDefaultCommerce {
    self.commerceName.text = USER_SINGLE.default_commerce_name;
    self.memberJob.text = [[NSString stringWithFormat:@"%@",USER_SINGLE.default_role_type] isEqualToString:@"2"]?@"个人职位：会员":@"个人职位：秘书长";
    [self getCommerceImage];
    self.commerceList.hidden = YES;
}
-(void)getCommerceListData{

    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.exp,@"exp",USER_SINGLE.member_id,@"member_id",USER_SINGLE.role_type,@"role_type",USER_SINGLE.default_commerce_id,@"default_commerce_id",USER_SINGLE.default_role_type,@"default_role_type",USER_SINGLE.TokenFrom,@"TokenFrom", nil];
    [HTTPREQUEST_SINGLE shitPostWithURLString:COMMERCE_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSArray *dataArray = responseDic[@"data"];
        USER_SINGLE.commerceArray = dataArray;
        if (dataArray.count > 0 ) {
            NSDictionary *dic = dataArray.firstObject;
            if (USER_SINGLE.default_commerce_id == nil) {
                USER_SINGLE.default_commerce_name = dic[@"commerce_name"];
                USER_SINGLE.default_commerce_id = dic[@"commerce_id"];
            }
            self.commerceName.text = USER_SINGLE.default_commerce_name;
            self.memberJob.text = [[NSString stringWithFormat:@"%@",USER_SINGLE.default_role_type] isEqualToString:@"2"]?@"个人职位：会员":@"个人职位：秘书长";
            [self getCommerceImage];
            [self.changeCommerce bk_whenTapped:^{
                [self showCommerceListView:dataArray];
            }];
        }else{
            self.autoHeight.constant = 0;
            self.commerceView.hidden = YES;
            [AlertView showYMAlertView:self.view andtitle:@"请先申请加入社团"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                });
        }
       
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    }];
}
-(void)getCommerceImage{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.default_commerce_id,@"commerce_id", nil];
    [HTTPREQUEST_SINGLE getWithURLString:HOME_SCROLL_IMAGE parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            NSString *imgURLString = responseDic[@"data"][@"u_recycle_img"];
            NSArray *imageurlArray = [imgURLString componentsSeparatedByString:@"|"];
            NSMutableArray *adervtImageArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i <= imageurlArray.count - 1; i ++) {
                NSString *imageString = [NSString stringWithFormat:@"%@%@",@"https://app.tianxun168.com",imageurlArray[i]];
                [adervtImageArray addObject:imageString];
            }
            self.contentImage.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            self.contentImage.imageURLStringsGroup = adervtImageArray;
            self.contentImage.showPageControl = YES;
            [self.contentImage setAutoScrollTimeInterval:5];
            self.contentImage.autoScroll = adervtImageArray.count >1?YES:NO;
            self.contentImage.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)showCommerceListView:(NSArray *)commerceArray{
    self.commerceList = [[NSBundle mainBundle] loadNibNamed:@"CommerceList" owner:self options:nil][0];
    self.commerceList.commerceArray = commerceArray;
//    [self.commerceList setCommerceArray:commerceArray];
    if (commerceArray.count <= 3) {
        self.commerceList.frame =  CGRectMake(0, 0, 261, 60 * commerceArray.count + 40);
    }else{
        self.commerceList.frame =  CGRectMake(0, 0, 261, 60 * 3 + 40);
    }
    [self.commerceList.closeBtn bk_whenTapped:^{
        self.commerceList.hidden = YES;
    }];
    self.commerceList.mineVC = self;
    self.commerceList.center = self.view.center;
    [self.view addSubview:self.commerceList];
    [self.commerceList setupTableView];
}
-(void)setupClickAction{
    __block MineCommerceController *blockSelf = self;
    
    [self.introduceView bk_whenTapped:^{
        CommerceDetailController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceDetailController"];
        vc.commerceId = USER_SINGLE.default_commerce_id;
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.memberView bk_whenTapped:^{
        MemberListController *vc = [[UIStoryboard storyboardWithName:@"MemberList" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberListController"];
        vc.checkMember = NO;
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.noticeView bk_whenTapped:^{
        CommerceNotifyController *vc = [[UIStoryboard storyboardWithName:@"CommerceNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceNotifyController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.newsView bk_whenTapped:^{
        CommerceNewsController *vc = [[UIStoryboard storyboardWithName:@"CommerceNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceNewsController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
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
