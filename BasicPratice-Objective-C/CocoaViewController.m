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


//UIViewController的生命周期方法有哪些?
//[UIViewController alloc] 创建对象并分配内存空间
//[UIViewController initWithNibName:bundle:] 视图控制器nib初始化，初始化对象以及数据
//[ViewController init] 视图控制器初始化，初始化对象以及对象
-(void)loadView
{
    //首次创建View调用该方法(例如首次调用view的getter方法，self.view controller.view)
    //如果使用nib创建视图,那么从nib加载视图
}
-(void)loadViewIfNeeded
{
    //如果视图控制器海没有加载，那么加载
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //视图加载完成，可以动态添加其他UI控件
    //self.view.backgroundColor = [UIColor whiteColor];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //视图即将出现在屏幕上之前(每一次要显示该视图都会重复调用，不仅仅是第一次创建初始化之后，
    //下面另外三个时机亦然)
}
-(void)viewDidAppear:(BOOL)animated
{
    //视图已经显示显示到屏幕上之后
}
-(void)viewWillDisappear:(BOOL)animated
{
    //视图即将从屏幕上消失(消失包括被销毁、被隐藏、被覆盖等情况)
}
-(void)viewDidDisappear:(BOOL)animated
{
    //视图已经从屏幕上消失
}
-(void)viewWillLayoutSubviews
{
    //在视图的layoutSubviews方法激活(view自身的frame发生改变)调用
}
-(void)viewDidLayoutSubviews
{
    //在视图的layoutSubViews方法激活后立刻调用
}
-(void)didReceiveMemoryWarning
{
    //应用收到内存警告导致视图无法加载时调用，需要手动清理因iOS6以后
    //不会默认自动清理，通常在应用占用太大内存时被系统进行内存警告，
    //需要在下面的viewWillUnload方法中将UI手动置为nil
}
-(void)viewWillUnload
{
    //视图将不会继续加载，对应下面的viewDidUnload，iOS6后不会再对其进行调用

}
-(void)viewDidUnload
{
    //在视图控制器被释放或者被设置为nil时调用，例如收到内存警告无法加载时，
    //即非正常加载，而不是dealloc时的正常销毁，这里要手动清理界面元素资源
    //iOS6以后该回调方法被弃用了，任何情况下都不会再被调用，因为内存低时
    //系统不再在这里清理视图元素了，官方建议之前在该回调方法的清理工作应转移
    //到didReceiveMemoryWarning回调方法中，但实际上也不并不需要再进行之前
    //在viewDidUnload中进行视图清理工作，系统会独立于视图单独进行处理
}
-(void)dealloc
{
    //视图销毁，可以释放初始化时的对象等资源
}
@end
