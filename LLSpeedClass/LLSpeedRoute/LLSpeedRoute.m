//
//  LLSpeedRoute.m
//  LLRoute
//
//  Created by Lilong on 2017/10/10.
//

#import "LLSpeedRoute.h"

#import "LLSpeedAboutViewController.h"  //关于
#import "LLSpeedMenuViewController.h"   //菜单
#import "LLSpeedGameViewController.h"   //开始

@implementation LLSpeedRoute


/**
 跳转前缀
 */
+(NSString *)routeName{
    return LLSPEED_SCHEME;
}

/**
 组件scheme跳转   子类重新 参考！！！！！！
 
 @param schemeUrl scheme参数
 @param dic 其他特殊参数
 */
+ (void)routeToSchemeUrl:(NSURL *)schemeUrl parameter:(NSMutableDictionary *)dic{
    UIViewController *currentVC = [dic objectForKey:CURRENT_VC_KEY];
    NSLog(@"当前页面  currvc class = %@",[currentVC class]);
    NSString *hidesBottomStr = [dic objectForKey:HIDESBOTTOMBARWHENPUSHED_KEY];
    BOOL hidesBottom;
    if ([hidesBottomStr isEqualToString:HIDESBOTTOMBARWHENPUSHED_YES]) {
        hidesBottom = YES;
    }else{
        hidesBottom = NO;
    }
    [LLSpeedRoute routeWithUrl:schemeUrl currentVC:currentVC hidesBottomBarWhenPushed:hidesBottom parameterDict:dic];
}

/**
 路径跳转
 
 @param url 跳转的url
 @param currentVC 当前跳转的UIViewController
 @param hidesBottomBarWhenPushed 是否隐藏tabbar
 @param parameterDict 需要传递的参数
 */
+ (LLSpeedRoute *)routeWithUrl:(NSURL *)url currentVC:(UIViewController *)currentVC hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed parameterDict:(NSMutableDictionary *)parameterDict{
    LLSpeedRoute *route = [[LLSpeedRoute alloc] initWithUrl:url currentVC:currentVC hidesBottomBarWhenPushed:hidesBottomBarWhenPushed parameterDict:parameterDict];
    return route;
}

- (id)initWithUrl:(NSURL *)url currentVC:(UIViewController *)currentVC hidesBottomBarWhenPushed:(BOOL)yes parameterDict:(NSMutableDictionary *)parameterDict{
    self = [super init];
    if (self) {
        self.currentVC = currentVC;
        self.linkUrl = url;
        self.hidesBottom = yes;
        self.parameterDict = parameterDict;
        [self startParsingWithUrl:url];
    }
    return self;
}

#pragma mark - 开始解析
/**
 *  开始解析
 *
 *  @param url url description
 */
-(void)startParsingWithUrl:(NSURL *)url{
    NSString *scheme = url.scheme;
    if ([scheme hasPrefix:LLSPEED_SCHEME]) {
        [self routeToModule:[LLRoute getModuleInfo:url]];
    }else if ([scheme isEqualToString:@"http"]||[scheme isEqualToString:@"https"]||[scheme isEqualToString:@"ftp"])
    {
        [self parseToOtherLinkWithUrl:url.absoluteString];
    }else if ([scheme isEqualToString:@"tel"])
    {
        [self parseToPhoneCallWithUrl:url.absoluteString];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"链接地址错误" message:url.absoluteString delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - 解析到对应的模块
/**
 *  解析模块  (内部)
 *
 *  @param moduleInfo url description
 */
-(void)routeToModule:(LLModuleInfo*)moduleInfo{
    if ([moduleInfo.moduleName isEqualToString:@"game"]) {
        //
        [self routeToGameWithModule:moduleInfo];
    }
    
}
/**
 *  解析为外部链接
 *
 *  @param url url description
 */
-(void)parseToOtherLinkWithUrl:(NSString*)url{
    
}

/**
 *  拨打电话
 *
 *  @param url url description
 */
-(void)parseToPhoneCallWithUrl:(NSString*)url{
    UIWebView*callWebview =[[UIWebView alloc] init] ;
    NSURL *telURL =[NSURL URLWithString:url];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.currentVC.view addSubview:callWebview];
}


- (void)routeToGameWithModule:(LLModuleInfo*)moduleInfo{
    //开始
    if ([moduleInfo.page isEqualToString:@"/begin"]) {
        [LLSpeedRoute pushToGameBeginWithCurrVC:self.currentVC];
        return;
    }
    //菜单
    if ([moduleInfo.page isEqualToString:@"/menu"]) {
        [LLSpeedRoute pushToGameMenuWithCurrVC:self.currentVC];
        return;
    }
    //关于
    if ([moduleInfo.page isEqualToString:@"/about"]) {
        [LLSpeedRoute pushToGameAboutWithCurrVC:self.currentVC];
        return;
    }
}

//开始
+ (void)pushToGameBeginWithCurrVC:(UIViewController *)currVC{
    LLSpeedGameViewController *vc = [[LLSpeedGameViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [currVC.navigationController pushViewController:vc animated:YES];
}

//菜单
+ (void)pushToGameMenuWithCurrVC:(UIViewController *)currVC{
    LLSpeedMenuViewController *vc = [[LLSpeedMenuViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [currVC.navigationController pushViewController:vc animated:YES];
}

//关于
+ (void)pushToGameAboutWithCurrVC:(UIViewController *)currVC{
    LLSpeedAboutViewController *vc = [[LLSpeedAboutViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [currVC.navigationController pushViewController:vc animated:YES];
}


@end
