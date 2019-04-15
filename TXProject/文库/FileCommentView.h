//
//  FileCommentView.h
//  TXProject
//
//  Created by Sam on 2019/3/27.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileCommentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UILabel *sosoLabel;
@property (weak, nonatomic) IBOutlet UILabel *badLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *sureLabel;
@property (weak, nonatomic) IBOutlet UIView *closeView;

@end

NS_ASSUME_NONNULL_END
