//
//  NSString+Extension.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/22.
//

#import "NSString+Extension.h"
#import <objc/runtime.h>
@implementation NSString (Extension)
-(id)name{
    id value = objc_getAssociatedObject(self, @"name");
    
    return  value;
    
}
-(void)setName:(NSString *)name
{
    objc_setAssociatedObject(self, @"name", name ,OBJC_ASSOCIATION_RETAIN);
    
}

+(void)load
{
    Method description = class_getInstanceMethod([self class], @selector(description));
    
    Method myDescription = class_getInstanceMethod([self class], @selector(myDescription));
    
    //method_exchangeImplementations(description, myDescription);
}
-(NSString *)myDescription
{
    return [NSString stringWithFormat:@"这是自定义打印方法"];
}

@end
