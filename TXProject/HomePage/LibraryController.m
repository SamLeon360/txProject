//
//  LibraryController.m
//  TXProject
//
//  Created by Sam on 2019/1/17.
//  Copyright © 2019 sam. All rights reserved.
//

#import "LibraryController.h"
#import "TXWebViewController.h"
#import "LibraryListController.h"
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
        [blockSelf clickToList:@"1"];
    }];
    [self.companyLibrary bk_whenTapped:^{
        [blockSelf clickToList:@"2"];
    }];
    
}
-(void)clickToList:(NSString *)type{
    LibraryListController *vc = [[UIStoryboard storyboardWithName:@"Library" bundle:nil] instantiateViewControllerWithIdentifier:@"LibraryListController"];
    vc.libraryVCType = type;
    [self.navigationController pushViewController:vc animated:YES];
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
