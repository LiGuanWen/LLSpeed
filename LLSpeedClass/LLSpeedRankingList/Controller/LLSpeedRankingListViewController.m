
//
//  LLSpeedRankingListViewController.m
//  FDFullscreenPopGesture
//
//  Created by Lilong on 2017/10/15.
//

#import "LLSpeedRankingListViewController.h"
#import "LLSpeedRankingTableViewCell.h"

@interface LLSpeedRankingListViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *gameDataArr;

@end

@implementation LLSpeedRankingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    [self.tableView registerNib:[UINib nibWithNibName:@"LLSpeedRankingTableViewCell" bundle:nil] forCellReuseIdentifier:@"LLSpeedRankingTableViewCell"];

    
    NSArray *dataArr = [[NSUserDefaults standardUserDefaults] objectForKey:SAVE_LLSPEED_GEME_DATA_KEY];
    self.gameDataArr = [[NSMutableArray alloc] init];
    if (dataArr.count > 0) {
        [self.gameDataArr addObjectsFromArray:dataArr];
    }

    self.gameDataArr = (NSMutableArray *)[self arraySortDESC:self.gameDataArr];
    // Do any additional setup after loading the view from its nib.
}

- (NSArray *)arraySortDESC:(NSArray *)array{
    //对数组进行排序
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSMutableDictionary *dict1 = (NSMutableDictionary *)obj1;
        NSMutableDictionary *dict2 = (NSMutableDictionary *)obj2;
        float time1 = [dict1[LLSPEED_SURVIVAL_TIME_KEY] floatValue];
        float time2 = [dict2[LLSPEED_SURVIVAL_TIME_KEY] floatValue];
        if (time1 < time2) {
            return NSOrderedDescending;
        }
        else if (time1 > time2){
            return NSOrderedAscending;
        }else {
            return NSOrderedSame;
        }
    }];
    NSLog(@"result=%@",result);
    return result;
}


#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gameDataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLSpeedRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLSpeedRankingTableViewCell" forIndexPath:indexPath];
    NSMutableDictionary *dict = self.gameDataArr[indexPath.row];
    [cell setupCellWithDict:dict ranking:indexPath.row +1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
