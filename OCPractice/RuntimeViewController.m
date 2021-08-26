//
//  RuntimeViewController.m
//  OCPractice
//
//  Created by liuningbo on 2021/8/26.
//

#import "RuntimeViewController.h"
#import <Objc/runtime.h>
@interface RuntimeViewController ()
@property (nonatomic, strong) UIScrollView *myScrollView;
@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Runtime";
    self.view.backgroundColor = [UIColor whiteColor];
    [self test];
    [self testSEL];
    [self forwardMessage1];
    
}
//1、什么是Runtime？
//我们都知道，将源代码转换为可执行程序，主要经过三个步骤：编译、链接、运行。不同的编译语言，在这三个步骤中所进行的操作又有一些不同。

//C语言 作为一门静态语言，在编译阶段就已经确定了所有变量的数据类型，同时也确定好了调用的函数，以及函数的实现。

//而Objective—C 是一门动态语言。在编译阶段并不知道变量的具体数据类型，也不知道真正调用的是哪个函数。只有在运行时间才能检查变量的数据类型，同时在运行时才会根据函数名查找要调用的具体函数。这样在程序没运行的时候，我们并不知道调用一个方法具体会发生什么。

//Objective-C 把一些决定性的工作从编译阶段、链接阶段推迟到运行时阶段的机制，使得Objective-C变得更加灵活。我们甚至可以在程序运行的时候，动态去修改一个方法的实现，这也为「热更新」提供了可能性。

//而实现Objective-C运行时机制的一切基础就是Runtime。

//Runtime实际上是一个库，这个库使我们可以在程序运行的时候，动态的创建对象、检查对象，修改类和对象的方法。


//2、Objective-C中，对象方法的调用都是类似[receicer selector];的形式，其本质就是让对象在运行的时候发送消息的过程。

//我们来看看方法调用[receiver selector];在「编译阶段」和「运行阶段」分别做了什么？

//编译阶段：[receiver selector];方法被编译器转换为：

//objc_msgSend(receiver, selector) --- (不带参数)
//objc_msgSend(receiver, selector, org1, org2, ...) --- (带参数)
//运行时阶段：消息接受者receiver寻找对应的selector.

//通过receiver的isa 指针找到receiver的Class (类)；
//在Class (类)的cache (方法缓存)的散列表中寻找对应的IMP (方法实现)；
//如果在cache (方法缓存)中没有找到对应的IMP (方法实现)的话，就继续在Class (类)的method list (方法列表)中找对应的selector，如果找到，填充到cache (方法缓存)中，并返回selector；
//如果在Class (类)中没有找到这个selector，就继续在它的superClass (父类)中寻找；
//一旦找到对应的selector，直接执行receiver对应的selecotr方法实现的IMP (方法实现)。
//若找不到对应的selector，消息被转发 或者 临时向receiver添加这个selector对应的实现方法，否则就会发生崩溃。
//在上述过程中，涉及了好几个概念：objc_msgSend、isa 指针、Class (类)、IMP (方法实现)等，下面我们来具体探讨一下这些概念。
//3、Runtime中的概念解析
//3.1、objc_msgSend

//所有的Objective-C方法调用，在编译的时候会转化为C函数objc_msgSend的调用。
//objc_msgSend(receiver, selector);是[receiver selector];对应的 C函数。

//3.2、Class（类）

//在objc/runtime.h中，Class (类)被定义为指向Objc_class 结构体的指针，Objc_class 结构体的数据结构如下：

/*
 
 struct objc_class {
     Class _Nonnull isa  OBJC_ISA_AVAILABILITY;               // objc_class 结构体的实例指针

 #if !__OBJC2__
     Class _Nullable super_class                              OBJC2_UNAVAILABLE;    // 指向父类的指针
     const char * _Nonnull name                               OBJC2_UNAVAILABLE;    // 类的名称
     long version                                             OBJC2_UNAVAILABLE;    // 类的版本信息，默认为 ·0·
     long info                                                OBJC2_UNAVAILABLE;    // 类的信息，共运行时使用的一些位标识
     long instance_size                                       OBJC2_UNAVAILABLE;    // 该类的实例变量大小
     struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;    // 该类的实例变量列表
     struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;  // 方法定义的列表
     struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;    // 方法缓存
     struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;    // 遵守的协议列表
 #endif

 } OBJC2_UNAVAILABLE;
  Use `Class` instead of `struct objc_class *`
 */
//从源码中我们可以看出，objc_class 结构体定义了很多变量：自身的所有实例变量（ivars）、所有方法的定义（methodLists）、遵守的协议列表（protocols）等。
//objc_class 结构体存放的数据称为：元数据（metadata）。

//objc_class 结构体的第一个成员变量是isa 指针；isa 指针保存的是所属类的结构体的实例指针，这里保存的就是objc_class 结构体的实例指针，而实例换个名字就是对象。换句话说，Class (类)的本质就是一个对象，我们称之为：类对象。

//3.3 Object（对象）
//接下来，我们再来看看objc/objc.h中关于Object (对象)的定义。
//Object (对象)被定义为objc_object 结构体，其数据结构如下：
/*
 /// An opaque type that represents an Objective-C class.
 typedef struct objc_class *Class;

 /// Represents an instance of a class.
 struct objc_object {
     Class _Nonnull isa  OBJC_ISA_AVAILABILITY; // objc_object 结构体的实例指针
 };

 /// A pointer to an instance of a class.
 typedef struct objc_object *id;
 */
//这里的id被定义为一个指向objc_object 结构体的指针。从中可以看出objc_object 结构体只包含一个Class类型的isa 指针。

//也就是说，一个Object (对象)唯一保存的就是它所属Class (类)的地址。当我们对一个对象进行方法调用的时候，比如[receiver selector];，它会通过objc_object 结构体的isa 指针去找到对应的object_class 结构体，然后在object_class 结构体的methodLists (方法列表)中找到我们调用的方法，然后执行
//3.4、Meta Class（元类）
//从上面的内容我们看出，对象 (objc_object 结构体)的isa 指针指向的是对应的类对象 (object_class 结构体)。那么类对象 (object_class 结构体)的isa 指针又指向哪里呢？

//object_class 结构体的isa 指针实际上指向的是类对象自身的Meta Class (元类)。

//Meta Class (元类)就是一个类对象所属的类。一个对象所属的类叫做类对象，而一个类对象所属的类就叫做元类

//Runtime中，把类对象的所属类型叫做Meta Class (元类)，用于描述类对象本身所具有的特征，而在元类的methodLists中，保存了类的方法链表，即所谓的「类方法」。并且类对象中的isa 指针指向的就是元类。每个类对象有且仅有一个与之相关的元类。
//在上面2、消息机制的基本原理中，我们探讨了对象方法的调用流程，我们通过对象的isa 指针找到对应的Class (类)；然后在Class (类)的methodLists (方法列表)中找到对应的selector

//而类方法的调用流程和对象方法的调用流程是差不多的，流程如下：

//通过类对象isa 指针找到所属的Meta Class (元类)；
//在Meta Class (元类)的methodLists (方法列表)中找到对应的selector；
//执行对应的selector
//下面看一个示例：
-(void)test
{
    NSString *str = [NSString stringWithFormat: @"%d",1];
    //示例中，stringWithFormat:被发送给了NSString 类，NSString 类通过isa 指针找到NSString 元类，
    //然后在该元类的方法列表中找到对应的stringWithFormat:方法，然后执行该方法。
    
}
//3.5、示例对象、类、元类之间的关系

//上面，我们讲解了实例对象 (Object)、类 (Class)、Meta Class (元类)的基本概念，以及简单的指向关系。下面我们通过一张图来捋一下它们之间的关系。

//父类   ------>isa指针
//根类 Object实例对象--->object类对象--->NSObject元类
//父类 Person实例对象--->Person类对象--->Person元类
//子类 Man实例对象  ---->Man类对象---->Man元类
//我们先来看isa 指针：
//水平方向上，每一级中的实例对象的isa 指针指向了对应的类对象，而类对象的isa 指针指向了对应的元类。而所有元类的isa 指针最终指向了NSObject 元类，因此NSObject 元类也被称为根元类。
//垂直方向上，元类的isa 指针和父类元类的isa 指针都指向了根元类。而根元类的isa 指针又指向了自己。
//我们再来看父类指针：

//类对象的父类指针指向了父类的类对象；父类的类对象又指向了根类的类对象，跟类的类对象最终指向了nil。
//元类的父类指针指向了父类对象的元类；父类对象的元类的父类指针指向了根类对象的元类，也就是根元类；而根元类的父类指针指向了根类对象，最终指向了nil。
//3.6、Method（方法）
//object_class 结构体的methodLists (方法列表)中存放的元素是Method (方法)。

//我们来看一下objc/runtime.h中，表示Method (方法)的objc_method 结构体的数据结构：

/*
 /// An opaque type that represents a method in a class definition.
 /// 代表类定义中一个方法的不透明类型
 typedef struct objc_method *Method;

 struct objc_method {
     SEL _Nonnull method_name        OBJC2_UNAVAILABLE; // 方法名
     char * _Nullable method_types   OBJC2_UNAVAILABLE; // 方法类型
     IMP _Nonnull method_imp         OBJC2_UNAVAILABLE; // 方法实现
 }
 */
//可以看到，objc_method 结构体中包含了method_name (方法名)、method_types (方法类型)和method_imp (方法实现)。
//下面我们来详细探索一下这三个变量。
//SEL method_name; --- 方法名
///// An opaque type that represents a method selector.
//typedef struct objc_selector *SEL;
//SEL是一个指向objc_selector 结构体的指针，但是Runtime相关头文件中并没有找到明确的定义。
//不过，通过测试我们可以得出：SEL只是一个保存方法名的字符串。
-(void)testSEL
{
    SEL sel = @selector(viewDidLoad);
    NSLog(@"%s",sel);//打印viewDidLoad
    SEL sel1 = @selector(test);
    NSLog(@"%s",sel1);//打印test
    
}
//IMP method_imp; --- 方法实现
//#if !OBJC_OLD_DISPATCH_PROTOTYPES
//typedef void (*IMP)(void /* id, SEL, ... */ );
//#else
//typedef id _Nullable (*IMP)(id _Nonnull, SEL _Nonnull, ...);
//#endif
//IMP的实质是一个函数指针，所指向的就是方法的实现。IMP用来找到函数地址，然后执行函数。
//char * method_types; --- 方法类型
//方法类型method_types是个字符串，用来存储方法的参数类型和返回值类型
//探索到这里，Method的结构已经很明朗了。
//Method将SEL (方法名)和IMP (函数指针)关联起来；当对一个对象发送消息时，
//会通过给出SEL (方法名)去找到IMP (函数指针)，然后执行


//4、Runtime消息转发
//在上面消息发送流程中我们提到过：若找不到对应的selector，消息被转发或者临时向receiver添加selector对应的方法实现，否则就会发生崩溃
//当一个方法找不到的时候，Runtime提供了 消息动态解析、消息接受者重定向、消息重定向等三步处理消息。具体流程如下
//消息动态解析的两个方法
//+(BOOL)resolveClassMethod:(SEL)sel
//+(BOOL)resolveInstanceMethod:(SEL)sel
//如果添加了其他函数实现消息成功处理，如果没有添加其他函数实现
//则消息接受者重定向
//-(id)forwardingTargetForSelector:(SEL)aSelector
//+(id)forwardingTargetForSelector:(SEL)aSelector
//如果实现了以上两个方法，则返回新的接受对象，消息成功处理，
//如果上述两个方法返回nil，则进行消息重定向，进入最后一道防线
//-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 和-(void)forwardInvocation:(NSInvocation *)anInvocation
//+(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 和+(void)forwardInvocation:(NSInvocation *)anInvocation
//如果有对象响应该方法，则消息转发给它，如果没有对象响应该方法，则程序崩溃

//4.1、消息动态解析

//Objective-C运行时会调用+resolveInstanceMethod: 或者 +resolveClassMethod:，让你有机会提供一个函数实现。前者在对象方法未找到时调用，后者在类方法未找到时调用。我们可以通过重写这两个方法，添加其他函数实现，并返回YES，那运行时系统就会重新启动一次消息发送的过程。

//主要使用的方法如下：
/**
 * class_addMethod      向具有给定 名称和实现 的类中添加新方法
 * @param cls           被添加方法的类
 * @param name          selector 方法名
 * @param imp           实现方法的函数指针
 * @param types         描述方法参数类型的字符数组
 * @return
*/
//OBJC_EXPORT BOOL
//class_addMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp,
                //const char * _Nullable types)
    //OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
-(void)forwardMessage1
{
    [self performSelector:@selector(fun)];
    //控制台打印NSLog(@"new funcMethod");
}
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(fun)) {
        class_addMethod([self class], sel, (IMP)funcMethod, "v@:");
        return  YES;
    }
    return  [super resolveInstanceMethod:sel];
}
void funcMethod (id objc,SEL _cmd){
    NSLog(@"new funcMethod");
}
//从上面的例子中，我们可以看出，虽然我们没有实现func方法，但是通过重写resolveInstanceMethod:，利用class_addMethod方法添加对象方法实现funcMethod方法，并执行。从打印的结果来看，我们成功调起了funcMethod方法。
//大家也注意到了class_addMethod中types这个参数的传入比较特殊。这里大家可以参考官方文档中关于Type Encodings的说明。「官方文档」
//官方文档地址:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100

@end

