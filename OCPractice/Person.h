//
//  Person.h
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
+ (Person *) personWithName:(NSString *)name age:(int)age;
@end

NS_ASSUME_NONNULL_END
