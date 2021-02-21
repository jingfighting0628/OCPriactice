//
//  iOSDevelopBasicConceptViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSDevelopBasicConceptViewController.h"
#import "Person.h"
@interface iOSDevelopBasicConceptViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation iOSDevelopBasicConceptViewController
//懒加载
-(NSArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return  _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *objectArray = [[NSArray alloc]initWithObjects:
    [Person personWithName:@"Amy" age:9],
    [Person personWithName:@"Lily" age:10],
    [Person personWithName:@"Sam" age:12],
    [Person personWithName:@"Eric" age:18], nil];
    
    NSPredicate *predicate;
    
    int a = 5;
    if (a == 0) {
       predicate = [NSPredicate predicateWithFormat:@"age >= 10"];
    }
    else if (a == 1){
        predicate = [NSPredicate predicateWithFormat:@"name IN {'Sam','Eric'}"];
    }
    else if (a == 2){
        predicate = [NSPredicate predicateWithFormat:@"age > 10 && age < 20"];
    }
    else if (a == 3){
        
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS 'a'"];
    }
    else if (a == 4){
        predicate = [NSPredicate predicateWithFormat:@"name like '??m'"];
    }
    else if (a == 5){
        predicate = [NSPredicate predicateWithFormat:@"name like '*a*'"];
    }
    
    NSArray *newArray = [objectArray filteredArrayUsingPredicate:predicate];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
