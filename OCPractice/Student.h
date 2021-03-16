//
//  Student.h
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "Major.h"
#import "Person.h"
NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject
{
@private NSString *name;
}
@property (nonatomic, strong) Major *major;
@property (nonatomic, strong) Person *person;
@property (nonatomic, copy) NSString *infomation;
@end

NS_ASSUME_NONNULL_END
