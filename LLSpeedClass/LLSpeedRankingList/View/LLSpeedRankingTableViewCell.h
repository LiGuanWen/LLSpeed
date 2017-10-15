//
//  LLSpeedRankingTableViewCell.h
//  FDFullscreenPopGesture
//
//  Created by Lilong on 2017/10/15.
//

#import <UIKit/UIKit.h>
#define LLSPEED_SURVIVAL_TIME_KEY @"llspeed_survival_time"   //生存时长
#define LLSPEED_CURRENT_TIME_KEY @"llspeed_current_time"     //当前时长
#define LLSPEED_CURRENT_USER_KEY @"llspeed_current_user"     //当前用户
#define SAVE_LLSPEED_GEME_DATA_KEY @"SAVE_LLSPEED_GEME_DATA_KEY"

@interface LLSpeedRankingTableViewCell : UITableViewCell

- (void)setupCellWithDict:(NSMutableDictionary *)dict ranking:(NSUInteger)ranking;
@end
