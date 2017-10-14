//
//  LLSpeedGameViewController.m
//  Pods
//
//  Created by Lilong on 2017/9/22.
//
//

#import "LLSpeedGameViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "LLSpeedGameScene.h"

@interface LLSpeedGameViewController ()
@property (nonatomic, strong) SKView *skView;
@property (nonatomic, assign) float timeCount;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isStart;

@end

@implementation LLSpeedGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //主线程调用
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initGame];
    });
    // Do any additional setup after loading the view from its nib.
}

- (void)initGame{
    self.skView = [[SKView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.skView];
    if (!self.skView.scene) {
        self.skView.backgroundColor = [SKColor redColor];
        SKScene *scene = [LLSpeedGameScene sceneWithSize:self.skView.bounds.size];
        [self.skView presentScene:scene];
    }
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
