//
//  InvestmentDetailController.m
//  TXProject
//
//  Created by Sam on 2019/1/17.
//  Copyright © 2019 sam. All rights reserved.
//

#import "InvestmentDetailController.h"
#import "TXWebViewController.h"

@interface InvestmentDetailController ()
@property (weak, nonatomic) IBOutlet UIView *projectView;
@property (weak, nonatomic) IBOutlet UIView *instructionView;

@end

@implementation InvestmentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"招商投资";
    __block InvestmentDetailController *blockSelf = self;
    [self.projectView bk_whenTapped:^{
        TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
        vc.webUrl = [NSString stringWithFormat:@"%@merchants/common_merchants_list/1/0//////1",WEB_HOST_URL];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.instructionView bk_whenTapped:^{
        TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
        vc.webUrl = [NSString stringWithFormat:@"%@investment_guide_index/0//1",WEB_HOST_URL];
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
