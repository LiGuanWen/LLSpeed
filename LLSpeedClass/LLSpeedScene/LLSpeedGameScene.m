//
//  LLSpeedGameScene.m
//  LLRoute
//
//  Created by Lilong on 2017/10/12.
//

#import "LLSpeedGameScene.h"
@import AVFoundation;

#define RunInPlacePlayer @"runInPlacePlayer"

static const uint32_t playerCategory       =  0x1 << 0;
static const uint32_t objectCategory       =  0x1 << 1;
static const uint32_t groundCategory       =  0x1 << 2;
static const uint32_t StageCategory        =  0x1 << 3;


@interface LLSpeedGameScene ()<SKPhysicsContactDelegate>{
    dispatch_source_t timergcd;  //
}
@property (nonatomic, strong) SKSpriteNode *player;   //跑步者🏃
@property (nonatomic, strong) SKSpriteNode *ground;   //底线
@property (nonatomic, strong) SKSpriteNode *object;    //台阶

@property (strong, nonatomic) SKLabelNode *timeLabel;  //计时器
@property (strong, nonatomic) NSMutableArray *playerRunFrames;  //存储跑步帧

@property (assign, nonatomic) float timeCount;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;  //播放音频

@property (nonatomic) BOOL isJumping;  //是否跳起重

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@end

@implementation LLSpeedGameScene

- (void)dealloc{
    NSLog(@"内存释放");
}

- (instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        //设置场景背景色
        self.backgroundColor = [SKColor whiteColor];
        [self createPlayer];  //创建人物
        [self createGround];  //创建底线
        [self createStage];   //创建平台
        [self createTimeLabel];  //创建计时器
        [self createCountDounLabel];  //开始倒计时
        self.physicsWorld.gravity = CGVectorMake(0 , -5);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}


// 场景人物
- (void)createPlayer{
    //构建一个用于存包跑步帧 （run frame）
    NSMutableArray *runFrames = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"perRun%d", i];
        SKTexture *temp = [SKTexture textureWithImageNamed:textureName];
        [runFrames addObject:temp];
    }
    self.playerRunFrames = runFrames;
    //创建sprite,并将其位置设置在屏幕左侧，然后添加到场景中
    if (self.playerRunFrames.count < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"人物图片不存在" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
        return;
    }
    SKTexture *temp = self.playerRunFrames[0];
    self.player = [[SKSpriteNode alloc]initWithTexture:temp color:[UIColor clearColor] size:CGSizeMake(30, 40)];
    if ([[UIScreen mainScreen]bounds].size.width == 768) {
        self.player.size = CGSizeMake(40, 55);
    }
    self.player.position = CGPointMake(40, CGRectGetMidY(self.frame) + 95);
    [self addChild:self.player];
    [self runPlayer];
    //物理属性设置
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.physicsBody.dynamic = YES;
    self.player.physicsBody.friction = 0.2;   //摩擦力
    self.player.physicsBody.categoryBitMask = playerCategory;
    self.player.physicsBody.contactTestBitMask = objectCategory | groundCategory | StageCategory;
    self.player.physicsBody.collisionBitMask = objectCategory | groundCategory | StageCategory;
    self.player.physicsBody.usesPreciseCollisionDetection = YES;
    self.player.physicsBody.allowsRotation = NO;

}
//添加人物奔跑方法
- (void)runPlayer{
    [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.playerRunFrames timePerFrame:0.03f resize:NO restore:YES]] withKey:RunInPlacePlayer];
    
}
//创建底线
- (void)createGround{
    self.ground = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"sceneView_ground"] color:[UIColor clearColor] size:CGSizeMake(self.size.width, 30)];
    if ([[UIScreen mainScreen] bounds].size.width == 768) {
        self.ground.size = CGSizeMake(self.size.width, 45);
    }
    self.ground.position = CGPointMake(self.size.width / 2, CGRectGetMidY(self.frame) - 165);
    [self addChild:self.ground];
    
    self.ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.ground.size];
    self.ground.physicsBody.dynamic = NO;
    self.ground.physicsBody.affectedByGravity = NO;
    self.ground.physicsBody.contactTestBitMask = playerCategory;
    self.ground.physicsBody.categoryBitMask = groundCategory;
    self.ground.physicsBody.collisionBitMask = playerCategory;
    self.ground.physicsBody.usesPreciseCollisionDetection = YES;
}
//创建平台
- (void)createStage{
    SKSpriteNode *stage = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(self.frame.size.width * 3, 250)];
    stage.position = CGPointMake(self.size.width, CGRectGetMidY(self.frame) - 50);
    [self addChild:stage];
    //初始平台
    stage.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:stage.size];
    stage.physicsBody.dynamic = NO;
    stage.physicsBody.affectedByGravity = NO;
    stage.physicsBody.categoryBitMask = StageCategory;
    stage.physicsBody.collisionBitMask = playerCategory;
    stage.physicsBody.contactTestBitMask = playerCategory;
    stage.physicsBody.usesPreciseCollisionDetection = YES;
    int duration = 5;
    if ([UIScreen mainScreen].bounds.size.width == 768) {
        stage.size = CGSizeMake(self.size.width * 2, 250);
        duration = 4;
    }
    SKAction *actionMove = [SKAction moveToX:-stage.size.width / 2 duration:duration];
    [stage runAction:[SKAction sequence:@[actionMove, [SKAction removeFromParent]]]];
}

//创建计时器
- (void)createTimeLabel{
    self.timeLabel = [[SKLabelNode alloc] init];
    self.timeLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 180);
    self.timeLabel.fontSize = 50;
    self.timeLabel.fontColor = [SKColor blackColor];
    self.timeLabel.text = @"0.0";
    [self addChild:self.timeLabel];
    if ([UIScreen mainScreen].bounds.size.width == 768) {
        self.timeLabel.fontSize = 120;
        self.timeLabel.position = CGPointMake(self.size.width/2, self.size.height/2+250);
    }
}
//倒计时
- (void)createCountDounLabel{
    SKLabelNode *countLabel = [[SKLabelNode alloc] init];
    countLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 110);
    countLabel.fontColor = [SKColor blackColor];
    countLabel.text = @"3";
    countLabel.fontSize = 50;
    [self addChild:countLabel];
    //添加动画
    SKAction *act1 = [SKAction scaleTo:1.2 duration:1];
    SKAction *act2 = [SKAction scaleTo:1.3 duration:1];
    SKAction *act3 = [SKAction scaleTo:1.4 duration:1];
    SKAction *act4 = [SKAction scaleTo:1.5 duration:1];
    [countLabel runAction:act1 completion:^{
        countLabel.fontSize = 50;
        countLabel.text = @"2";
        [countLabel runAction:act2 completion:^{
            countLabel.text = @"1";
            countLabel.fontSize = 50;
            [countLabel runAction:act3 completion:^{
                countLabel.fontSize = 50;
                countLabel.text = @"游戏开始！";
                //倒计时结束开始游戏计时
                [self startTime];
                [countLabel runAction:act4 completion:^{
                    [countLabel removeFromParent];
                }];
            }];
        }];
    }];
}

- (void)startTime{
    [self startTimergcd];
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle]URLForResource:@"bgm1" withExtension:@"caf"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)addTime{
    self.timeCount++;
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f", self.timeCount/10];
    NSLog(@"%@",self.timeLabel.text);
}

/**
 启动配置定时器
 */
- (void)startTimergcd{
    if (timergcd) {
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timergcd = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timergcd,dispatch_walltime(NULL, 0),0.1*NSEC_PER_SEC, 0); //每0.01秒执行
    dispatch_source_set_event_handler(timergcd, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addTime];
        });
    });
    dispatch_resume(timergcd);
}

/**
 停止配置定时器
 */
- (void)stopTimergcd{
    if (timergcd) {
        dispatch_source_cancel(timergcd);
    }
    timergcd = nil;
}

#pragma mark - 点击触发跳跃
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isJumping) {
        return;
    }
    NSLog(@"跳起来");
    [self jumpPlayer];
}
//人物跳跃
- (void)jumpPlayer{
    //设置为跳跃状态
    self.isJumping = YES;
    //删除跑的动画
    [self.player removeAllActions];
    //跳跃时的动画
    float duration = 0.6;
    
    SKAction *jumpAction = [SKAction animateWithTextures:self.playerRunFrames timePerFrame:0.08 resize:NO restore:YES];
    //向上移动的动画
    SKAction *moveUpAction = [SKAction moveTo:CGPointMake(self.player.position.x, self.player.position.y+90) duration:duration/2+0.04];
    SKAction *holdAction = [SKAction waitForDuration:0.03];
    //    SKAction *moveDownAction=[SKAction moveTo:CGPointMake(self.player.position.x, self.player.position.y) duration:duration/2-0.04];
    
    __weak LLSpeedGameScene *blockSelf = self;
    [self.player runAction:[SKAction group:@[jumpAction,[SKAction sequence:@[moveUpAction,holdAction]]]] completion:^{
        SKAction *runAction = [SKAction repeatActionForever:[SKAction animateWithTextures:blockSelf.playerRunFrames timePerFrame:0.03f resize:NO restore:YES]];
        [blockSelf.player runAction:runAction withKey:RunInPlacePlayer];
    }];
}

#pragma mark - 处理时间增量  SKScene 父类方法重写
- (void)update:(NSTimeInterval)currentTime{
    //处理时间增量
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0/60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    if (self.player.position.y <= self.ground.position.y) {
        [self gameOver];
    }
    if (self.player.position.x <= 40) {
        [self.player runAction:[SKAction moveToX:40 duration:1]];;
    }
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast{
    //将上次更新(update调用)的时间追加到self.lastSpawnTimeInterval中
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > (arc4random()%30 + 70) * 0.01) {
        self.lastSpawnTimeInterval = 0;
        [self addObject];
    }
}
- (void)addObject{
    int duration = 2;
    int width = arc4random()%200+50;
    SKColor *color = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    if ([[UIScreen mainScreen]bounds].size.width == 768) {
        duration = 3;
    }
    if ([self.timeLabel.text floatValue]>60) {
        width = arc4random()%100 + 150;
        duration = 1.9;
    }
    if([self.timeLabel.text floatValue] > 180){
        color = [SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    }
    self.object = [[SKSpriteNode alloc]initWithColor:color size:CGSizeMake(width, 5)];
    self.object.position = CGPointMake(self.frame.size.width * 1.2 + self.object.size.width, CGRectGetMidY(self.frame) - arc4random()%60 + 40 + self.object.size.height / 2);
    [self addChild:self.object];
    self.object.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.object.size];
    self.object.physicsBody.categoryBitMask = objectCategory;
    self.object.physicsBody.collisionBitMask = playerCategory;
    self.object.physicsBody.contactTestBitMask = playerCategory;
    self.object.physicsBody.allowsRotation = NO;
    self.object.physicsBody.affectedByGravity = NO;
    self.object.physicsBody.dynamic = NO;
    if([self.timeLabel.text floatValue] > 180){
        self.object.physicsBody.dynamic = YES;
    }
    [self gameDifficultyChange];
    SKAction *actionMove = [SKAction moveToX:-self.object.size.width / 2 duration:duration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self.object runAction:[SKAction sequence:@[actionMove,actionMoveDone]]];
}

#pragma mark - 游戏难度随时间递增

- (void)gameDifficultyChange{
    SKAction *act = [SKAction moveToX:-self.size.width duration:5];
    SKLabelNode *countLabel = [[SKLabelNode alloc] init];
    countLabel.position = CGPointMake(self.size.width + countLabel.frame.size.width / 2, self.size.height / 2 + 110);
    countLabel.fontColor =[ SKColor blackColor];
    countLabel.fontSize = 20;
    if ([UIScreen mainScreen].bounds.size.width == 768) {
        countLabel.fontSize = 40;
    }
    if ([self.timeLabel.text floatValue] > 60 & [self.timeLabel.text floatValue] < 60.3) {
        countLabel.text = @"你竟然跑了1分钟了，看来得给你加点难度了";
        [self addChild:countLabel];
        [countLabel runAction:act completion:^{
            [countLabel removeFromParent];
        }];
        
        NSError *error;
        NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"bgm2" withExtension:@"caf"];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        self.audioPlayer.numberOfLoops = -1;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
    if ([self.timeLabel.text floatValue] > 180 & [self.timeLabel.text floatValue] < 180.3) {
        countLabel.text = @"3分钟了！可是没有人能在这个游戏撑过4分钟！你也不行！";
        [self addChild:countLabel];
        [countLabel runAction:act completion:^{
            [countLabel removeFromParent];
        }];
    }
}

#pragma mark SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & objectCategory) != 0){
        if (contact.contactPoint.y > firstBody.node.position.y) {
            NSLog(@"1=%f,2=%f", contact.contactPoint.y, firstBody.node.position.y);
            self.isJumping = YES;
        }else{
            NSLog(@"跳上了台阶");
            self.isJumping = NO;
        }
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & groundCategory) != 0) {
        [self runAction:[SKAction playSoundFileNamed:@"gameOverSound.caf" waitForCompletion:NO]];
        [self gameOver];
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & StageCategory) != 0){
        NSLog(@"初始台阶");
        self.isJumping = NO;
    }
}
- (void)didEndContact:(SKPhysicsContact *)contact{
    
}

- (void)gameOver{
    [self stopTimergcd];
}

@end
