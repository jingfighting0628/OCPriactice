//
//  iOSMultiThreadViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSMultiThreadViewController.h"
#import "Annimal.h"

typedef void (^block)();
@interface iOSMultiThreadViewController ()
@property (nonatomic, copy) block myBlock;
@property (nonatomic, copy) NSString *blockString;
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
-(void)NSURLConnection
{
    //NSURLConnection 使用步骤
    //1、创建NSURL对象，用于设置请求路径
    //2、创建一个NSURLRequest对象,并设置请求头、请求体
    //3、创建一个NSURLResponse对象用于接收响应数据,一般使用NSURLReponse的子类
    //NSHTTPURLResponse
    //4、使用NSURLConnection发送同步异步请求
    
    NSURL *url = [NSURL URLWithString:@"IMAGRURL"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse * response = nil;
    NSError *error = nil;
    //发送同步请求对阻塞当前线程
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //_image = [UIImage imageWithData:data];
     //异步的POST请求
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"IMGAGEURL"]];
    
    request1.HTTPMethod = @"POST";
    request1.HTTPBody = [@"username=520it&pwd=520type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //设置请求的超时时间
    request1.timeoutInterval = 15;
    //设置请求头
    [request1 setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"error:%@",error.userInfo);
        }else {
            //_image = [UIImage imageWithData:data];
            
            
        }
    }];
    //NSURLConnectionDelegata 的使用
    //可以使用NSURLConnectionDelegate监听网络请求的响应
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    
}

//当收到服务器响应的时候调用，第一个参数connection监听的是哪个NSURLConnection对象
//第二个参数response接收到的服务器返回的响应头信息







-(void)NSURLSession
{
    //NSURLSession 指的不仅是同名类NSURLSession，它还包括一系列相关联的类
    //NSURLSession包括了之前相同的组件：NSURLRequest 与 NSURLCache，但是
    //将NSURLConnection 替换成了 NSURLSession、NSURLSessionConfiguration及
    //NSURLSessionTask、NSURLSessionUploadTask、NSURLSessionDownloadTask
    
    //与NSURLConnection相比,NSURLSession最直接的改进就是可以配置每个session的
    //缓存、协议、cookie以及证书策略(Credential Policy)，甚至跨进程共享这些信息
    //这将允许程序和网络基础框架之间相互独立,不会发生干扰，每个URLSession对象都
    //由一个NSURLSessionConfiguration对象进行初始化，后者指定了刚才提到那些策略以及用来增强移动设备上性能的新选项
    
    //NSURLSessionTask 负责处理数据的加载以及文件的数据的客户端与服务器之间的上传和
    //和下载，它是一个抽象类，一般使用子类:NSURLSessionDataTask 、NSURLSessionUploadTask、NSURLSessionDownloadTask。这3个子类
    //封装了现代程序3个最基本的网络任务:获取数据(JSON或XML),上传文件、下载文件
    
    //1、创建NSURLSessionConfiguration对象对NSURLSession进行配置
    //2、创建NSURLSession对象
    //3、利用上一步创建好的NSURLSession对象创建NSURLSessionTask的子类对象
    //4、执行请求任务
    
    NSURL *url = [NSURL URLWithString:@"IMAGEURL"];
    //创建请求对象，默认GET请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //创建配置
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //创建NSURLSession对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    //创建任务
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            return;
        }
        //解析返回的数据
        
        //_image = [UIImage imageWithData:data];
        
        
        
    }];
    
    [task resume];
    
    
    
}
//NSURLConnection 与 NSURLSession 区别


//block与GCD

-(void)block
{
    //block有哪几种定义方式
    //在Objective-C，block定义包含了block类型的声明和实现
    //基本形式如下
    //返回值类型(^block名称)(参数类型) = ^(参数类型和参数名){}
    //其中返回值类型和参数可以是空,如果有参数,那么定义block的时候
    //必须要标明参数的类型和参数名，所以大致有3种戏份的定义方式
    
    //1、没有返回值。没有参数的定义方式
    void(^myBlock)(void) = ^{
        
        
    };
    //2、有返回值,有参数的定义方式
    
    int(^block)(int) = ^(int a){
        
       return a*3;
    };
    //3、有返回值,没有参数的定义方式
    
    int(^myBlock1)() = ^{
        
        return 100;
    };
    //当前，block也有自己属于自己的类型,就像在Objective-C中，字符串对象属于NSString类型一样，block类型的格式就是
    //返回值类型(^)(参数类型)
    
    //也就是说,上面第一种定义方式的block类型就是void(^)()，myblock不是变量名，而是
    //这种block类型的别名,在Objective-C中，可以使用typedef关键字定义block类型，也可以使用inline提示符自动生成block格式
    
    //typedef void (^myBlock123)(void);
    
    //使用inline提示符累自动生成block格式
    
   // <#returnType#>^<#blockName#>(<#parameterType#>) = ^(<#parameters#>){
        
        
    //};
    
    //在ARC环境下是否需要copy关键字来修饰block
    
    //先要明确的是,block其实包含两个组成部分,一部分是block所执行的代码,这一部分在
    //编译的时候已经确定,另一部分是block执行时所需要的外部变量值的数据结构，根据block
    //在内存中的位置，系统将block分为3类
    
    
    
}

-(void)test
{
    //1、NSGlobalBlock,该类型的block类似函数，内存地址位于内存全局区,只要block
    //没有作用域中局部变量进行引用，此block会被系统设置为该类型
    void(^gBlock)(int ,int) = ^(int a, int b){
        
        NSLog(@"a + b = %d",a + b);
        
    };
    NSLog(@"%@",gBlock);
    
    //事实上，对于NSGlobalBlock类型的block,无需做更多的处理,不需要使用retain 和 copy进行修饰，即使使用了copy。系统也不会改变block的内存地址，操作时无效的
    //2、NSStackBlock，该类型的block内存位于栈,其生命周期由函数决定,函数返回后将block无效
    //在MRC环境下，若block内部引用了局部变量，此block就会被系统设置为该类型，
    //对于NSStackBlock类的block,使用retain和release操作都是无效的，必须调用
    //Block_copy()方法,或者使用copy进行修饰,其作用就是将block的内存从栈移到堆中
    //此时block就会转变为NSMallocBlock类型,所以在ARC环境下，不需要手动使用copy关键字来修饰block
    //3、NSMallocBlock，当对NSStackBlock类型的block进行copy操作后，block就会
    //转为此类型，在MRC环境下，可以使用retain、release等方法手动管理此类型block的生命周期，在ARC环境下，系统会帮助管理此类型block的生命周期
    //在block内如何修改block外部变量
    
    //在block内修改block外部变量会造成编译错误,提示缺少__block修饰，不可赋值，要想在
    //在block内部修改block外部变量，则必须在外部定义变量时，前面加上__block修饰符
    
    //block外部变量
    __block int var1 = 0;
    int var2 = 0;
    void(^block)(void) = ^{
        
        var1 = 100;
        //编译错误,在block内部不可对var2赋值
        //var2 = 1;
    };
    block();
    NSLog(@"修改后的var1:%d",var1);//修改后var1为100
    //block内部为何不能直接修改外部变量呢？
    //因为当外部变量没有使用__block修饰符修饰时，block在截获外部自动变量时会在内部
    //新创建一个新的变量var来保存所截获的外部瞬时值，新变量val成为block的成员变量(Objective-C也是对象),之后在block代码中修改的值是成员变量val值,而不是
    //截获的外部变量值，所以外部变量的值不会受影响。此时，修改外部变量是先取值并赋值
    //给成员变量val,然后修改val值,可用下面的代码模拟其原理,假设block对外部变量var
    //进行了加1操作，block使用一个名为block的函数来表示
    /*
    int var = 1;
    void block(){
        int val = var;
        val += 1;
        
    }
   
    
    __block int var = 1;
    void block(){
        int *ptr = &var;
        *Ptr += 1;
        
    };
     */
    //因此，block内部不可以直接修改外部变量,如果要修改外部变量,那么该外部变量必须使用
    //__block修饰符进行修饰，否则编译器会直接进行报错提示
    //需要注意的是，此时讨论的是自动变量，而静态变量由于默认传给block就是地址值，
    //所以是可以直接修改的，另外，全局变量和静态全局变量由于作用域很广，也是可以在block中直接修改的，编译器也不会报错
    
}

-(void)testBlock
{
   
    
    
    self.myBlock = ^(){
        
      //其实注释的代码，同样会造成循环引用
        NSString *localString = self.blockString;
    };
    //在上面的例子中，myBlock和self相互引用了对方,此时self的销毁依赖于myBlock
    //的销毁，而myBlock销毁又依赖于self的销毁，这样就造成了循环引用，即使在外界已经没有任何指针能够访问到它们了，它们也无法释放
    //解决循环引用的关键是断开引用链，在实际开发中，主要使用弱引用(weak reference)
    //的方法来避免循环引用的产生，在ARC环境下，使用__weak修饰符定义一个__weak引用，并且在里面使用这个弱引用，使用这种方式对示例代码修改如下
    __weak typeof(self)weakSelf = self;
    self.myBlock = ^(){
        
      //其实注释的代码，同样会造成循环引用
        NSString *localString = weakSelf.blockString;
    };
    //当使用了__weak修饰弱类型self时,block便不会再self的引用了，也就
    //不会再产生循环引用了
    //下面是不会造成循环引用的几种情况
    //1、大部分GCD方法，示例代码如下
    //使用GCD异步主列队任务
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doSomething];
    });
    //在例子中，因为self并没有对GCD的block进行持有，只有block持有了self的引用
    //所以不会造成循环引用
    
    //2、block作为临时变量，在这种情况下，同样self并没有持有block，所以也不会
    //造成循环引用
    
    //3、block执行过程中self对象被释放，事实上，block的具体执行时间不确定，当block
    //被执行的时候block中被__weak修饰的self对象有可能已经被释放了(例如:控制器对象
    //已经被POP了)。当在并发执行了，涉及异步服务的时候，这种情况没有可能会出现
    //对于这种情况，应该在block中使用__strong修饰符修饰self对象，使得在block期间
    //对象持有，当block执行结束后，解除其持有，
    /*
    __weak typeof(self) weakSelf1 = self;
    
    self.myBlock() = ^(){
        __strong typeof(self) strongSelf = weakSelf1;
        NSString *localString = strongSelf.blockString;
    };
    */
    //GCD有哪几种队列
    
    //串行队列:串行队列的任务按先后顺序逐个执行。通常用于同步访问一个特定
    //的资源。使用dispatch_queue_creat，可以创建串行队列
    //2、并发队列。在GCD中也称为全局并发队列，可以并发地执行一个或者
    //多个任务，并发队列有高、中、低、后台4个优先级别，中级是默认级别
    
    
    //线程间如何实现线程同步
    
    //NSOperation可以通过使用addDependency函数直接设置操作之间的依赖关系
    //来调整操作之间的执行顺序从而实现线程同步，还可以使用setMaxConcurrentCount
    //函数来直接设置并发控制最大并发数量，那么在GCD中如何实现呢？
    //GCD 实现线程同步的方法有以下3种
    //1、组队列 dispatch_group
    //2、阻塞任务 dispatch_barrier_(a)sync
    //3、信号量机制 dispatch_semaphore
    //信号量机制主要是通过设置有限的资源数量来控制线程的最大并发数量及阻塞线程实现
    //线程同步等
    //GCD 中使用信号量需要用到3个函数
    //1、dispatch_semaphore_creat 用来创建一个semaphore信号量并设置初始信号量的值
    //2、dispatch_semaphore_signal 发送一个信号量增加1(对应PV操作的V操作)
    //3、dispatch_semaphore_wait 等待信号使信号量减1(对应PV操作的P操作)
    
    //那么如何通过信号量来实现同步呢？下面介绍GCD信号量来实现任务之间的依赖和
    //最大并发任务数量的控制
    //引申1、使用信号量实现任务2依赖任务1，即任务2要等任务结束才执行
    //方法很简单，创建信号量并初始化为0，让任务2执行前等待信号，实现对任务2的阻塞，
    //然后任务1完成后再发送信号，从而任务2获得信号开始执行，需要注意的是，这里的任务12
    //和任务2都是异步提交的，如果没有信号量的阻塞，那么任务2时不会等待任务1的，实际上
    //这里使用信号量实现了两个任务的同步
    
    //创建一个信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //任务1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [NSThread sleepForTimeInterval:3];
        NSLog(@"任务1结束");
        //任务1结束，发送信号告诉任务2可以开始了
        dispatch_semaphore_signal(semaphore);
    });
    //任务2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //等待任务1结束后获得信号量，无限等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //如果获得信号量，那么开始任务2
        NSLog(@"任务2开始");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"任务2结束");
    });
    [NSThread sleepForTimeInterval:10];
    //引申2:通过信号量控制最大并发量
    //通过信号量控制最大并发数量的方法为:创建信号并 初始化信号量为想要的控制的最大并发
    //数量，例如想要保证最大并发数5,则信号量初始化为5，然后每个新任务执行前进行P操作，
    //等待信号量减1，每个任务结束后进行V操作，发送信号使信号量加1，这样即可保证信号量
    //始终在5以内，当前最多也只有5个以内的任务在并发执行
    //创建一个信号量并初始化为5
    dispatch_semaphore_t semaphore1 = dispatch_semaphore_create(5);
    
    //模拟1000个等待执行的任务，通过信号量最大并发任务数量为5
    
    for (int i = 0; i < 1000; i++) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
            NSLog(@"任务%d开始",i);
            [NSThread sleepForTimeInterval:10];
            NSLog(@"任务%d结束",i);
            //任务i结束，发送信号释放一个资源
            dispatch_semaphore_signal(semaphore1);
        });
    }
    [NSThread sleepForTimeInterval:1000];
    //GCD 多线程编程中什么时候会创建新线程
    //对于是否会开启新线程的情景主要有如下几种情况:串行队列中提交异步任务、串行队列中
    //提交同步任务、并发队列中提交异步任务、并发队列中提交同步任务(其中主队列是典型的串行
    //队列，全局队列是典型的并发队列)
    //创建一个串行队列
    
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //1、串行队列中提交同步任务。不会开启新线程，直接在当前线程同步地串行这些任务
    
    //串行队列添加同步任务，没有开启新线程，全部在主线程串行执行
    dispatch_sync(serialQueue, ^{
        NSLog(@"SERIAL_SYN_A:%@",[NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"SERIAL_SYN_B:%@",[NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"SERIAL_SYN_C:%@",[NSThread currentThread]);
    });
    //2、串行队列中提交异步任务:会开启一个新线程，在新子线程中异步德串行执行这些任务
    //串行队列添加异步任务:开启一个新线程，在新子线程异步地串行执行这些任务
    
    dispatch_async(serialQueue, ^{
        
        NSLog(@"SERIAL_ASYN_A:%@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        
        NSLog(@"SERIAL_ASYN_B:%@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        
        NSLog(@"SERIAL_ASYN_C:%@",[NSThread currentThread]);
    });
    //3、并发队列中提交同步任务，不会开启新线程，效果和"串行队列中提交同步任务"一样
    //直接在当前线程同步地串行执行这些任务
    
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"CONCURRENT_SYN_A:%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"CONCURRENT_SYN_B:%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"CONCURRENT_SYN_C:%@",[NSThread currentThread]);
    });
    //4、并发队列中提交异步任务，会开启多个子线程，在子线程异步地并发执行
    //并发队列添加异步任务、开启多个子线程，并发执行多个任务
    dispatch_async(concurrentQueue, ^{
        NSLog(@"CONCURRENT_ASYN_A:%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"CONCURRENT_ASYN_B:%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"CONCURRENT_ASYN_C:%@",[NSThread currentThread]);
    });
}
-(void)doSomething
{
    
    
    //iOS中如何触发定时任务或延时任务
    //1、performSelector 实现延时任务
    //延时任务可以通过当前UIViewController的performSelector隐式
    //创建子线程实现，不会阻塞主线程
    [self performSelector:@selector(task) withObject:nil afterDelay:10];
    
    //2、利用sleep实现后面的任务的等待
    //慎用，会阻塞主线程
    //[NSThread sleepForTimeInterval:10];
    //3、GCD 实现延时任务或定时任务
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
    
    dispatch_after(delay, dispatch_get_main_queue(), ^{
       
        //delay task
    });
    //GCD 还可以用来实现定时器的功能,还能设置延时开启计时器，使用中注意一定
    //定义强引用指针来指向计时器对象才可以让计时器生效。
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //dispatch_source_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    //4、NSTimer实现定时任务
    //NSTimer 主要用于开启定时任务,但要正确使用才能保证它能够正常有效德运行
    //尤其要注意两点
    //1、确保NSTimer已经添加到当前RunLoop
    //2、确保当前RunLoop已经启动
    //创建NSTimer有两种方法
    
  NSTimer *mainThreadTimer =   [NSTimer timerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
    }];
    //这两个方法主要区别为:使用timerWithTimeInterval创建timer不会自动添加到档期啊RunLoop
    //需要手动添加并指定RunLoo的模式，
    [[NSRunLoop currentRunLoop] addTimer:mainThreadTimer forMode:NSDefaultRunLoopMode];
    //而使用scheduledTimerWithTimeInterval创建的RunLoop会默认添加到当前RunLoop中
    
    //5、CADisplaylink实现定时任务
    
    //CADisplaylink实现定时器与屏幕刷新频率绑定在一起,是一种帧率刷新，适用于界面不断重绘
    //(例如流畅动画和视频播放),CADisplaylink以特定模式注册到RunLoop后，每当屏幕显示
    //内容刷新结束后就会向CADisplaylink指定的target发送一次消息,实现target的每帧调用
    //根据需求也可以这只每几帧调用一次,默认每帧都调用。另外，通过CADisplaylink还可以获取
    //帧率和时间等信息
    
    //CADisplaylink实现的定时器精度非常高,但如果调用的方法十分耗时,超过一帧的时间间隔，
    //那么会导致跳帧，跳帧次数取决于CPU的忙碌程度
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display_SEL)];
    
    //添加到当前运行的RunLoop中启动
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    //暂停,继续对selector的调用
    [displaylink setPaused:YES];
    [displaylink setPaused:NO];
    //设置每几帧调用一次selector,默认为1
    [displaylink setPreferredFramesPerSecond:2];
    //移除,不再使用
    [displaylink invalidate];
    displaylink  = nil ;
    //如何解决网络请求的依赖关系
    //1、一种是通过线程管理来实现,即线程同步,让线程等待线程A,iOS中实现线程同步
    //的方法很多;可以设置NSOperation操作依赖实现，即让操作B依赖操作A，操作B会在
    //操作A结束后才会开始执行(B addDependency:A),也可以GCD来实现,包括组队列(dispatch_group)
    // 阻塞任务(dispatch_barrier_(a)sync)和信号量机制(dispatch_semaphore)
    //2、另外也可以直接通过逻辑衔接来实现，即在网络请求A的响应回调中编写网络请求B
    //的逻辑，缺点是耦合度上会高一些。
    
    
    
}



@end
