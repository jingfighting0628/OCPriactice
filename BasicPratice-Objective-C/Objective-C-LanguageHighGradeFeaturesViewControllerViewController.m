//
//  Objective-C-LanguageHighGradeFeaturesViewControllerViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "Objective-C-LanguageHighGradeFeaturesViewControllerViewController.h"
#import "Test.h"
#import "Annimal.h"
#import "Dog.h"
#import "Cat.h"
#import "TestMessageForward.h"
#import <objc/runtime.h>
#import "NSString+Extension.h"
@interface Objective_C_LanguageHighGradeFeaturesViewControllerViewController ()
@property (nonatomic, strong)   NSString         *nameStrong;    // 用strong修饰
@property (nonatomic, copy)     NSString         *nameCopy;      // 用copy修饰
@property (nonatomic, copy)     NSString         *normalName;    // 原字符串-不可变
@property (nonatomic, strong)   NSMutableString  *mutableName;   // 原字符串-可变

@property (nonatomic, assign) int age;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, copy) NSString *name1;
@end

@implementation Objective_C_LanguageHighGradeFeaturesViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自定义变量名
    //@synthesize myName = theName ;
    //禁止编译器自动合成存取方法 如果.myName会崩溃
    //@dynamic myName ;具体见Test.m
    Test *test = [[Test alloc] init];
    test.myName = @"myName";
    //atomic nonatomic 原子性和非原子性
    //在多线程中同一个变量可能被多个线程访问，进而造成数据污染，因此为了系统安全
    //Objective-C默认是atomic，即会对setter方法加锁，应用如果不是特殊情况，
    //一般是用nonatomic来修饰变量的，不会对setter方法加锁，以提高多线程并发访问性能
    /*
     苹果开发文档已经明确指出：Atomic不能保证对象多线程的安全。所以Atomic 不能保证对象多线程的安全。它只是能保证你访问的时候给你返回一个完好无损的Value而已。举个例子：

     如果线程 A 调了 getter，与此同时线程 B 、线程 C 都调了 setter——那最后线程 A get 到的值，有3种可能：可能是 B、C set 之前原始的值，也可能是 B set 的值，也可能是 C set 的值。同时，最终这个属性的值，可能是 B set 的值，也有可能是 C set 的值。所以atomic可并不能保证对象的线程安全。

     atomic和nonatomic的对比：

     1、atomic和nonatomic用来决定编译器生成的getter和setter是否为原子操作。

     2、atomic：系统生成的 getter/setter 会保证 get、set 操作的完整性，不受其他线程影响。getter 还是能得到一个完好无损的对象（可以保证数据的完整性），但这个对象在多线程的情况下是不能确定的，比如上面的例子。

     也就是说：如果有多个线程同时调用setter的话，不会出现某一个线程执行完setter全部语句之前，另一个线程开始执行setter情况，相当于函数头尾加了锁一样，每次只能有一个线程调用对象的setter方法，所以可以保证数据的完整性。

     atomic所说的线程安全只是保证了getter和setter存取方法的线程安全，并不能保证整个对象是线程安全的。

     3、nonatomic：就没有这个保证了，nonatomic返回你的对象可能就不是完整的value。因此，在多线程的环境下原子操作是非常必要的，否则有可能会引起错误的结果。但仅仅使用atomic并不会使得对象线程安全，我们还要为对象线程添加lock来确保线程的安全。

     4、nonatomic的速度要比atomic的快。

     5、atomic与nonatomic的本质区别其实也就是在setter方法上的操作不同
     
     */
    //readonly readwrite
    //readonly只读 只有getter 没有setter readwrite 既有setter又有getter方法
    //assign 修饰基本数据类型，或者修饰对指针的弱引用，不会使对象的引用计数器加1
    //weak 修饰弱引用，不会增加引用计数器，主要可以避免循环引用 hestrong/assign对应 和assign一样简单，用weak修饰的对象消失后指针置为nil
    //retain 引用计数器 +1
    //strong ARC中 引用计数器 +1
    //copy:建立和新对象内容相同且索引计数为1的对象，指针指向这个对象，然后释放指针指向的之前的旧对象,NSString变量一般用于copy修饰，因为字符串常用语直接复制，而不是去引用字符串
    
    //在定义一个NSString类型的属性时，为什么要用copy修饰？
    //为了防止在把一个可变字符串在未使用copy方法时赋值给这个字符串对象时，修改原字符串时，本字符串也会被动进行修改的情况发生
    
    //所有权修饰符 __strong __weak
    //__strong修饰强引用持有对象
    //__weak 防止循环引用
    
    
    
    //先说原字符串为不可变的情况，这种情况比较简单。给normalName赋值，并把normalName赋值给nameStrong和nameCopy，如下
    [self testCopy1];
    //如果对原字符串normalName进行改变呢？严谨来说，normalName为不可变类型，只能重新进行赋值
    [self testCopy2];
    //原字符串为可变的情况,给mutableName进行赋值，并把mutableName赋值给nameStrong和nameCopy，如下
    [self testCopy3];
    //如果是直接对mutableName进行赋值操作，则同normalName一样，对strongName和copyName都不会有影响，只是改变的它自己，如下：
    [self testCopy4];
    
    
    //多态 是在面向对象语言中国呢指同一个接口可以有多种不同的实现方式，Objective-C的多态则是不同对象对同一个消息的不同响应方式
    Annimal *animal = [[Annimal alloc] init];
    Annimal *dog = [[Dog alloc] init];
    Annimal *cat = [[Cat alloc] init];
    //向指向不同对象的父类指针发送相同的消息
    [animal shout];
    [dog shout];
    [cat shout];
    //Objective-C 有多重继承吗 可以实现多个接口吗？重写一个类用继承好还是分类好？为啥？
    //Objective-C只支持单继承，不可以多继承，Objective-C可以利用protocal代理协议实现多个接口
    //在Objective-C中多态性是通过protocal和Category来实现，protocol实现的接口方法可以被多个
    //类实现，Category可以在不变动原来的类的情况下实现方法的重写和扩展
    //重写一个类一般情况下使用Category好，因为Category可以重写类方法，仅对本Category有效，不会影响到其他类和原有类
    
    //Objective-C动态性
    //动态类型：运行时确定对象的类型
    //指的是指针类型的动态性，具体是指使用id类型将对象的类型推迟到运行时才确定，由赋给它对象类型决定对象的类型
    //动态绑定 运行时确定对象的调用方法
    //指的是将执行的方法推迟到运行时才确定，可以动态添加方法
    //动态加载:运行时加载需要的资源或者可执行代码
    //指的是动态资源加载，代码模块加载
    
    //消息传递机制
    //在Objective-C方法的调用不再理解为对象调用其方法，要理解为对象接收消息，
    //消息的发送采用动态绑定的机制，具体调用哪个方法知道运行时才确定，确定后才会
    //执行可绑定的代码，方法的调用实际就是告诉对象要什么，给对象传递一个消息
    //对象为接收者(receiver)调用的方法及其参数就是(message)，给一个对象传递消息的
    //表达式[receiver message] 接收者的类型可以通过动态类型识别在运行时确定
    //在消息传递的机制中，开发者编写[receiver message]语句发出消息后，编译器都会
    //将其转换为一条objc_msgSend C语言消息发送原语
    //void objc_msgSend(id self,SEL cmd....)
    //这个原语函数参数可变，第一个参数填入消息的接收者，第二个参数是消息的"选择子"
    //后面跟着可选消息的参数，有了这些参数，obc_msgSend 就可以通过isa指针
    //到类对象中的方法列表中可以选择子的名称“键”寻找相应的方法，若找到对应的方法
    //则转到实现的代码执行，否则继续从父类中寻找，如果到了根类还是无法找到对应的方法，
    //说明接收者对象无法响应该消息，那么就触发消息转发机制，给开发者最后一次挽救程序崩溃的机会
    
    //消息转发机制
    //如果在消息的传递过程中，接收者无法响应收到的消息，那么会触发消息转发机制，
    //消息转发机制依次经过3道防线，任何一个起作用都可以挽救此消息转发，3道防线依此为
    //1动态补加方法
    //+(BOOL)resolveInstanceMethdo:(SEL)sel
    //+(BOOL)resolveClassMethod:(SEL)sel
    //2.直接返回消息转发的对象中(将消息发送给另一个对象中)
    //-(id)forwoadingTagetForSelector:(SEL)aSelctor
    //3.手动生成方法签名并转发另一个对象
    //-(NSMethodSignature *)methodSignatureForSeletor:(SEL)aSelector
    //-(vood)forwardInvocation:(NSInvocation *)anInvocation;
    [self testMessageForward];
    //什么编译时与运行时
    //编译时：即编译器对语言的编译阶段，编译时只是对语言进行最基本的检查报错，包括词法分析
    //语法分析，将程序代码翻译成计算机能够识别的语言(例如汇编)编译通过并不意味着程序就可以成功运行
    
    //运行时:即程序通过了编译这一关之后编译好的代码被装载到内存中运行起来的，这是好对类型检查，而不是仅仅对
    //对代码简单扫描，此时若出错，程序崩溃
    
    //OC是运行时语言主要OC语言的动态性、包括动态性和多态性
    //动态性是动态类型、动态绑定、动态加载
    //多态是面向对象变成语言的特性，OC作为面向对象语言，多态来自不同的对象可以接收同一消息的能力
    //或者说不同对象以自己的方式响应相同的消息的能力
    
    //isKindOfClass 和isMemberofClass
    //isKindofClass判断某个对象是动态类型Class的实例及其子类的实例
    //isMemberOfClass 与isKindOfClass不同，这里只判断是逗是Class类型的实例
    //判断是否有对应的方法
    //-(BOOL)respondsToSelector:(SEL)selctor
    //类中是否有这个实例方法
    //-(BOOL)instanceRespondToSelector:(SEL)selector
    
    //instanceType与id有什么区别
    //instanceType和id都表示任意类型
    
    //在runtime中类与对象如何表示
    [self runtime];
    //如何打印一个类中所有实例变量
    [self printClassIvars];
    //Category添加属性，系统不会为这个属性生成setter和getter方法,利用runtime给类添加属性
    [self addPropertyForCatagory];
    //类别和扩展有什么区别
    //子类扩展和继承有什么区别？
    //1.子类继承是进行类扩展一种方法，
}
-(void)testCopy1{
    self.normalName     = @"1111";
    self.nameStrong     = self.normalName;
    self.nameCopy       = self.normalName;
       
    NSLog(@"\nnormalName: %@ - normalName地址: %p\nnameStrong: %@ - nameStrong地址: %p\nnameCopy: %@ - nameCopy地址: %p",
             self.normalName, _normalName, self.nameStrong, _nameStrong, self.nameCopy, _nameCopy);
    
    //你会发现，nameStrong和nameCopy同原字符串的地址是一样的，所以值肯定也是一样的
}
-(void)testCopy2
{
    self.normalName    = @"1111";
    self.nameStrong    = self.normalName;
    self.nameCopy      = self.normalName;
        
    NSLog(@"\nnormalName: %@ - normalName地址: %p\nnameStrong: %@ - nameStrong地址: %p\nnameCopy: %@ - nameCopy地址: %p",
              self.normalName, _normalName, self.nameStrong, _nameStrong, self.nameCopy, _nameCopy);
        
    self.normalName = @"2222";
        
    NSLog(@"\nnormalName: %@ - normalName地址: %p\nnameStrong: %@ - nameStrong地址: %p\nnameCopy: %@ - nameCopy地址: %p",
              self.normalName, _normalName, self.nameStrong, _nameStrong, self.nameCopy, _nameCopy);
    //你会发现，nameStrong和nameCopy的地址并没有发生变化，还是同最初normalName的地址是一样的，所以值没变，但normalName重新赋值后，地址发生了变化，指针指向了一块新的地址。
    //结论1:如果原字符串为不可变类型字符串，使用copy或strong修饰NSString效果是一样的
}
-(void)testCopy3
{
    self.mutableName    = [NSMutableString stringWithString:@"1111"];
    self.nameStrong     = self.mutableName;
    self.nameCopy       = self.mutableName;
        
    NSLog(@"\nmutableName: %@ - mutableName地址: %p\nnameStrong: %@ - nameStrong地址: %p\nnameCopy: %@ - nameCopy地址: %p",
              self.mutableName, _mutableName, self.nameStrong, _nameStrong, self.nameCopy, _nameCopy);
    //你会发现，三个属性的值是一样的，但nameStrong同mutableName指向的是同一块地址，而nameCopy则是指向的一块新的地址。那是因为在把mutableName赋值给nameCopy时，自动进行了深拷贝，把mutableName的内容复制了一份，并新开了一块内存来存储，然后让nameCopy指向了这个新的地址
    
    [self.mutableName appendString:@"aaaa"];

       NSLog(@"\nmutableName: %@ - mutableName地址: %p\nnameStrong: %@ - nameStrong地址: %p\nnameCopy: %@ - nameCopy地址: %p",
             self.mutableName, _mutableName, self.nameStrong, _nameStrong, self.nameCopy, _nameCopy);
    //你会发现，nameStrong的值也被改变了，但nameCopy并没改变。这就是为什么要使用copy的原因了
}
-(void)testCopy4
{
    self.mutableName     = [NSMutableString stringWithString:@"1111"];
    self.nameStrong      = self.mutableName;
    self.nameCopy        = self.mutableName;
      
    NSLog(@"\nmutableName: %@ - mutableName地址: %p\nnameStrong: %@ - nameStrong地址: %p\nnameCopy: %@ - nameCopy地址: %p",
            self.mutableName, _mutableName, self.nameStrong, _nameStrong, self.nameCopy, _nameCopy);
      
  //    [self.mutableName appendString:@"aaaa"];
    self.mutableName = [NSMutableString stringWithString:@"2222"];

    NSLog(@"\nmutableName: %@ - mutableName地址: %p\nnameStrong: %@ - nameStrong地址: %p\nnameCopy: %@ - nameCopy地址: %p",
            self.mutableName, _mutableName, self.nameStrong, _nameStrong, self.nameCopy, _nameCopy);
}
//下面这段代码有什么问题
-(void)setAge:(int)newAge
{
    self.age = newAge;
}
//self.age 是调用self中age的setter方法，setter方法调用自身，即setter方法中嵌套set方法导致死循环 通过点语法访问变量时，
//变量左边是setter方法，右边是getter方法


- (void)testMessageForward
{
    TestMessageForward *test = [[TestMessageForward alloc] init];
    [test instanceMethod];
    
}
-(void)runtime
{
    
    /*
     struct objc_class {
         Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

     #if !__OBJC2__
         Class _Nullable super_class                              OBJC2_UNAVAILABLE;
         const char * _Nonnull name                               OBJC2_UNAVAILABLE;
         long version                                             OBJC2_UNAVAILABLE;
         long info                                                OBJC2_UNAVAILABLE;
         long instance_size                                       OBJC2_UNAVAILABLE;
         struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
         struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
         struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
         struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
     #endif

     } OBJC2_UNAVAILABLE;
     
     */
    //在这个结构体中，有几个重要的字段
    //1/isa 在OC中，所有的类自身也是一个对象 这个对象的Class里面也存在一个isa指针
    //对象需要通过isa指针找到它的类，类需要通过isa指针找到它的元类(Meta Class)
    //元类可以理解为类对象的类，每个类都会有一个单独的元类，事实上元类也是一个类，它也
    //存在一个isa指针，它的指针指向父类的元类，也就是说，任何NSObject继承体系下的元类
    //都使用NSObject的元类作为自己的所属类，而基类的元类isa的指向它自己，这样就形成一个
    //完美闭环，isa指针在调用实例方法和类方法的时候起到重要作用
    //2‘superClass:指向该类的父类，如果该类已经是最顶层的类(Root Class)那么super_class就是nil
    //3.cache：主要是缓存类中最近使用的方法，当开发者调用过一个方法后，runtime会将这个方法缓存到cache列表中，
    //如果再次调用这个方法，那么runtime就会优先去cache中查找，如果cache没有，那么就会去methodLists
    //4.ivars指向该类的成员变量链表
    //5.methodLists指向方法定义的链表
    //6.protocols：指向协议链表
    
}
- (void)printClassIvars
{
    //OC中的类中由Class类型表示的，而Class是一个objc_class类型的结构体,它包含了实例变量列表(objc_ivar_list)、方法
    //列表(objc_method_list)和协议列表(objc_protocol_list)开发者可以通过runtime提供函数来操作
    
    //获取成员变量列表函数如下:
    // Ivar *class_copyIvarList(Class class ,unsigned int *outCount)
}
- (void)addPropertyForCatagory
{
    
    NSString *str = @"123";
    str.name = @"1234";
    
    NSLog(@"name:%@",str.name);
    
    
}
@end
