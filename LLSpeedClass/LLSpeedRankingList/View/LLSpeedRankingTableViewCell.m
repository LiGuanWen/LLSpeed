
//
//  LLSpeedRankingTableViewCell.m
//  FDFullscreenPopGesture
//
//  Created by Lilong on 2017/10/15.
//

#import "LLSpeedRankingTableViewCell.h"


@interface LLSpeedRankingTableViewCell ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *rankingNumLabel;  //排名
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation LLSpeedRankingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupCellWithDict:(NSMutableDictionary *)dict ranking:(NSUInteger)ranking{
    self.rankingNumLabel.text = [NSString stringWithFormat:@"%zd",ranking];
    NSString *useTime = dict[LLSPEED_SURVIVAL_TIME_KEY];
    NSString *nickName = dict[LLSPEED_CURRENT_USER_KEY];
    NSString *playTime = dict[LLSPEED_CURRENT_TIME_KEY];
    self.useTimeLabel.text = [NSString stringWithFormat:@"生存时长：%@秒",useTime];
    if (nickName.length > 0) {
        self.nickNameLabel.text = [NSString stringWithFormat:@"玩家：%@",nickName];
    }else{
        self.nickNameLabel.text = @"";
    }
    self.playTimeLabel.text = [NSString stringWithFormat:@"%@",playTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
