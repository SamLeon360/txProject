//
//  MyGuideController.m
//  TXProject
//
//  Created by Sam on 2019/2/27.
//  Copyright © 2019 sam. All rights reserved.
//

#import "MyGuideController.h"

@interface MyGuideController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation MyGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollview setContentSize:CGSizeMake(ScreenW, 5500*kScale)];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_one"]];
    imageV.frame = CGRectMake(0, 0, ScreenW, 4500*320/ScreenW*kScale);
    ///使用指导

    [self.scrollview addSubview:imageV];
    
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
