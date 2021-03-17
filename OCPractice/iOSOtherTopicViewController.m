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

//设计模式
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
    //V 表示View的可见元素，展示UI界面给用户，主要为UIKit中UIView的子类，其中
    //和用户进行交互的视图元素为UIKit子类UIControl下的子类视图，非UIControl子类的视图
    //不能交互
    //C表示Controller，逻辑控制器，对应于UIkit中的UIViewController及其子类控制器
    //负责协调View和Model
    //Conttoller和View的通信主要通过一些代理协议以及block代码块等实现，而Controller和Model
    //的通信主要用到Notification消息通知和KVO等典型观察者模式实现，View和Model是隔离的，不可以直接相互通信
    //MVC设计模式是官方推荐在iOS开发中使用的规范模式，应用的数据存储在Model层
    //逻辑处理在Controller中进行，而用户界面在View中展示
    //如何理解MVC设计模式
    //MVC 全名是 Model View Controller 是模型(Model)-界面视图(View)-控制器(Controller)的缩写
    //它是一种软件设计规范，用一种将业务逻辑、数据、界面显示分离的方法组织代码，将业务逻辑聚集到Controller中，在改建和个性化定制界面及用户交互同时，不需要编写业务逻辑。
    
               //Controller
        //Update(C->M)      //update(C->V)
        //Notify(M->C)     //UserAction(V->C)
     //Model                //View
    
    //1、模型对象
    //模型对象封装了应用程序的数据，并定义了操控和处理该数据的逻辑和运算规则，用户在视图层
    //中所进行的创建或者修改数据操作，会通过控制器传达出去，最终创建或者更新模型对象，另外，当模型
    //对象更改时(例如:通过网络连接接收到新数据),模型对象会通知控制器对象，控制器对象
    //更新相应的视图对象，被模型返回的数据是中立的，也就是说模型和数据格式无关，这样一个模型能为
    //多个视图提供数据，由于应用于模型的代码只需要写一次就可以被多个视图重用，所以减少了代码的重复性
    
    //2、视图对象
    //视图对象是应用程序中用户可以看到并且够与之交互的界面，视图对象对外提供显示
    //自身和响应用户操作的接口，视图对象的主要作用就是显示来自应用程序模型对象的数据
    //并使该数据可被编辑，在iOS应用程序开发中，所有的控件、窗口等都继承自UIView，
    //对应于MVC的View
    //3、控制器对象
    //在应用程序的一个或多个视图对象和一个或多个模型对象之间，控制器充当媒介。
    //因此，控制器对象是同步管理程序，通过控制器对象，视图对象了解对象的更改
    //反之亦然，控制器对象还可以为应用程序执行设置和协调任务，并管理其他对象的生命周期
    //控制器对象解释在视图对象中进行的用户操作，并将新的或更改的数据传达给模型对象。模型
    //对象更改时，一个控制器对象会将新的模型数据传达给视图对象，以便视图对象可以显示它
    
    //MVC设计模式的低耦合性、高重用性、可维护性等优点显而易见，使得原本复杂的代码与界面的
    //交互变得简单、清晰、明了，开发者可以把更多的精力放在前端界面设计上，而不用绞尽脑汁
    //去思考究竟应该如何使界面得到同步，这样减轻了设计压力，也从另一方面使用户得到更多更好的享受体验
    //事实上，MVC设计模式也是苹果公司推荐并在大量实践的设计模式，例如:对于不同的UIView类型的
    //的视图对象，都有相应的控制器对象(如UIViewController)与之对应，例如,常用的视图类UITableViewController，它所对应的
    //控制器对象就是UITableViewController类对象
    
    //MVC 设计模式有哪些优缺点？
    //MVC的优点如下
    //1、代码具有低耦合的特性
    //耦合性，也称块间联系，指程序结构中各模块间相互联系紧密程度的一种度量，模块间联系越紧密，
    //其耦合性就越强，模块的独立性越差，在MVC设计模式中，由于视图层、业务层和数据层分离，每个模块之间
    //相互独立，这样就允许更改视图层代码而不用重新编译模型和控制器代码，同样，一个应用程序的业务流程
    //或者业务规则的改变只需要改动MVC的模型层即可，因为模型与控制器和视图相分离，所以就很容易改变
    //应用程序的数据层和业务层的规则
    
    //2、高重用性和可适用性
    //随着技术的不断进步，现在需要用越来越对的方式来访问应用程序，MVC设计模式允许用户使用各种不同样式的视图来访问一个服务端的代码，它包括任何Web(HTTP)浏览器或者浏览器（WAP），例如:用户可以通过
    //计算机也可以通过手机来订购某样产品，虽然订购方式不一样，但处理订购产品的方式是一样的，由于模型返回的数据没有进行格式化，所以同样的构件能被不同的界面使用，例如,很多数据可能用HTML表示，也有可能用WAP表示，这些表示所需要的命令是改变视图层的实现方式，而控制层和模型层无须做任何改变
    
   //3、较低的生命周期成本和高可维护性
    //MVC 设计模型使视图层和业务层分离，使得应用更易于维护和修改，开发和维护
    //接口的技术含量降低，技术人员只要关心指定模块的代码逻辑即可
    
    //4、有利于软件工程化管理
    //由于不同层各司其职，每一层不同的应用具有某些相同的特征，有利于通过工程化、工具化管理程序代码
    
    //MVC 的缺点如下
    //1、增加了系统结构和实现的复杂性
    //MVC 设计模式适合用户界面和业务逻辑比较复杂的应用程序，对于简单的界面，严格遵循MVC设计模式，使
    //模型、视图和控制器分离，会增加结构的复杂性，并可能产生过多的更新操作，降低运行效率
    
    //2、视图与控制器间的过于紧密的连接
    //虽然视图与控制器之间是相互分离的，但在实际开发中，视图与控制器确又是联系紧密的部件，
    //视图没有控制器的存在，其应用是很有限的，反之亦然，这样就妨碍了它们的独立重用
    
    //3、视图对模型数据的低效率访问
    //依据模型操作接口的不同，视图可能需要多次调用才能获得足够的显示数据，对未变化的数据
    //的不必要的频繁访问，也将损害操作性能
    
    //4、大量逻辑处理代码全部放入ViewController控制器中，加上要遵循很多协议，会导致变得臃肿和混乱
    //难以维护和管理，也难以分离模块进行测试
    
    //5、缺少专门放网络逻辑代码部分
    //导致网络逻辑处理只能放在Controller控制器中国呢，加剧了Controller控制器部分的臃肿的问题
    
    
    //如何理解MVVM设计模式
    //随着业务规模不断扩大，业务逻辑也越来越复杂，这使得Controller中的任务越来越
    //繁重，传统的MVC架构已经很难满足低耦合，高内聚的设计要求，在这样的背景下，MVVM
    //(Model-View-ViewModel)诞生了，MVVM是由微软公司提出的一种新的设计架构，它基于
    //MVC架构，其特点是在View和Model之间多加了一层ViewModel来实现数据的绑定(data-bingding)
    //从而很好地解决了MVC中的Controller过于臃肿的问题
                            //owns             //owns
    //View、ViewController————————>ViewModel ——————————>Model
                    //update<--------//update<--------
    
     //MVVM中的ViewModel有以下的几个特点
     //1、ViewModel是有状态的。ViewModel有自己的属性，还会持有Model对象
    //2、ViewModel与UI控件的无关性。ViewModel并不关心UI控件的相关逻辑，
    //只关心自己的数据处理逻辑
    //3、易于单元测试，以往的Controller过于复杂，无法进行单元测试，而ViewModel测试起来简单很多
    //4、ViewModel可以抽离出来做转换器给其他项目使用，从而最大程度上实现了代码复用/
    //从Contoller中解放出来，使得Controller只需要专注于业务分配的工作，将数据加工的任务
    //ViewModel负责Model与View之间的通信，并完成通信间的额外操作，如数据转换、字符串拼接等操作，
    //因此，ViewModel经常作为转换器使用，从而提高了代码复用性，ViewModel还能帮助
    //Controller完成复杂的网络请求逻辑，从而大大降低了Controller的复杂度，这里需要强调的是
    //ViewModel具有独立性，它并不关心UI的业务逻辑，也不持有任何UI对象，只关心自己的数据处理
    //逻辑是否正确，很多初学者不清楚ViewMode的用法，往往地错误将UI对象当作ViewModel的属性或者将
    //UI对象的操作放入ViewModel的方法中，这些做法都是不正确的，没有真正理解MVVM含义，尽管MVVM带来了
    //很多好处，降低了代码耦合度和复杂度，但它往往要写更多的代码来实现一个功能，同时还增加；饿
    //工程的规模，使得工程中的目录比以前要稍多一些，不易查找文件，MVVM并不是iOS开发中的“银弹”
    //没有哪种方法能完全解决软件开发中的问题，但相对于MVC来说，MVVM无疑是一个更好的选择
    
    //常见面试1、MVVM设计模式能够减少代码量吗？能够在开发中代替MVC设计模式吗？
    //答案:事实上，MVVM设计模式在实际使用中，虽然能够将诸多非业务逻辑从Controller
    //中抽离，减少了代码的复杂性，但是总体的代码量不会减少，甚至会有些增加
    //MVVM 设计模式作为一种新颖的编程框架，能够帮助开发者解决一些旧编程框架带来的问题
    //但是也会带来一些新的问题，例如:
    //1、MVVM将Model通过ViewModel与View绑定使得Bug很难被调试，你看到的界面异常了，
    //有可能是你View的代码有问题，也可能是Model代码有问题，数据绑定使得一个位置的bug
    //被快读传递到别的位置，要定位原始出的问题的地方就变得不那么容易了
    //2、对于过大的项目，数据绑定需要花费更多的内存。某种意义上来说，数据绑定使得MVVM设计模式
    //变得复杂和难用了
    //综上所述，在iOS应用程序中国开发过程中，MVC设计模式和MVVM设计模式都有适合自己的应用场景，
    //应该根据具体业务需要，客观评估项目的具体情况，既不能守旧，又不能盲目追赶新技术，这样才能应对
    //新技术
    
    //常见面试题2、MVVM设计模式中如何实现数据绑定？
    //答案:MVVM设计模式的核心是ViewModel,当ViewModel发生变化时需要及时通知View更新
    //(即Updates),这就需要将ViewModel和View进行数据绑定，目前在iOS开发中较为常见的以下两种
    //方式
    //1、使用KVO(Key-Value-Observer)的绑定机制，在轻量级的开发中，它能很好地
    //将Objective-C和Cocoa结合起来，不需要借助第三方类库进行数据绑定
    //2、除了使用KVO，业界通常采用ReactiveCocoa作为绑定机制，ReactiveCocoa是
    //函数响应式编程(FRP)在iOS中国呢的一个实现框架
    
    
    
    
}

@end
