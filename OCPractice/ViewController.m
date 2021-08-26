//
//  ViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "ViewController.h"
#import "iOSDevelopBasicConceptViewController.h"
#import "Objective-C-LanguageFeaturesViewControllerViewController.h"
#import "Objective-C-LanguageHighGradeFeaturesViewControllerViewController.h"
#import "CocoaViewController.h"
#import "iOSDevelopObjectCommunicationViewController.h"
#import "iOSDevelopLayerAndConversationViewController.h"
#import "iOSDataPersistenceViewController.h"
#import "iOSMemoryManagementViewController.h"
#import "iOSMultiThreadViewController.h"
#import "iOSOtherTopicViewController.h"
#import "EffectiveObjective-C2.h"
#import "OCBaseApIViewController.h"
//#import "DataBaseViewController.h"
//#import "OperatingSystemViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSourceArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"程序员面试笔试宝典";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _dataSourceArray = @[ @{@"ClassName":@"iOSDevelopBasicConceptViewController",
                            @"Navtitle":@"IOS开发基础概念"
                          },
                          @{@"ClassName":@"Objective-C-LanguageFeaturesViewControllerViewController",
                            @"Navtitle":@"Objecttive-C语言基础"
                          },
                          
                          @{@"ClassName":@"Objective-C-LanguageHighGradeFeaturesViewControllerViewController",
                            @"Navtitle":@"Objective-C语言高级特性"
                          },
                          
                          @{@"ClassName":@"CocoaViewController",
                            @"Navtitle":@"Cocoa框架相关"
                          },
                          
                          @{@"ClassName":@"iOSDevelopObjectCommunicationViewController",
                            @"Navtitle":@"iOS开发中对象的通信机制"
                          },
                          
                          @{@"ClassName":@"iOSDevelopLayerAndConversationViewController",
                            @"Navtitle":@"iOS中的图层与对话"
                          },
                          
                          @{@"ClassName":@"iOSDataPersistenceViewController",
                            @"Navtitle":@"iOS中的数据持久化"
                          },
                          
                          @{@"ClassName":@"iOSMemoryManagementViewController",
                            @"Navtitle":@"iOS中的内存管理"
                          },
                          
                          @{@"ClassName":@"iOSMultiThreadViewController",
                            @"Navtitle":@"iOS中的网络和多线程编程"
                          },
                          @{@"ClassName":@"iOSOtherTopicViewController",
                            @"Navtitle":@"其他话题"
                          },
                          @{@"ClassName":@"DataBaseViewController",
                            @"Navtitle":@"数据库"
                          },
                          @{@"ClassName":@"OperatingSystemViewController",
                            @"Navtitle":@"操作系统"
                          },
                          @{@"ClassName":@"EffectiveObjective-C2",
                            @"Navtitle":@"EffectiveObjective-C2.0编写高质量iOS与OSX代码的52个方法"
                          },
                          @{@"ClassName":@"OCBaseApIViewController",
                            @"Navtitle":@"OC底层探索(runtime、RunLoop、多线程等)"
                          },
    ];
    
   
    
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        NSDictionary *dic = _dataSourceArray[indexPath.row];
        cell.textLabel.text = dic[@"Navtitle"];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return  cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    NSDictionary *dic = _dataSourceArray[indexPath.row];
    Class class = NSClassFromString(dic[@"ClassName"]);
    BaseViewController *vc = [[class alloc] init];
    vc.NavTitle = dic[@"NavTitle"];
    [self.navigationController pushViewController:vc animated:YES];
     */
    NSDictionary *dic = _dataSourceArray[indexPath.row];
    if (indexPath.row == 0) {
        iOSDevelopBasicConceptViewController *vc = [[iOSDevelopBasicConceptViewController alloc] init];
        vc.NavTitle = dic[@"Navtitle"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1){
        Objective_C_LanguageFeaturesViewControllerViewController *vc = [[Objective_C_LanguageFeaturesViewControllerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.row == 2){
        Objective_C_LanguageHighGradeFeaturesViewControllerViewController *vc = [[Objective_C_LanguageHighGradeFeaturesViewControllerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.row == 3){
        CocoaViewController *vc = [[CocoaViewController alloc] init];
        //vc.NavTitle = dic[@"Navtitle"];
        [self.navigationController pushViewController:vc animated:YES ];
        
    }
    else if (indexPath.row == 4){
        iOSDevelopObjectCommunicationViewController *vc = [[iOSDevelopObjectCommunicationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES ];
    }
    else if (indexPath.row == 5){
        iOSDevelopLayerAndConversationViewController *vc = [[iOSDevelopLayerAndConversationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES ];
    }
    else if (indexPath.row == 6){
        iOSDataPersistenceViewController *vc = [[iOSDataPersistenceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES ];
        
    }
    else if (indexPath.row == 7){
        iOSMemoryManagementViewController *vc = [[iOSMemoryManagementViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES ];
    }
    
    else if (indexPath.row == 8){
        iOSMultiThreadViewController *vc = [[iOSMultiThreadViewController alloc] init];
        //vc.NavTitle = dic[@"Navtitle"];
        [self.navigationController pushViewController:vc animated:YES ];
    }
   
    else if (indexPath.row == 9){
        iOSOtherTopicViewController *vc = [[iOSOtherTopicViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES ];
    }
    else if (indexPath.row == 12){
        EffectiveObjective_C2 *vc = [[EffectiveObjective_C2 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 13){
        OCBaseApIViewController *vc = [[OCBaseApIViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    /*
    else if (indexPath.row == 10){
        OperatingSystemViewController *vc = [[OperatingSystemViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES ];
    }
   */
    
}
@end
