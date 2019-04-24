//
//  ExpertTeamCell.m
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ExpertTeamCell.h"
@interface ExpertTeamCell()
@property (weak, nonatomic) IBOutlet UIImageView *team_image;
@property (weak, nonatomic) IBOutlet UILabel *team_name;
@property (weak, nonatomic) IBOutlet UILabel *leader;
@property (weak, nonatomic) IBOutlet UILabel *job_name;
@property (weak, nonatomic) IBOutlet UILabel *major;
@property (weak, nonatomic) IBOutlet UILabel *unit_name;
@property (weak, nonatomic) IBOutlet UILabel *post_time;

@end

@implementation ExpertTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ExpertTeamModel *)model{
    NSArray *imageArr = [model.team_photo componentsSeparatedByString:@"|"];

    [_team_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,imageArr.count>0?imageArr.firstObject:@""]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [self->_team_image setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    _team_name.text = model.team_name;
    _leader.text = model.team_leaders_name;
    _job_name.text = model.responsible_jobtitle;
    _major.text = [NSString getProfessionalField:model.professional_field];
    _post_time.text = [NSString stringWithFormat:@"%@发布",model.formation_date];
    _unit_name.text = model.unit_name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
