//
//  Student.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/3/11.
//

#import "Student.h"

@implementation Student
- (NSString *)infomation
{
    return [NSString stringWithFormat:@"student_name = %@ student_age = %d",self.person.name,self.person.age];
}
- (void)setInfomation:(NSString *)infomation
{
    NSArray *array = [infomation componentsSeparatedByString:@"#"];
    [self.person setName:[array objectAtIndex:0]];
    [self.person setAge:[[array objectAtIndex:1]intValue]];
}
+ (NSSet *)keyPathsForValuesAffectingInfomation
{
    NSSet *set = [NSSet setWithObjects:@"person.age",@"person.name", nil];
    return set;
}
@end
