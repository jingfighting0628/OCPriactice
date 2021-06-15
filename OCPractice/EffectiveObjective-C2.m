//
//  EffectiveObjective-C2.m
//  OCPractice
//
//  Created by liuningbo on 2021/6/14.
//

#import "EffectiveObjective-C2.h"

@interface EffectiveObjective_C2 ()

@end

@implementation EffectiveObjective_C2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1、OC语言的起源
    //2、在类的头文件中尽量少引入其他头文件
    //@class XXXX
    //这叫做"向前声明"该类，将引入头文件的时机尽量延后，只有在确有需要时再引入，这样
    //就可以减少类的使用者所需引入的头文件的数量
    //3、多用字面量语法，少用与之等价的方法
    //3.1字面数值
    NSNumber *sommNumber = [NSNumber numberWithInt:1];
    //使用字面量语法更为精简
    NSNumber *intNumber = @1;
    NSNumber *floatNumber = @2.5f;
    NSNumber *doubleNumber = @3.1415926;
    NSNumber *boolNumber = @YES;
    NSNumber *charNumber = @'a';
    
    //字面量数组
    NSArray *annimals = [NSArray arrayWithObjects:@"cat",@"dog",@"mouse",@"badger",nil];
    //使用字面量语法创建则是
    NSArray *animals1 = @[@"cat",@"dog",@"mouse",@"badger"];
    
    NSDictionary *personData = [NSDictionary dictionaryWithObjectsAndKeys:@"Matt",@"firstName",@"Galloway",@"lastName",[NSNumber numberWithInt:28],@"age", nil];
    //使用字面量
    NSDictionary *personData1 = @{@"fistName":@"Matt",@"lastName":@"Galloway",@"age":@28};
    NSLog(@"personData:%@ personData1:%@",personData,personData1);
    //4、多用类型常量，少用#define预处理命令
#define ANNIMATION_DURATION 0.3
    //上述预处理命令会把源代码中的ANNIMATION_DURATION字符串替换为0.3，这可能是你想要的效果，不过这样定义吃了
    //5、用枚举表示状态、选项、状态码
    
}


@end
