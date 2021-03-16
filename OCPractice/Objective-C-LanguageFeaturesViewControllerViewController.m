//
//  Objective-C-LanguageFeaturesViewControllerViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "Objective-C-LanguageFeaturesViewControllerViewController.h"
#import "Model1.h"
@interface Objective_C_LanguageFeaturesViewControllerViewController ()

@end

@implementation Objective_C_LanguageFeaturesViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     类对象:类本身也是一个对象,保存该类的成员变量、属性列表和方法列表等
     实例对象:类对象经过实例化alloc后成为实例对象
     
     根类实例对象、父类实例对象、子类实例对象 通过isa指针分别指向
     根类(Class)、父类(Class)、子类(Class)
     而根类(Class)、父类(Class)、子类(Class)通过isa指针指向
     根类(meata元类)、父类(meata元类)、子类(meata元类)
     
     1、类方法属于类对象，类方法列表定义在类对象的元类中，通过isa指针找到，
     2、实例方法属于实例对象，属于实例对象，定义在实例对象的类对象中，通过isa指针找到
     3、类方法中的self指的是类对象，实例方法中的self指的是实例对象
     4、实例方法可以调用成员变量，但是类方法不能调用成员变量
     5、类方法只能通过类对象调用，也就是类名调用，实例方法则需要通过alloc和init实例化
     的实例调用
     6、类方法可以调用其他的类方法，但不可以直接调用实例方法，而实例方法既可以调用其他实例方法
     ，也可以通过类名直接调用本类或者外部类的类方法。
     
     
     #import #include #import<> #import ""
     #import #include都是引入头文件，与#include相比，#import不会包含重复，可以保证头文件只
     被编译一次
     
     @class代表什么？
     @class相当于在头文件声明一下要用的类的头文件(前向声明),告诉编译器有这样的一个类，但暂时
     不要将类的实现引入
     
     在OC中的数组和字典中，添加nil对象会有什么问题
     
     子类初始化为什么要调用self = [super init]
     因为子类继承父类，需要获得父类的实例和方法等，所以初始化子类之前保证父类已经初始化
     完毕，防止出错
     使用dealloc释放对象时，为什么要调用[super dealloc]方法?在何处调用
     因为子类的很多实例变量是继承父类的，所以调用[super dealloc]从父类继承的变量
     实际是还是释放自己的实例变量，

     */
    
  
    NSArray *array = [[NSArray alloc] initWithObjects:@1,@2,@3, nil];
    NSMutableArray *mulArray = [[NSMutableArray alloc]initWithObjects:@4,@5,@6, nil];
    //深拷贝mulArray数组，但得到的是一个新的不可数组array
    NSMutableArray *array1 = [mulArray copy];
    //[array1 addObject:@"4"];
    
    
    /*
     一：概念
     浅拷贝：指针拷贝，不会创建一个新的对象。浅拷贝简单点说就是对内存地址的复制，让目标对象指针和源对象指针指向同一片内存空间
     深拷贝: 内容拷贝，会创建一个新的对象。深拷贝就是拷贝地址中的内容，让目标对象产生新的内存区域，且将源内存区域中的内容复制到目标内存区域中
     深拷贝和浅拷贝的本质是内存地址是否相同
     */
    [self testCopy];
    [self testCopy1];
    
    [self testCopy2];
    ////容器的双层深copy：这里的双层指的是完成了NSArray对象和NSArray容器内对象的深copy（为什么不说完全，是因为无法处理NSArray中还有一个NSArray这种情况）
    [self testCopy3];
    
}
-(void)testCopy
{
    NSString *str = @"jing_fight0628";
    NSString *str1 = [str copy];//浅拷贝
    NSString *str2 = [str mutableCopy];//深拷贝
    NSMutableString *str3 = [str copy];//浅拷贝
    //[str3 appendString:@"lnb"];对 NSString copy结果为不可变对象
    NSMutableString *str4 = [str mutableCopy];//深拷贝
    [str4 appendString:@"lnb"];//对 NSString mutableCopy结果为可变对象
    NSLog(@"指针地址:str = %p,str1 = %p",str,str1);
    NSLog(@"指针地址:str = %p,str2 = %p",str,str2);
    NSLog(@"指针地址:str = %p,str3 = %p",str,str3);
    NSLog(@"指针地址:str = %p,str4 = %p",str,str4);
    
    NSMutableString *mStr = [NSMutableString  stringWithFormat:@"coder"];
    NSString *mStr1 = [mStr copy];//深拷贝
    NSString *mStr2 = [mStr mutableCopy];//深拷贝
    NSMutableString *mStr3 = [mStr copy];//深拷贝
    //[mStr3 appendString:@"123"]; 崩溃//对 NSMutableString copy结果为不可变对象
    NSMutableString *mStr4 = [mStr mutableCopy];//对 NSMutableString mutableCopy结果为可变对象
    [mStr4 appendString:@"123"];
    NSLog(@"指针值:mStr = %p mStr1 = %p",mStr,mStr1);
    NSLog(@"指针值:mStr = %p mStr2 = %p",mStr,mStr2);
    NSLog(@"指针值:mStr = %p mStr3 = %p",mStr,mStr3);
    NSLog(@"指针值:mStr = %p mStr4 = %p",mStr,mStr4);
    NSLog(@"mStr4 == %@",mStr4);
    /*
     结论：

     无论是对NSString类型还是对NSMutableString进行mutableCopy，得到的内存地址都与原对象地址不同，mutableCopy是真正意义上的深拷贝
     NSString，NSMutableString和copy，mutableCopy4种组合方式只有对不可变对象NSString类型进行copy后得到的内存地址和原对象地址相同，是浅拷贝，其他都是深拷贝
     copy得到的对象都仍然是不可变对象，mutableCopy的到的对象仍然是不可变对象

     这里可以回答一个经常面试问到问题：
     对NSMutableString用copy修饰会有什么问题？
     答：对NSMutableString用copy修饰得到的是不可变类型NSString对象，如果再对这个对象进行改变会crash
     
     默认Foundation框架NSString、NSDictionary、NSArray类都可以调用copy和mutableCopy实现拷贝

     原因是因为这些类遵守了NSCopying, NSMutableCopying协议，并实现了协议中的方法

     自定义继承NSobject类的实例对象想具备cop和mutableCopy功能，需要遵守了NSCopying, NSMutableCopying协议，并实现了协议中的方法

     1.当调用一个实例对象调用copy方法 系统框架内部实现去调用该实例对象的copyWithZone:方法决定copy返回结果

     2.当调用一个实例对象调用mutableCopy方法 系统框架内部实现去调用该实例对象的mutableCopyWithZone:方法决定mutableCopy返回结果

     zone参数是系统已经提供的内空间
     
     */
}
-(void)testCopy1
{
    Model1 *model1 = [[Model1 alloc] init];
    model1.name = @"coder";
    Model1 *copyModel = [[Model1 alloc] init];
    NSLog(@"指针值model = %p ,copyModel :%p",model1,copyModel);
    
    
}
-(void)testCopy2
{
    /*
     分析:
     arr和mCopyArr地址不同，实现了外层NSArray对象的深拷贝
     但是arr首元素和mCopyArr首元素地址相同，证明并未对其容器内对象进行处理
     单层深拷贝
     */
    
    NSArray *arr = [NSArray arrayWithObjects:@"1", nil];
    NSArray *copyArr = [arr copy];
    NSLog(@"******************浅copy******************");
    NSLog(@"原对象指针:arr == %p copyArr == %p",arr,copyArr);
    NSLog(@"******************单层深copy******************");
    NSArray *mCopyArr = [arr mutableCopy];
    NSLog(@"原对象指针arr==%p,mCopyArr==%p", arr,mCopyArr);
    NSLog(@"指针变量地址==%p, arr对象地址==%p", &arr,arr);
    NSLog(@"指针变量地址==%p, mCopyArr对象地址==%p",&copyArr, mCopyArr);
    
    
}
-(void)testCopy3
{
    // 随意创建一个NSMutableString对象
        NSMutableString *mStr = [NSMutableString stringWithString:@"zww"];

        // 随意创建一个包涵NSMutableString的NSMutableArray对象
        NSMutableString *mStr1 = [NSMutableString stringWithString:@"111"];
        NSMutableArray *mArr = [NSMutableArray arrayWithObjects:mStr1, nil];

        // 将mutableString和mutableArr放入一个新的NSArray中
        NSArray *testArr = [NSArray arrayWithObjects:mStr, mArr, nil];
        // 通过官方文档提供的方式创建
        NSArray *testArrCopy = [[NSArray alloc] initWithArray:testArr copyItems:YES];

        // testArr和testArrCopy指针对比
         NSLog(@"原对象指针testArr==%p,testArrCopy==%p", testArr,testArrCopy);

        // testArr和testArrCopy中元素指针对比
        // mStr对比
        NSLog(@"首元素mStr地址testArr[0]==%p，testArrCopy[0]==%p", testArr[0],testArrCopy[0]);

        // mArr对比
        NSLog(@"其中元素mArr地址testArr[1]==%p，testArrCopy[1]==%p", testArr[1],testArrCopy[1]);


        // mArr中的元素对比，即mStr1对比
        NSLog(@"其中元素mArr里面包含元素mStr1的地址testArr[1][0]==%p，testArrCopy[1][0]==%p", testArr[1][0],testArrCopy[1][0]);

    
    
}
@end
