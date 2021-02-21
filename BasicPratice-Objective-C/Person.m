//
//  Person.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/22.
//

#import "Person.h"

@interface Person ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@end

@implementation Person

-(Person *)initWithName:(NSString *)name age:(int)age
{
    self = [super init];
    if (self) {
        self.name = name;
        self.age = age;
    }
    return  self;
}

+ (Person *) personWithName:(NSString *)name age:(int)age
{
    return [[self alloc] initWithName:name age:age];
}
@end



