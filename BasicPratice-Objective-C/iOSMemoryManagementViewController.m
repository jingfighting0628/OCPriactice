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
