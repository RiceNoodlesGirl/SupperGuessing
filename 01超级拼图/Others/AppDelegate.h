//
//  AppDelegate.h
//  01超级拼图
//
//  Created by mac on 2021/6/7.
//
//https://www.jianshu.com/p/801de3beee22 解读appdelegate 跟scenedelegate
/**
 发现，iOS13中appdelegate的职责发现了改变：
 iOS13之前，Appdelegate的职责全权处理App生命周期和UI生命周期；
 iOS13之后，Appdelegate的职责是：
 1、处理 App 生命周期
 2、新的 Scene Session 生命周期
 那UI的生命周期呢？交给新增的Scene Delegate处理
 用图表示就是：
 iOS13之前：
 但是iOS13之后，Appdelegate不在负责UI生命周期，所有UI生命周期交给SceneDelegate处理：
 */
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@end

