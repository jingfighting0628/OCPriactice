//
//  Test1.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/3/11.
//

#import "Test1.h"
#import <objc/runtime.h>
@implementation Test1

-(void)instanceMethod1
{
    NSLog(@"instanceMethod1...");
}
-(void)instanceMethod2
{
    NSLog(@"instanceMethod2...");
}

-(void)classMethod1
{
    NSLog(@"classMethod1...");
}
-(void)classMethod2
{
    NSLog(@"classMethod2...");
}
+ (void)load
{
    Class class = [self class];
    
    SEL selInsMethod1 = @selector(instanceMethod1);
    SEL selInsMethod2 = @selector(instanceMethod2);
    SEL selClassMethod1 = @selector(classMethod1);
    SEL selClassMethod2 = @selector(classMethod2);
    
    Method insMethod1 = class_getInstanceMethod(class, selInsMethod1);
    Method insMethod2 = class_getInstanceMethod(class, selInsMethod2);
    Method ClassMethod1 = class_getClassMethod(class, selClassMethod1);
    Method ClassMethod2 = class_getClassMethod(class, selClassMethod2);
    
    if (!insMethod1 || !insMethod2) {
        NSLog(@"实例方法实现运行时交换失败");
        return;
    }
    method_exchangeImplementations(insMethod1, insMethod2);
    
    if (!ClassMethod1 || !ClassMethod2) {
        
        NSLog(@"类方法实现运行时交换失败");
        return;
    }
    method_exchangeImplementations(ClassMethod1, ClassMethod2);
    
    //重新设置类中某个方法的实现
    
    IMP impInsMethod1 = method_getImplementation(insMethod1);
    IMP impInsMethod2 = method_getImplementation(insMethod2);
    
    IMP impClassMethod1 = method_getImplementation(ClassMethod1);
    IMP impClassMethod2 = method_getImplementation(ClassMethod2);
    
    method_setImplementation(insMethod1, impInsMethod2);
    method_setImplementation(insMethod2, impInsMethod1);
    
    method_setImplementation(ClassMethod1, impClassMethod2);
    method_setImplementation(ClassMethod2, impClassMethod1);
    
    //替换类中某个方法的实现
    //替换方法实现函数，class_replaceMethod(Class cls, SEL name, IMP imp,const char *types)
    
    const char * typeInsMethod1 = method_getTypeEncoding(insMethod1);
    const char * typeInsMethod2 = method_getTypeEncoding(insMethod2);
    
    const char * typeClassMethod1 = method_getTypeEncoding(ClassMethod1);
    const char * typeClassMethod2 = method_getTypeEncoding(ClassMethod2);
    
    class_replaceMethod(class, selInsMethod1, impInsMethod2, typeInsMethod2);
    class_replaceMethod(class, selInsMethod2, impInsMethod1, typeInsMethod1);
    
    //尝试替换类方法的实现
    
    class_replaceMethod(class, selClassMethod1, impClassMethod2, typeClassMethod2);
    class_replaceMethod(class, selClassMethod2, impClassMethod1, typeClassMethod1);
    
    //在运行时为类添加新方法
    
    SEL selNewInsMethod = @selector(newInsMethod);
    BOOL isInsAdded = class_addMethod(class, selNewInsMethod, impInsMethod1, typeInsMethod1);
    if (!isInsAdded) {
        NSLog(@"新实例方法添加失败");
    }
    
    
    
    
}
@end
