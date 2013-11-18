//
//  DZAppDelegate.h
//  DZSMSSender
//
//  Created by linx on 13-8-20.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZViewController;

@interface DZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DZViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;
@end
