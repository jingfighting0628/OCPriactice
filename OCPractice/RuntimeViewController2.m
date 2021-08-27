//
//  RuntimeViewController2.m
//  OCPractice
//
//  Created by liuningbo on 2021/8/27.
//

#import "RuntimeViewController2.h"

@interface RuntimeViewController2 ()

@end

@implementation RuntimeViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Runtime--Method Swizzling";
}
//1、Method Swizzling (动态方法交换) 简介
//2、Method Swizzling 使用方法（四种方案）
//3、Method Swizzling 使用注意
//4、Method Swizzling 应用场景
//1、全局页面统计功能
//2、字体根据屏幕尺寸适配
//3、处理按钮重复点击
//3、TableView、CollectionView异常加载站位图
//4、APM（应用性能管理）、防止崩溃


@end
