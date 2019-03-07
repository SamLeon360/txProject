//
//  InvestmentDetailController.m
//  TXProject
//
//  Created by Sam on 2019/3/1.
//  Copyright © 2019 sam. All rights reserved.
//

#import "InvestmentDetailController.h"
#import "InvestmentListController.h"
#import "TXWebViewController.h"
@interface InvestmentDetailController ()
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@end

@implementation InvestmentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.oneLabel makeCorner:5];
    [self.twoLabel makeCorner:5];
    self.title = @"招商引资";
    [self.oneView bk_whenTapped:^{
        InvestmentListController * vc = [[UIStoryboard storyboardWithName:@"Investment" bundle:nil] instantiateViewControllerWithIdentifier:@"InvestmentListController"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.twoView bk_whenTapped:^{
        TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
        vc.webUrl = @"https://app.tianxun168.com/h5/ios_app.html#/investment_guide_index/0///1";
        [self.navigationController pushViewController:vc animated:YES];
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
