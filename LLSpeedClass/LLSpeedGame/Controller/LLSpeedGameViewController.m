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

@interface LLSpeedGameViewController ()<UIActionSheetDelegate>
@property (nonatomic, strong) SKView *skView;
@property (nonatomic, assign) float timeCount;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, strong) LLSpeedGameScene *gameScene;

@end

@implementation LLSpeedGameViewController


/**
 隐藏导航栏
 */
- (BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

/**
 隐藏返回手势
 */
- (BOOL)fd_interactivePopDisabled{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationItem.leftBarButtonItem = nil;
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
        self.gameScene = [[LLSpeedGameScene alloc] initWithSize:self.skView.bounds.size superVC:self];
        [self.skView presentScene:self.gameScene];
    }
    float widhtHeight = 25;
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - widhtHeight - 20, 30, widhtHeight, widhtHeight)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateSelected];
    [settingBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
}

- (void)settingBtnAction{
    BOOL isClose = [self.gameScene checkIsCloseBgMusic];
    NSString *hintMusic;
    if (isClose) {
        hintMusic = @"打开声音";
    }else{
        hintMusic = @"关闭声音";
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:hintMusic,@"退出游戏", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 ) {
        //开关背景音乐
        BOOL isClose = [self.gameScene checkIsCloseBgMusic];
        [self.gameScene bgMusicOpenStatus:isClose];
    }else if (buttonIndex == 1){
        [self.gameScene quitGame];
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
