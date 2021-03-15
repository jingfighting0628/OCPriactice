//
//  iOSMemoryManagementViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSMemoryManagementViewController.h"

@interface iOSMemoryManagementViewController ()

@end

@implementation iOSMemoryManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //什么是内存泄漏？是什么是安全释放
    //内存泄漏时动态分配内存对象在使用完后没有被系统回收内存,导致该对象始终占用
    //内存，又无法通过代码访问，数据内存管理出错,如果出现大量内存泄漏,那么会导致
    //内存不足的问题，由于内存泄漏的检测是程序开发中不可避免的问题,所以对程序员而言
    //一方面要深入理解内存管理原则,养成良好编程习惯以减少内存泄漏情况的发生；另一方面
    //可以通过各种方法，例如使用Xcode提供检测调试工具Instruments，检测可能导致内存
    //泄漏的代码，并及时进行优化
    //安全释放指释放掉不再适用的对象同时不会造成内存泄漏或者指针悬挂的操作，为了
    //保证安全释放，在对象dealloc后要将其指针置为nil，另外，要严格遵守内存管理的yuanze
    //保证对象的引用计数正确，同时要避免引用循环的问题
    
    //僵尸对象：一个引用计数器为0的Objective-C对象被释放后就变成僵尸对象，僵尸对象
    //的内存已经被系统回收，虽然该对象可能还存在，数据依然在内存中，但僵尸对象已经是
    //不稳定对象了，不可以再访问或者使用，它的内存是随时可能被别的对象申请而占用的 ，
    //需要注意的是，僵尸对象所占的是正常的，不会造成内存泄漏
    
    
    //野指针：又叫悬挂指针，野指针出现的原因是指针没有赋值，或者指针指向的对象已经释放掉了
    //野指针指向一块随机的垃圾内存,向它们发送EXC_BAD_ACCESS错误导致程序崩溃
    
    //空指针不同于野指针，它是一个没有任何内存的指针，空指针是有效指针，值为nil、NULL、Nil或0
    //给空还真发送消息不会报错，只是不响应消息而已，应该给野指针赋予零值使其变成有效的空指针，避免
    //内存报错
    
    
    //Objective-C 是如何实现内存管理的？
    //Objective-C内存管理本质上通过引用计数实现的，每次Runloop都会检查对象的
    //引用计数，如果引用计数为0,那么说明该对象已经没有再被使用了，此时可以对其进行
    //释放了，引用计数可以大体分为MRC、ARC和内存池
    //那么引用计数是如何操作的？其实不论哪种引用计数方式，它们本质上都是在适合的 时机
    //将对象的引用计数加1或减1
    //所以对于引用计数可以总结如下
    //1、使用引用计数加1的常见操作alloc、copy、retain
    //2、事对象引用计数减1的常见操作release、autorealease
    //自动释放池是一个统一来释放一组对象的容器、在向对象发送autorealease消息时
    //对象并没有立即释放，而是将对象加入到最新的自动释放池(即将该对象的引用交给自动释放池，之后统一调用release，自动释放池会在程序执行到作用域结束的位置时进行drain释放操作)，这个时候会对池中每一个对象发送realease消息来释放所有对象，这样其实
    //实现了对象的延迟释放
    //自动释放池释放的时机指自动释放池内的所有的对象是在什么释放的,这里要提到程序
    //运行周期RunLoop,对于每个新的RunLoop，系统都会隐式地创建一个autoreleasepool
    //Runloop结束时自动释放池便会进行对象的释放操作，autorelease和release的区别主要是
    //引用计数减1的时机不同，autorelease是在对象的使用真正结束时时候才做引用计数减1
    //而不是收到消息立马释放
    
    //如何实现autorealeasepool
    //autorealeasepool(自动释放池)其实并没有自身的结构,它是基于多个AutoreleasePooolPage(一个C++类)以双向链表组合起来的结构，其基本操作都是简单封装了AutoreleasePoolPage的
    //操作方法,例如:可以通过push操作添加对象或者通过pop操作弹出对象，以及通过release操作释放对象
    //对应的3个封装的操作函数为:objc_autoreleasepoolPush、objcautoleasepoolPop和objc_release
    //自动释放池将用完的对象集中起来，统一释放，起到延迟释放对象的作用
    
    //自动释放池存储于内存的栈上，释放池之间遵循“先进后出”原则，例如下面的代码所示的释放池的嵌套
    
    //NSArray 和 NSMutableArray 在 copy 和 MutableCopy 下的内存情况是怎样的
    //有两种情况:浅拷贝和深拷贝，浅拷贝只是复制了内存地址，也就是对内存空间的引用
    //深拷贝则是开辟新的空间并复制原空间相同的内容，新指针指向新空间内容
    //除了NSArray在Copy下是浅复制，其他都是深复制
    
    
    
    
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
