//
//  ResultMessageCell.m
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ResultMessageCell.h"
@interface ResultMessageCell()
@property (weak, nonatomic) IBOutlet UIImageView *researchPictures;
@property (weak, nonatomic) IBOutlet UILabel *resultsName;
@property (weak, nonatomic) IBOutlet UILabel *domain;
@property (weak, nonatomic) IBOutlet UILabel *completeUnit;
@property (weak, nonatomic) IBOutlet UILabel *completeTime;

@end

@implementation ResultMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ResultMessageModel *)model
{
    [_researchPictures sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,model.research_pictures]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [self->_researchPictures setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    _resultsName.text = model.results_name;
    _domain.text = [NSString getProfessionalField:model.domain];
    _completeUnit.text = model.complete_unit;
    _completeTime.text = model.complete_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
