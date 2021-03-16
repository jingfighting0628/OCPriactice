//
//  iOSMultiThreadViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSMultiThreadViewController.h"
#import "Annimal.h"
@interface iOSMultiThreadViewController ()

@end

@implementation iOSMultiThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //NSThread 、GCD、NSOperation
    //[self NSThread];
    
    [self GCD];
    
    [self operation];
}
-(void)NSThread
{
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
-(void)GCD
{
    //GCD(Grand Centrs Dispathc)，又叫大中央调度,它对线程操作进行了很多新的特性
    //内部进行了效率优化，提供了简洁的C语言接口,使用更加简单高效，也是苹果公司推荐的方式
    
    //这里对GCD进行简单的提炼,整理出如下必会内容
    //1、同步dis_sync和异步dispath_async任务派发
    //2、串行队列和并发队列 dispatch_queue_t
    //3、dispatch_once_t 只执行一次
    //4、dispatch_after 延后执行
    //5、dispatch_group_t 组调度
    
    //1、串行和并发(Serial 和 Concurrent)
    //这个概念在创建操作队列的时候有宏定义参数,用来指定创建的是串行队列还是并行队列
    //串行队列内任务一个接一个执行，任务之间要依次等待不可重合，且添加的任务按照先进先出(FIFO)的顺序执行
    //但并不是指这就是单线程，只是同一个串行队列内的任务需要依次等待排队执行避免出现竞态条件
    //仍然可以创建单个串行队列并行执行任务，也就是说，串行队列内串行的，串行队列之间仍然可以是并行的
    //同一个串行队列内的任务的执行顺序是确定的(FIFO),且可以创建任意多个串行队列
    
    
    //并行同一个队列先后添加的多个任务可以同时并发操作,任务之间不会等待,且这些任务的执行顺序
    //和执行过程不可预测
    
    //2、同步和异步任务派发
    //GCD多线程编程时经常使用dispatch_async 和 dispatch_sync函数向指定队列中添加任务块
    //区别就是同步和异步
    //同步指阻塞当前线程，即要等添加的耗时代码块block完成后，函数才能返回，后面的代码才可以
    //执行，如果在主线程上，那么会发生阻塞，用户会感觉到应用不响应，这是要避免的
    //有时需要使用同步任务的原因是想保证先后添加的任务按照编写的逻辑顺序依次执行
    //异步指将任务添加到队列后函数立刻返回，后面的代码不用等待添加的任务完成返回即可继续执行
    //异步提交无法确认任务的执行顺序
    
    //通过下面的代码可以比较异步和同步的任务的区别
    
    NSLog(@"开始提交异步任务");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时任务
        [NSThread sleepForTimeInterval:10];
    });
    
    NSLog(@"异步任务提交成功");
    
    //提交同步任务
    NSLog(@"开始提交同步任务");
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时任务
        [NSThread sleepForTimeInterval:10];
    });
    
    NSLog(@"同步任务提交成功");
    //通过打印结果时间可以看出，异步任务提交后立即就执行下一步打印提交成功了
    //不会阻塞当前线程，提交的任务会后台去执行，而提交的同步任务要等待体检的后台的任务结束后才可以继续执行当前线程的下一步,此处在主线程上添加的同步任务就会阻塞主线程,导致后面界面的显示要延迟，影响用户体验
    //3、dispatch_queue_t
    //GCD队列有两种类型,并发队列和串行队列，它们的区别上面已经提到，具体创建的方法很简单
    //要提供两个参数，一个是标记该自定义队列的唯一字符串，另一个是指定串行队列还是并发队列的参数
    
    //创建一个并发队列
    dispatch_queue_t concurrent_queue = dispatch_queue_create("demo.gcd.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    //创建一个串行队列
    
    dispatch_queue_t serial_queue = dispatch_queue_create("demo.gcd.serial_queue", DISPATCH_QUEUE_SERIAL);
    //另外GCD还提供了几个常用的全局队列以及主队列，其中全局队列本质是并发队列
    //主队列本质是串行队列
    
    //获取主队列(在主线程上执行)
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    //获取不同优先级的全局队列(优先级从高到低)
    dispatch_queue_t queue_high = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_queue_t queue_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue_low = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t queue_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    //4、dispatch_once_t
    //这个函数控制指定代码只会被执行一次,常用来实现单例模式
    //这里以单例模式实现的模版代码为例展示dispatch_once_t用法 其中
    //实例化语句只会被执行一次
    /*
     +(instancetype)sharedInstance
     {
         static dispatch_queue_t once = 0;
         static id sharedInstance = nil;
         
         dispatch_once(&once, ^{
            
             sharedInstance = [[self alloc]init];
         });
         return  sharedInstance;
     }
     
     */
    
    //5、dispatch_after
    //通过该函数可以让要提交的任务从提交开始后的指定时间执行,也就是定时延迟执行提交的任务
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(3.0 * NSEC_PER_SEC));
    
    dispatch_after(delay, dispatch_get_main_queue(), ^{
       //要执行的任务
    });
    
    // dispathc_group_t
    
    //组调度可以实现等待一组操作都完成后执行后续操作,典型的例子是大图下载,例如可以将大图分成几块同时下载,等各部分都下载完后再后续将图片拼接起来
    //提高下载的效率
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        
     //加载图片操作1
    });
    dispatch_group_async(group, queue, ^{
       //加载图片操作2
    });
    dispatch_group_async(group, queue, ^{
       //加载图片操作3
    });
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
       //后续操作
    });
    //7、同步代码到主线程
    //对于UI的更新代码，必须要在主线程上执行才会及时有效，当前代码不在主线程时，
    //需要将UI更新的部分代码单独同步到主线程，同步的方法有3种，可以使用NSThread类的
    //performSelectorOnMainThread或者NSOperationQueue类的mainQueue主队列进行同步，但推荐直接使用GCD方法
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //UI更新代码...
    });
    
    
    
}

-(void)operation
{
    //NSOperation是基于GCD的一个抽象基类，将线程封装成要执行的操作，不需要管理线程的生命周期和同步，但比GCD可控性更强，例如可以加入操作依赖控制操作执行顺序
    //设置操作队列最大可并发的操作个数(setMaxConcurrentOperationCount)，取消
    //操作(cancel)等
    
    //NSOperation作为抽象类不具备封装开发者的操作的功能，需要使用两个它的实体子类
    //NSBlockOperation和NSInvocationOperation，或者继承NSOperation自定义子类
    //NSInvocationOperation和NSBlockOperation 用法区别是:前者执行指定方法
    //后者执行代码块，相对来说后者更加灵活易用.NSOperation操作配置完成后便可调用
    //start函数在当前线程执行，如果要异步执行避免阻塞当前线程，那么可以加入NSOperationQueue中异步执行
   
    
    //NSInvocationOperation初始化
    
    NSInvocationOperation *invoOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    [invoOperation start];
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation");
    }];
    
    //另外，NSBlockOperatipn可以后续继续添加block代码块，操作启动后会在
    //不同线程并发这些代码块，
    //
    
    NSBlockOperation *blkOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperationA：%@",[NSThread currentThread]);
    }];
    
    [blkOperation addExecutionBlock:^{
        NSLog(@"NSBlockOperationB:%@",[NSThread currentThread]);
    }];
    
    [blkOperation addExecutionBlock:^{
        NSLog(@"NSBlockOperationC：%@",[NSThread currentThread]);
    }];
    //另外NSOperation的可控性比GCD要强,其中一个非常重要特性是可以设置各个操作
    //之间的依赖实现线程同步，例如，规定操作A要在操作B完成之后才能开始执行，称为
    //A依赖于操作B，而GCD中任务默认是先进先出的，要实现线程同步需要通过组队列或信号量等方式实现。
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    //创建 a、b、c操作
    
    NSOperation *c = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"OperationC");
    }];
    
    NSOperation *a = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"OperationA");
    }];
    
    NSOperation *b = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"OperationB");
    }];
    //添加操作依赖，c依赖a和b，这样c一定会在a和b完成后才执行，即A、B、C
    [c addDependency:a];
    [c addDependency:b];
    //添加操作a、b、c到操作队列queue 特意将c在a和b之前添加
    [queue addOperation:c];
    [queue addOperation:a];
    [queue addOperation:b];
    
    //NSBlockOperation和NSInvocationOperation可以满足多数情况下的编程需求
    //如果需求特殊，那么需要继承NSOperation类自定义子类来更加灵活的实现
    
    //GCD和NSOperation的区别
   //1、GCD是基于C语言的API NSOperation是对线程高度抽象提供OC接口
    //2、NSOperation可以添加各个操作之间的依赖关系，GCD实现起来较复杂用(队列组、信号量)实现
    //3、Objectice语言API面向对象(可封装、复用)控制精细灵活，用于复杂项目
    //C语言API简单易读、代码精简控制较简单粗略用于简单项目
    //4、NSOperation可以设置最大并发数，GCD不能
    
    
    //什么是线程死锁
    /*
    int main (int argc ,const char *argv[]){
        
        NSLog(@"1");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2");
        });
        NSLog(@"3");
        return 0;
    }
     */
    
    //在上述代码中国呢,main函数第二句代码在主线程上使用了dispatch_sync同步向主线程派发任务，
    //而同步派发要等到任务完成后才能返回，阻塞当前线程，也就睡说，执行到此，
    //主线程被阻塞，同时又要等主线程执行完成该任务，造成主线程自身的等待循环
    //也就是死锁，程序运行到此会崩溃，将dispatch_sync改为dispatch_async异步
    //派发任务即可避免死锁或者将任务派发到其他队列上而不是主队列
    
    //dispatch_barrier_(a)sync的作用是什么
    
    //通过dispatch_barrier_async 添加的操作会赞数阻塞当前队列，即等待前面的并发操作
    //都完成后执行该阻塞操作，待其完成后后面并发操作才可继续，可以将其比喻为
    //一根霸道的独木桥、是并发队列中的一个并发障碍点，或者说是中间瓶颈，临时阻塞并独占，
    //注意:dispatch_barrier_async 只有在并发队列中才能起作用，在串行队列中队列
    //本身就是独木桥，将失去意义
    
    //创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 添加两个并发操作A和B，即A和B会并发执行
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"OperationA");
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"OperationB");
    });
    
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"OperationBarrier");
    });
    //继续添加并发操作C和D，要等待barrier障碍操作结束后才能开始
    dispatch_async(concurrentQueue, ^{
       
        NSLog(@"OperationC");
    });
    dispatch_async(concurrentQueue, ^{
       
        NSLog(@"OperationD");
    });
    
    //如何理解线程安全
    //在实际开发中，如果程序中使用了多线程技术，那么有可能会遇到同一块资源被多个线程
    //共享情况，也就是多个线程可能会访问同一块资源，如多个线程同一块资源时，很容易
    //会发生数据错误及数据不安全等问题
    //要避免这种因争夺资源而导致的数据安全问题、需要使用“线程锁”来解决，即在同一时间段内，只允许一个线程来使用资源，在iOS开发中主要使用几种线程锁技术
    
    //1、使用@synchironized关键字
    //使用@synchironized能够很方便的隐式创建锁对象
    [self testSynchronized];
    //2、NSLock
    
    
}
-(void)testSynchronized {
    
    Annimal *someone = [Annimal new];
    
    //线程A
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        @synchronized (someone) {
            NSLog(@"线程A = %@",[NSThread currentThread]);
            someone.name = @"口";
            [NSThread sleepForTimeInterval:5];
        }
    });
    
    //线程B
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        @synchronized (someone) {
            NSLog(@"线程B = %@" , [NSThread currentThread]);
            someone.name = @"";
        }
    });
    
    
    //可以发现发现B访问资源的时间比线程A要晚5s 关键字synchronized将实例
    //对象someone设定为锁的唯一标识,只有标识相同时，才满足互斥，如果线程B
    //中的锁标识改为其他对象，那么线程B将不会被阻塞
    
    
}
@end
