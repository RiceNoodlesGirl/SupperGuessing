//
//  main.m
//  01超级拼图
//
//  Created by mac on 2021/6/7.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
     return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

