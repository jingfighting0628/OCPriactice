//
//  iOSMultiThreadViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSMultiThreadViewController.h"

@interface iOSMultiThreadViewController ()

@end

@implementation iOSMultiThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSThread 、GCD、NSOperation
    //NSThread 静态工具方法
    // 是否开启了多线程
    BOOL isMutiThreaded = [NSThread isMultiThreaded];
    //获取当前线程
    NSThread *currentThread = [NSThread currentThread];
    //睡眠当前线程
    // 线程睡眠5s
    [NSThread sleepForTimeInterval:5];
    //线程睡眠到指定时间,效果同上
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    
    //退出当前线程，注意不要在主线程上调用,防止主线程被kill到
    [NSThread exit];
    
    //NSThread线程对象的基本创建，target为入口方法所在的对象，seletor为线程入口方法
    //1、线程实例对象创建与设置
    NSThread *newThread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    //设置线程优先级threadPriority(0-1.0)该属性即将被抛弃，将使用qualityOfService代替
    //newThread.threadPriority = 1.0;
    newThread.qualityOfService = NSQualityOfServiceUserInteractive;
    [newThread start];
    //静态方法快速创建并开启新线程
    
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"block run");
    }];
    
    //NSObject基类隐式创建线程的一些静态工具方法
    //1、在当前线程上执行方法,延迟2s
    [self performSelector:@selector(run) withObject:nil afterDelay:2.0];
    //2、在指定线程上执行方法 ,不等待当前线程
    [self performSelector:@selector(run) onThread:newThread withObject:nil waitUntilDone:NO];
    //3、后台异步执行方法
    [self performSelectorInBackground:@selector(run) withObject:nil];
    //4、在主线程执行方法
    [self performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:NO];
}

-(void)run
{
    NSLog(@"run");
}

@end
