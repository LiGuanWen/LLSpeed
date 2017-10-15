//
//  LLSpeedGameScene.h
//  LLRoute
//
//  Created by Lilong on 2017/10/12.
//

#import <SpriteKit/SpriteKit.h>

@interface LLSpeedGameScene : SKScene


- (instancetype)initWithSize:(CGSize)size superVC:(UIViewController *)superVC;

//检查是否关闭了背景音乐
- (BOOL)checkIsCloseBgMusic;
//打开 关闭 背景音乐
- (void)bgMusicOpenStatus:(BOOL)status;
//退出游戏
- (void)quitGame;
@end
