//
//  Model1.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/22.
//

#import "Model1.h"

@implementation Model1

-(id)copyWithZone:(NSZone *)zone{
    return  self;
}

/*
-(id)copyWithZone:(NSZone *)zone{
    
    Model1 *model = [[Model1 alloc] init];
    model.name = [self.name mutableCopy];
    return  model;
    
}
 */
@end
