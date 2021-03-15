//
//  iOSDataPersistenceViewController.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/21.
//

#import "iOSDataPersistenceViewController.h"

@interface iOSDataPersistenceViewController ()

@end

@implementation iOSDataPersistenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //数据持久化的方法
    //主要有NSUserDefault简单数据快速读写、PropertyList(属性列表)、Archive(归档)
    //SQlite本地数据库和CoreData
    
    
    //沙盒机制
    //Documents目录
    //Documents目录主要存储非常大的文件或需要非常频繁更新的数据
    //目录中的文件能够进行iTuens和iClound的备份，获取Documents目录的代码
    //Library目录
    //在Library目录分别有Prefrences和Caches目录，其中Prefrence主要存储
    //应用程序的设置数据，能进行iTunes和iClound备份，通常保存应用的设置信息
    //而Caches目录主要存放数据的缓存文件，不能进行iTunes和iClound备份，适合
    //存储体积大。不需要备份非重要的数据
    //tmp目录
    //tmp目录是应用程序的临时目录,它里面的文件不能进行iTunes或iCloud备份
    //而且这里面的文随时可能被系统清除
    
    //默认情况下NSUerDefalts只能存储基本对象类型(NSData、NSString等类型)
    //和基本数据类型,直接保存自定义对象将会抛出异常
    //此时需要自定义类遵守NSCoding协议并实现协议方法进行编码和反编码，再通过
    //NSKeyUncachive类将自定义对象转为NSData对象，之后才能使用NSUserDefaluts
    //进行存储,简单来说,对于自定义对象，必须要通过一些方式将其转化为基本类型
    //即遵守NSCoding协议,
    //序列化和归档
    //序列化或者归档指将程序语言中的对象转化成二进制流从而存储到文件，因为对象
    //不可以直接存入文件的，相反反序列化或者反归档将二进制流转化成对象，从而可以在
    //程序中操作
    
    //NSKeyArchive是NSCode的子类,它能够将不同类型的对象编码成NSData类型的数据、
    //并将数据写入文件，NSKeyUnarchive类能够将存档的数据进行解档并还原成原来的对象
    
    
    
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
