//
//  Annimal.h
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Annimal : NSObject
@property (nonatomic, copy) NSString *name;
//父类接口 动物的叫声
- (void) shout;

@end

NS_ASSUME_NONNULL_END
