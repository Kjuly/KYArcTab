//
//  AppDelegate.m
//  KYArcTabDemo
//
//  Created by Kjuly on 1/8/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "AppDelegate.h"

#import "KYArcTabViewController.h"

@implementation AppDelegate

- (UIViewController *)viewControllerWithBackgroundColor:(UIColor *)backgroundColor tabItemImageIndex:(NSInteger)imageIndex {
	
	UIViewController *viewController = [[UIViewController alloc] init];
	viewController.view.backgroundColor = backgroundColor;
	
	NSString *imageName = [NSString stringWithFormat:@"KYTabBarItem%.2ld.png", (long)imageIndex];
	UIImage *image = [UIImage imageNamed:imageName];
	viewController.arcTabItem = [[KYArcTabItem alloc] initWithTitle:nil image:image selectedImage:nil];
	
	return viewController;
}

- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
	
	KYArcTabViewController *arcTabViewController = [[KYArcTabViewController alloc] init];
	arcTabViewController.swipeEnagled = YES;
	
	NSArray *viewControllers = @[
								 [self viewControllerWithBackgroundColor:[UIColor blackColor] tabItemImageIndex:1],
								 [self viewControllerWithBackgroundColor:[UIColor redColor] tabItemImageIndex:2],
								 [self viewControllerWithBackgroundColor:[UIColor greenColor] tabItemImageIndex:3],
								 [self viewControllerWithBackgroundColor:[UIColor blueColor] tabItemImageIndex:4],
								 ];
	
	UIViewController *topViewController = viewControllers[0];
	
	// Add a gesture signal on the first view
	UIImage * gestureImage = [UIImage imageNamed:@"KYIArcTabGestureHelp.png"];
	UIImageView * gestureImageView = [[UIImageView alloc] initWithImage:gestureImage];
	[gestureImageView setUserInteractionEnabled:YES];
	
	[topViewController.view addSubview:gestureImageView];
	
	gestureImageView.center = topViewController.view.center;
	gestureImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	
	arcTabViewController.viewControllers = viewControllers;
	
  [self.window setRootViewController:arcTabViewController];
  
  [self.window makeKeyAndVisible];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
