//
//  Test.h
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Test : NSObject
//在括号内添加属性例如readwrite进行限制
@property (atomic, copy,readwrite) NSString *myName;
@end

NS_ASSUME_NONNULL_END
