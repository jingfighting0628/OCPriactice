//
//  TestMessageForward.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/22.
//

#import "TestMessageForward.h"
#import <objc/runtime.h>
#import "TestMessageForward2.h"
@implementation TestMessageForward


void instanceMethod(id self, SEL _cmd){
    NSLog(@"收到消息后会执行此处的方法实现");
    
}
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
    if (sel == @selector(instanceMethod)) {
        class_addMethod(self, sel, (IMP)instanceMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    if (aSelector == @selector(instanceMethod)) {
        
        return [[TestMessageForward alloc] init];
    }
    return  nil;
    
}
//如果没有实现上面两个补救方法或者forwardTargetForSelector方法返回了nil,就进入到最后一道防线
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *selName = NSStringFromSelector(aSelector);
    if ([selName isEqualToString:@"instanceMethod"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    //如果另一个对象可以响应该消息,那么将消息转发给它
    SEL sel = [anInvocation selector];
    TestMessageForward2 * test2 = [[TestMessageForward2 alloc] init];
    if ([test2 respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:test2];
    }
}
@end
