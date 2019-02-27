//
//  LibraryController.m
//  TXProject
//
//  Created by Sam on 2019/1/17.
//  Copyright © 2019 sam. All rights reserved.
//

#import "LibraryController.h"
#import "TXWebViewController.h"
@interface LibraryController ()
@property (weak, nonatomic) IBOutlet UIView *commerceLibrary;
@property (weak, nonatomic) IBOutlet UIView *companyLibrary;

@end

@implementation LibraryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文库";
    __block LibraryController *blockSelf = self;
    [self.commerceLibrary bk_whenTapped:^{
        TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
        vc.webUrl = [NSString stringWithFormat:@"%@library/commerce_library_list/1/1////0/1",WEB_HOST_URL];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.companyLibrary bk_whenTapped:^{
        TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
        vc.webUrl = [NSString stringWithFormat:@"%@library/commerce_library_list/1/2////0/1",WEB_HOST_URL];
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
