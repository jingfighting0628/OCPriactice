//
//  iOSDevelopLayerAndConversationViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSDevelopLayerAndConversationViewController.h"

@interface iOSDevelopLayerAndConversationViewController ()

@end

@implementation iOSDevelopLayerAndConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UIView和CALayer区别是什么？
    //CAlayer是动画中经常使用的一个类，它包含在QuartzCore框架中，
    //CALayer类在概念上和UIView类似,同样是一些被层级关系数管理的的
    //矩形块，也可以包含一些内容(像图片、文本或者背景色)，管理子图层的位置
    //它们有一些方法和属性用来做动画和变换，使用CoreAnimation开发动画的本质
    //就是将CALayer中的内容转化为位图供硬件操作
    //CALayer是一个比UIView更底层的图形类，是对底层图形API(openGL ES)一层层
    //封装得到的一个类，用于展示一些可见的图形元素，保留了一些基本的图形化操作，但同时
    //由于相对高度的封装，使得操作使用变得很简单，CALayer用于管理图形元素，甚至可以
    //制作动画，它保留了一些几何属性，如位置、尺寸、图形变换等。一般的CALayer是作为
    //UIView背后的支持角色，在创建了一个UIView的同时也存在一个相应的CALayer
    //UIView作为CALayer的代理角色去实现一些功能，例如常见的UIView制作一个圆角，
    //就会用到UIView背后的layer操作
    //view.layer.cornerRadius = 10
    //CAlayer可以通过UIView很方便地展示操作UI元素，但是CALayer自身单独也可以展示和
    //操作可见元素，且灵活度更高，它自身有一些可见可设置的属性，如背景色、边框、阴影等
    //另外，UIView简单来说是一个可以在里面渲染可见内容的矩形框，它里面的内容可以个用户
    //进行交互，UIView可以对交互事件进行处理，除了其背后CALayer的图形操作支持，
    //UIView自身也有像设置背景色等最基本的属性设置
    
    
    
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
