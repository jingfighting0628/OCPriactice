//
//  CocoaViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "CocoaViewController.h"

@interface CocoaViewController ()

@end

@implementation CocoaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //如何对UITableView的滚动加载进行优化
    //1、减少celllForRowAtIndexpath
    //2、减少heightForRowAtIndexPath代理中的计算量
    //减少cellForRowAtIndexpath代理中计算量
    //1、先要提前计算每个cell中需要的一些基本数据，代理调用的时候直接取出
    //2、图片要异步加载，加载完成后再根据cell内部UIImageView的引用设置图片
    //3、图片数量多时，图片的尺寸要根据需要提前经过transform矩阵变换压缩好(直接设置
    //图片的ontentMode让其自行压缩会影响滚动效率),必要时候要准备好预览图和高清图，需要时
    //再加载高清图
    //4、图片的懒加载方法，即延迟加载，当滚动速度很快时避免频繁请求服务器数据
    //5、尽量手动Drawing视图提升流畅性，而不是直接子类化UITableViewCell，然后覆盖
    //drawRect方法，因为cell中不是只有一个contentView。绘制cell不建议使用UIView，建议使用
    //CAlayer，因为要参考UIView和CAlayer的区别和联系
    //减少heightForRowAtIndexPath代理中的计算量
    //1、由于每次tableView进行update都会对每一个cell调用heightForRowAtIndexPath
    //代理取得最新的height，会大大增加计算时间，如果表格的所有cell的高度都是固定的，那么
    //去掉heightForRowAtIndexPath的代理，直接设置tableView的rowHeight属性为固定值
    //2、如果高度不固定，那么尽量将cell的高度数据计算好并存储存起来，代理调用时候直接取，
    //即将height的计算时间复杂度降低到O(1)，例如，在异步请求服务器数据时，提前将cell的高度计算好
    //并作为dataSource的一个数据存到数据库供随时取用
    
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
