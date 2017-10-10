//
//  LLSpeedMenuViewController.m
//  Pods
//
//  Created by Lilong on 2017/9/22.
//
//

#import "LLSpeedMenuViewController.h"

#import "LLSpeedRoute.h"
@interface LLSpeedMenuViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *gameImageView;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *beginButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *aboutButton;
@end

@implementation LLSpeedMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//开始游戏
- (IBAction)gameBeginAction:(id)sender {
//    [LLSpeedRoute routeWithUrl:[NSURL URLWithString:llspeed_routeWithBegin] currentVC:self hidesBottomBarWhenPushed:YES parameterDict:nil];
    [LLRoute routeWithUrl:[NSURL URLWithString:llspeed_routeWithBegin] currentVC:self hidesBottomBarWhenPushed:YES parameterDict:nil];
}
//关于游戏
- (IBAction)gameAboutAction:(id)sender {
    [LLRoute routeWithUrl:[NSURL URLWithString:llspeed_routeWithAbout] currentVC:self hidesBottomBarWhenPushed:YES parameterDict:nil];
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
