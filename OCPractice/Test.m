//
//  Test.m
//  BasicPratice-Objective-C
//
//  Created by liuningbo on 2021/2/22.
//

#import "Test.h"



@interface Test ()
{
  @public NSString *_name;//声明为公共变量
  @private NSString *_major;//限制为私有变量,.m实现文件中定义变量的默认类型
  @protected NSString *_accupation;//限制为子类访问变量，头文件中定义变量的默认类型
  @protected NSString *_company; //包内变量，只能本框架内使用
}

@end

@implementation Test
//自定义变量名
//@synthesize myName = theName ;
//禁止编译器自动合成存取方法 如果.myName会崩溃
//@dynamic myName ;
@end
