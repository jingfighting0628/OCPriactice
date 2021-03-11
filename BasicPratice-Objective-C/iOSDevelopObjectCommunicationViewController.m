//
//  iOSDevelopObjectCommunicationViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSDevelopObjectCommunicationViewController.h"

@interface iOSDevelopObjectCommunicationViewController ()

@end

@implementation iOSDevelopObjectCommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //iOS中Protocol和Delegate
    //Protocol类似Java语言中的接口，它是一个自定义方法的集合，让遵守这个协议
    //的类去实现为了达到某种功能这些方法，与Java语言中的接口不同的是协议中可以
    //@optional来选择性实现这个方法
    //Delegate代理是一种设计模式，是一个概念，只不过在Objective-C通过protocol
    //来进行实现，指的是一个对象在某些特定时刻通知其他类的对象去做一些任务，但不需要
    //获取到那些对象的指针，两者共同完成一件事，实现不同对象之间通信，代理模式大大减小了
    //对象之间耦合度，它使得代码逻辑更加清晰有序，而且，由于降低了框架复杂度，所以
    //便于代码的维护扩展，另外，消息的传递过程可以有参数回调，它类似于Java语言的回调监听机制
    //从而大大提高了编程的灵活性
    
    //消息推送是什么？和Notification有什么区别
    //消息推送指在App关闭时 (不在前台运行时),仍然向用户发送内部消息，消息推送通知
    //和Objective-C中的Notification通知机制不同，推送的消息是给用户看的，也就是可见的
    //而通知机制是Objective-C语言中对象间通信的一种机制，基于观察者模式，目的是触发内部事件，
    //减小类之间的耦合度，对用户是不可见的
    
    //在iOS开发中有两种类型的消息推送:本地消息推送和远程消息推送
    //1、本地消息推送：本地消息推送很简单，不需要联网，不需要服务器，由客户端应用直接发出推送消息
    //一般通过定时器在指定时间进行消息推送
    //2、远程消息推送:远程消息推送过程略微复杂，需要客户端从苹果的APNs服务器注册获得当前用户设备
    //令牌并发送给应用的服务器，然后应用的服务器才可以通过APNs服务器间接的向客户端发送推送消息
    //期间难免会有延迟
    //1、App客户端向APNs服务器发送设备UUID和Bundle Identifier
    //2、APNs服务器对传过来的信息加密生成一个deviceToken，并返回给客户端
    //3、客户端将当前用户的deviceToken发送给自己应用放入服务端
    //4、自己应用的服务器将得到的deviceToken保存，需要的时候利用deviceToken向APNs服务器
    //服务器发送推送消息
    //5、APNs服务器接收自己的应用的服务器的推送消息时，验证传过来的deviceToken，如果结果一致，
    //那么将消息推送给客户端
    
    
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
