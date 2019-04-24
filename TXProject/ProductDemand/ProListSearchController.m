//
//  ProListSearchController.m
//  TXProject
//
//  Created by Sam on 2019/4/17.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProListSearchController.h"

@interface ProListSearchController ()
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@end

@implementation ProListSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block ProListSearchController *blockSelf = self;
    [self.searchLabel bk_whenTapped:^{
    blockSelf.selectStringCallBack(blockSelf.searchTF.text);
        [blockSelf.navigationController popViewControllerAnimated:YES];
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
