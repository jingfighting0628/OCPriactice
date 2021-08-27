//
//  OCBaseApIViewController.m
//  OCPractice
//
//  Created by liuningbo on 2021/8/25.
// 此类主要是对OC底层或者比较关键的知识点进行整理和总结
//例如:Runtime、多线程、Block、Runloop、AutorealeasePool、
//Category(分类)、RSA加密、

#import "OCBaseApIViewController.h"
#import "RuntimeViewController.h"
#import "RuntimeViewController2.h"
@interface OCBaseApIViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *mArray;
@end

@implementation OCBaseApIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Objective-C底层探索";
    // Do any additional setup after loading the view.
    _mArray = [@[@"Runtime",@"多线程",@"Block",@"Runloop",@"内存管理",@"Category",@"HTTP与HTTPS",@"AutoReleasePool"]mutableCopy];
    [self setUpTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_white"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    //[tableView registerClass:[<#classCell#> class] forCellReuseIdentifier:<#kReuseIdentifier#>];
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tableView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _mArray[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        RuntimeViewController *vc = [[RuntimeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        RuntimeViewController2 *vc = [[RuntimeViewController2 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
