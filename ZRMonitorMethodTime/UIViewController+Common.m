//
//  UIViewController+Common.m
//  ZRMonitorMethodTime
//
//  Created by ZhouRui on 2023/12/7.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0) {
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        } else {
            return svc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController *)vc;
        if (nvc.viewControllers.count > 0) {
            return [UIViewController findBestViewController:nvc.topViewController];
        } else {
            return nvc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (UITabBarController *)vc;
        if (tbc.viewControllers.count > 0) {
            return [UIViewController findBestViewController:tbc.selectedViewController];
        } else {
            return tbc;
        }
    } else {
        return vc;
    }
}

+ (UIViewController *)currentViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        return [UIViewController findBestViewController:viewController];
}

@end
