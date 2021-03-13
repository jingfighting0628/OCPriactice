//
//  iOSDevelopObjectCommunicationViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSDevelopObjectCommunicationViewController.h"
#import "Student.h"
#import "Person.h"
@interface iOSDevelopObjectCommunicationViewController ()
@property (nonatomic, strong) Student *student;
@end

@implementation iOSDevelopObjectCommunicationViewController
{
    Person *aperson;
}
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
    
    //什么是键值编码KVC？键路径是什么？什么是键值观察KVO？
    
    //键值编码(KVC)是一种在NSKeyValueCodeing非正式协议下使用的
    //字符串标志间接访问对象属性一种机制，也就是访问对象变量的一种特殊的捷径
    //如果一个对象符合键值编码的约定，那么它的属性就可以通过一个准确的、唯一de字符串
    //(键路径字符串)参数进行访问，类似于将所有对象看作Dictionary，键路径为key(keypath)
    //属性值为value,通过键路径访问属性值，键值编码的间接访问方式其实是传统实例变量的存取方法
    //访问的一种替代，也就是另外一种可以访问对象变量方法，其中注意键值编码可以暴力
    //访问对象的任何变量，无论是private私有类型的变量。
    
    //键值编码是Cocoa框架中很基础的一个概念，像KVO、Cocoa绑定、CoreData
    //都是基于KVC的
    
    //2、键路径
    //键路径就是键值编码中某个属性的key,一个由连续键名组成的字符串，键名即属性名
    //键名之间用点隔开，用于指定一个连接一起的对象性质序列，键路径使开发者可以独立于
    //模型实现方式指定相关对象的性质、通过键路径】可以指定对象图中的一个任意深度的路径
    //使其指向相关对象的某个特定的属性
    
    //3、KVO
    //键值观察，是基于键值编码实现的一种观察者机制，提供了观察某一个属性变化的监听方法
    //用开简化代码，优化逻辑和组织
    //这里提供一个最基本的KVO和KVC的使用示例，假设有一个专业类Major、Major有一个
    //专业名(majorName)私有属性，一个学生类Student,Student有一个姓名(name)私有属性
    //同时还有一个专业(Major)对象变量，这样就出现了简单的Major和Student的对象嵌套
    //Major和Student都继承自NSObject，都符合键值编码约定，可以定义一个变量对其进行键值编码
    //和键值观察
    
    
    _student = [[Student alloc] init];
    _student.major = [[Major alloc] init];
    //通过KVC设置Student对象的值(可以强行访问private变量)
    [_student setValue:@"Sam" forKey:@"name"];
    [_student setValue:@"Computer Science" forKeyPath:@"major.majorName"];
    //get:通过KVC读取Student对象的值(可以强行访问private变量)
    NSLog(@"%@",[_student valueForKey:@"name"]);
    NSLog(@"%@",[_student valueForKeyPath:@"major.majorName"]);
    //kvo添加当前控制器为键路径为major.majorName的一个观察者
    //如果major.majorName的值改变，那么会通知当前控制器从而自动调用
    //下面的observeValueForPath方法，这里传递旧值和新值
    
    [_student addObserver:self forKeyPath:@"major.majorName" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //KVC在iOS中至关重要这种基于运行时的编程方式极大地提高了代码的灵活性，简化了代码逻辑
    //甚至实现了很多难以想象的功能，
    //1、动态地取值和设值
    //2、利用KVC来访问、修改对象和私有变量和属性
    //3、利用KVC进行Model和字典之间转换
    //4、利用KVC实现高阶消息传递
    
    //如何运用KVO进行键值观察
    //键值观察模式是观察者模式在Objective-C中的一种运用方式，其基本思想是
    //一个被观察目标管理所有依赖于它的观察者对象，并在它自身的属性发生改变时主动
    //通知所有观察者对象，观察者对象可以对改变做出相应的处理,通过这种机制
    //KVO能够较完美地将目标对象与观察者对象解耦
    
    aperson = [[Person alloc] init];
    [aperson addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew    context:nil];
    [aperson addObserver:self forKeyPath:@"infomation" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    //如何使用KVO设置键值观察依赖键
    //很多情况下对象的属性之间是相互关联的，对象的一个属性值依赖于另一个对象的一个属性或者
    //多个属性，如果这些属性的任意一个值发生改变，那么依赖属性的值也会相应的发生变改变，如果要观察被
    //依赖属性的变更，那么就需要使用KVO中的依赖键，实现KVO的依赖键最重要的部分是设置依赖关系
    //开发者要手动实现infomation的setter和getter方法，还要实现keyPathsForValuesAffectingInfomation 或者 keyPathsForValuesAffectingValueForKey方法，这两个方法的作用都是告诉系统
    //infomation属性依赖于其他哪些属性，而且这两个方法都返回包含着依赖key-path
    //在例子中,infomation属性依赖于person中的age和name属性,当person中的age或name属性发生改变时,
    //infomation的观察者都会得到通知,
    
    //setValue:forKey 方法的底层实现是什么、
    //当一个对象发送setValue:forKey消息时，方法内部会做以下操作:
    //1、查对象的类中是否存在与key相对应的访问器方法(即-set<key>)，如果存在
    //那么就会直接调用访问器方法
    //2、如果访问器方法不存在，那么就会继续查找与key的名称相同并且带"_"前缀成员
    //变量(即_key)，如果存在这样的成员变量并且类型是一个对象指针类型，那么就会先
    //released成员变量的旧值,然后直接为对象的这个成员变量赋新值
    //3、如果_key不存在，那么就会继续查找与key名称相同的属性,如果有这样的属性
    //那么就会直接为这个对象的这个属性赋值
    //4、如果访问器方法、成员变量和属性都没有找到，那么就会调用setValue：forUndefinedKey:
    //方法，该方法的默认实现抛出一个NSUndefinedKeyException 类型的异常,但是可以根据重写
    //setValue:forUndefinedKey：方法
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqual:@"major.majorName"]) {
        NSString *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"major.majorName value changed oldValue:%@ newValue :%@",oldValue    ,newValue);
    }
  
    if ([keyPath isEqualToString:@"age"]) {
        NSLog(@"oldAge = %@ newAge = %@",change[NSKeyValueChangeOldKey],change[NSKeyValueChangeNewKey]);
    }
    if ([keyPath isEqualToString:@"name"]){
        NSLog(@"oldName :%@ newName :%@",change[NSKeyValueChangeOldKey],change[NSKeyValueChangeNewKey]);
    }
    if ([keyPath isEqualToString:@"infomation"]) {
        NSLog(@"old_infomation:%@ new_infomation:%@",change[NSKeyValueChangeNewKey],change[NSKeyValueChangeNewKey]);
    }
}
-(void)dealloc
{
    [_student removeObserver:self forKeyPath:@"major.majorName"];
    [aperson removeObserver:self forKeyPath:@"age"];
    [aperson removeObserver:self forKeyPath:@"name"];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    aperson.age = 20;
    [aperson setValue:@"Sam" forKey:@"name"];
}
@end
