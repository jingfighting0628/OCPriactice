//
//  iOSOtherTopicViewController.m
//  OCPractice
//
//  Created by liuningbo on 2021/3/17.
//

#import "iOSOtherTopicViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface iOSOtherTopicViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *myButton;
@end

@implementation iOSOtherTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self RAC];
    //设计模式
    [self designPattern];
    
}
-(void)RAC
{
    // Do any additional setup after loading the view.
    //函数响应式编程(Functional Reactive Programming FRP) 也叫 函数反应式编程
    //它结合了函数式编程的思想和响应式编程(Reactive Programming)的思想，它将
    //函数作为一等公民，将变量、事件看作流，是一种面向数据流的编程范式，函数响应式编程
    //意味着可以在编程中很方便地表达静态或动态的数据流,而相关的计算模型会自动将变化的值
    //通过数据流进行传播,不同于命令式编程，函数响应式编程是声明式编程的子编程式，它描述
    //的是更高层次的代码逻辑，专注于我们想要什么(what)而不是具体如何实现(how)，函数响应式
    //编程能让程序员集中精力编写业务逻辑，而不用关注复杂的内部流程逻辑，它使得
    //开发效率事半功倍，
    //随着互联网的高速发展以及业务的不断增加，App复杂度越来越高，程序员对高可用
    //性的代码需求越来越强烈，然而，传统的面向对象的编程方式已经无法满足程序员的需求，
    //在这种背景下，函数响应式编程思想诞生了，许多函数响应式编程框架也如雨后春笋一样
    //不断被研发出来，如ReactiveCocoa、RxSwift，其中ReactiveCocoa是GitHub官方
    //在开发客户端的时候开源的副产物，简称RAC，是iOS中最早的FRP框架，许多公司在项目
    //中都使用了RAC，学习和了解RAC的使用对即将面试iOS职位程序员是一个非常好的加分项
    
    //什么是ReactiveCocoa？如何使用？
    //ReactiveCocoa是GitHub开源的应用于iOS和 OS X的FRP框架，它吸取了.Net的Reactive
    //Extensions的设计，并实现了Objective-C 和 Swift 两个版本
    
    //ReactiveCocoa的宗旨是Streams of values over time(随着时间变化而不断流动的数据流)
    //它的主要目的是想解决Controller过于臃肿的问题,状态以及状态转化的问题，数据和事件的绑定问题
    //以及消息传递的问题。RAC中把事件、变量等都看作信号，而信号就对应了FRP中的流
    //当信号被订阅(subscribing)时，信号的执行才会被触发
    
    //创建一个信号，并订阅它
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        
        int a = 0;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        
        return  nil;
    }];
    //订阅信号signal
    [signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"x:%@",x);
    }];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(7, 150, size.width -  14 , 45)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    //_textField.backgroundColor = [UIColor blueColor];
    _textField.placeholder = @"请输入";
    
    [self.view addSubview:_textField];
    //监听一个UItextField属性text的变化,并打印text的值
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
       
        NSLog(@"text:%@",x);
    }];
    //使用filter过滤掉UITextField中text长度小于6的字符串
    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
            
            return value.length > 6;
            
        }]subscribeNext:^(NSString * _Nullable x) {
            NSLog(@"textValue:%@",x);
        }];
    //通过map重新映射的信号持有的变量，实现获取UitextField中的长度
    
    RACSignal *textLengthSignal = [self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        
        
        return @(value.length);
    }];
    [textLengthSignal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"text length:%d",[x intValue]);
    }];
    //使用signalForControlEvents代替 addTarget 实现事件绑定
    
    _myButton = [[UIButton alloc] initWithFrame:CGRectMake(30, _textField.frame.origin.y + _textField.frame.size.height + 20, size.width - 60, 40)];
    _myButton.backgroundColor = [UIColor lightGrayColor];
    [_myButton setTitle:@"myButton" forState:UIControlStateNormal];
    _myButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_myButton];
    [[self.myButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
          
         NSLog(@"button click");
        }];
    
    //RAC的强大远不止如此，可以用它来封装请求，从而帮助Controller减少网络请求
    //的逻辑，开发人员还可以用RAC重新实现MVVM模式，通过RAC实现模型与数据的绑定
    
    
    //如何使用RAC防止button短时间内重复单击
    
    //很多时候，我们要防止按钮或cell的重复单击，特别当单击按钮会触发网络请求的时候
    //如果在短时间内多次单击按钮，那么会使得网络在短时间内重复请求，上一个请求未结束
    //下一个请求又发出了，这样有可能带来意想不到后果，严重的话会造成程序崩溃，因此，防止按钮
    //在短时间重复单击是非常有必要的，如果是经验丰富的程序员，那么他们会想到AOP,利用iOS中
    //的runtime机制，使用Method swizzling 实现单击事件的block，然后延时执行单击事件，
    //从而避免短时间内的重复单击，如果开发者会RAC，那么这个问题就很简单了，解决方法如下
    
    [[[self.myButton rac_signalForControlEvents:UIControlEventTouchUpInside]throttle:2]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"button Click one");
        }];
    //以上代码的功能使用 throttle (节流) 方法 ,实现 2s 内，多次单击按钮只响应最后一次的单击事件
    
}
-(void)designPattern
{
    
    //Cocoa框架本身即可以看到不同设计模式的广泛应用,除了最基本的 MVC架构模式
    //和常见的单例模式，还有之前介绍过的基于(Protocal)协议实现的代理模式，实现
    //Notification(通知)的观察者模式，以UIbutton为代表的类工厂方法、目标-动作机制等
    
    //什么是单例模式
    //单例模式是一种最基本的设计模式，单例类在系统只有一个实例，它通过一个个全局接口
    //随时进行访问或者更新，起到控制中心的角色，全局协调累的各种服务
    //Foundation 和 Application Kit 框架中的一些类只允许创建单个对象，即这些类
    //在当前进程中唯一实例，举例来说，NSfileManager 和 NSWorkSpace 类在使用时都是
    //基于进程进行单个对象的实例化，当向这些类请求实例的时候，它们会传递单一实例的一个引用，
    //如果该实例不存在，那么先进行实例的分配和初始化，如果类在概念上只有一个实例(例如NSWorkSpace),那么就应该产生一个单件实例，而不是多个实例，如果将来可能有多个
    //实例，那么可以使用单件实例机制，而不是工厂方法或方法
    
    //1、Cocoa框架中常用的单例对象
     // UIApplication ：应用程序实例对象
    //NSNotificationCenter:通知中心
    //NSFileManager 文件管理器
    //NSUserDefault 应用程序的偏好设置
    //NSWorkSpace 一个比较宏观的应用级控制中心单例类
    //NSURLCache iOS 中设置内存缓存的一个单例类
    //NSHTTPCookieStorage :iOS 中的一个管理cookie的单例对象
    
    //2、Objective-C单例模式的实现
    //iOS中单例模式的实现主要考虑两种情况，一种是非ARC下的实现(要考虑内存管理)
    //另一种是ARC实现，但目的相同都是实现让某个类在应用中有且只有一个实例，这里
    //只说ARC下的实现方法，假设规定就通过类名的类函数来调用单例，不允许通过alloc
    //和init创建，也暂时不考虑截断copyWithZone的问题，从而简单实现，但实际上
    //可能会通过其他方式重新初始化创建一个新的对象，为了阻止其发生，还要考虑将其
    //他创建方式进行重写截断，保证对象只会按照预想的被实例化一次
    
    //什么是MVC设计模式
    //MVC 是iOS开发中一种很基础的工程架构模式，也是构成iOS应用标准模式，它将
    //数据模型、UI视图和逻辑控制器分开并规定它们之间的通信方式，大大优化了程序的
    //的结构组织
    // M表示 Model,专门用来存储对象数据模型，一般使用一个继承NSObject的的基本类
    //对模型的数据进行封装，在.h文件中声明一些用来存放数据的属性,在CoreData中模型即
    //Managed Object
    
    
    
    
}

@end
